import 'package:flutter/material.dart';

class OiyaStyles {
  // Colors
  static const Color primary = Color(0xFF3A506B); // Midnight Indigo
  static const Color primaryFocus = Color(0xFF1C2541); // Deep Indigo Focus
  static const Color primaryOnDark = Color(0xFF9EC1A3); // Pale Sage
  static const Color ink = Color(0xFF1C2541); // Deep Indigo Ink
  static const Color body = Color(0xFF1C2541);
  static const Color bodyOnDark = Color(0xFFF4F6F9); // Ice White Body
  static const Color bodyMuted = Color(0xFF8D99AE); // Muted Slate
  static const Color inkMuted80 = Color(0xFF2B3A5A); // Deep Slate Blue
  static const Color inkMuted48 = Color(0xFF5C677D); // Muted Slate Grey
  static const Color dividerSoft = Color(0xFFEDF2F7); // Cool Divider Soft
  static const Color hairline = Color(0xFFE2E8F0); // Cool Hairline
  static const Color canvas = Color(0xFFFAF9F6); // Alabaster White
  static const Color canvasParchment = Color(0xFFF0F2F5); // Cool Mist
  static const Color surfacePearl = Color(0xFFEDF2F7); // Light Grey Button
  static const Color surfaceTile1 = Color(0xFF0B132B); // Midnight Dark
  static const Color surfaceTile2 = Color(0xFF1C2541); // Deep Indigo Card
  static const Color surfaceTile3 = Color(0xFF080C24); // Deepest Dark Indigo
  static const Color surfaceBlack = Color(0xFF050814); // Void Black
  static const Color surfaceChipTranslucent = Color(0xA3E2E8F0); // Translucent Cool Chip

  // Spacing
  static const double spacingXxs = 4.0;
  static const double spacingXs = 8.0;
  static const double spacingSm = 12.0;
  static const double spacingMd = 17.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;
  static const double spacingSection = 80.0;

  // Radii
  static const double roundedNone = 0.0;
  static const double roundedXs = 5.0;
  static const double roundedSm = 8.0;
  static const double roundedMd = 11.0;
  static const double roundedLg = 18.0;
  static const double roundedPill = 9999.0;
  static const double roundedFull = 9999.0;

  // Typography helpers
  static TextStyle heroDisplay({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 40, // Scaled down display headline for mobile comfort
        fontWeight: FontWeight.w600,
        height: 1.1,
        letterSpacing: -0.28,
        color: color,
      );

  static TextStyle displayLg({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 32, // Optimized size for mobile section titles
        fontWeight: FontWeight.w600,
        height: 1.15,
        letterSpacing: -0.4,
        color: color,
      );

  static TextStyle displayMd({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 26,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: -0.374,
        color: color,
      );

  static TextStyle lead({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w400,
        height: 1.3,
        letterSpacing: 0.1,
        color: color,
      );

  static TextStyle leadAiry({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 18,
        fontWeight: FontWeight.w300,
        height: 1.4,
        letterSpacing: 0,
        color: color,
      );

  static TextStyle tagline({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.15,
        color: color,
      );

  static TextStyle bodyStrong({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.24,
        letterSpacing: -0.374,
        color: color,
      );

  static TextStyle bodyText({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.47,
        letterSpacing: -0.374,
        color: color,
      );

  static TextStyle denseLink({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.8,
        letterSpacing: 0,
        color: color,
      );

  static TextStyle caption({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: -0.224,
        color: color,
      );

  static TextStyle captionStrong({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.29,
        letterSpacing: -0.224,
        color: color,
      );

  static TextStyle buttonLarge({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.0,
        letterSpacing: 0,
        color: color,
      );

  static TextStyle buttonUtility({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.29,
        letterSpacing: -0.224,
        color: color,
      );

  static TextStyle finePrint({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.1,
        letterSpacing: -0.12,
        color: color,
      );

  static TextStyle microLegal({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 10,
        fontWeight: FontWeight.w400,
        height: 1.3,
        letterSpacing: -0.08,
        color: color,
      );

  static TextStyle navLink({required Color color}) => TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.0,
        letterSpacing: -0.12,
        color: color,
      );
}
