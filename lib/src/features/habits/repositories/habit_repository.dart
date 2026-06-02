import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/habit.dart';

abstract class HabitRepository {
  Future<List<Habit>> getAll();
  Future<void> save(Habit habit);
  Future<void> delete(String id);
}

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  throw UnimplementedError('HabitRepository override is required');
});

class HiveHabitRepository implements HabitRepository {
  HiveHabitRepository(this._box);

  final Box<Map> _box;

  @override
  Future<List<Habit>> getAll() async {
    final habits = _box.values.map(Habit.fromMap).toList(growable: false)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return habits;
  }

  @override
  Future<void> save(Habit habit) async {
    await _box.put(habit.id, habit.toMap());
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
