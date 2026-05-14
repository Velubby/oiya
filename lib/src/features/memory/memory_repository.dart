import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import 'memory_note.dart';

abstract class MemoryRepository {
  Future<List<MemoryNote>> getAll();
  Future<void> add(String text);
  Future<void> delete(String id);
}

final memoryRepositoryProvider = Provider<MemoryRepository>((ref) {
  throw UnimplementedError('MemoryRepository override is required');
});

class HiveMemoryRepository implements MemoryRepository {
  HiveMemoryRepository(this._box);

  final Box<Map> _box;
  final Uuid _uuid = const Uuid();

  @override
  Future<List<MemoryNote>> getAll() async {
    final notes = _box.values.map(MemoryNote.fromMap).toList(growable: false)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }

  @override
  Future<void> add(String text) async {
    final now = DateTime.now();
    final id = _uuid.v4();
    final note = MemoryNote(
      id: id,
      text: text,
      createdAt: now,
      updatedAt: now,
    );
    await _box.put(id, note.toMap());
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
