import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/habit.dart';
import '../repositories/habit_repository.dart';

final habitControllerProvider =
    StateNotifierProvider<HabitController, List<Habit>>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return HabitController(repository);
});

/// Exposes active habits scheduled for today
final activeHabitsForTodayProvider = Provider<List<Habit>>((ref) {
  final habits = ref.watch(habitControllerProvider);
  final today = DateTime.now();
  return habits.where((r) => r.isScheduledFor(today)).toList();
});

class HabitController extends StateNotifier<List<Habit>> {
  HabitController(this._repository) : super(const []) {
    _load();
  }

  final HabitRepository _repository;
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
    DateTime? specificDate,
    int? specificHour,
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
    final habit = Habit(
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
      specificDate: specificDate,
      specificHour: specificHour,
    );

    await _repository.save(habit);
    await _load();
  }

  Future<void> completeReminder(
    String id, {
    String? proofCaption,
    String? proofData,
  }) async {
    final habit = state.firstWhere((r) => r.id == id);
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);

    if (habit.isCompletedOn(todayNormalized)) {
      return; // Already completed today
    }

    final updatedCompletedDates = List<DateTime>.from(habit.completedDates)
      ..add(todayNormalized);

    final updatedCompletedProofs = Map<String, String>.from(habit.completedProofs);
    final todayKey = "${todayNormalized.year}-${todayNormalized.month.toString().padLeft(2, '0')}-${todayNormalized.day.toString().padLeft(2, '0')}";

    if (habit.proofType != 'none') {
      final captionText = proofCaption?.trim() ?? '';
      final dataText = proofData ?? 'Done';
      updatedCompletedProofs[todayKey] = captionText.isNotEmpty 
          ? "$captionText ($dataText)" 
          : dataText;
    }

    final updatedHabit = habit.copyWith(
      completedDates: updatedCompletedDates,
      completedProofs: updatedCompletedProofs,
    );

    await _repository.save(updatedHabit);
    await _load();
  }

  Future<void> restoreStreak(String id, DateTime missedDate) async {
    final habit = state.firstWhere((r) => r.id == id);
    if (habit.restoreChances <= 0) {
      return;
    }

    final dateNormalized = DateTime(missedDate.year, missedDate.month, missedDate.day);
    if (habit.isCompletedOn(dateNormalized)) {
      return;
    }

    final updatedCompletedDates = List<DateTime>.from(habit.completedDates)
      ..add(dateNormalized)
      ..sort();

    final updatedCompletedProofs = Map<String, String>.from(habit.completedProofs);
    final dateKey = "${dateNormalized.year}-${dateNormalized.month.toString().padLeft(2, '0')}-${dateNormalized.day.toString().padLeft(2, '0')}";
    updatedCompletedProofs[dateKey] = "[RESTORED]";

    final updatedHabit = habit.copyWith(
      completedDates: updatedCompletedDates,
      completedProofs: updatedCompletedProofs,
      restoreChances: habit.restoreChances - 1,
    );

    await _repository.save(updatedHabit);
    await _load();
  }

  Future<void> deleteReminder(String id) async {
    await _repository.delete(id);
    await _load();
  }
}
