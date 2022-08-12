import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/constants/constants.dart';

class AppThemeData {
  static ThemeData _themeData({
    Brightness brightness = Brightness.light,
    required AppColors colors,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      extensions: <ThemeExtension<dynamic>>[
        colors,
      ],
    );
  }

  static ThemeData get light => _themeData(
        colors: AppColorsLight(),
      );
  static ThemeData get dark => _themeData(
        colors: AppColorsDark(),
        brightness: Brightness.dark,
      );
}
