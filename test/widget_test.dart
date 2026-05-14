import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:oiya/src/app.dart';
import 'package:oiya/src/features/memory/memory_note.dart';
import 'package:oiya/src/features/memory/memory_repository.dart';
import 'package:oiya/src/features/settings/theme_repository.dart';

void main() {
  testWidgets('quick capture stores and shows memory in home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          memoryRepositoryProvider
              .overrideWithValue(_InMemoryMemoryRepository()),
          themeRepositoryProvider.overrideWithValue(_InMemoryThemeRepository()),
        ],
        child: const OiyaApp(),
      ),
    );

    await tester.tap(find.text('Capture'));
    await tester.pump();

    await tester.enterText(
      find.byType(TextField).first,
      'Parkir di basement B2',
    );
    await tester.tap(find.text('Simpan Memory'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Parkir di basement B2'), findsOneWidget);
  });
}

class _InMemoryMemoryRepository implements MemoryRepository {
  final List<MemoryNote> _data = <MemoryNote>[];

  @override
  Future<void> add(String text) async {
    final now = DateTime.now();
    _data.add(
      MemoryNote(
        id: '${_data.length + 1}',
        text: text,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  @override
  Future<void> delete(String id) async {
    _data.removeWhere((element) => element.id == id);
  }

  @override
  Future<List<MemoryNote>> getAll() async {
    final items = List<MemoryNote>.from(_data)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }
}

class _InMemoryThemeRepository implements ThemeRepository {
  ThemeMode _mode = ThemeMode.system;

  @override
  Future<ThemeMode> loadThemeMode() async => _mode;

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    _mode = mode;
  }
}
