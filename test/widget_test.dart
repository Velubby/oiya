import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:oiya/src/app.dart';
import 'package:oiya/src/features/journal/models/journal_note.dart';
import 'package:oiya/src/features/journal/repositories/journal_repository.dart';
import 'package:oiya/src/features/settings/repositories/theme_repository.dart';

void main() {
  testWidgets('quick capture stores and shows memory in home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          journalRepositoryProvider
              .overrideWithValue(_InMemoryJournalRepository()),
          themeRepositoryProvider.overrideWithValue(_InMemoryThemeRepository()),
        ],
        child: const OiyaApp(),
      ),
    );

    // Click on the plus button to open quick capture
    await tester.tap(find.byIcon(CupertinoIcons.plus));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextField).first,
      'Parkir di basement B2',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Parkir di basement B2'), findsOneWidget);
  });

  testWidgets('edit memory updates text from home list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          journalRepositoryProvider.overrideWithValue(_InMemoryJournalRepository()),
          themeRepositoryProvider.overrideWithValue(_InMemoryThemeRepository()),
        ],
        child: const OiyaApp(),
      ),
    );

    // Tap plus to open quick capture
    await tester.tap(find.byIcon(CupertinoIcons.plus));
    await tester.pumpAndSettle();
    
    await tester.enterText(
      find.byType(TextField).first,
      'Memory lama',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Tap the memory card text to edit it
    await tester.tap(find.text('Memory lama'));
    await tester.pumpAndSettle();
    
    await tester.enterText(
      find.byType(CupertinoTextField),
      'Memory baru',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Memory baru'), findsOneWidget);
    expect(find.text('Memory lama'), findsNothing);
  });

  testWidgets('delete memory requires confirmation', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          journalRepositoryProvider.overrideWithValue(_InMemoryJournalRepository()),
          themeRepositoryProvider.overrideWithValue(_InMemoryThemeRepository()),
        ],
        child: const OiyaApp(),
      ),
    );

    // Tap plus to open quick capture
    await tester.tap(find.byIcon(CupertinoIcons.plus));
    await tester.pumpAndSettle();
    
    await tester.enterText(
      find.byType(TextField).first,
      'Memory untuk dihapus',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Tap the delete button on the card
    await tester.tap(find.byIcon(CupertinoIcons.delete).first);
    await tester.pumpAndSettle();
    expect(find.text('Delete memory?'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Memory untuk dihapus'), findsNothing);
  });
}

class _InMemoryJournalRepository implements JournalRepository {
  final List<JournalNote> _data = <JournalNote>[];

  @override
  Future<void> add(String text) async {
    final now = DateTime.now();
    _data.add(
      JournalNote(
        id: '${_data.length + 1}',
        text: text,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  @override
  Future<void> update(String id, String text) async {
    final idx = _data.indexWhere((element) => element.id == id);
    if (idx < 0) {
      return;
    }

    final current = _data[idx];
    _data[idx] = current.copyWith(text: text, updatedAt: DateTime.now());
  }

  @override
  Future<void> delete(String id) async {
    _data.removeWhere((element) => element.id == id);
  }

  @override
  Future<List<JournalNote>> getAll() async {
    final items = List<JournalNote>.from(_data)
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
