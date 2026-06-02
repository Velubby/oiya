import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/habits/controllers/habit_controller.dart';
import '../../features/habits/models/habit.dart';
import '../style/oiya_styles.dart';
import 'streak_badge.dart';

void checkAndShowStreakPromotion(BuildContext context, WidgetRef ref, String habitId, int oldStreak) {
  final habits = ref.read(habitControllerProvider);
  final updatedHabits = habits.where((r) => r.id == habitId).toList();
  if (updatedHabits.isEmpty) return;
  final updatedHabit = updatedHabits.first;
  final newStreak = updatedHabit.streakCount;

  if (newStreak > oldStreak) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final oldStyle = getStreakTierStyle(oldStreak, isDark);
    final newStyle = getStreakTierStyle(newStreak, isDark);

    if (oldStyle.name != newStyle.name) {
      showStreakPromotionOverlay(context, updatedHabit, oldStreak, newStreak);
    }
  }
}

void showStreakPromotionOverlay(BuildContext context, Habit habit, int oldStreak, int newStreak) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final oldStyle = getStreakTierStyle(oldStreak, isDark);
  final newStyle = getStreakTierStyle(newStreak, isDark);

  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Streak Promotion',
    barrierColor: Colors.black.withOpacity(0.85),
    transitionDuration: const Duration(milliseconds: 600),
    pageBuilder: (context, anim1, anim2) {
      return StreakPromotionOverlayWidget(
        habit: habit,
        oldStreak: oldStreak,
        newStreak: newStreak,
        oldStyle: oldStyle,
        newStyle: newStyle,
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      final curve = CurvedAnimation(parent: anim1, curve: Curves.elasticOut);
      return Transform.scale(
        scale: curve.value,
        child: FadeTransition(
          opacity: anim1,
          child: child,
        ),
      );
    },
  );
}

class StreakPromotionOverlayWidget extends StatefulWidget {
  final Habit habit;
  final int oldStreak;
  final int newStreak;
  final StreakTierStyle oldStyle;
  final StreakTierStyle newStyle;

  const StreakPromotionOverlayWidget({
    super.key,
    required this.habit,
    required this.oldStreak,
    required this.newStreak,
    required this.oldStyle,
    required this.newStyle,
  });

  @override
  State<StreakPromotionOverlayWidget> createState() => _StreakPromotionOverlayWidgetState();
}

class _StreakPromotionOverlayWidgetState extends State<StreakPromotionOverlayWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 6.0, end: 18.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _playCelebrationHaptics();
  }

  Future<void> _playCelebrationHaptics() async {
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 120));
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 90));
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 60));
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: ArcadeParticleBurst(colors: widget.newStyle.gradientColors),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F1322) : const Color(0xFFFAF9F6),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: widget.newStyle.borderTint,
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.newStyle.gradientColors.first.withOpacity(0.15),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: widget.newStyle.bgTint,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: widget.newStyle.borderTint, width: 1),
                    ),
                    child: Text(
                      'STREAK TIER UPGRADE!',
                      style: OiyaStyles.tagline(color: widget.newStyle.textColor).copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Promoted to',
                    style: OiyaStyles.caption(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.newStyle.name.toUpperCase(),
                    style: OiyaStyles.displayMd(color: widget.newStyle.textColor).copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      return ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.newStyle.bgTint,
                            boxShadow: [
                              BoxShadow(
                                color: widget.newStyle.gradientColors.first.withOpacity(0.2),
                                blurRadius: _glowAnimation.value,
                                spreadRadius: _glowAnimation.value / 3,
                              ),
                            ],
                            border: Border.all(
                              color: widget.newStyle.borderTint,
                              width: 2.0,
                            ),
                          ),
                          child: Center(
                            child: GradientIcon(
                              widget.newStyle.icon,
                              colors: widget.newStyle.gradientColors,
                              size: 72,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 28),
                  Text(
                    '${widget.newStreak} DAYS',
                    style: OiyaStyles.displayLg(color: isDark ? Colors.white : OiyaStyles.ink).copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 36,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Keep your habit on "${widget.habit.title}" alive to unlock the next flame tier!',
                    style: OiyaStyles.caption(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.newStyle.textColor,
                        foregroundColor: isDark ? const Color(0xFF0F1322) : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'AWESOME!',
                        style: OiyaStyles.bodyStrong(
                          color: isDark ? const Color(0xFF0F1322) : Colors.white,
                        ).copyWith(fontWeight: FontWeight.w800, letterSpacing: 1.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ArcadeParticleBurst extends StatefulWidget {
  final List<Color> colors;

  const ArcadeParticleBurst({super.key, required this.colors});

  @override
  State<ArcadeParticleBurst> createState() => _ArcadeParticleBurstState();
}

class _ArcadeParticleBurstState extends State<ArcadeParticleBurst> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    final random = math.Random();
    _particles = List.generate(80, (index) {
      final angle = random.nextDouble() * 2 * math.pi;
      final speed = 40.0 + random.nextDouble() * 180.0;
      final size = 3.0 + random.nextDouble() * 6.0;
      final colorIndex = random.nextInt(widget.colors.length);
      return Particle(
        angle: angle,
        speed: speed,
        size: size,
        color: widget.colors[colorIndex],
        spinSpeed: -4.0 + random.nextDouble() * 8.0,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: ParticlePainter(
            particles: _particles,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class Particle {
  final double angle;
  final double speed;
  final double size;
  final Color color;
  final double spinSpeed;

  const Particle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.color,
    required this.spinSpeed,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;

  ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      final distance = particle.speed * progress;
      final gravity = 200.0 * progress * progress;
      
      final dx = center.dx + math.cos(particle.angle) * distance;
      final dy = center.dy + math.sin(particle.angle) * distance + gravity;

      final alpha = (1.0 - progress).clamp(0.0, 1.0);
      paint.color = particle.color.withOpacity(alpha);

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(particle.spinSpeed * progress);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: particle.size, height: particle.size),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
