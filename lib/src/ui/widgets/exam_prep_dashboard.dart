import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../features/habits/models/habit.dart';
import '../style/oiya_styles.dart';

class ExamPrepDashboard extends StatelessWidget {
  final List<Habit> examHabits;

  const ExamPrepDashboard({super.key, required this.examHabits});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Sort habits so those with the closest exams appear first
    final sortedHabits = List<Habit>.from(examHabits)..sort((a, b) {
      final aDays = _getMinDaysLeft(a);
      final bDays = _getMinDaysLeft(b);
      if (aDays == null && bDays == null) return 0;
      if (aDays == null) return 1;
      if (bDays == null) return -1;
      return aDays.compareTo(bDays);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.book_fill,
                size: 16,
                color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'EXAM PREP TRACKER',
                style: OiyaStyles.captionStrong(
                  color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80,
                ).copyWith(letterSpacing: 1.0),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 155,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sortedHabits.length,
            itemBuilder: (context, index) {
              final habit = sortedHabits[index];
              return _buildExamCard(context, habit, isDark);
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  int? _getMinDaysLeft(Habit habit) {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    int? minDays;
    for (final examDate in habit.examDates) {
      final examStart = DateTime(examDate.year, examDate.month, examDate.day);
      final diff = examStart.difference(todayStart).inDays;
      if (diff >= 0) {
        if (minDays == null || diff < minDays) {
          minDays = diff;
        }
      }
    }
    return minDays;
  }

  Widget _buildExamCard(BuildContext context, Habit habit, bool isDark) {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    DateTime? nextExam;
    int? daysLeft;

    for (final examDate in habit.examDates) {
      final examStart = DateTime(examDate.year, examDate.month, examDate.day);
      final difference = examStart.difference(todayStart).inDays;
      if (difference >= 0) {
        if (daysLeft == null || difference < daysLeft) {
          daysLeft = difference;
          nextExam = examDate;
        }
      }
    }

    final displayDate = nextExam != null 
        ? DateFormat('MMM dd, yyyy').format(nextExam) 
        : (habit.examDates.isNotEmpty ? DateFormat('MMM dd, yyyy').format(habit.examDates.first) : 'No date');

    final totalPreps = habit.examPrepDates.length;
    final completedPreps = habit.completedDates.where((d) {
      final local = d.toLocal();
      final normD = DateTime(local.year, local.month, local.day);
      return habit.examPrepDates.any((p) => p.year == normD.year && p.month == normD.month && p.day == normD.day);
    }).length;
    
    final progressPercent = totalPreps > 0 ? (completedPreps / totalPreps) : 0.0;

    Color badgeBg;
    Color badgeText;
    String badgeLabel;
    IconData? badgeIcon;
    bool isPulse = false;

    if (daysLeft == null) {
      badgeBg = isDark ? Colors.white10 : Colors.black12;
      badgeText = isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80;
      badgeLabel = 'No upcoming';
    } else if (daysLeft == 0) {
      badgeBg = const Color(0xFFFF3B30).withOpacity(0.15);
      badgeText = const Color(0xFFFF453A);
      badgeLabel = 'EXAM TODAY';
      badgeIcon = CupertinoIcons.exclamationmark_circle_fill;
      isPulse = true;
    } else if (daysLeft == 1) {
      badgeBg = const Color(0xFFFF9500).withOpacity(0.15);
      badgeText = const Color(0xFFFF9F0A);
      badgeLabel = 'PREP ACTIVE';
      badgeIcon = CupertinoIcons.bolt_fill;
      isPulse = true;
    } else {
      badgeBg = isDark ? OiyaStyles.primaryOnDark.withOpacity(0.1) : OiyaStyles.primary.withOpacity(0.08);
      badgeText = isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary;
      badgeLabel = 'T-${daysLeft}d';
    }

    return Container(
      width: 290,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isPulse 
              ? badgeText.withOpacity(0.4) 
              : (isDark ? Colors.white10 : OiyaStyles.dividerSoft),
          width: isPulse ? 1.5 : 1.0,
        ),
        boxShadow: isPulse ? [
          BoxShadow(
            color: badgeText.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  habit.title,
                  style: OiyaStyles.bodyStrong(color: isDark ? Colors.white : OiyaStyles.ink),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (badgeIcon != null) ...[
                      Icon(
                        badgeIcon,
                        size: 10,
                        color: badgeText,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      badgeLabel,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: badgeText,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            nextExam != null 
                ? 'Next Exam: $displayDate' 
                : 'All Exams Completed',
            style: OiyaStyles.finePrint(
              color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Prep Progress',
                style: OiyaStyles.finePrint(
                  color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80,
                ).copyWith(fontSize: 11),
              ),
              Text(
                '$completedPreps/$totalPreps preps done',
                style: OiyaStyles.captionStrong(
                  color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary,
                ).copyWith(fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                Container(
                  height: 8,
                  width: double.infinity,
                  color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
                ),
                FractionallySizedBox(
                  widthFactor: progressPercent.clamp(0.0, 1.0),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark 
                            ? [const Color(0xFF30D158), const Color(0xFF34C759)]
                            : [const Color(0xFF24B14B), const Color(0xFF34C759)],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
