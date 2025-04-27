import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0093E9); // Jasny niebieski
  static const Color secondary = Color(0xFF80D0C7); // Morski
  static const Color background = Color(0xFFF5F7FA); // Jasne tło
  static const Color accent = Color(0xFF5C6BC0); // Indygo

  // Odcienie primary color dla różnych stanów
  static final Color primaryLight = primary.withOpacity(0.8);
  static final Color primaryLighter = primary.withOpacity(0.5);
}
