import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../features/memory/memory_controller.dart';
import '../features/memory/memory_note.dart';
import '../features/memory/reminder.dart';
import '../features/memory/reminder_controller.dart';
import '../features/settings/theme_mode_controller.dart';
import 'retro_camera_view.dart';

class OiyaStyles {
  // Colors
  static const Color primary = Color(0xFF3A506B); // Midnight Indigo
  static const Color primaryFocus = Color(0xFF1C2541); // Deep Indigo Focus
  static const Color primaryOnDark = Color(0xFF9EC1A3); // Pale Sage
  static const Color ink = Color(0xFF1C2541); // Deep Indigo Ink
  static const Color body = Color(0xFF1C2541);
  static const Color bodyOnDark = Color(0xFFF4F6F9); // Ice White Body
  static const Color bodyMuted = Color(0xFF8D99AE); // Muted Slate
  static const Color inkMuted80 = Color(0xFF2B3A5A); // Deep Slate Blue
  static const Color inkMuted48 = Color(0xFF5C677D); // Muted Slate Grey
  static const Color dividerSoft = Color(0xFFEDF2F7); // Cool Divider Soft
  static const Color hairline = Color(0xFFE2E8F0); // Cool Hairline
  static const Color canvas = Color(0xFFFAF9F6); // Alabaster White
  static const Color canvasParchment = Color(0xFFF0F2F5); // Cool Mist
  static const Color surfacePearl = Color(0xFFEDF2F7); // Light Grey Button
  static const Color surfaceTile1 = Color(0xFF0B132B); // Midnight Dark
  static const Color surfaceTile2 = Color(0xFF1C2541); // Deep Indigo Card
  static const Color surfaceTile3 = Color(0xFF080C24); // Deepest Dark Indigo
  static const Color surfaceBlack = Color(0xFF050814); // Void Black
  static const Color surfaceChipTranslucent = Color(0xA3E2E8F0); // Translucent Cool Chip

  // Spacing
  static const double spacingXxs = 4.0;
  static const double spacingXs = 8.0;
  static const double spacingSm = 12.0;
  static const double spacingMd = 17.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;
  static const double spacingSection = 80.0;

  // Radii
  static const double roundedNone = 0.0;
  static const double roundedXs = 5.0;
  static const double roundedSm = 8.0;
  static const double roundedMd = 11.0;
  static const double roundedLg = 18.0;
  static const double roundedPill = 9999.0;
  static const double roundedFull = 9999.0;

