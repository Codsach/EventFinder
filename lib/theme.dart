import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Core colors
  static const Color bgDeep = Color(0xFF080B14);
  static const Color bgCard = Color(0xFF0F1523);
  static const Color bgSurface = Color(0xFF141A2B);
  static const Color accentCyan = Color(0xFF00E5FF);
  static const Color accentPurple = Color(0xFF9B59FF);
  static const Color accentPink = Color(0xFFFF3CAC);
  static const Color glassWhite = Color(0x14FFFFFF);
  static const Color glassBorder = Color(0x26FFFFFF);
  static const Color textPrimary = Color(0xFFF0F4FF);
  static const Color textSecondary = Color(0xFF8A9BC4);
  static const Color textMuted = Color(0xFF4A5578);

  static const Map<String, Color> categoryColors = {
    'Music': Color(0xFFFF3CAC),
    'Sports': Color(0xFF00E5FF),
    'Tech': Color(0xFF9B59FF),
    'Wellness': Color(0xFF00FF9D),
    'Art': Color(0xFFFFB547),
    'Gaming': Color(0xFFFF6B35),
    'Food': Color(0xFFFF4757),
    'Comedy': Color(0xFFFFD700),
  };

  static Color categoryColor(String cat) =>
      categoryColors[cat] ?? accentCyan;

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bgDeep,
        colorScheme: const ColorScheme.dark(
          primary: accentCyan,
          secondary: accentPurple,
          surface: bgCard,
        ),
        textTheme: GoogleFonts.interTextTheme().apply(
          bodyColor: textPrimary,
          displayColor: textPrimary,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: GoogleFonts.poppins(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          iconTheme: const IconThemeData(color: textPrimary),
        ),
        useMaterial3: true,
      );
}
