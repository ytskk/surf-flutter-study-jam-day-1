import 'package:flutter/material.dart';

abstract class AppColors extends ThemeExtension<AppColors> {
  final Color contrastingSecondary;
  final Color red;

  AppColors(
    this.red,
    this.contrastingSecondary,
  );

  static AppColors getColors(BuildContext context) {
    return Theme.of(context).extension<AppColors>()!;
  }
}

class AppColorsLight implements AppColors {
  @override
  Color get red => const Color(0xFFC6716F);
  @override
  Color get contrastingSecondary => const Color(0xFF303030);

  @override
  ThemeExtension<AppColors> copyWith() {
    return this;
  }

  @override
  ThemeExtension<AppColors> lerp(ThemeExtension<AppColors>? other, double t) {
    // TODO: make smooth changing.
    return this;
  }

  @override
  Object get type => AppColors;
}

class AppColorsDark implements AppColors {
  @override
  Color get contrastingSecondary => const Color(0xFF1D1D1F);

  @override
  Color get red => const Color(0xFFC6716F);

  @override
  ThemeExtension<AppColors> copyWith() {
    return this;
  }

  @override
  ThemeExtension<AppColors> lerp(ThemeExtension<AppColors>? other, double t) {
    return this;
  }

  @override
  Object get type => AppColors;
}
