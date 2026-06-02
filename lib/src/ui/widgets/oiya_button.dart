import 'package:flutter/material.dart';
import '../style/oiya_styles.dart';

class OiyaButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isSecondaryOutline;
  final bool isDarkUtility;
  final bool isPearlCapsule;
  final bool isStoreHero;
  final Widget? icon;

  const OiyaButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isPrimary = false,
    this.isSecondaryOutline = false,
    this.isDarkUtility = false,
    this.isPearlCapsule = false,
    this.isStoreHero = false,
    this.icon,
  });

  @override
  State<OiyaButton> createState() => _OiyaButtonState();
}

class _OiyaButtonState extends State<OiyaButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    Color bg = OiyaStyles.primary;
    Color text = Colors.white;
    TextStyle style = OiyaStyles.bodyText(color: text);
    double radius = OiyaStyles.roundedPill;
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 12);
    Border? border;

    if (widget.isPrimary) {
      bg = OiyaStyles.primary;
      text = Colors.white;
      style = OiyaStyles.bodyText(color: text);
      radius = OiyaStyles.roundedPill;
      padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 12);
    } else if (widget.isSecondaryOutline) {
      bg = Colors.transparent;
      text = OiyaStyles.primary;
      style = OiyaStyles.bodyText(color: text);
      radius = OiyaStyles.roundedPill;
      border = Border.all(color: OiyaStyles.primary, width: 1.5);
      padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 12);
    } else if (widget.isDarkUtility) {
      bg = OiyaStyles.ink;
      text = Colors.white;
      style = OiyaStyles.buttonUtility(color: text);
      radius = OiyaStyles.roundedSm;
      padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 8);
    } else if (widget.isPearlCapsule) {
      bg = OiyaStyles.surfacePearl;
      text = OiyaStyles.inkMuted80;
      style = OiyaStyles.caption(color: text);
      radius = OiyaStyles.roundedMd;
      padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8);
      border = Border.all(color: OiyaStyles.dividerSoft, width: 3);
    } else if (widget.isStoreHero) {
      bg = OiyaStyles.primary;
      text = Colors.white;
      style = OiyaStyles.buttonLarge(color: text);
      radius = OiyaStyles.roundedPill;
      padding = const EdgeInsets.symmetric(horizontal: 28, vertical: 14);
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (widget.isSecondaryOutline && isDark) {
      text = OiyaStyles.primaryOnDark;
      style = OiyaStyles.bodyText(color: text);
      border = Border.all(color: OiyaStyles.primaryOnDark, width: 1.5);
    }

    return MouseRegion(
      cursor: widget.onPressed == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: widget.onPressed == null ? null : (_) => setState(() => _isPressed = true),
        onTapUp: widget.onPressed == null ? null : (_) => setState(() => _isPressed = false),
        onTapCancel: widget.onPressed == null ? null : () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          transform: Matrix4.identity()..scale(_isPressed ? 0.96 : 1.0),
          transformAlignment: Alignment.center,
          padding: padding,
          decoration: BoxDecoration(
            color: widget.onPressed == null ? bg.withOpacity(0.5) : bg,
            borderRadius: BorderRadius.circular(radius),
            border: border,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                widget.icon!,
                const SizedBox(width: 8),
              ],
              Text(widget.label, style: style.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