  // Typography helpers
  static TextStyle heroDisplay({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 40, // Scaled down display headline for mobile comfort
        fontWeight: FontWeight.w600,
        height: 1.1,
        letterSpacing: -0.28,
        color: color,
      );

  static TextStyle displayLg({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 32, // Optimized size for mobile section titles
        fontWeight: FontWeight.w600,
        height: 1.15,
        letterSpacing: -0.4,
        color: color,
      );

  static TextStyle displayMd({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 26,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: -0.374,
        color: color,
      );

  static TextStyle lead({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w400,
        height: 1.3,
        letterSpacing: 0.1,
        color: color,
      );

  static TextStyle leadAiry({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 18,
        fontWeight: FontWeight.w300,
        height: 1.4,
        letterSpacing: 0,
        color: color,
      );

  static TextStyle tagline({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.15,
        color: color,
      );

  static TextStyle bodyStrong({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.24,
        letterSpacing: -0.374,
        color: color,
      );

  static TextStyle bodyText({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.47,
        letterSpacing: -0.374,
        color: color,
      );

  static TextStyle denseLink({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.8,
        letterSpacing: 0,
        color: color,
      );

  static TextStyle caption({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: -0.224,
        color: color,
      );

  static TextStyle captionStrong({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.29,
        letterSpacing: -0.224,
        color: color,
      );

  static TextStyle buttonLarge({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.0,
        letterSpacing: 0,
        color: color,
      );

  static TextStyle buttonUtility({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.29,
        letterSpacing: -0.224,
        color: color,
      );

  static TextStyle finePrint({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.1,
        letterSpacing: -0.12,
        color: color,
      );

  static TextStyle microLegal({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 10,
        fontWeight: FontWeight.w400,
        height: 1.3,
        letterSpacing: -0.08,
        color: color,
      );

  static TextStyle navLink({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.0,
        letterSpacing: -0.12,
        color: color,
      );
}

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

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  void _goToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _HomePage(onTabSelected: _goToTab),
      _CapturePage(onCaptureSaved: () => _goToTab(0)),
      const _SearchPage(),
      const _ResurfacePage(),
      const _SettingsPage(),
    ];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? OiyaStyles.surfaceBlack : OiyaStyles.canvasParchment,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: _OiyaBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _goToTab,
      ),
    );
  }
}

class _OiyaBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _OiyaBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary;
    final inactiveColor = isDark ? OiyaStyles.inkMuted48 : Colors.black38;

    const items = [
      _BottomNavItem(icon: CupertinoIcons.house, activeIcon: CupertinoIcons.house_fill, label: 'Vault'),
      _BottomNavItem(icon: CupertinoIcons.plus_circle, activeIcon: CupertinoIcons.plus_circle_fill, label: 'Capture'),
      _BottomNavItem(icon: CupertinoIcons.search, activeIcon: CupertinoIcons.search, label: 'Search'),
      _BottomNavItem(icon: CupertinoIcons.sparkles, activeIcon: CupertinoIcons.sparkles, label: 'Resurface'),
      _BottomNavItem(icon: CupertinoIcons.settings, activeIcon: CupertinoIcons.settings_solid, label: 'Settings'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: (isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas).withOpacity(0.88),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline,
            width: 0.5,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: SafeArea(
            top: false,
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final isSelected = index == currentIndex;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onTap(index);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSelected ? item.activeIcon : item.icon,
                            color: isSelected ? activeColor : inactiveColor,
                            size: 23,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.label,
                            style: OiyaStyles.navLink(
                              color: isSelected ? activeColor : inactiveColor,
                            ).copyWith(
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _MobileHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const _MobileHeader({required this.title, this.actions});

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

class _HomePage extends ConsumerStatefulWidget {
  final ValueChanged<int> onTabSelected;

  const _HomePage({
    required this.onTabSelected,
  });

  @override
  ConsumerState<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<_HomePage> {
  int _homeTab = 0; // 0 = Journal, 1 = Habits



  void _showCreateHabitSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: const _CreateHabitSheetContent(),
      ),
    );
  }

  void _handleCompleteHabit(BuildContext context, WidgetRef ref, Reminder habit) {
    if (habit.isCompletedOn(DateTime.now())) return;

    if (habit.proofType == 'none') {
      HapticFeedback.mediumImpact();
      ref.read(reminderControllerProvider.notifier).completeReminder(habit.id);
      _showCupertinoToast(context, 'Habit completed!');
    } else {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (ctx) => CupertinoActionSheet(
          title: Text('Complete "${habit.title}"'),
          message: const Text('This habit requires Polaroid proof. You can take a custom retro Polaroid photo or skip the proof.'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => RetroCameraView(
                      reminderId: habit.id,
                      reminderTitle: habit.title,
                      onComplete: () {
                        Navigator.pop(context);
                        _showCupertinoToast(context, 'Habit completed and verified!');
                      },
                    ),
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.camera_fill, size: 20),
                  SizedBox(width: 8),
                  Text('Take Retro Polaroid'),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(ctx);
                HapticFeedback.mediumImpact();
                ref.read(reminderControllerProvider.notifier).completeReminder(
                      habit.id,
                      proofCaption: 'Completed directly (Skipped Polaroid)',
                      proofData: 'Checked directly',
                    );
                _showCupertinoToast(context, 'Habit completed!');
              },
              child: const Text('Skip Photo & Mark Done'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(ctx),
            isDefaultAction: true,
            child: const Text('Cancel'),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final memories = ref.watch(memoryControllerProvider);
    final resurfacedCount = ref.watch(resurfacedMemoriesProvider).length;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount = 1;
    if (width >= 640) {
      crossAxisCount = 2;
    }

    final accentColor = isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary;

    return Scaffold(
      backgroundColor: isDark ? OiyaStyles.surfaceBlack : OiyaStyles.canvasParchment,
      appBar: _MobileHeader(
        title: 'OIYA',
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.plus, color: accentColor, size: 22),
            onPressed: () {
              if (_homeTab == 0) {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(ctx).viewInsets.bottom,
                    ),
                    child: const _QuickCaptureSheet(),
                  ),
                );
              } else {
                _showCreateHabitSheet(context, ref);
              }
            },
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Header title and subtitle
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _homeTab == 0 ? 'Vault.' : 'Habits.',
                    style: OiyaStyles.displayLg(
                      color: isDark ? Colors.white : OiyaStyles.ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _homeTab == 0
                        ? 'Remember everything, instantly.'
                        : 'Daily routines and exam study plans.',
                    style: OiyaStyles.leadAiry(
                      color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted48,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sliding Segment Toggle
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _homeTab = 0;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _homeTab == 0 ? accentColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Journal',
                            style: OiyaStyles.captionStrong(
                              color: _homeTab == 0
                                  ? (isDark ? OiyaStyles.ink : Colors.white)
                                  : (isDark ? Colors.white70 : OiyaStyles.inkMuted80),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _homeTab = 1;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _homeTab == 1 ? accentColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Habits',
                            style: OiyaStyles.captionStrong(
                              color: _homeTab == 1
                                  ? (isDark ? OiyaStyles.ink : Colors.white)
                                  : (isDark ? Colors.white70 : OiyaStyles.inkMuted80),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // TAB 0: JOURNAL
          if (_homeTab == 0) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline,
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${memories.length}',
                              style: OiyaStyles.displayMd(
                                color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ideas Saved',
                              style: OiyaStyles.captionStrong(
                                color: isDark ? Colors.white70 : OiyaStyles.inkMuted80,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline,
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$resurfacedCount',
                              style: OiyaStyles.displayMd(
                                color: resurfacedCount > 0
                                    ? const Color(0xFF34C759)
                                    : (isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted48),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Due Today',
                              style: OiyaStyles.captionStrong(
                                color: isDark ? Colors.white70 : OiyaStyles.inkMuted80,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Text(
                  'Recent Entries',
                  style: OiyaStyles.tagline(
                    color: isDark ? Colors.white : OiyaStyles.ink,
                  ),
                ),
              ),
            ),
            if (memories.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _OiyaProductGraphic(isDark: isDark),
                          const SizedBox(height: 28),
                          Text(
                            'Your Vault is empty',
                            style: OiyaStyles.bodyStrong(color: isDark ? Colors.white : OiyaStyles.ink),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Write down thoughts, reminders, or tasks quickly so they stay organized.',
                            style: OiyaStyles.caption(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          OiyaButton(
                            label: 'Capture Idea',
                            isPrimary: true,
                            onPressed: () => widget.onTabSelected(1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            else if (crossAxisCount == 1)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final memory = memories[memories.length - 1 - index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Dismissible(
                          key: Key(memory.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) async {
                            HapticFeedback.mediumImpact();
                            await ref.read(memoryControllerProvider.notifier).deleteMemory(memory.id);
                            if (context.mounted) {
                              _showCupertinoToast(context, 'Memory terhapus.');
                            }
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF3B30),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(CupertinoIcons.trash, color: Colors.white, size: 20),
                          ),
                          child: _MemoryCard(
                            memory: memory,
                            onTap: () => _openEditMemoryDialog(context, ref, memory),
                            onDelete: () => _confirmDeleteMemory(context, ref, memory),
                          ),
                        ),
                      );
                    },
                    childCount: memories.length,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.4,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final memory = memories[memories.length - 1 - index];
                      return _MemoryCard(
                        memory: memory,
                        onTap: () => _openEditMemoryDialog(context, ref, memory),
                        onDelete: () => _confirmDeleteMemory(context, ref, memory),
                      );
                    },
                    childCount: memories.length,
                  ),
                ),
              ),
          ] else ...[
            // TAB 1: HABITS
            SliverToBoxAdapter(
              child: _HabitList(
                onAddPressed: () => _showCreateHabitSheet(context, ref),
                onComplete: (habit) => _handleCompleteHabit(context, ref, habit),
              ),
            ),
          ],
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }
}

class _HabitList extends ConsumerWidget {
  const _HabitList({
    required this.onAddPressed,
    required this.onComplete,
  });

  final VoidCallback onAddPressed;
  final ValueChanged<Reminder> onComplete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(activeRemindersForTodayProvider);
    final allHabits = ref.watch(reminderControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Habits',
                style: OiyaStyles.tagline(color: isDark ? Colors.white : OiyaStyles.ink),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${habits.where((h) => h.isCompletedOn(DateTime.now())).length}/${habits.length} Done',
                  style: OiyaStyles.captionStrong(color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (habits.isEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline),
              ),
              child: Column(
                children: [
                  Icon(
                    CupertinoIcons.checkmark_seal,
                    size: 40,
                    color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No habits scheduled for today.',
                    style: OiyaStyles.bodyStrong(color: isDark ? Colors.white : OiyaStyles.ink),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Create daily habits or exams to build consistency and keep your streak alive.',
                    style: OiyaStyles.caption(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  OiyaButton(
                    label: 'Create Habit',
                    isPrimary: true,
                    onPressed: onAddPressed,
                  ),
                ],
              ),
            ),
          ] else ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                final isCompletedToday = habit.isCompletedOn(DateTime.now());

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isCompletedToday
                          ? const Color(0xFF7CA982).withOpacity(0.5)
                          : (isDark ? const Color(0xFF333333) : OiyaStyles.hairline),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: isCompletedToday ? null : () => onComplete(habit),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompletedToday
                                ? const Color(0xFF7CA982)
                                : Colors.transparent,
                            border: Border.all(
                              color: isCompletedToday ? const Color(0xFF7CA982) : OiyaStyles.primary,
                              width: 2.0,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: isCompletedToday
                              ? const Icon(CupertinoIcons.checkmark, color: Colors.white, size: 14)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              habit.title,
                              style: OiyaStyles.bodyStrong(
                                color: isCompletedToday
                                    ? (isDark ? Colors.white60 : OiyaStyles.inkMuted80)
                                    : (isDark ? Colors.white : OiyaStyles.ink),
                              ).copyWith(
                                decoration: isCompletedToday ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  habit.scheduleType == 'exam'
                                      ? CupertinoIcons.book
                                      : CupertinoIcons.calendar,
                                  size: 11,
                                  color: OiyaStyles.inkMuted48,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  habit.scheduleType.toUpperCase(),
                                  style: OiyaStyles.finePrint(color: OiyaStyles.inkMuted48),
                                ),
                                if (habit.proofType != 'none') ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: const Color(0x1F7CA982),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '📷 POLAROID PROOF',
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStreakBadge(context, ref, habit),
                      const SizedBox(width: 4),
                      if (!isCompletedToday)
                        IconButton(
                          icon: Icon(
                            habit.proofType == 'none'
                                ? CupertinoIcons.checkmark_circle
                                : CupertinoIcons.camera_fill,
                            color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary,
                          ),
                          onPressed: () => onComplete(habit),
                        )
                      else
                        IconButton(
                          icon: const Icon(CupertinoIcons.trash, color: Colors.redAccent, size: 16),
                          onPressed: () async {
                            HapticFeedback.lightImpact();
                            final confirm = await showCupertinoDialog<bool>(
                              context: context,
                              builder: (ctx) => CupertinoAlertDialog(
                                title: const Text('Delete Habit?'),
                                content: const Text('This will delete the habit reminder but keep your existing completion history.'),
                                actions: [
                                  CupertinoDialogAction(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Cancel'),
                                  ),
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await ref.read(reminderControllerProvider.notifier).deleteReminder(habit.id);
                              if (context.mounted) {
                                _showCupertinoToast(context, 'Habit deleted.');
                              }
                            }
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
          if (allHabits.isNotEmpty) ...[
            const SizedBox(height: 32),
            Text(
              'All Registered Habits',
              style: OiyaStyles.tagline(color: isDark ? Colors.white : OiyaStyles.ink),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allHabits.length,
              itemBuilder: (context, index) {
                final habit = allHabits[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isDark ? Colors.white10 : OiyaStyles.dividerSoft),
                    ),
                    tileColor: isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl,
                    title: Text(
                      habit.title,
                      style: OiyaStyles.bodyStrong(color: isDark ? Colors.white70 : OiyaStyles.ink),
                    ),
                    subtitle: Text(
                      'Type: ${habit.scheduleType.toUpperCase()} | Verification: ${habit.proofType.toUpperCase()}',
                      style: OiyaStyles.finePrint(color: OiyaStyles.inkMuted48),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildStreakBadge(context, ref, habit),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(CupertinoIcons.trash, color: Colors.redAccent, size: 16),
                          onPressed: () async {
                            HapticFeedback.lightImpact();
                            final confirm = await showCupertinoDialog<bool>(
                              context: context,
                              builder: (ctx) => CupertinoAlertDialog(
                                title: const Text('Delete Habit?'),
                                content: const Text('This will delete the habit reminder but keep your existing completion history.'),
                                actions: [
                                  CupertinoDialogAction(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Cancel'),
                                  ),
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await ref.read(reminderControllerProvider.notifier).deleteReminder(habit.id);
                              if (context.mounted) {
                                _showCupertinoToast(context, 'Habit deleted.');
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStreakBadge(BuildContext context, WidgetRef ref, Reminder habit) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final streak = habit.streakCount;
    final hasStreak = streak > 0;

    final badgeColor = hasStreak
        ? const Color(0xFFFF9500).withOpacity(0.12)
        : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03));
    final borderColor = hasStreak
        ? const Color(0xFFFF9500).withOpacity(0.4)
        : (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.08));
    final textColor = hasStreak
        ? (isDark ? const Color(0xFFFFB340) : const Color(0xFFD67A00))
        : (isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted48);

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        _showHabitStreakDetailSheet(context, ref, habit);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: hasStreak ? 1.0 : 0.4,
              child: const Text('🔥', style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(width: 4),
            Text(
              '${streak}d',
              style: OiyaStyles.finePrint(color: textColor).copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showHabitStreakDetailSheet(BuildContext context, WidgetRef ref, Reminder habit) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _HabitStreakDetailSheet(habit: habit),
  );
}

class _HabitStreakDetailSheet extends StatelessWidget {
  final Reminder habit;

  const _HabitStreakDetailSheet({required this.habit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final streak = habit.streakCount;
    final hasStreak = streak > 0;

    // Generate past 14 days (ending today)
    final List<DateTime> past14Days = List.generate(14, (index) {
      return todayStart.subtract(Duration(days: 13 - index));
    });

    // Calculate completions in the last 14 days
    int completionsInLast14 = 0;
    int scheduledInLast14 = 0;
    for (final date in past14Days) {
      if (habit.isCompletedOn(date)) completionsInLast14++;
      if (habit.isScheduledFor(date)) scheduledInLast14++;
    }
    final completionRate = scheduledInLast14 > 0
        ? (completionsInLast14 / scheduledInLast14 * 100).round()
        : 100;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? Colors.white30 : Colors.black12,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Title / Close button row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Habit Consistency',
                style: OiyaStyles.tagline(color: isDark ? Colors.white : OiyaStyles.ink),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  'Close',
                  style: OiyaStyles.captionStrong(color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Habit Hero Box (Title & Streak Count)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: hasStreak 
                    ? const Color(0xFFFF9500).withOpacity(0.3) 
                    : (isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Big Flame Indicator
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: hasStreak 
                        ? const Color(0xFFFF9500).withOpacity(0.15) 
                        : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03)),
                    shape: BoxShape.circle,
                  ),
                  child: Opacity(
                    opacity: hasStreak ? 1.0 : 0.4,
                    child: const Text('🔥', style: TextStyle(fontSize: 32)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.title,
                        style: OiyaStyles.lead(color: isDark ? Colors.white : OiyaStyles.ink).copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        hasStreak ? '$streak Day Streak!' : 'No active streak yet',
                        style: OiyaStyles.bodyStrong(
                          color: hasStreak 
                              ? (isDark ? const Color(0xFFFFB340) : const Color(0xFFD67A00))
                              : OiyaStyles.bodyMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Consistency Metrics
          Text(
            'STATISTICS',
            style: OiyaStyles.captionStrong(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  context,
                  label: 'COMPLETIONS',
                  value: '${habit.completedDates.length}',
                  subtext: 'Total days',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricTile(
                  context,
                  label: 'RATE (14D)',
                  value: '$completionRate%',
                  subtext: '$completionsInLast14/$scheduledInLast14 scheduled',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricTile(
                  context,
                  label: 'SCHEDULE',
                  value: habit.scheduleType.toUpperCase(),
                  subtext: habit.scheduleType == 'weekly'
                      ? '${habit.weeklyDays.length} days/week'
                      : 'Prep schedule',
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          // 14-day history grid
          Text(
            'LAST 14 DAYS',
            style: OiyaStyles.captionStrong(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 14,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 16,
              crossAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              final date = past14Days[index];
              final dayName = DateFormat('E').format(date).substring(0, 1);
              final dayNum = DateFormat('d').format(date);
              final isCompleted = habit.isCompletedOn(date);
              final isScheduled = habit.isScheduledFor(date);
              final isToday = date.year == todayStart.year && 
                              date.month == todayStart.month && 
                              date.day == todayStart.day;

              Widget indicator;
              Color statusColor;
              if (isCompleted) {
                statusColor = const Color(0xFF7CA982); // Green completed
                indicator = Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7CA982),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(CupertinoIcons.checkmark, size: 14, color: Colors.white),
                );
              } else if (isScheduled) {
                if (isToday) {
                  statusColor = const Color(0xFFFF9500); // Orange pending
                  indicator = Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: statusColor,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                } else {
                  statusColor = Colors.redAccent; // Red missed
                  indicator = Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: statusColor.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(CupertinoIcons.xmark, size: 12, color: statusColor),
                  );
                }
              } else {
                // Off day
                statusColor = isDark ? Colors.white24 : Colors.black12;
                indicator = Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: statusColor,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 6,
                      height: 1.5,
                      color: statusColor,
                    ),
                  ),
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dayName,
                    style: OiyaStyles.finePrint(color: isDark ? Colors.white30 : Colors.black38).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dayNum,
                    style: OiyaStyles.captionStrong(
                      color: isToday
                          ? (isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary)
                          : (isDark ? Colors.white70 : OiyaStyles.ink),
                    ),
                  ),
                  const SizedBox(height: 6),
                  indicator,
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem(context, const Color(0xFF7CA982), '✓ Completed'),
              _buildLegendItem(context, const Color(0xFFFF9500), '• Pending'),
              _buildLegendItem(context, Colors.redAccent, '✕ Missed'),
              _buildLegendItem(context, isDark ? Colors.white38 : Colors.black38, '- Off Day'),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildMetricTile(
    BuildContext context, {
    required String label,
    required String value,
    required String subtext,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: OiyaStyles.finePrint(
              color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted48,
            ).copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: OiyaStyles.bodyStrong(
              color: isDark ? Colors.white : OiyaStyles.ink,
            ).copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            subtext,
            style: OiyaStyles.microLegal(
              color: isDark ? Colors.white30 : Colors.black38,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: OiyaStyles.microLegal(
            color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted48,
          ),
        ),
      ],
    );
  }
}

class _CreateHabitSheetContent extends ConsumerStatefulWidget {
  const _CreateHabitSheetContent();

  @override
  ConsumerState<_CreateHabitSheetContent> createState() => _CreateHabitSheetContentState();
}

class _CreateHabitSheetContentState extends ConsumerState<_CreateHabitSheetContent> {
  final TextEditingController _titleController = TextEditingController();
  String _proofType = 'none'; // 'none' or 'image'
  String _scheduleType = 'daily'; // 'daily', 'weekly', 'exam'

  final List<int> _selectedWeeklyDays = [];
  final List<DateTime> _selectedExamDates = [];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _toggleWeeklyDay(int day) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_selectedWeeklyDays.contains(day)) {
        _selectedWeeklyDays.remove(day);
      } else {
        _selectedWeeklyDays.add(day);
      }
    });
  }

  Future<void> _addExamDate() async {
    HapticFeedback.lightImpact();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: OiyaStyles.primaryOnDark,
                    onPrimary: OiyaStyles.ink,
                    surface: OiyaStyles.surfaceTile1,
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: OiyaStyles.primary,
                    onPrimary: Colors.white,
                    surface: OiyaStyles.canvas,
                    onSurface: OiyaStyles.ink,
                  ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        final normalized = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
        if (!_selectedExamDates.any((d) => d.year == normalized.year && d.month == normalized.month && d.day == normalized.day)) {
          _selectedExamDates.add(normalized);
          _selectedExamDates.sort();
        }
      });
    }
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    if (_scheduleType == 'weekly' && _selectedWeeklyDays.isEmpty) {
      _showCupertinoToast(context, 'Pilih minimal satu hari.');
      return;
    }

    if (_scheduleType == 'exam' && _selectedExamDates.isEmpty) {
      _showCupertinoToast(context, 'Tambahkan minimal satu tanggal ujian.');
      return;
    }

    await ref.read(reminderControllerProvider.notifier).addReminder(
          title: title,
          proofType: _proofType,
          scheduleType: _scheduleType,
          weeklyDays: _selectedWeeklyDays,
          examDates: _selectedExamDates,
        );

    if (mounted) {
      Navigator.pop(context);
      _showCupertinoToast(context, 'Habit berhasil dibuat!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? Colors.white30 : Colors.black12,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Create Habit / Study Schedule',
                style: OiyaStyles.tagline(color: isDark ? Colors.white : OiyaStyles.ink),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  'Batal',
                  style: OiyaStyles.captionStrong(color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'HABIT / EXAM NAME',
            style: OiyaStyles.captionStrong(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            style: OiyaStyles.bodyText(color: isDark ? Colors.white : OiyaStyles.ink),
            decoration: InputDecoration(
              hintText: 'e.g. Maths Exam Prep, Clean the bed...',
              hintStyle: TextStyle(
                color: isDark ? Colors.white30 : Colors.black38,
                fontSize: 15,
              ),
              filled: true,
              fillColor: isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl,
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'VERIFICATION PROOF',
            style: OiyaStyles.captionStrong(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildSegmentButton('none', 'No Photo Proof', _proofType == 'none', (val) {
                setState(() => _proofType = val);
              }),
              const SizedBox(width: 10),
              _buildSegmentButton('image', '📷 Polaroid Photo', _proofType == 'image', (val) {
                setState(() => _proofType = val);
              }),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'SCHEDULE TYPE',
            style: OiyaStyles.captionStrong(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildScheduleSegment('daily', 'Daily', _scheduleType == 'daily'),
              const SizedBox(width: 8),
              _buildScheduleSegment('weekly', 'Weekly', _scheduleType == 'weekly'),
              const SizedBox(width: 8),
              _buildScheduleSegment('exam', '🎓 Exam Prep', _scheduleType == 'exam'),
            ],
          ),
          const SizedBox(height: 20),
          if (_scheduleType == 'weekly') ...[
            Text(
              'REPEAT DAYS',
              style: OiyaStyles.captionStrong(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final dayNum = index + 1;
                final dayName = ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index];
                final isSelected = _selectedWeeklyDays.contains(dayNum);
                return GestureDetector(
                  onTap: () => _toggleWeeklyDay(dayNum),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? (isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary)
                          : (isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl),
                      border: Border.all(
                        color: isSelected
                            ? (isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary)
                            : (isDark ? Colors.white10 : OiyaStyles.dividerSoft),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      dayName,
                      style: TextStyle(
                        color: isSelected
                            ? (isDark ? OiyaStyles.ink : Colors.white)
                            : (isDark ? Colors.white70 : OiyaStyles.inkMuted80),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
          ] else if (_scheduleType == 'exam') ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'EXAM DATES',
                  style: OiyaStyles.captionStrong(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
                ),
                GestureDetector(
                  onTap: _addExamDate,
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.plus_circle, size: 14, color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary),
                      const SizedBox(width: 4),
                      Text(
                        'Add Date',
                        style: OiyaStyles.captionStrong(color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_selectedExamDates.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'No exam dates added yet.',
                  style: OiyaStyles.caption(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedExamDates.map((date) {
                  final dateStr = DateFormat('dd MMM yyyy').format(date);
                  return Chip(
                    label: Text(
                      dateStr,
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.white : OiyaStyles.ink),
                    ),
                    backgroundColor: isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isDark ? Colors.white12 : OiyaStyles.dividerSoft),
                    ),
                    deleteIcon: const Icon(CupertinoIcons.xmark, size: 12, color: Colors.redAccent),
                    onDeleted: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _selectedExamDates.remove(date);
                      });
                    },
                  );
                }).toList(),
              ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0x1F7CA982),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x407CA982)),
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.info_circle_fill, color: Color(0xFF7CA982), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Prep sessions will automatically be scheduled exactly 1 day before each exam date.',
                      style: OiyaStyles.finePrint(color: isDark ? Colors.white70 : OiyaStyles.inkMuted80),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
          SizedBox(
            width: double.infinity,
            child: OiyaButton(
              label: 'Create Habit',
              isPrimary: true,
              onPressed: _save,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(String value, String label, bool isSelected, ValueChanged<String> onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap(value);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary)
                : (isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? (isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary)
                  : (isDark ? Colors.white10 : OiyaStyles.dividerSoft),
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
    );
  }

  Widget _buildScheduleSegment(String value, String label, bool isSelected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() {
            _scheduleType = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary)
                : (isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? (isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary)
                  : (isDark ? Colors.white10 : OiyaStyles.dividerSoft),
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
    );
  }
}

class _CapturePage extends ConsumerStatefulWidget {
  const _CapturePage({required this.onCaptureSaved});

  final VoidCallback onCaptureSaved;

  @override
  ConsumerState<_CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends ConsumerState<_CapturePage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  bool _isSaving = false;
  int _sessionCount = 0;
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateCharCount);
  }

  void _updateCharCount() {
    setState(() {
      _charCount = _controller.text.length;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_updateCharCount);
    _controller.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await ref.read(memoryControllerProvider.notifier).addMemory(text);
      HapticFeedback.mediumImpact();
      _controller.clear();
      if (!mounted) return;

      final isThoughtDump = ref.read(thoughtDumpModeProvider);
      if (!isThoughtDump) {
        _showCupertinoToast(context, 'Memory tersimpan.');
        widget.onCaptureSaved();
      } else {
        setState(() {
          _sessionCount++;
        });
        _inputFocusNode.requestFocus();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isThoughtDump = ref.watch(thoughtDumpModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? OiyaStyles.surfaceBlack : OiyaStyles.canvasParchment,
      appBar: const _MobileHeader(title: 'Capture'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New Memory.',
                style: OiyaStyles.displayLg(color: isDark ? Colors.white : OiyaStyles.ink),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      key: const ValueKey<String>('capture-input'),
                      controller: _controller,
                      focusNode: _inputFocusNode,
                      autofocus: !kIsWeb, // Safely autofocus only on native platforms
                      minLines: 5,
                      maxLines: 8,
                      maxLength: 500,
                      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => const SizedBox(),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _save(),
                      style: OiyaStyles.bodyText(color: isDark ? Colors.white : OiyaStyles.ink),
                      decoration: InputDecoration(
                        hintText: isThoughtDump
                            ? 'Tulis cepat, klik Simpan untuk terus lanjut...'
                            : 'Tulis ide, memo, atau catatan cepat...',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white30 : Colors.black38,
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl,
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: OiyaStyles.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Character Count',
                          style: OiyaStyles.caption(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
                        ),
                        Text(
                          '$_charCount / 500',
                          style: OiyaStyles.captionStrong(
                            color: _charCount >= 500
                                ? Theme.of(context).colorScheme.error
                                : (isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted48),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: OiyaStyles.hairline, height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Thought Dump Mode',
                          style: OiyaStyles.bodyStrong(color: isDark ? Colors.white : OiyaStyles.ink),
                        ),
                        CupertinoSwitch(
                          activeColor: OiyaStyles.primary,
                          value: isThoughtDump,
                          onChanged: (value) {
                            HapticFeedback.lightImpact();
                            ref.read(thoughtDumpModeProvider.notifier).state = value;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Keep keyboard open for rapid entry stacks.',
                      style: OiyaStyles.finePrint(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted48),
                    ),
                  ],
                ),
              ),
              if (isThoughtDump && _sessionCount > 0) ...[
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0x1F30D158),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(CupertinoIcons.checkmark_seal_fill, color: Color(0xFF30D158), size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'Captured $_sessionCount ideas this session',
                          style: OiyaStyles.captionStrong(color: const Color(0xFF30D158)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OiyaButton(
                  label: _isSaving
                      ? 'Saving...'
                      : isThoughtDump
                          ? 'Save & Continue'
                          : 'Save to Vault',
                  isPrimary: true,
                  icon: _isSaving
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CupertinoActivityIndicator(radius: 8, color: Colors.white),
                        )
                      : Icon(
                          isThoughtDump ? CupertinoIcons.paperplane_fill : CupertinoIcons.checkmark_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                  onPressed: _save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchPage extends ConsumerStatefulWidget {
  const _SearchPage();

  @override
  ConsumerState<_SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<_SearchPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initialQuery = ref.read(searchQueryProvider);
    _controller = TextEditingController(text: initialQuery);
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final currentFilter = ref.watch(searchFilterProvider);
    final results = ref.watch(filteredMemoriesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount = 1;
    if (width >= 640) {
      crossAxisCount = 2;
    }

    return Scaffold(
      backgroundColor: isDark ? OiyaStyles.surfaceBlack : OiyaStyles.canvasParchment,
      appBar: const _MobileHeader(title: 'Search'),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search.',
                      style: OiyaStyles.displayLg(color: isDark ? Colors.white : OiyaStyles.ink),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _controller,
                      onChanged: (value) =>
                          ref.read(searchQueryProvider.notifier).state = value,
                      style: OiyaStyles.bodyText(color: isDark ? Colors.white : OiyaStyles.ink),
                      decoration: InputDecoration(
                        hintText: 'Cari catatan atau ide...',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white30 : Colors.black38,
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas,
                        prefixIcon: Icon(
                          CupertinoIcons.search,
                          color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted48,
                          size: 20,
                        ),
                        suffixIcon: _controller.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  _controller.clear();
                                  ref.read(searchQueryProvider.notifier).state = '';
                                },
                                child: Icon(
                                  CupertinoIcons.clear_thick_circled,
                                  color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted48,
                                  size: 20,
                                ),
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9999),
                          borderSide: BorderSide(
                            color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9999),
                          borderSide: BorderSide(
                            color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9999),
                          borderSide: const BorderSide(
                            color: OiyaStyles.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _SearchFilterChip(
                            label: 'All Memories',
                            isSelected: currentFilter == SearchFilter.all,
                            onTap: () {
                              ref.read(searchFilterProvider.notifier).state = SearchFilter.all;
                            },
                          ),
                          const SizedBox(width: 8),
                          _SearchFilterChip(
                            label: 'Created Today',
                            isSelected: currentFilter == SearchFilter.today,
                            onTap: () {
                              ref.read(searchFilterProvider.notifier).state = SearchFilter.today;
                            },
                          ),
                          const SizedBox(width: 8),
                          _SearchFilterChip(
                            label: 'Recent (3d)',
                            isSelected: currentFilter == SearchFilter.recent,
                            onTap: () {
                              ref.read(searchFilterProvider.notifier).state = SearchFilter.recent;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.surfacePearl,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(color: OiyaStyles.dividerSoft),
                      ),
                      child: Text(
                        query.trim().isEmpty
                            ? 'All Saved (${results.length})'
                            : 'Results for "$query" (${results.length})',
                        style: OiyaStyles.captionStrong(
                          color: isDark ? Colors.white : OiyaStyles.inkMuted80,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (results.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.search_circle,
                        size: 48,
                        color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No matching memories found.',
                        style: OiyaStyles.caption(
                          color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted48,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (crossAxisCount == 1)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final memory = results[results.length - 1 - index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Dismissible(
                          key: Key('search-${memory.id}'),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) async {
                            HapticFeedback.mediumImpact();
                            await ref.read(memoryControllerProvider.notifier).deleteMemory(memory.id);
                            if (context.mounted) {
                              _showCupertinoToast(context, 'Memory terhapus.');
                            }
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF3B30),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(CupertinoIcons.trash, color: Colors.white, size: 20),
                          ),
                          child: _MemoryCard(
                            memory: memory,
                            onTap: () => _openEditMemoryDialog(context, ref, memory),
                            onDelete: () => _confirmDeleteMemory(context, ref, memory),
                          ),
                        ),
                      );
                    },
                    childCount: results.length,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.4,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final memory = results[results.length - 1 - index];
                      return _MemoryCard(
                        memory: memory,
                        onTap: () => _openEditMemoryDialog(context, ref, memory),
                        onDelete: () => _confirmDeleteMemory(context, ref, memory),
                      );
                    },
                    childCount: results.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResurfacePage extends ConsumerWidget {
  const _ResurfacePage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resurfaced = ref.watch(resurfacedMemoriesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount = 1;
    if (width >= 640) {
      crossAxisCount = 2;
    }

    return Scaffold(
      backgroundColor: isDark ? OiyaStyles.surfaceBlack : OiyaStyles.canvasParchment,
      appBar: const _MobileHeader(title: 'Resurface'),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resurface.',
                      style: OiyaStyles.displayLg(color: isDark ? Colors.white : OiyaStyles.ink),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Ideas automatically surface at 7, 14, and 30-day intervals so they are never forgotten.',
                      style: OiyaStyles.leadAiry(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted48),
                    ),
                  ],
                ),
              ),
            ),
            if (resurfaced.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _OiyaProductGraphic(isDark: isDark),
                          const SizedBox(height: 28),
                          Text(
                            'Nothing to resurface today',
                            style: OiyaStyles.bodyStrong(color: isDark ? Colors.white : OiyaStyles.ink),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Capture thoughts daily and they will automatically reappear here when their time is right.',
                            style: OiyaStyles.caption(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            else if (crossAxisCount == 1)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final memory = resurfaced[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Dismissible(
                          key: Key('resurface-${memory.id}'),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) async {
                            HapticFeedback.mediumImpact();
                            await ref.read(memoryControllerProvider.notifier).deleteMemory(memory.id);
                            if (context.mounted) {
                              _showCupertinoToast(context, 'Memory terhapus.');
                            }
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF3B30),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(CupertinoIcons.trash, color: Colors.white, size: 20),
                          ),
                          child: _MemoryCard(
                            memory: memory,
                            onTap: () => _openEditMemoryDialog(context, ref, memory),
                            onDelete: () => _confirmDeleteMemory(context, ref, memory),
                          ),
                        ),
                      );
                    },
                    childCount: resurfaced.length,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.4,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final memory = resurfaced[index];
                      return _MemoryCard(
                        memory: memory,
                        onTap: () => _openEditMemoryDialog(context, ref, memory),
                        onDelete: () => _confirmDeleteMemory(context, ref, memory),
                      );
                    },
                    childCount: resurfaced.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsPage extends ConsumerWidget {
  const _SettingsPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final memoriesCount = ref.watch(memoryControllerProvider).length;

    return Scaffold(
      backgroundColor: isDark ? OiyaStyles.surfaceBlack : OiyaStyles.canvasParchment,
      appBar: const _MobileHeader(title: 'Settings'),
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
                          title: const Text('Hapus seluruh memory?'),
                          content: const Text('Semua ide yang disimpan di HP ini akan hilang selamanya.'),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Batal'),
                            ),
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Hapus Semua'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true && context.mounted) {
                        HapticFeedback.heavyImpact();
                        await _runWithBlockingLoader(
                          context,
                          message: 'Mereset Vault...',
                          action: () async {
                            final items = ref.read(memoryControllerProvider);
                            final notifier = ref.read(memoryControllerProvider.notifier);
                            for (final item in items) {
                              await notifier.deleteMemory(item.id);
                            }
                          },
                        );
                        if (context.mounted) {
                          _showCupertinoToast(context, 'Vault telah dibersihkan.');
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

class _MemoryCard extends StatefulWidget {
  final MemoryNote memory;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _MemoryCard({
    required this.memory,
    required this.onTap,
    this.onDelete,
  });

  @override
  State<_MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<_MemoryCard> {
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

class _OiyaProductGraphic extends StatelessWidget {
  final bool isDark;

  const _OiyaProductGraphic({required this.isDark});

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

class _QuickCaptureSheet extends ConsumerStatefulWidget {
  const _QuickCaptureSheet();

  @override
  ConsumerState<_QuickCaptureSheet> createState() => _QuickCaptureSheetState();
}

class _QuickCaptureSheetState extends ConsumerState<_QuickCaptureSheet> {
  final TextEditingController _controller = TextEditingController();
  bool _isSaving = false;

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await ref.read(memoryControllerProvider.notifier).addMemory(text);
      if (mounted) {
        Navigator.of(context).pop();
        _showCupertinoToast(context, 'Memory tersimpan.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        border: Border.all(color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? Colors.white30 : Colors.black12,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Capture',
                style: OiyaStyles.tagline(color: isDark ? Colors.white : OiyaStyles.ink),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  'Batal',
                  style: OiyaStyles.captionStrong(color: OiyaStyles.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: !kIsWeb, // Safely autofocus only on native platforms
            minLines: 3,
            maxLines: 5,
            maxLength: 300,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            style: OiyaStyles.bodyText(color: isDark ? Colors.white : OiyaStyles.ink),
            decoration: InputDecoration(
              hintText: 'Tulis cepat sebelum lupa...',
              hintStyle: TextStyle(
                color: isDark ? Colors.white30 : Colors.black38,
                fontSize: 16,
              ),
              filled: true,
              fillColor: isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl,
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: OiyaStyles.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OiyaButton(
              label: _isSaving ? 'Saving...' : 'Save',
              isPrimary: true,
              icon: _isSaving
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CupertinoActivityIndicator(radius: 8, color: Colors.white),
                    )
                  : null,
              onPressed: _save,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

Future<void> _runWithBlockingLoader(
  BuildContext context, {
  required String message,
  required Future<void> Function() action,
}) async {
  showCupertinoDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => CupertinoAlertDialog(
      content: Row(
        children: [
          const SizedBox(
            width: 22,
            height: 22,
            child: CupertinoActivityIndicator(radius: 11),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(message)),
        ],
      ),
    ),
  );

  try {
    await action();
  } finally {
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

void _showCupertinoToast(BuildContext context, String message) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 80),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.85),
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: OiyaStyles.caption(color: Colors.white),
        ),
      ),
    ),
  );
  Future.delayed(const Duration(milliseconds: 1200), () {
    if (!context.mounted) return;
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
  });
}

Future<void> _openEditMemoryDialog(
  BuildContext context,
  WidgetRef ref,
  MemoryNote memory,
) async {
  final controller = TextEditingController(text: memory.text);
  final nextText = await showCupertinoDialog<String>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text('Edit memory'),
      content: Container(
        padding: const EdgeInsets.only(top: 12),
        child: CupertinoTextField(
          controller: controller,
          autofocus: true,
          minLines: 3,
          maxLines: 6,
          maxLength: 500,
          placeholder: 'Isi memory',
          style: const TextStyle(fontSize: 16),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(controller.text.trim()),
          child: const Text('Simpan'),
        ),
      ],
    ),
  );
  WidgetsBinding.instance.addPostFrameCallback((_) {
    controller.dispose();
  });

  if (nextText == null ||
      nextText.isEmpty ||
      nextText == memory.text ||
      !context.mounted) {
    return;
  }

  await _runWithBlockingLoader(
    context,
    message: 'Menyimpan perubahan...',
    action: () => ref
        .read(memoryControllerProvider.notifier)
        .updateMemory(memory.id, nextText),
  );
}

Future<void> _confirmDeleteMemory(
  BuildContext context,
  WidgetRef ref,
  MemoryNote memory,
) async {
  final confirm = await showCupertinoDialog<bool>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text('Hapus memory?'),
      content: const Text('Catatan ini akan hilang selamanya.'),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Hapus'),
        ),
      ],
    ),
  );

  if (confirm == true && context.mounted) {
    HapticFeedback.mediumImpact();
    await _runWithBlockingLoader(
      context,
      message: 'Menghapus...',
      action: () => ref
          .read(memoryControllerProvider.notifier)
          .deleteMemory(memory.id),
    );
    if (context.mounted) {
      _showCupertinoToast(context, 'Memory terhapus.');
    }
  }
}

class _SearchFilterChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SearchFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SearchFilterChip> createState() => _SearchFilterChipState();
}

class _SearchFilterChipState extends State<_SearchFilterChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color selectedBg = isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary;
    final Color selectedText = isDark ? OiyaStyles.ink : Colors.white;
    
    final Color unselectedBg = isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl;
    final Color unselectedText = isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80;
    final Color unselectedBorder = isDark ? const Color(0xFF333333) : OiyaStyles.dividerSoft;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          transform: Matrix4.identity()..scale(_isPressed ? 0.96 : 1.0),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isSelected ? selectedBg : unselectedBg,
            borderRadius: BorderRadius.circular(OiyaStyles.roundedPill),
            border: Border.all(
              color: widget.isSelected ? selectedBg : unselectedBorder,
              width: 1.0,
            ),
          ),
          child: Text(
            widget.label,
            style: OiyaStyles.captionStrong(
              color: widget.isSelected ? selectedText : unselectedText,
            ),
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
