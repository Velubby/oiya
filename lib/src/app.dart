import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/settings/controllers/theme_mode_controller.dart';
import 'ui/screens/main_shell_screen.dart';

class OiyaApp extends ConsumerWidget {
  const OiyaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    const lightScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF3A506B), // Midnight Indigo
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF7CA982), // Sage Green
      onSecondary: Color(0xFFFFFFFF),
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      surface: Color(0xFFFAF9F6), // Alabaster White
      onSurface: Color(0xFF1C2541), // Deep Indigo Ink
      primaryContainer: Color(0xFF1C2541), // Deep Indigo Focus
      onPrimaryContainer: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFFAF9F6), // Alabaster Canvas
      onSecondaryContainer: Color(0xFF1C2541),
      tertiary: Color(0xFF7CA982),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFF0F2F5), // Cool Mist
      onTertiaryContainer: Color(0xFF1C2541),
      surfaceContainerHighest: Color(0xFFF0F2F5),
      onSurfaceVariant: Color(0xFF5C677D), // Muted Slate Grey
      outline: Color(0xFFE2E8F0), // Cool Hairline
      outlineVariant: Color(0xFFEDF2F7), // Cool Divider Soft
      shadow: Color(0x1F1C2541), // drop shadow ~12% alpha soft indigo
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF1C2541),
      onInverseSurface: Color(0xFFFAF9F6),
      inversePrimary: Color(0xFF9EC1A3),
      surfaceTint: Color(0xFF3A506B),
    );
    const darkScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF9EC1A3), // Pale Sage
      onPrimary: Color(0xFF0B132B),
      secondary: Color(0xFF80A1D4), // Lavender Slate
      onSecondary: Color(0xFF0B132B),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      surface: Color(0xFF0B132B), // Midnight Dark
      onSurface: Color(0xFFF4F6F9), // Ice White Body
      primaryContainer: Color(0xFF3A506B),
      onPrimaryContainer: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFF1C2541), // Deep Indigo Card
      onSecondaryContainer: Color(0xFFF4F6F9),
      tertiary: Color(0xFF80A1D4),
      onTertiary: Color(0xFF0B132B),
      tertiaryContainer: Color(0xFF1C2541),
      onTertiaryContainer: Color(0xFFF4F6F9),
      surfaceContainerHighest: Color(0xFF1C2541),
      onSurfaceVariant: Color(0xFF8D99AE), // Muted Slate
      outline: Color(0xFF3A506B),
      outlineVariant: Color(0xFF1C2541),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFFAF9F6),
      onInverseSurface: Color(0xFF0B132B),
      inversePrimary: Color(0xFF3A506B),
      surfaceTint: Color(0xFF9EC1A3),
    );

    return MaterialApp(
      title: 'oiya',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightScheme,
        scaffoldBackgroundColor: lightScheme.surface,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        platform: TargetPlatform.iOS,
        cardTheme: CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18), // rounded.lg (18px)
            side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.0), // hairline (E2E8F0)
          ),
          color: lightScheme.surface,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: lightScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9999), // rounded.pill
            borderSide: const BorderSide(color: Color(0x14000000), width: 1.0), // rgba(0,0,0,0.08)
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9999),
            borderSide: const BorderSide(color: Color(0x14000000), width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9999),
            borderSide: const BorderSide(color: Color(0xFF3A506B), width: 2.0), // primary indigo focus outline
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: lightScheme.onSurface,
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        fontFamily: 'Inter',
        fontFamilyFallback: const ['.SF UI Text', 'SF Pro Text', 'San Francisco', 'Roboto', 'system-ui', 'sans-serif'],
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: lightScheme.surface,
          elevation: 0,
          indicatorColor: Colors.transparent,
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w600
                  : FontWeight.w400,
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkScheme,
        scaffoldBackgroundColor: darkScheme.surface,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        platform: TargetPlatform.iOS,
        cardTheme: CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18), // rounded.lg (18px)
            side: const BorderSide(color: Color(0xFF1C2541), width: 1.0), // 1C2541
          ),
          color: darkScheme.secondaryContainer,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: darkScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9999),
            borderSide: const BorderSide(color: Color(0x1FFFFFFF), width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9999),
            borderSide: const BorderSide(color: Color(0x1FFFFFFF), width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9999),
            borderSide: const BorderSide(color: Color(0xFF9EC1A3), width: 2.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: darkScheme.onSurface,
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        fontFamily: 'Inter',
        fontFamilyFallback: const ['.SF UI Text', 'SF Pro Text', 'San Francisco', 'Roboto', 'system-ui', 'sans-serif'],
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: darkScheme.surface,
          elevation: 0,
          indicatorColor: Colors.transparent,
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w600
                  : FontWeight.w400,
            ),
          ),
        ),
      ),
      home: const MainShell(),
    );
  }
}
