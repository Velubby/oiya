import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/journal/controllers/journal_controller.dart';
import '../../../features/habits/controllers/habit_controller.dart';
import '../../../features/habits/models/habit.dart';
import '../../style/oiya_styles.dart';
import '../../widgets/create_habit_sheet.dart';
import '../../widgets/floating_toast.dart';
import '../../widgets/journal_actions.dart';
import '../../widgets/memory_card.dart';
import '../../widgets/mobile_header.dart';
import '../../widgets/oiya_button.dart';
import '../../widgets/oiya_product_graphic.dart';
import '../../widgets/quick_capture_sheet.dart';
import '../../widgets/retro_camera/retro_camera_view.dart';
import '../../widgets/streak_promotion_dialog.dart';
import 'widgets/habit_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final ValueChanged<int> onTabSelected;

  const HomeScreen({
    super.key,
    required this.onTabSelected,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
        child: const CreateHabitSheet(),
      ),
    );
  }

  void _handleCompleteHabit(BuildContext context, WidgetRef ref, Habit habit) async {
    if (habit.isCompletedOn(DateTime.now())) return;

    final oldStreak = habit.streakCount;

    if (habit.proofType == 'none') {
      HapticFeedback.mediumImpact();
      await ref.read(habitControllerProvider.notifier).completeReminder(habit.id);
      if (context.mounted) {
        showOiyaToast(context, 'Habit completed!');
        checkAndShowStreakPromotion(context, ref, habit.id, oldStreak);
      }
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
                        showOiyaToast(context, 'Habit completed and verified!');
                        checkAndShowStreakPromotion(context, ref, habit.id, oldStreak);
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
              onPressed: () async {
                Navigator.pop(ctx);
                HapticFeedback.mediumImpact();
                await ref.read(habitControllerProvider.notifier).completeReminder(
                      habit.id,
                      proofCaption: 'Completed directly (Skipped Polaroid)',
                      proofData: 'Checked directly',
                    );
                if (context.mounted) {
                  showOiyaToast(context, 'Habit completed!');
                  checkAndShowStreakPromotion(context, ref, habit.id, oldStreak);
                }
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
    final memories = ref.watch(journalControllerProvider);
    final resurfacedCount = ref.watch(resurfacedJournalNotesProvider).length;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount = 1;
    if (width >= 640) {
      crossAxisCount = 2;
    }

    final accentColor = isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary;

    return Scaffold(
      backgroundColor: isDark ? OiyaStyles.surfaceBlack : OiyaStyles.canvasParchment,
      appBar: MobileHeader(
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
                    child: const QuickCaptureSheet(),
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
                          OiyaProductGraphic(isDark: isDark),
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
                            await ref.read(journalControllerProvider.notifier).deleteMemory(memory.id);
                            if (context.mounted) {
                              showOiyaToast(context, 'Memory deleted.');
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
                          child: MemoryCard(
                            memory: memory,
                            onTap: () => openEditMemoryDialog(context, ref, memory),
                            onDelete: () => confirmDeleteMemory(context, ref, memory),
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
                      return MemoryCard(
                        memory: memory,
                        onTap: () => openEditMemoryDialog(context, ref, memory),
                        onDelete: () => confirmDeleteMemory(context, ref, memory),
                      );
                    },
                    childCount: memories.length,
                  ),
                ),
              ),
          ] else ...[
            // TAB 1: HABITS
            SliverToBoxAdapter(
              child: HabitList(
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
