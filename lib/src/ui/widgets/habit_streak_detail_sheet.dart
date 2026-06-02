import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../features/habits/controllers/habit_controller.dart';
import '../../features/habits/models/habit.dart';
import '../style/oiya_styles.dart';
import 'oiya_button.dart';
import 'streak_badge.dart';
import 'streak_promotion_dialog.dart';

void showHabitStreakDetailSheet(BuildContext context, WidgetRef ref, Habit habit) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => HabitStreakDetailSheet(habit: habit),
  );
}

class HabitStreakDetailSheet extends ConsumerWidget {
  final Habit habit;

  const HabitStreakDetailSheet({super.key, required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitControllerProvider);
    final activeHabit = habits.firstWhere((r) => r.id == habit.id, orElse: () => habit);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final streak = activeHabit.streakCount;
    final hasStreak = streak > 0;
    final style = getStreakTierStyle(streak, isDark);

    // Generate past 14 days (ending today)
    final List<DateTime> past14Days = List.generate(14, (index) {
      return todayStart.subtract(Duration(days: 13 - index));
    });

    // Calculate completions in the last 14 days
    int completionsInLast14 = 0;
    int scheduledInLast14 = 0;
    for (final date in past14Days) {
      if (activeHabit.isCompletedOn(date)) completionsInLast14++;
      if (activeHabit.isScheduledFor(date)) scheduledInLast14++;
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
                color: style.borderTint,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Big Flame Indicator
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: style.bgTint,
                    shape: BoxShape.circle,
                    border: Border.all(color: style.borderTint, width: 1.0),
                  ),
                  child: streak == 0
                      ? Icon(style.icon, size: 32, color: style.textColor.withOpacity(0.5))
                      : GradientIcon(style.icon, colors: style.gradientColors, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activeHabit.title,
                        style: OiyaStyles.lead(color: isDark ? Colors.white : OiyaStyles.ink).copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        hasStreak ? '$streak Day Streak! (${style.name})' : 'No active streak yet',
                        style: OiyaStyles.bodyStrong(
                          color: style.textColor,
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
                  value: '${activeHabit.completedDates.length}',
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
                  value: activeHabit.scheduleType == 'specific'
                      ? 'ACTIVITY'
                      : activeHabit.scheduleType.toUpperCase(),
                  subtext: activeHabit.scheduleType == 'custom'
                      ? '${activeHabit.weeklyDays.length} days/week'
                      : activeHabit.scheduleType == 'daily'
                          ? 'Every day'
                          : activeHabit.scheduleType == 'specific'
                              ? _formatSpecificSchedule(activeHabit)
                              : 'Prep schedule',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Streak Shields status
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? OiyaStyles.surfaceTile2 : OiyaStyles.surfacePearl,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const GradientIcon(
                      CupertinoIcons.shield_fill,
                      colors: [Color(0xFF64D2FF), Color(0xFF0A84FF)],
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Streak Shields',
                          style: OiyaStyles.captionStrong(color: isDark ? Colors.white : OiyaStyles.ink),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${activeHabit.restoreChances} of 3 available',
                          style: OiyaStyles.finePrint(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: List.generate(3, (idx) {
                    final isAvailable = idx < activeHabit.restoreChances;
                    return Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: isAvailable
                          ? const GradientIcon(
                              CupertinoIcons.shield_fill,
                              colors: [Color(0xFF64D2FF), Color(0xFF0A84FF)],
                              size: 16,
                            )
                          : Icon(
                              CupertinoIcons.shield,
                              color: isDark ? Colors.white24 : Colors.black26,
                              size: 16,
                            ),
                    );
                  }),
                ),
              ],
            ),
          ),
          if (activeHabit.streakCount == 0 && activeHabit.restoreChances > 0 && activeHabit.lastMissedScheduledDate != null) ...[
            const SizedBox(height: 12),
            OiyaButton(
              label: 'Activate Shield & Restore Streak',
              isPrimary: true,
              onPressed: () async {
                final missedDate = activeHabit.lastMissedScheduledDate!;
                final oldStreak = activeHabit.streakCount;
                HapticFeedback.mediumImpact();
                await ref.read(habitControllerProvider.notifier).restoreStreak(activeHabit.id, missedDate);
                if (context.mounted) {
                  Navigator.of(context).pop(); // Dismiss bottom sheet
                  checkAndShowStreakPromotion(context, ref, activeHabit.id, oldStreak);
                }
              },
            ),
          ],
          const SizedBox(height: 24),
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
              final isCompleted = activeHabit.isCompletedOn(date);
              final isScheduled = activeHabit.isScheduledFor(date);
              final isToday = date.year == todayStart.year && 
                              date.month == todayStart.month && 
                              date.day == todayStart.day;
              final isRestored = activeHabit.isRestoredOn(date);

              Widget indicator;
              Color statusColor;
              if (isCompleted) {
                statusColor = isRestored ? const Color(0xFF0A84FF) : const Color(0xFF7CA982);
                indicator = Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isRestored ? CupertinoIcons.shield_fill : CupertinoIcons.checkmark,
                    size: 14,
                    color: Colors.white,
                  ),
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
              _buildLegendItem(context, const Color(0xFF7CA982), 'Done'),
              _buildLegendItem(context, const Color(0xFF0A84FF), 'Saved'),
              _buildLegendItem(context, const Color(0xFFFF9500), 'Pending'),
              _buildLegendItem(context, Colors.redAccent, 'Missed'),
              _buildLegendItem(context, isDark ? Colors.white38 : Colors.black38, 'Off Day'),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  String _formatSpecificSchedule(Habit habit) {
    if (habit.specificDate == null) return 'Activity Reminder';
    final dateStr = DateFormat('MMM dd, yyyy').format(habit.specificDate!);
    if (habit.specificHour != null) {
      final hourStr = habit.specificHour!.toString().padLeft(2, '0');
      return '$dateStr @ $hourStr:00';
    }
    return dateStr;
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
