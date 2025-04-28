import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales según la nueva paleta
  static const Color primaryColor = Color(0xFFFA8716);  // Naranjo - se mantiene
  static const Color scaffoldBackgroundColor = Color(0xFF080A0B);  // Muy oscuro, casi negro
  static const Color cardColor = Color(0xFF101417);  // Gris muy oscuro para las tarjetas
  static const Color secondaryColor = Color(0xFF1F2226);  // Gris oscuro para elementos secundarios
  
  // Colores de texto
  static const Color textPrimaryColor = Colors.white;
  static const Color textSecondaryColor = Color(0xFFD0D0D0);

  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      cardColor: cardColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: cardColor,
        background: scaffoldBackgroundColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimaryColor),
        titleTextStyle: TextStyle(
          color: textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textPrimaryColor),
        bodyMedium: TextStyle(color: textPrimaryColor),
        titleLarge: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: textPrimaryColor),
        titleSmall: TextStyle(color: textSecondaryColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondaryColor.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: textSecondaryColor),
      ),
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 2,
        shadowColor: primaryColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      // Actualizar el color de fondo para diálogos y sheets
      dialogBackgroundColor: cardColor,
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: cardColor,
      ),
    );
  }
} 