import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../features/memory/reminder_controller.dart';
import 'main_shell.dart';

class RetroCameraView extends ConsumerStatefulWidget {
  const RetroCameraView({
    super.key,
    required this.reminderId,
    required this.reminderTitle,
    required this.onComplete,
  });

  final String reminderId;
  final String reminderTitle;
  final VoidCallback onComplete;

  @override
  ConsumerState<RetroCameraView> createState() => _RetroCameraViewState();
}

class _RetroCameraViewState extends ConsumerState<RetroCameraView> with SingleTickerProviderStateMixin {
  // Camera settings state
  double _exposure = 1.0; // 0.5 to 1.5
  int _isoIndex = 1;
  final List<int> _isoOptions = [100, 400, 600];
  bool _flashEnabled = true;
  String _activeFilter = 'Classic SX-70';
  final List<String> _filters = ['Classic SX-70', 'Dusk Amber', 'Cool Cyan', 'Monochrome'];

  // Camera flow states
  bool _isCaptured = false;
  bool _isDeveloping = false;
  double _developmentProgress = 0.0;
  bool _flashTriggered = false;

  // Animation controller for Polaroid slide out & development
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  // Caption input
  final TextEditingController _captionController = TextEditingController();

  // Custom viewfinder live noise update timer
  Timer? _noiseTimer;
  double _noiseSeed = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    _noiseTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted && !_isCaptured) {
        setState(() {
          _noiseSeed = math.Random().nextDouble();
        });
      }
    });
  }

  @override
  void dispose() {
    _noiseTimer?.cancel();
    _animationController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  void _cycleIso() {
    HapticFeedback.lightImpact();
    setState(() {
      _isoIndex = (_isoIndex + 1) % _isoOptions.length;
    });
  }

  void _cycleFilter() {
    HapticFeedback.lightImpact();
    setState(() {
      int idx = _filters.indexOf(_activeFilter);
      _activeFilter = _filters[(idx + 1) % _filters.length];
    });
  }

  void _triggerShutter() {
    if (_isCaptured) return;
    HapticFeedback.heavyImpact();

    // Trigger visual flash if enabled
    if (_flashEnabled) {
      setState(() {
        _flashTriggered = true;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            _flashTriggered = false;
          });
        }
      });
    }

    setState(() {
      _isCaptured = true;
      _isDeveloping = true;
      _developmentProgress = 0.0;
    });

    _animationController.forward();

    // Simulate chemical Polaroid development
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _developmentProgress += 0.04;
        if (_developmentProgress >= 1.0) {
          _developmentProgress = 1.0;
          _isDeveloping = false;
          timer.cancel();
          HapticFeedback.mediumImpact();
        }
      });
    });
  }

  void _retake() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isCaptured = false;
      _isDeveloping = false;
      _developmentProgress = 0.0;
      _captionController.clear();
    });
    _animationController.reverse();
  }

  Future<void> _saveProof() async {
    HapticFeedback.mediumImpact();
    final caption = _captionController.text.trim();

    // Call complete reminder
    await ref.read(reminderControllerProvider.notifier).completeReminder(
      widget.reminderId,
      proofCaption: caption.isNotEmpty ? caption : 'Verified Polaroid Proof',
      proofData: 'Polaroid #OIYA-${math.Random().nextInt(9000) + 1000}',
    );

    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final viewWidth = MediaQuery.of(context).size.width;
    final maxCameraWidth = math.min(viewWidth, 420.0);

    return Scaffold(
      backgroundColor: const Color(0xFF13131A), // Matte camera body black
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.clear, color: Colors.white70),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
        title: Column(
          children: [
            const Text(
              'OIYA INSTANT SX-70',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'PROOF VERIFICATION',
              style: TextStyle(
                color: OiyaStyles.primaryOnDark.withOpacity(0.8),
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Camera Shell Center Layout
          Center(
            child: Container(
              width: maxCameraWidth,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!_isCaptured) ...[
                    // --- VIEWFINDER MODE ---
                    // LED Info Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E28),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLedIndicator('ISO', '${_isoOptions[_isoIndex]}'),
                          _buildLedIndicator('FILT', _activeFilter.toUpperCase().split(' ').last),
                          _buildLedIndicator('EV', '${_exposure.toStringAsFixed(1)}x'),
                          _buildLedIndicator('BATT', '98%'),
                        ],
                      ),
                    ),

                    // Square Viewfinder Screen
                    AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          color: const Color(0xFF23232F),
                          child: Stack(
                            children: [
                              // Live Generative Viewfinder Stream
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: RetroPhotoPainter(
                                    title: widget.reminderTitle,
                                    exposure: _exposure,
                                    filter: _activeFilter,
                                    noiseSeed: _noiseSeed,
                                    developmentProgress: 1.0,
                                    isLiveViewfinder: true,
                                  ),
                                ),
                              ),
                              // 3x3 Grid Overlay
                              const Positioned.fill(
                                child: IgnorePointer(
                                  child: GridOverlay(),
                                ),
                              ),
                              // Live Status HUD
                              Positioned(
                                top: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'STILL',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              // Exposure visual label
                              Positioned(
                                bottom: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'ISO ${_isoOptions[_isoIndex]}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Camera Controls & Settings Sliders
                    Column(
                      children: [
                        // Exposure Slider
                        Row(
                          children: [
                            const Icon(CupertinoIcons.sun_min_fill, color: Colors.amber, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SliderTheme(
                                data: const SliderThemeData(
                                  activeTrackColor: OiyaStyles.primaryOnDark,
                                  inactiveTrackColor: Colors.white12,
                                  thumbColor: Colors.white,
                                  trackHeight: 3,
                                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                                ),
                                child: Slider(
                                  value: _exposure,
                                  min: 0.5,
                                  max: 1.5,
                                  onChanged: (val) {
                                    setState(() {
                                      _exposure = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(CupertinoIcons.sun_max_fill, color: Colors.amber, size: 22),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Action Buttons: ISO, Filter, Flash
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCompactControl(
                              icon: CupertinoIcons.slider_horizontal_3,
                              label: 'ISO',
                              onTap: _cycleIso,
                            ),
                            _buildCompactControl(
                              icon: CupertinoIcons.sparkles,
                              label: 'FILTER',
                              onTap: _cycleFilter,
                            ),
                            _buildCompactControl(
                              icon: _flashEnabled ? CupertinoIcons.bolt_fill : CupertinoIcons.bolt_slash_fill,
                              label: 'FLASH',
                              color: _flashEnabled ? Colors.amber : Colors.white24,
                              onTap: () {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  _flashEnabled = !_flashEnabled;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Giant Shutter Button
                    GestureDetector(
                      onTap: _triggerShutter,
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF22222E),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.8),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF453A), Color(0xFFFF9F0A)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            CupertinoIcons.camera_fill,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ] else ...[
                    // --- CAPTURED & DEVELOPING POLAROID ---
                    const SizedBox(height: 10),
                    // Slide out Polaroid Card
                    ScaleTransition(
                      scale: _slideAnimation,
                      child: Container(
                        width: 320,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Polaroid Photo Window
                            AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                color: Colors.black,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: CustomPaint(
                                        painter: RetroPhotoPainter(
                                          title: widget.reminderTitle,
                                          exposure: _exposure,
                                          filter: _activeFilter,
                                          noiseSeed: 0.5,
                                          developmentProgress: _developmentProgress,
                                          isLiveViewfinder: false,
                                        ),
                                      ),
                                    ),
                                    if (_isDeveloping)
                                      Positioned.fill(
                                        child: Center(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.8),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              'DEVELOPING... ${( _developmentProgress * 100).toInt()}%',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'monospace',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Polaroid Bottom Area (Handwritten Note Input)
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.black12, width: 1.5),
                                ),
                              ),
                              child: TextField(
                                controller: _captionController,
                                autofocus: !_isDeveloping,
                                enabled: !_isDeveloping,
                                maxLength: 40,
                                style: TextStyle(
                                  fontFamily: 'Georgia',
                                  fontSize: 16,
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                                decoration: InputDecoration(
                                  hintText: _isDeveloping ? 'Processing chemistry...' : 'Write a caption...',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Georgia',
                                    fontSize: 14,
                                    color: Colors.black38,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  filled: false,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                                  counterText: '',
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                DateFormat('yyyy.MM.dd  HH:mm').format(DateTime.now()),
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 10,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Bottom Save/Retake Actions
                    AnimatedOpacity(
                      opacity: _isDeveloping ? 0.3 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: IgnorePointer(
                        ignoring: _isDeveloping,
                        child: Column(
                          children: [
                            OiyaButton(
                              label: 'Save Verified Proof',
                              isPrimary: true,
                              onPressed: _saveProof,
                              icon: const Icon(CupertinoIcons.checkmark_seal_fill, color: Colors.white, size: 18),
                            ),
                            const SizedBox(height: 12),
                            TextButton.icon(
                              onPressed: _isDeveloping ? null : _retake,
                              icon: const Icon(CupertinoIcons.refresh_bold, color: Colors.white60, size: 14),
                              label: const Text(
                                'Retake Photo',
                                style: TextStyle(color: Colors.white60, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ]
                ],
              ),
            ),
          ),

          // Screen Flash Overlay (Fades out when capture runs)
          if (_flashTriggered)
            Positioned.fill(
              child: Container(
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLedIndicator(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white30,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: const TextStyle(
            color: OiyaStyles.primaryOnDark,
            fontFamily: 'monospace',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactControl({
    required IconData icon,
    required String label,
    Color color = Colors.white70,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1E1E28),
              border: Border.all(color: Colors.white10),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white30,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class GridOverlay extends StatelessWidget {
  const GridOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GridOverlayPainter(),
    );
  }
}

class GridOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Vertical lines
    canvas.drawLine(Offset(size.width / 3, 0), Offset(size.width / 3, size.height), paint);
    canvas.drawLine(Offset(size.width * 2 / 3, 0), Offset(size.width * 2 / 3, size.height), paint);

    // Horizontal lines
    canvas.drawLine(Offset(0, size.height / 3), Offset(size.width, size.height / 3), paint);
    canvas.drawLine(Offset(0, size.height * 2 / 3), Offset(size.width, size.height * 2 / 3), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RetroPhotoPainter extends CustomPainter {
  RetroPhotoPainter({
    required this.title,
    required this.exposure,
    required this.filter,
    required this.noiseSeed,
    required this.developmentProgress,
    required this.isLiveViewfinder,
  });

  final String title;
  final double exposure;
  final String filter;
  final double noiseSeed;
  final double developmentProgress;
  final bool isLiveViewfinder;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw base chemicals (starts black/greyish and developments to colors)
    final Paint bgPaint = Paint();

    if (developmentProgress < 1.0) {
      // In development: blend from murky dark grey/brown to filter base
      final factor = developmentProgress;
      bgPaint.color = Color.lerp(
        const Color(0xFF1C1A17), // Murky chemical brown
        _getFilterBaseColor(),
        factor,
      )!;
    } else {
      bgPaint.color = _getFilterBaseColor();
    }

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. Draw Generative Subject Outline with fading opacity based on progress
    if (developmentProgress > 0.05) {
      final double drawingOpacity = developmentProgress;
      final Paint drawPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 * exposure
        ..strokeCap = StrokeCap.round;

      // Color choice based on filter
      if (filter == 'Monochrome') {
        drawPaint.color = Colors.white.withOpacity(drawingOpacity * 0.85);
      } else if (filter == 'Dusk Amber') {
        drawPaint.color = const Color(0xFFFF9F0A).withOpacity(drawingOpacity * 0.9);
      } else if (filter == 'Cool Cyan') {
        drawPaint.color = const Color(0xFF64D2FF).withOpacity(drawingOpacity * 0.95);
      } else {
        // Classic SX-70
        drawPaint.color = const Color(0xFF9EC1A3).withOpacity(drawingOpacity * 0.9);
      }

      // Detect keyword
      final query = title.toLowerCase();
      if (query.contains('bed') || query.contains('sleep') || query.contains('clean')) {
        _drawBed(canvas, size, drawPaint);
      } else if (query.contains('study') || query.contains('exam') || query.contains('read') || query.contains('math') || query.contains('prep') || query.contains('book')) {
        _drawDeskBook(canvas, size, drawPaint);
      } else if (query.contains('water') || query.contains('drink') || query.contains('glass') || query.contains('cup')) {
        _drawWaterGlass(canvas, size, drawPaint);
      } else {
        _drawRetroSunset(canvas, size, drawPaint, drawingOpacity);
      }
    }

    // 3. Viewfinder scanning/LED line or noise overlay
    if (isLiveViewfinder) {
      // Animated green focus box
      final focusPaint = Paint()
        ..color = const Color(0xFF34C759).withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      final center = Offset(size.width / 2, size.height / 2);
      canvas.drawRect(Rect.fromCenter(center: center, width: 30, height: 30), focusPaint);

      // Scanline effect
      final scanPaint = Paint()
        ..color = Colors.white.withOpacity(0.04)
        ..strokeWidth = 1.0;
      for (double y = 0; y < size.height; y += 4) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), scanPaint);
      }
    }

    // 4. Polaroid Film Grain Noise overlay
    final rand = math.Random((noiseSeed * 100000).toInt());
    final noisePaint = Paint()..color = Colors.white.withOpacity(isLiveViewfinder ? 0.05 : 0.03);
    for (int i = 0; i < 200; i++) {
      final x = rand.nextDouble() * size.width;
      final y = rand.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), 0.8, noisePaint);
    }
  }

  Color _getFilterBaseColor() {
    switch (filter) {
      case 'Dusk Amber':
        return const Color(0xFF2A1C10); // Warm sepia / amber wash
      case 'Cool Cyan':
        return const Color(0xFF0F1E24); // Cold blue wash
      case 'Monochrome':
        return const Color(0xFF1E1E1E); // Grey scale dark
      case 'Classic SX-70':
      default:
        return const Color(0xFF1C2541); // Deep Indigo
    }
  }

  // --- DRAW GENERATIVE SHAPES ---
  void _drawBed(Canvas canvas, Size size, Paint paint) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final w = size.width * 0.5;
    final h = size.height * 0.3;

    // Bedframe
    final rect = Rect.fromCenter(center: Offset(cx, cy + 10), width: w, height: h);
    canvas.drawRect(rect, paint);

    // Pillows
    canvas.drawRect(Rect.fromLTWH(cx - w/2 + 8, cy - h/2 + 2, w/2 - 12, 12), paint);
    canvas.drawRect(Rect.fromLTWH(cx + 4, cy - h/2 + 2, w/2 - 12, 12), paint);

    // Blanket folded line
    canvas.drawLine(Offset(cx - w/2, cy + 5), Offset(cx + w/2, cy + 5), paint);

    // Headboard posts
    canvas.drawLine(Offset(cx - w/2, cy - h/2 - 10), Offset(cx - w/2, cy + h/2 + 10), paint);
    canvas.drawLine(Offset(cx + w/2, cy - h/2 - 10), Offset(cx + w/2, cy + h/2 + 10), paint);

    // Cute sparkles above bed
    canvas.drawCircle(Offset(cx - 30, cy - h/2 - 20), 2, paint);
    canvas.drawCircle(Offset(cx + 30, cy - h/2 - 25), 3, paint);
  }

  void _drawDeskBook(Canvas canvas, Size size, Paint paint) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Open Book shape
    final path = Path()
      ..moveTo(cx, cy + 20)
      ..quadraticBezierTo(cx - 30, cy, cx - 60, cy + 15)
      ..lineTo(cx - 60, cy - 15)
      ..quadraticBezierTo(cx - 30, cy - 30, cx, cy - 10)
      ..quadraticBezierTo(cx + 30, cy - 30, cx + 60, cy - 15)
      ..lineTo(cx + 60, cy + 15)
      ..quadraticBezierTo(cx + 30, cy, cx, cy + 20)
      ..close();

    canvas.drawPath(path, paint);

    // Divider line in the middle
    canvas.drawLine(Offset(cx, cy - 10), Offset(cx, cy + 20), paint);

    // Little study lamp next to it
    final lampPath = Path()
      ..moveTo(cx + 40, cy - 15)
      ..lineTo(cx + 50, cy - 40)
      ..lineTo(cx + 35, cy - 40)
      ..lineTo(cx + 35, cy - 45)
      ..lineTo(cx + 55, cy - 45)
      ..lineTo(cx + 55, cy - 40)
      ..lineTo(cx + 52, cy - 40)
      ..lineTo(cx + 42, cy - 15);
    canvas.drawPath(lampPath, paint);

    // Light beam dotted lines
    final beamPaint = Paint()
      ..color = paint.color.withOpacity(paint.color.opacity * 0.4)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(cx + 35, cy - 40), Offset(cx + 10, cy - 10), beamPaint);
    canvas.drawLine(Offset(cx + 55, cy - 40), Offset(cx + 30, cy + 5), beamPaint);
  }

  void _drawWaterGlass(Canvas canvas, Size size, Paint paint) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Glass outline
    final path = Path()
      ..moveTo(cx - 25, cy - 40)
      ..lineTo(cx - 20, cy + 40)
      ..quadraticBezierTo(cx, cy + 45, cx + 20, cy + 40)
      ..lineTo(cx + 25, cy - 40)
      ..close();

    canvas.drawPath(path, paint);

    // Water level line inside
    canvas.drawLine(Offset(cx - 22, cy), Offset(cx + 22, cy), paint);

    // Ice cube outlines
    canvas.drawRect(Rect.fromLTWH(cx - 10, cy + 10, 12, 12), paint);

    // Bubbles
    canvas.drawCircle(Offset(cx + 8, cy - 15), 2, paint);
    canvas.drawCircle(Offset(cx - 8, cy - 8), 3, paint);
    canvas.drawCircle(Offset(cx + 4, cy + 25), 1.5, paint);
  }

  void _drawRetroSunset(Canvas canvas, Size size, Paint paint, double opacity) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Draw Synthwave Grid floor perspective
    final gridY = cy + 15;
    canvas.drawLine(Offset(0, gridY), Offset(size.width, gridY), paint);

    // Converging lines
    for (int i = 0; i <= 6; i++) {
      final startX = size.width * (i / 6);
      canvas.drawLine(Offset(startX, gridY), Offset(cx + (startX - cx) * 0.15, cy - 5), paint);
    }

    // Horizontal grid lines
    for (int y = 0; y < 6; y++) {
      final double progress = y / 5;
      final currentY = gridY + (size.height - gridY) * progress * progress;
      canvas.drawLine(Offset(0, currentY), Offset(size.width, currentY), paint);
    }

    // Draw Sunset Sun (half circle outline)
    final sunRadius = size.width * 0.22;
    final sunCenter = Offset(cx, cy - 5);

    // We can paint a sun with custom path to cut out stripes
    final sunPath = Path()
      ..addArc(
        Rect.fromCircle(center: sunCenter, radius: sunRadius),
        math.pi,
        math.pi,
      );
    canvas.drawPath(sunPath, paint);

    // Sunset sun stripe lines
    canvas.drawLine(Offset(cx - sunRadius, cy - 15), Offset(cx + sunRadius, cy - 15), paint);
    canvas.drawLine(Offset(cx - sunRadius * 0.8, cy - 25), Offset(cx + sunRadius * 0.8, cy - 25), paint);
    canvas.drawLine(Offset(cx - sunRadius * 0.5, cy - 35), Offset(cx + sunRadius * 0.5, cy - 35), paint);
  }

  @override
  bool shouldRepaint(covariant RetroPhotoPainter oldDelegate) {
    return oldDelegate.noiseSeed != noiseSeed ||
        oldDelegate.developmentProgress != developmentProgress ||
        oldDelegate.exposure != exposure ||
        oldDelegate.filter != filter;
  }
}
