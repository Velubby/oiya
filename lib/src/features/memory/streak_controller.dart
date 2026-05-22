import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'memory_controller.dart';
import 'reminder_controller.dart';

class StreakInfo {
  const StreakInfo({
    required this.streakCount,
    required this.hasActivityToday,
    required this.activeDates,
  });

  final int streakCount;
  final bool hasActivityToday;
  final Set<String> activeDates; // YYYY-MM-DD strings
}

final streakProvider = Provider<StreakInfo>((ref) {
  final memories = ref.watch(memoryControllerProvider);
  final reminders = ref.watch(reminderControllerProvider);

  String formatDate(DateTime dt) {
    final local = dt.toLocal();
    return "${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}";
  }

  final activeDates = <String>{};

  for (final note in memories) {
    activeDates.add(formatDate(note.createdAt));
  }

  for (final reminder in reminders) {
    for (final completedDate in reminder.completedDates) {
      activeDates.add(formatDate(completedDate));
    }
  }

  final today = DateTime.now();
  final todayStr = formatDate(today);
  final yesterday = today.subtract(const Duration(days: 1));
  final yesterdayStr = formatDate(yesterday);

  int streak = 0;
  final bool hasActivityToday = activeDates.contains(todayStr);

  if (hasActivityToday) {
    streak = 1;
    var checkDate = yesterday;
    while (activeDates.contains(formatDate(checkDate))) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }
  } else if (activeDates.contains(yesterdayStr)) {
    streak = 1;
    var checkDate = yesterday.subtract(const Duration(days: 1));
    while (activeDates.contains(formatDate(checkDate))) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }
  } else {
    streak = 0;
  }

  return StreakInfo(
    streakCount: streak,
    hasActivityToday: hasActivityToday,
    activeDates: activeDates,
  );
});
