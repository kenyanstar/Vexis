import 'package:flutter/material.dart';
import 'package:vexis_browser/core/constants.dart';

class VexisTheme {
  // Light theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: VexisColors.primaryBlue,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: VexisColors.primaryBlue,
      secondary: VexisColors.secondaryPurple,
      error: VexisColors.errorColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: VexisColors.primaryBlue,
          width: 2,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: VexisColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: VexisColors.primaryBlue,
        side: const BorderSide(color: VexisColors.primaryBlue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    primaryColor: VexisColors.primaryBlue,
    scaffoldBackgroundColor: VexisColors.backgroundColor,
    colorScheme: const ColorScheme.dark(
      primary: VexisColors.primaryBlue,
      secondary: VexisColors.secondaryPurple,
      error: VexisColors.errorColor,
      surface: Color(0xFF121212),
      background: VexisColors.backgroundColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: VexisColors.backgroundColor,
      foregroundColor: VexisColors.textColor,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: VexisColors.textColor, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: VexisColors.textColor, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: VexisColors.textColor, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: VexisColors.textColor, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: VexisColors.textColor, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: VexisColors.textColor, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: VexisColors.textColor),
      bodyMedium: TextStyle(color: VexisColors.textColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.black.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: VexisColors.primaryBlue,
          width: 2,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: VexisColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: VexisColors.primaryBlue,
        side: const BorderSide(color: VexisColors.primaryBlue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}