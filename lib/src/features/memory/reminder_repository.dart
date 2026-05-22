import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'reminder.dart';

abstract class ReminderRepository {
  Future<List<Reminder>> getAll();
  Future<void> save(Reminder reminder);
  Future<void> delete(String id);
}

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  throw UnimplementedError('ReminderRepository override is required');
});

class HiveReminderRepository implements ReminderRepository {
  HiveReminderRepository(this._box);

  final Box<Map> _box;

  @override
  Future<List<Reminder>> getAll() async {
    final reminders = _box.values.map(Reminder.fromMap).toList(growable: false)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return reminders;
  }

  @override
  Future<void> save(Reminder reminder) async {
    await _box.put(reminder.id, reminder.toMap());
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
