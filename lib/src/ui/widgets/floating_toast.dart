import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../style/oiya_styles.dart';

OverlayEntry? _activeToastEntry;

void showOiyaToast(BuildContext context, String message) {
  if (_activeToastEntry != null) {
    try {
      _activeToastEntry!.remove();
    } catch (_) {}
    _activeToastEntry = null;
  }

  final overlayState = Overlay.of(context);
  
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 80,
      left: 40,
      right: 40,
      child: _FloatingToastWidget(
        message: message,
        onDismissed: () {
          if (_activeToastEntry == entry) {
            _activeToastEntry = null;
          }
          try {
            entry.remove();
          } catch (_) {}
        },
      ),
    ),
  );
  
  _activeToastEntry = entry;
  overlayState.insert(entry);
}

class _FloatingToastWidget extends StatefulWidget {
  final String message;
  final VoidCallback onDismissed;

  const _FloatingToastWidget({
    required this.message,
    required this.onDismissed,
  });

  @override
  State<_FloatingToastWidget> createState() => _FloatingToastWidgetState();
}

class _FloatingToastWidgetState extends State<_FloatingToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0.0, 0.4), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward().then((_) {
      _dismissTimer = Timer(const Duration(milliseconds: 1500), () {
        if (mounted) {
          _controller.reverse().then((_) {
            widget.onDismissed();
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Choose icon based on message content
    IconData iconData = CupertinoIcons.info_circle_fill;
    Color iconColor = isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary;
    
    final lowerMessage = widget.message.toLowerCase();
    if (lowerMessage.contains('completed') || lowerMessage.contains('saved') || lowerMessage.contains('created') || lowerMessage.contains('done')) {
      iconData = CupertinoIcons.checkmark_alt_circle_fill;
      iconColor = const Color(0xFF30D158); // Green
    } else if (lowerMessage.contains('deleted') || lowerMessage.contains('cleared') || lowerMessage.contains('resetting')) {
      iconData = CupertinoIcons.trash_fill;
      iconColor = const Color(0xFFFF453A); // Red
    }

    return IgnorePointer(
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Center(
            child: Material(
              type: MaterialType.transparency,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark 
                          ? Colors.black.withOpacity(0.65) 
                          : Colors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark 
                            ? Colors.white.withOpacity(0.08) 
                            : Colors.black.withOpacity(0.06),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          spreadRadius: 4,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          iconData,
                          color: iconColor,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            widget.message,
                            style: OiyaStyles.caption(
                              color: isDark ? Colors.white : OiyaStyles.ink,
                            ).copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
