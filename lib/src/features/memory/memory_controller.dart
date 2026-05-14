import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'memory_note.dart';
import 'memory_repository.dart';

final memoryControllerProvider =
    StateNotifierProvider<MemoryController, List<MemoryNote>>((ref) {
  final repository = ref.watch(memoryRepositoryProvider);
  return MemoryController(repository);
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredMemoriesProvider = Provider<List<MemoryNote>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final notes = ref.watch(memoryControllerProvider);

  if (query.isEmpty) {
    return notes;
  }

  return notes
      .where((note) => note.text.toLowerCase().contains(query))
      .toList(growable: false);
});

final resurfacedMemoriesProvider = Provider<List<MemoryNote>>((ref) {
  final notes = ref.watch(memoryControllerProvider);
  final today = DateTime.now();
  const interestingDays = <int>{7, 14, 30};

  return notes.where((note) {
    final noteDate = DateTime(
      note.createdAt.year,
      note.createdAt.month,
      note.createdAt.day,
    );
    final currentDate = DateTime(today.year, today.month, today.day);
    final daysAgo = currentDate.difference(noteDate).inDays;
    return interestingDays.contains(daysAgo);
  }).toList(growable: false);
});

class MemoryController extends StateNotifier<List<MemoryNote>> {
  MemoryController(this._repository) : super(const []) {
    _load();
  }

  final MemoryRepository _repository;

  Future<void> _load() async {
    state = await _repository.getAll();
  }

  Future<void> addMemory(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }

    await _repository.add(trimmed);
    state = await _repository.getAll();
  }

  Future<void> deleteMemory(String id) async {
    await _repository.delete(id);
    state = await _repository.getAll();
  }
}
