import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/settings/theme_mode_controller.dart';
import 'ui/main_shell.dart';

class OiyaApp extends ConsumerWidget {
  const OiyaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    const lightScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF6D5EF9),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFFFF4DB8),
      onSecondary: Color(0xFFFFFFFF),
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      surface: Color(0xFFF8F7FF),
      onSurface: Color(0xFF1A1730),
      primaryContainer: Color(0xFFE6E2FF),
      onPrimaryContainer: Color(0xFF251A6A),
      secondaryContainer: Color(0xFFFFD8F0),
      onSecondaryContainer: Color(0xFF3F002A),
      tertiary: Color(0xFF2FD3C9),
      onTertiary: Color(0xFF003734),
      tertiaryContainer: Color(0xFFB7FFF8),
      onTertiaryContainer: Color(0xFF00201E),
      surfaceContainerHighest: Color(0xFFE8E5F5),
      onSurfaceVariant: Color(0xFF47435A),
      outline: Color(0xFF78738D),
      outlineVariant: Color(0xFFC8C3DC),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF2F2B45),
      onInverseSurface: Color(0xFFF3EFFF),
      inversePrimary: Color(0xFFC9C1FF),
      surfaceTint: Color(0xFF6D5EF9),
    );
    const darkScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFC9C1FF),
      onPrimary: Color(0xFF372C8A),
      secondary: Color(0xFFFFA7DC),
      onSecondary: Color(0xFF5D1143),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      surface: Color(0xFF10101A),
      onSurface: Color(0xFFE8E4F7),
      primaryContainer: Color(0xFF4F42C1),
      onPrimaryContainer: Color(0xFFE6E2FF),
      secondaryContainer: Color(0xFF7B2C5D),
      onSecondaryContainer: Color(0xFFFFD8F0),
      tertiary: Color(0xFF74F8EE),
      onTertiary: Color(0xFF003734),
      tertiaryContainer: Color(0xFF00504B),
      onTertiaryContainer: Color(0xFFB7FFF8),
      surfaceContainerHighest: Color(0xFF2A2838),
      onSurfaceVariant: Color(0xFFC9C3DD),
      outline: Color(0xFF928BA8),
      outlineVariant: Color(0xFF47435A),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE8E4F7),
      onInverseSurface: Color(0xFF2F2B45),
      inversePrimary: Color(0xFF6D5EF9),
      surfaceTint: Color(0xFFC9C1FF),
    );

    return MaterialApp(
      title: 'OIYA',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightScheme,
        scaffoldBackgroundColor: lightScheme.surface,
        fontFamily: 'Roboto',
        cardTheme: CardTheme(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          color: lightScheme.surface,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: lightScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: lightScheme.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: lightScheme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: lightScheme.primary, width: 1.6),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: lightScheme.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: lightScheme.surface.withOpacity(0.92),
          elevation: 0,
          indicatorColor: lightScheme.primaryContainer,
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontWeight:
                  states.contains(WidgetState.selected)
                      ? FontWeight.w700
                      : FontWeight.w500,
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkScheme,
        scaffoldBackgroundColor: darkScheme.surface,
        cardTheme: CardTheme(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          color: darkScheme.surfaceContainerHighest,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: darkScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: darkScheme.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: darkScheme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: darkScheme.primary, width: 1.6),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: darkScheme.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: darkScheme.surface.withOpacity(0.92),
          elevation: 0,
          indicatorColor: darkScheme.primaryContainer,
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontWeight:
                  states.contains(WidgetState.selected)
                      ? FontWeight.w700
                      : FontWeight.w500,
            ),
          ),
        ),
      ),
      home: const MainShell(),
    );
  }
}
