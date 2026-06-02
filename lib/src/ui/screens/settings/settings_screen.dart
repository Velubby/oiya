import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/journal/controllers/journal_controller.dart';
import '../../../features/settings/controllers/theme_mode_controller.dart';
import '../../style/oiya_styles.dart';
import '../../widgets/floating_toast.dart';
import '../../widgets/mobile_header.dart';
import '../../widgets/quick_capture_sheet.dart'; // contains runWithBlockingLoader

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final memoriesCount = ref.watch(journalControllerProvider).length;

    return Scaffold(
      backgroundColor: isDark ? OiyaStyles.surfaceBlack : OiyaStyles.canvasParchment,
      appBar: const MobileHeader(title: 'Settings'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings.',
                style: OiyaStyles.displayLg(color: isDark ? Colors.white : OiyaStyles.ink),
              ),
              const SizedBox(height: 20),
              
              _SettingsGroup(
                title: 'Appearance',
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Theme Mode',
                          style: OiyaStyles.bodyStrong(color: isDark ? Colors.white : OiyaStyles.ink),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ThemeMode.light,
                            ThemeMode.dark,
                            ThemeMode.system,
                          ].map((mode) {
                            final isSelected = themeMode == mode;
                            final label = mode.name[0].toUpperCase() + mode.name.substring(1);
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      ref.read(themeModeProvider.notifier).setThemeMode(mode);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? (isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary)
                                            : (isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl),
                                        borderRadius: BorderRadius.circular(11),
                                        border: Border.all(
                                          color: isSelected
                                              ? (isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary)
                                              : (isDark ? const Color(0xFF333333) : OiyaStyles.hairline),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          label,
                                          style: OiyaStyles.captionStrong(
                                            color: isSelected
                                                ? (isDark ? OiyaStyles.ink : Colors.white)
                                                : (isDark ? Colors.white70 : OiyaStyles.inkMuted80),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              _SettingsGroup(
                title: 'Vault Statistics',
                children: [
                  _SettingsRow(
                    leading: Icon(CupertinoIcons.folder_badge_plus, size: 20, color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary),
                    title: 'Memories Stored',
                    trailing: Text(
                      '$memoriesCount ideas',
                      style: OiyaStyles.bodyStrong(color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary),
                    ),
                  ),
                  const _SettingsRow(
                    leading: Icon(CupertinoIcons.device_phone_portrait, size: 20, color: Color(0xFF34C759)),
                    title: 'Local Storage',
                    trailing: Text(
                      '100% Client-Only',
                      style: TextStyle(
                        color: Color(0xFF34C759),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              _SettingsGroup(
                title: 'Data Management',
                children: [
                  _SettingsRow(
                    isDestructive: true,
                    leading: const Icon(CupertinoIcons.clear_circled, size: 20, color: Color(0xFFFF3B30)),
                    title: 'Clear All Vault Data',
                    onTap: () async {
                      HapticFeedback.heavyImpact();
                      final confirm = await showCupertinoDialog<bool>(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: const Text('Delete all memories?'),
                          content: const Text('All ideas saved on this device will be lost forever.'),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete All'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true && context.mounted) {
                        HapticFeedback.heavyImpact();
                        await runWithBlockingLoader(
                          context,
                          message: 'Resetting Vault...',
                          action: () async {
                            final items = ref.read(journalControllerProvider);
                            final notifier = ref.read(journalControllerProvider.notifier);
                            for (final item in items) {
                              await notifier.deleteMemory(item.id);
                            }
                          },
                        );
                        if (context.mounted) {
                          showOiyaToast(context, 'Vault has been cleared.');
                        }
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Text(
                      'OIYA INC. v1.0.0',
                      style: OiyaStyles.captionStrong(color: isDark ? Colors.white30 : Colors.black26),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Copyright © 2026 Oiya Inc. All rights reserved. Zero trackers, zero cloud syncing. Purely private personal database.',
                        textAlign: TextAlign.center,
                        style: OiyaStyles.microLegal(color: isDark ? OiyaStyles.bodyMuted.withOpacity(0.4) : OiyaStyles.inkMuted48.withOpacity(0.6)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _SettingsGroup({
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              title!.toUpperCase(),
              style: OiyaStyles.captionStrong(
                color: isDark ? OiyaStyles.bodyMuted.withOpacity(0.6) : OiyaStyles.inkMuted48,
              ).copyWith(fontSize: 12, letterSpacing: 0.5),
            ),
          ),
        ],
        Container(
          decoration: BoxDecoration(
            color: isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline,
              width: 1.0,
            ),
          ),
          child: Column(
            children: List.generate(children.length, (index) {
              final child = children[index];
              final isLast = index == children.length - 1;
              if (isLast) {
                return child;
              }
              return Column(
                children: [
                  child,
                  Divider(
                    color: isDark ? const Color(0xFF333333) : OiyaStyles.dividerSoft,
                    height: 1,
                    thickness: 1,
                    indent: 16,
                  ),
                ],
              );
            }),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _SettingsRow extends StatefulWidget {
  final Widget? leading;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;

  const _SettingsRow({
    this.leading,
    required this.title,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  State<_SettingsRow> createState() => _SettingsRowState();
}

class _SettingsRowState extends State<_SettingsRow> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = widget.isDestructive
        ? const Color(0xFFFF3B30)
        : (isDark ? Colors.white : OiyaStyles.ink);

    Widget rowContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      color: _isPressed && widget.onTap != null
          ? (isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04))
          : Colors.transparent,
      child: Row(
        children: [
          if (widget.leading != null) ...[
            widget.leading!,
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              widget.title,
              style: OiyaStyles.bodyText(color: textColor).copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (widget.trailing != null) widget.trailing!,
        ],
      ),
    );

    if (widget.onTap != null) {
      rowContent = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onTap!();
          },
          child: rowContent,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: rowContent,
    );
  }
}
