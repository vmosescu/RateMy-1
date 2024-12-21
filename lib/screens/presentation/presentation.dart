import 'package:flutter/material.dart';

import 'app_theme.dart';

class Presentation {
  final ThemeData theme = AppTheme.getAppTheme();

  get background => const Color.fromARGB(255, 32, 181, 255);
  get primary => theme.colorScheme.primary;
  get secondary => theme.colorScheme.secondary;

  get rateBtnStyle => TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: secondary);

  Widget get gapAboveScreenTitle {
    return const SizedBox(height: 35);
  }
}