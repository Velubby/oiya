class Reminder {
  const Reminder({
    required this.id,
    required this.title,
    required this.proofType, // 'none', 'text', 'image', 'video'
    required this.scheduleType, // 'daily', 'custom', 'exam', 'specific'
    this.weeklyDays = const [], // 1 = Mon, 7 = Sun
    this.examDates = const [], // Selected exam dates
    this.examPrepDates = const [], // Generated study sessions (1 day before each exam)
    this.completedDates = const [], // Days this reminder was completed (normalized to YYYY-MM-DD)
    this.completedProofs = const {}, // Map of date string -> proof caption/text
    required this.createdAt,
    this.restoreChances = 3,
    this.specificDate,
    this.specificHour,
  });

  final String id;
  final String title;
  final String proofType;
  final String scheduleType;
  final List<int> weeklyDays;
  final List<DateTime> examDates;
  final List<DateTime> examPrepDates;
  final List<DateTime> completedDates;
  final Map<String, String> completedProofs;
  final DateTime createdAt;
  final int restoreChances;
  final DateTime? specificDate;
  final int? specificHour;

  Reminder copyWith({
    String? id,
    String? title,
    String? proofType,
    String? scheduleType,
    List<int>? weeklyDays,
    List<DateTime>? examDates,
    List<DateTime>? examPrepDates,
    List<DateTime>? completedDates,
    Map<String, String>? completedProofs,
    DateTime? createdAt,
    int? restoreChances,
    DateTime? specificDate,
    int? specificHour,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      proofType: proofType ?? this.proofType,
      scheduleType: scheduleType ?? this.scheduleType,
      weeklyDays: weeklyDays ?? this.weeklyDays,
      examDates: examDates ?? this.examDates,
      examPrepDates: examPrepDates ?? this.examPrepDates,
      completedDates: completedDates ?? this.completedDates,
      completedProofs: completedProofs ?? this.completedProofs,
      createdAt: createdAt ?? this.createdAt,
      restoreChances: restoreChances ?? this.restoreChances,
      specificDate: specificDate ?? this.specificDate,
      specificHour: specificHour ?? this.specificHour,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'proofType': proofType,
      'scheduleType': scheduleType,
      'weeklyDays': weeklyDays,
      'examDates': examDates.map((d) => d.toIso8601String()).toList(),
      'examPrepDates': examPrepDates.map((d) => d.toIso8601String()).toList(),
      'completedDates': completedDates.map((d) => d.toIso8601String()).toList(),
      'completedProofs': completedProofs,
      'createdAt': createdAt.toIso8601String(),
      'restoreChances': restoreChances,
      'specificDate': specificDate?.toIso8601String(),
      'specificHour': specificHour,
    };
  }

  static Reminder fromMap(Map<dynamic, dynamic> map) {
    final rawScheduleType = map['scheduleType'] as String;
    final scheduleType = rawScheduleType == 'weekly' ? 'custom' : rawScheduleType;
    return Reminder(
      id: map['id'] as String,
      title: map['title'] as String,
      proofType: map['proofType'] as String,
      scheduleType: scheduleType,
      weeklyDays: List<int>.from(map['weeklyDays'] ?? []),
      examDates: (map['examDates'] as List? ?? [])
          .map((d) => DateTime.parse(d as String))
          .toList(),
      examPrepDates: (map['examPrepDates'] as List? ?? [])
          .map((d) => DateTime.parse(d as String))
          .toList(),
      completedDates: (map['completedDates'] as List? ?? [])
          .map((d) => DateTime.parse(d as String))
          .toList(),
      completedProofs: Map<String, String>.from(map['completedProofs'] ?? {}),
      createdAt: DateTime.parse(map['createdAt'] as String),
      restoreChances: map['restoreChances'] as int? ?? 3,
      specificDate: map['specificDate'] != null ? DateTime.parse(map['specificDate'] as String) : null,
      specificHour: map['specificHour'] as int?,
    );
  }

  /// Check if the reminder is active / scheduled for a given date
  bool isScheduledFor(DateTime date) {
    final checkDate = DateTime(date.year, date.month, date.day);

    if (scheduleType == 'daily') {
      return true;
    } else if (scheduleType == 'custom') {
      return weeklyDays.contains(checkDate.weekday);
    } else if (scheduleType == 'exam') {
      // Scheduled 1 day before any exam date
      return examPrepDates.any((prepDate) =>
          prepDate.year == checkDate.year &&
          prepDate.month == checkDate.month &&
          prepDate.day == checkDate.day);
    } else if (scheduleType == 'specific') {
      if (specificDate == null) return false;
      return specificDate!.year == checkDate.year &&
          specificDate!.month == checkDate.month &&
          specificDate!.day == checkDate.day;
    }
    return false;
  }

  /// Check if the reminder was completed on a given date
  bool isCompletedOn(DateTime date) {
    final checkDate = DateTime(date.year, date.month, date.day);
    return completedDates.any((completedDate) =>
        completedDate.year == checkDate.year &&
        completedDate.month == checkDate.month &&
        completedDate.day == checkDate.day);
  }

  /// Calculate the individual habit's streak count
  int get streakCount {
    if (completedDates.isEmpty) return 0;

    final Set<String> normalizedDates = completedDates.map((d) {
      final local = d.toLocal();
      return "${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}";
    }).toSet();

    final today = DateTime.now();
    final todayStr = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayStr = "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";

    final bool hasCompletedToday = normalizedDates.contains(todayStr);
    final bool hasCompletedYesterday = normalizedDates.contains(yesterdayStr);

    if (!hasCompletedToday && !hasCompletedYesterday) {
      return 0;
    }

    int streak = 0;

    if (scheduleType == 'daily') {
      DateTime checkDate = hasCompletedToday ? today : yesterday;
      while (true) {
        final checkDateStr = "${checkDate.year}-${checkDate.month.toString().padLeft(2, '0')}-${checkDate.day.toString().padLeft(2, '0')}";
        if (normalizedDates.contains(checkDateStr)) {
          streak++;
        } else {
          break;
        }
        checkDate = checkDate.subtract(const Duration(days: 1));
      }
      return streak;
    }

    if (scheduleType == 'custom') {
      DateTime checkDate = hasCompletedToday ? today : yesterday;
      while (true) {
        final checkDateStr = "${checkDate.year}-${checkDate.month.toString().padLeft(2, '0')}-${checkDate.day.toString().padLeft(2, '0')}";
        if (weeklyDays.contains(checkDate.weekday)) {
          if (normalizedDates.contains(checkDateStr)) {
            streak++;
          } else {
            break; // Missed a scheduled day
          }
        }
        checkDate = checkDate.subtract(const Duration(days: 1));
        // Safety timeout (e.g. 1 year back)
        if (checkDate.isBefore(createdAt.subtract(const Duration(days: 365)))) {
          break;
        }
      }
      return streak;
    }

    if (scheduleType == 'exam') {
      // Get all past and today's preps sorted descending
      final sortedPastPreps = examPrepDates
          .where((d) => d.isBefore(today) || (d.year == today.year && d.month == today.month && d.day == today.day))
          .toList()
        ..sort((a, b) => b.compareTo(a));

      if (sortedPastPreps.isEmpty) return 0;

      int startIndex = 0;
      final firstPrepStr = "${sortedPastPreps[0].year}-${sortedPastPreps[0].month.toString().padLeft(2, '0')}-${sortedPastPreps[0].day.toString().padLeft(2, '0')}";
      if (firstPrepStr == todayStr) {
        if (normalizedDates.contains(firstPrepStr)) {
          startIndex = 0;
        } else {
          // Today's prep is not yet completed. The streak can still be maintained if the previous preps were completed.
          startIndex = 1;
        }
      } else {
        startIndex = 0;
      }

      for (int i = startIndex; i < sortedPastPreps.length; i++) {
        final prepDate = sortedPastPreps[i];
        final prepStr = "${prepDate.year}-${prepDate.month.toString().padLeft(2, '0')}-${prepDate.day.toString().padLeft(2, '0')}";
        if (normalizedDates.contains(prepStr)) {
          streak++;
        } else {
          break; // Missed a prep session
        }
      }
      return streak;
    }

    if (scheduleType == 'specific') {
      if (specificDate == null) return 0;
      final specificStr = "${specificDate!.year}-${specificDate!.month.toString().padLeft(2, '0')}-${specificDate!.day.toString().padLeft(2, '0')}";
      return normalizedDates.contains(specificStr) ? 1 : 0;
    }

    return 0;
  }

  /// Check if a given date was restored via Streak Shield
  bool isRestoredOn(DateTime date) {
    final local = date.toLocal();
    final dateStr = "${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}";
    return completedProofs[dateStr] == "[RESTORED]";
  }

  /// Find the most recent scheduled date that was missed before today
  DateTime? get lastMissedScheduledDate {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    // Look back up to 30 days to find the most recent scheduled date that is not completed
    for (int i = 1; i <= 30; i++) {
      final date = todayStart.subtract(Duration(days: i));
      if (isScheduledFor(date) && !isCompletedOn(date)) {
        return date;
      }
    }
    return null;
  }
}
