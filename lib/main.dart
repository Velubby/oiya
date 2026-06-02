import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/app.dart';
import 'src/features/journal/repositories/journal_repository.dart';
import 'src/features/habits/repositories/habit_repository.dart';
import 'src/features/settings/repositories/theme_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final memoryBox = await Hive.openBox<Map>('memories');

  // Database migration/cleanup: Remove debug habit completions from memories box
  try {
    final keysToDelete = <dynamic>[];
    for (final key in memoryBox.keys) {
      final entry = memoryBox.get(key);
      if (entry != null) {
        final text = entry['text'] as String?;
        if (text != null && (
          text.contains('Verified Polaroid Proof') || 
          text.contains('Completed directly (Skipped Polaroid)') || 
          text.contains('Polaroid #OIYA-')
        )) {
          keysToDelete.add(key);
        }
      }
    }
    for (final key in keysToDelete) {
      await memoryBox.delete(key);
    }
  } catch (e) {
    debugPrint('Error cleaning up memories box: $e');
  }

  final reminderBox = await Hive.openBox<Map>('reminders');
  final settingsBox = await Hive.openBox<String>('settings');

  runApp(
    ProviderScope(
      overrides: [
        journalRepositoryProvider.overrideWithValue(
          HiveJournalRepository(memoryBox),
        ),
        habitRepositoryProvider.overrideWithValue(
          HiveHabitRepository(reminderBox),
        ),
        themeRepositoryProvider.overrideWithValue(
          HiveThemeRepository(settingsBox),
        ),
      ],
      child: const OiyaApp(),
    ),
  );
}
