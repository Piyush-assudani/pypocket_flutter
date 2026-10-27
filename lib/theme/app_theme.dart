import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Global theme controller notifier (defaults to Light Theme as requested)
  static final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

  // Common Brand Colors
  static const Color pythonBlue = Color(0xFF2563EB);
  static const Color pythonYellow = Color(0xFFEAB308);
  static const Color warmBronze = Color(0xFFC89B58);
  static const Color obsidianSlate = Color(0xFF17191C);
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color errorRed = Color(0xFFEF4444);

  // --- Dark Mode Colors ---
  static const Color darkBackground = Color(0xFF0D0F14);
  static const Color darkSurface = Color(0xFF141822);
  static const Color darkSurfaceLight = Color(0xFF1B2130);
  static const Color darkCard = Color(0xFF141822);
  static const Color darkBorder = Color(0xFF232A3B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);
  static const Color darkTerminalBg = Color(0xFF090C12);

  // Backwards-compatible aliases
  static const Color border = darkBorder;
  static const Color textPrimary = darkTextPrimary;
  static const Color textSecondary = darkTextSecondary;
  static const Color textMuted = darkTextMuted;
  static const Color terminalBg = darkTerminalBg;

  // --- Light Mode Colors (Warm Luxury Champagne & Ivory from Screenshots) ---
  static const Color lightBackground = Color(0xFFFAF7F2); // Warm luxury ivory
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceLight = Color(0xFFF4EFE6);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFEAE3D6); // Warm subtle beige border
  static const Color lightTextPrimary = Color(0xFF17191C); // Deep obsidian slate
  static const Color lightTextSecondary = Color(0xFF5A6372);
  static const Color lightTextMuted = Color(0xFF8C95A5);
  static const Color lightTerminalBg = Color(0xFF0F172A);

  // Helpers for dynamic brightness
  static Color surfaceOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkSurface : lightSurface;

  static Color cardOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkCard : lightCard;

  static Color borderOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkBorder : lightBorder;

  static Color textPrimaryOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkTextPrimary : lightTextPrimary;

  static Color textSecondaryOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkTextSecondary : lightTextSecondary;

  static Color textMutedOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkTextMuted : lightTextMuted;

  // --- Dark Theme Definition ---
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: pythonBlue,
      colorScheme: const ColorScheme.dark(
        primary: pythonBlue,
        secondary: pythonYellow,
        surface: darkSurface,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: darkTextPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.3,
        ),
        iconTheme: const IconThemeData(color: darkTextPrimary),
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: pythonBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkTextPrimary,
          side: const BorderSide(color: darkBorder),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: darkBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: darkBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: pythonBlue, width: 1.5)),
        labelStyle: GoogleFonts.outfit(color: darkTextSecondary),
        hintStyle: GoogleFonts.outfit(color: darkTextMuted),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF0B101D),
        selectedItemColor: pythonYellow,
        unselectedItemColor: darkTextMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(color: darkTextPrimary, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.0),
        displayMedium: GoogleFonts.outfit(color: darkTextPrimary, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.8),
        headlineLarge: GoogleFonts.outfit(color: darkTextPrimary, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.5),
        headlineMedium: GoogleFonts.outfit(color: darkTextPrimary, fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.3),
        titleLarge: GoogleFonts.outfit(color: darkTextPrimary, fontSize: 16, fontWeight: FontWeight.w700),
        titleMedium: GoogleFonts.outfit(color: darkTextPrimary, fontSize: 14.5, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(color: darkTextPrimary, fontSize: 15, height: 1.5),
        bodyMedium: GoogleFonts.inter(color: darkTextSecondary, fontSize: 13.5, height: 1.5),
        bodySmall: GoogleFonts.inter(color: darkTextMuted, fontSize: 12, height: 1.4),
        labelLarge: GoogleFonts.outfit(color: darkTextPrimary, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.5),
        labelSmall: GoogleFonts.jetBrainsMono(color: darkTextMuted, fontSize: 10.5, fontWeight: FontWeight.w600),
      ),
    );
  }

  // --- Light Theme Definition ---
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      primaryColor: pythonBlue,
      colorScheme: const ColorScheme.light(
        primary: pythonBlue,
        secondary: Color(0xFFB45309), // richer amber for light mode
        surface: lightSurface,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          color: lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.3,
        ),
        iconTheme: const IconThemeData(color: lightTextPrimary),
      ),
      cardTheme: CardThemeData(
        color: lightCard,
        elevation: 2,
        shadowColor: const Color(0x0D000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: lightBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: obsidianSlate,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.outfit(fontSize: 15.5, fontWeight: FontWeight.bold),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightTextPrimary,
          side: const BorderSide(color: lightBorder, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.outfit(fontSize: 14.5, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: lightBorder, width: 1.2)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: lightBorder, width: 1.2)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: warmBronze, width: 1.8)),
        labelStyle: GoogleFonts.outfit(color: lightTextSecondary),
        hintStyle: GoogleFonts.inter(color: lightTextMuted, fontSize: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: pythonBlue,
        unselectedItemColor: lightTextMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(color: lightTextPrimary, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.0),
        displayMedium: GoogleFonts.outfit(color: lightTextPrimary, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.8),
        headlineLarge: GoogleFonts.outfit(color: lightTextPrimary, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.5),
        headlineMedium: GoogleFonts.outfit(color: lightTextPrimary, fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.3),
        titleLarge: GoogleFonts.outfit(color: lightTextPrimary, fontSize: 16, fontWeight: FontWeight.w700),
        titleMedium: GoogleFonts.outfit(color: lightTextPrimary, fontSize: 14.5, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(color: lightTextPrimary, fontSize: 15, height: 1.5),
        bodyMedium: GoogleFonts.inter(color: lightTextSecondary, fontSize: 13.5, height: 1.5),
        bodySmall: GoogleFonts.inter(color: lightTextMuted, fontSize: 12, height: 1.4),
        labelLarge: GoogleFonts.outfit(color: lightTextPrimary, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.5),
        labelSmall: GoogleFonts.jetBrainsMono(color: lightTextMuted, fontSize: 10.5, fontWeight: FontWeight.w600),
      ),
    );
  }

  static TextStyle get codeStyle => GoogleFonts.jetBrainsMono(
    fontSize: 13.5,
    height: 1.45,
    color: const Color(0xFFE2E8F0),
  );
}
