import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

abstract class ThemeRepository {
  Future<ThemeMode> loadThemeMode();
  Future<void> saveThemeMode(ThemeMode mode);
}

final themeRepositoryProvider = Provider<ThemeRepository>((ref) {
  throw UnimplementedError('ThemeRepository override is required');
});

class HiveThemeRepository implements ThemeRepository {
  HiveThemeRepository(this._box);

  final Box<String> _box;
  static const _themeModeKey = 'theme_mode';

  @override
  Future<ThemeMode> loadThemeMode() async {
    final value = _box.get(_themeModeKey);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) {
    final encoded = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };

    return _box.put(_themeModeKey, encoded);
  }
}
