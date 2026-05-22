import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'memory_note.dart';
import 'memory_repository.dart';

final memoryControllerProvider =
    StateNotifierProvider<MemoryController, List<MemoryNote>>((ref) {
  final repository = ref.watch(memoryRepositoryProvider);
  return MemoryController(repository);
});

enum SearchFilter { all, today, recent }
final searchFilterProvider = StateProvider<SearchFilter>((ref) => SearchFilter.all);

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredMemoriesProvider = Provider<List<MemoryNote>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final filter = ref.watch(searchFilterProvider);
  final notes = ref.watch(memoryControllerProvider);

  Iterable<MemoryNote> filtered = notes;
  if (query.isNotEmpty) {
    filtered = filtered.where((note) => note.text.toLowerCase().contains(query));
  }

  final today = DateTime.now();
  filtered = filtered.where((note) {
    final noteDate = DateTime(
      note.createdAt.year,
      note.createdAt.month,
      note.createdAt.day,
    );
    final currentDate = DateTime(today.year, today.month, today.day);
    final daysAgo = currentDate.difference(noteDate).inDays;

    switch (filter) {
      case SearchFilter.all:
        return true;
      case SearchFilter.today:
        return daysAgo == 0;
      case SearchFilter.recent:
        return daysAgo >= 0 && daysAgo <= 3;
    }
  });

  return filtered.toList(growable: false);
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

final thoughtDumpModeProvider = StateProvider<bool>((ref) => false);

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

  Future<void> updateMemory(String id, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }

    await _repository.update(id, trimmed);
    state = await _repository.getAll();
  }

  Future<void> deleteMemory(String id) async {
    await _repository.delete(id);
    state = await _repository.getAll();
  }
}
