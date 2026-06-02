import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/habits/controllers/habit_controller.dart';
import '../../../../features/habits/models/habit.dart';
import '../../../style/oiya_styles.dart';
import '../../../widgets/exam_prep_dashboard.dart';
import '../../../widgets/floating_toast.dart';
import '../../../widgets/oiya_button.dart';
import '../../../widgets/streak_badge.dart';

class HabitList extends ConsumerWidget {
  const HabitList({
    super.key,
    required this.onAddPressed,
    required this.onComplete,
  });

  final VoidCallback onAddPressed;
  final ValueChanged<Habit> onComplete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(activeHabitsForTodayProvider);
    final allHabits = ref.watch(habitControllerProvider);
    final examHabits = allHabits.where((r) => r.scheduleType == 'exam').toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (examHabits.isNotEmpty)
            ExamPrepDashboard(examHabits: examHabits),
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
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          CupertinoIcons.camera_fill,
                                          size: 8,
                                          color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          'POLAROID PROOF',
                                          style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      StreakBadge(habit: habit),
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
                              await ref.read(habitControllerProvider.notifier).deleteReminder(habit.id);
                              if (context.mounted) {
                                showOiyaToast(context, 'Habit deleted.');
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
                        StreakBadge(habit: habit),
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
                              await ref.read(habitControllerProvider.notifier).deleteReminder(habit.id);
                              if (context.mounted) {
                                showOiyaToast(context, 'Habit deleted.');
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
}
