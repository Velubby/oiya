import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../models/journal_note.dart';

abstract class JournalRepository {
  Future<List<JournalNote>> getAll();
  Future<void> add(String text);
  Future<void> update(String id, String text);
  Future<void> delete(String id);
}

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  throw UnimplementedError('JournalRepository override is required');
});

class HiveJournalRepository implements JournalRepository {
  HiveJournalRepository(this._box);

  final Box<Map> _box;
  final Uuid _uuid = const Uuid();

  @override
  Future<List<JournalNote>> getAll() async {
    final notes = _box.values.map(JournalNote.fromMap).toList(growable: false)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }

  @override
  Future<void> add(String text) async {
    final now = DateTime.now();
    final id = _uuid.v4();
    final note = JournalNote(
      id: id,
      text: text,
      createdAt: now,
      updatedAt: now,
    );
    await _box.put(id, note.toMap());
  }

  @override
  Future<void> update(String id, String text) async {
    final existing = _box.get(id);
    if (existing == null) {
      return;
    }

    final previous = JournalNote.fromMap(existing);
    final updated = previous.copyWith(text: text, updatedAt: DateTime.now());
    await _box.put(id, updated.toMap());
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
