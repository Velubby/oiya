import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../features/journal/models/journal_note.dart';
import '../style/oiya_styles.dart';

class MemoryCard extends StatefulWidget {
  final JournalNote memory;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const MemoryCard({
    super.key,
    required this.memory,
    required this.onTap,
    this.onDelete,
  });

  @override
  State<MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd MMM yyyy, HH:mm');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final ageInDays = DateTime.now().difference(widget.memory.createdAt).inDays;
    String? intervalTag;
    if (ageInDays == 7) intervalTag = '7 Days Ago';
    if (ageInDays == 14) intervalTag = '14 Days Ago';
    if (ageInDays == 30) intervalTag = '30 Days Ago';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _isHovered
                  ? (isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary)
                  : (isDark ? const Color(0xFF333333) : OiyaStyles.hairline),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl,
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(color: OiyaStyles.dividerSoft, width: 1.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.sparkles,
                              size: 11,
                              color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Idea',
                              style: OiyaStyles.captionStrong(
                                color: isDark ? Colors.white : OiyaStyles.inkMuted80,
                              ).copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      if (intervalTag != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0x1F34C759),
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(color: const Color(0x4034C759)),
                          ),
                          child: Text(
                            intervalTag,
                            style: const TextStyle(
                              color: Color(0xFF34C759),
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (widget.onDelete != null)
                    IconButton(
                      icon: const Icon(CupertinoIcons.delete, size: 16),
                      color: OiyaStyles.inkMuted48,
                      onPressed: widget.onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.memory.text,
                style: OiyaStyles.bodyStrong(
                  color: isDark ? Colors.white : OiyaStyles.ink,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      formatter.format(widget.memory.createdAt),
                      style: OiyaStyles.finePrint(
                        color: OiyaStyles.inkMuted48,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Tap to edit',
                    style: OiyaStyles.captionStrong(
                      color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary,
                    ).copyWith(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
