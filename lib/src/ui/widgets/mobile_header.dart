import 'dart:ui';
import 'package:flutter/material.dart';
import '../style/oiya_styles.dart';

class MobileHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const MobileHeader({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: (isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas).withOpacity(0.85),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline,
            width: 0.5,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              title,
              style: OiyaStyles.tagline(color: isDark ? Colors.white : OiyaStyles.ink).copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
            centerTitle: true,
            actions: actions,
            automaticallyImplyLeading: false,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(52.0);
}
