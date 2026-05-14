import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme_repository.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeModeController, ThemeMode>((ref) {
  final repository = ref.watch(themeRepositoryProvider);
  return ThemeModeController(repository);
});

class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController(this._repository) : super(ThemeMode.system) {
    _load();
  }

  final ThemeRepository _repository;

  Future<void> _load() async {
    state = await _repository.loadThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _repository.saveThemeMode(mode);
  }
}
