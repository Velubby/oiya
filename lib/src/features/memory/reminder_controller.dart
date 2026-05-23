import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'reminder.dart';
import 'reminder_repository.dart';

final reminderControllerProvider =
    StateNotifierProvider<ReminderController, List<Reminder>>((ref) {
  final repository = ref.watch(reminderRepositoryProvider);
  return ReminderController(repository);
});

/// Exposes active reminders scheduled for today
final activeRemindersForTodayProvider = Provider<List<Reminder>>((ref) {
  final reminders = ref.watch(reminderControllerProvider);
  final today = DateTime.now();
  return reminders.where((r) => r.isScheduledFor(today)).toList();
});

class ReminderController extends StateNotifier<List<Reminder>> {
  ReminderController(this._repository) : super(const []) {
    _load();
  }

  final ReminderRepository _repository;
  final Uuid _uuid = const Uuid();

  Future<void> _load() async {
    state = await _repository.getAll();
  }

  Future<void> addReminder({
    required String title,
    required String proofType,
    required String scheduleType,
    List<int> weeklyDays = const [],
    List<DateTime> examDates = const [],
  }) async {
    final titleTrimmed = title.trim();
    if (titleTrimmed.isEmpty) {
      return;
    }

    // Generate study prep dates (exactly 1 day before each exam)
    final List<DateTime> examPrepDates = [];
    if (scheduleType == 'exam') {
      for (final examDate in examDates) {
        final prepDate = DateTime(examDate.year, examDate.month, examDate.day)
            .subtract(const Duration(days: 1));
        examPrepDates.add(prepDate);
      }
    }

    final id = _uuid.v4();
    final reminder = Reminder(
      id: id,
      title: titleTrimmed,
      proofType: proofType,
      scheduleType: scheduleType,
      weeklyDays: weeklyDays,
      examDates: examDates,
      examPrepDates: examPrepDates,
      completedDates: const [],
      completedProofs: const {},
      createdAt: DateTime.now(),
    );

    await _repository.save(reminder);
    await _load();
  }

  Future<void> completeReminder(
    String id, {
    String? proofCaption,
    String? proofData,
  }) async {
    final reminder = state.firstWhere((r) => r.id == id);
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);

    if (reminder.isCompletedOn(todayNormalized)) {
      return; // Already completed today
    }

    final updatedCompletedDates = List<DateTime>.from(reminder.completedDates)
      ..add(todayNormalized);

    final updatedCompletedProofs = Map<String, String>.from(reminder.completedProofs);
    final todayKey = "${todayNormalized.year}-${todayNormalized.month.toString().padLeft(2, '0')}-${todayNormalized.day.toString().padLeft(2, '0')}";

    if (reminder.proofType != 'none') {
      final captionText = proofCaption?.trim() ?? '';
      final dataText = proofData ?? 'Done';
      updatedCompletedProofs[todayKey] = captionText.isNotEmpty 
          ? "$captionText ($dataText)" 
          : dataText;
    }

    final updatedReminder = reminder.copyWith(
      completedDates: updatedCompletedDates,
      completedProofs: updatedCompletedProofs,
    );

    await _repository.save(updatedReminder);
    await _load();

  }

  Future<void> restoreStreak(String id, DateTime missedDate) async {
    final reminder = state.firstWhere((r) => r.id == id);
    if (reminder.restoreChances <= 0) {
      return;
    }

    final dateNormalized = DateTime(missedDate.year, missedDate.month, missedDate.day);
    if (reminder.isCompletedOn(dateNormalized)) {
      return;
    }

    final updatedCompletedDates = List<DateTime>.from(reminder.completedDates)
      ..add(dateNormalized)
      ..sort();

    final updatedCompletedProofs = Map<String, String>.from(reminder.completedProofs);
    final dateKey = "${dateNormalized.year}-${dateNormalized.month.toString().padLeft(2, '0')}-${dateNormalized.day.toString().padLeft(2, '0')}";
    updatedCompletedProofs[dateKey] = "[RESTORED]";

    final updatedReminder = reminder.copyWith(
      completedDates: updatedCompletedDates,
      completedProofs: updatedCompletedProofs,
      restoreChances: reminder.restoreChances - 1,
    );

    await _repository.save(updatedReminder);
    await _load();
  }

  Future<void> deleteReminder(String id) async {
    await _repository.delete(id);
    await _load();
  }
}
