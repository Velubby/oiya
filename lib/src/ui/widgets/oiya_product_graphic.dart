import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../style/oiya_styles.dart';

class OiyaProductGraphic extends StatelessWidget {
  final bool isDark;

  const OiyaProductGraphic({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 200,
      decoration: BoxDecoration(
        color: isDark ? OiyaStyles.surfaceTile3 : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline),
        boxShadow: const [
          BoxShadow(
            color: Color(0x38000000), // rgba(0, 0, 0, 0.22)
            offset: Offset(3, 5),
            blurRadius: 30,
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: OiyaStyles.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Memory Vault v1.0',
                style: OiyaStyles.captionStrong(color: isDark ? Colors.white : OiyaStyles.ink),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '“The mind is for having ideas, not holding them.”',
            style: OiyaStyles.bodyText(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80).copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '7 days ago',
                style: OiyaStyles.finePrint(color: OiyaStyles.inkMuted48),
              ),
              const Icon(CupertinoIcons.sparkles, color: OiyaStyles.primary, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}
