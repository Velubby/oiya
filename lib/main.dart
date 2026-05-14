import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/app.dart';
import 'src/features/memory/memory_repository.dart';
import 'src/features/settings/theme_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final memoryBox = await Hive.openBox<Map>('memories');
  final settingsBox = await Hive.openBox<String>('settings');

  runApp(
    ProviderScope(
      overrides: [
        memoryRepositoryProvider.overrideWithValue(
          HiveMemoryRepository(memoryBox),
        ),
        themeRepositoryProvider.overrideWithValue(
          HiveThemeRepository(settingsBox),
        ),
      ],
      child: const OiyaApp(),
    ),
  );
}
