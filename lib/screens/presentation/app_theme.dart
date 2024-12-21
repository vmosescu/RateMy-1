import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getAppTheme() {
    final ThemeData base = ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
    );

    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: const Color.fromARGB(255, 246, 246, 246),      // HEX: #545F71, Primary Gray
        primaryFixed: const Color.fromARGB(255, 55, 55, 1),   // HEX: #373737, Soft Black
        onPrimaryFixed: const Color.fromARGB(255, 0, 123, 255),    // HEX: #007BFF, Primary Blue
        outline: const Color.fromARGB(255, 246, 190, 44),     // HEX: #F6BE2C, Primary Yellow
        secondary: const Color.fromARGB(255, 73, 73, 74),  // HEX: #9BA5B7, Secondary
        tertiary: const Color.fromARGB(255, 238, 241, 244),   // HEX: #EEF1F4, Tertiary

        // So that calendar is well visible
        onPrimary: const Color.fromARGB(255, 238, 241, 244),    // HEX: #007BFF, Primary Blue
      ),
    );
  }
}
