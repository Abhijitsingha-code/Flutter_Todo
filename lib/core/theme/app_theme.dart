import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // Dark Theme Color palette
  static const _primary = Color(0xFF7C3AED);        // violet-600
  static const _primaryLight = Color(0xFFA78BFA);   // violet-400
  static const _secondary = Color(0xFF06B6D4);       // cyan-500
  static const _surface = Color(0xFF1E1B2E);         // dark purple surface
  static const _background = Color(0xFF13111E);      // deepest background
  static const _surfaceVariant = Color(0xFF2A2640);  // card background
  static const _onSurface = Color(0xFFF1F0F9);       // text on dark
  static const _onSurfaceMuted = Color(0xFF9B97B8);  // muted text
  static const _error = Color(0xFFEF4444);

  // Light Theme Color palette (Warm cream / gold)
  static const Color lightPrimary = Color(0xFFDDA721);       // Warm gold
  static const Color lightPrimaryContainer = Color(0xFFFAF6E8); // Light gold container
  static const Color lightBackground = Color(0xFFFAF7EC);     // Warm cream background
  static const Color lightContentBg = Color(0xFFF5F2EB);      // Warm beige content background
  static const Color lightSurface = Color(0xFFFFFFFF);        // White cards
  static const Color lightOnSurface = Color(0xFF1C1A17);      // Deep charcoal/black
  static const Color lightOnSurfaceMuted = Color(0xFF706E6B); // Muted dark grey
  static const Color lightBorder = Color(0xFFEAE6DB);         // Subtle border color
  static const Color lightSuccess = Color(0xFF10B981);        // Clean green
  static const Color lightPending = Color(0xFF8B5CF6);        // Violet pending
  static const Color lightWarning = Color(0xFFF59E0B);        // Amber warning

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        primaryContainer: lightPrimaryContainer,
        secondary: lightPrimary,
        surface: lightSurface,
        error: _error,
        onPrimary: lightOnSurface,
        onSurface: lightOnSurface,
      ),
      scaffoldBackgroundColor: lightBackground,
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: lightOnSurface,
            letterSpacing: -0.8,
          ),
          displayMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: lightOnSurface,
            letterSpacing: -0.5,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: lightOnSurface,
            letterSpacing: -0.3,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: lightOnSurface,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: lightOnSurface,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: lightOnSurfaceMuted,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: lightOnSurface,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: lightBorder, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8F6EF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: lightPrimary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _error, width: 1.5),
        ),
        labelStyle: const TextStyle(color: lightOnSurfaceMuted),
        hintStyle: const TextStyle(color: lightOnSurfaceMuted, fontSize: 14),
        prefixIconColor: lightOnSurfaceMuted,
        suffixIconColor: lightOnSurfaceMuted,
        errorStyle: const TextStyle(color: _error),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: lightOnSurface,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
          elevation: 1.5,
          shadowColor: lightPrimary.withValues(alpha: 0.4),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightPrimary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: lightOnSurface,
          fontFamily: 'Inter',
        ),
        iconTheme: IconThemeData(color: lightOnSurface),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: lightPrimary,
        foregroundColor: lightOnSurface,
        elevation: 4,
        shape: CircleBorder(),
      ),
      dividerTheme: const DividerThemeData(
        color: lightBorder,
        thickness: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _primary,
        primaryContainer: Color(0xFF4C1D95),
        secondary: _secondary,
        surface: _surface,
        surfaceContainerHighest: _surfaceVariant,
        onPrimary: Colors.white,
        onSurface: _onSurface,
        error: _error,
      ),
      scaffoldBackgroundColor: _background,
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: _onSurface,
            letterSpacing: -0.5,
          ),
          displayMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: _onSurface,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: _onSurface,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _onSurface,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: _onSurface,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: _onSurfaceMuted,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: _surfaceVariant,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF3D3860), width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF3D3860)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF3D3860)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _error, width: 2),
        ),
        labelStyle: const TextStyle(color: _onSurfaceMuted),
        hintStyle: const TextStyle(color: _onSurfaceMuted),
        prefixIconColor: _onSurfaceMuted,
        suffixIconColor: _onSurfaceMuted,
        errorStyle: const TextStyle(color: _error),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: _primaryLight),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: _onSurface,
          fontFamily: 'Inter',
        ),
        iconTheme: IconThemeData(color: _onSurface),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _surfaceVariant,
        contentTextStyle: const TextStyle(color: _onSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF3D3860),
        thickness: 1,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: const BorderSide(color: _onSurfaceMuted, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  // Semantic colors for direct use
  static const Color successColor = lightSuccess;
  static const Color errorColor = _error;
  static const Color primaryColor = lightPrimary;
  static const Color primaryLightColor = lightPrimaryContainer;
  static const Color mutedColor = lightOnSurfaceMuted;
}
