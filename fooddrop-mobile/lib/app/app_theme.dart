import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'food_drop_colors.dart';

const _colors = FoodDropColors();

ThemeData buildAppTheme() {
  final scheme = ColorScheme.dark(
    primary: _colors.accent,
    onPrimary: _colors.background,
    secondary: _colors.accentHot,
    surface: _colors.surface,
    onSurface: _colors.text,
    error: _colors.danger,
    outline: _colors.border,
  );
  final base = ThemeData(
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: _colors.background,
    extensions: const [_colors],
  );
  final textTheme = GoogleFonts.geistTextTheme(base.textTheme).apply(
    bodyColor: _colors.text,
    displayColor: _colors.text,
  );

  return base.copyWith(
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: _colors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: _colors.text,
    ),
    dividerColor: _colors.border,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: _colors.surface,
      modalBackgroundColor: _colors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _colors.surfaceRaised,
      contentTextStyle: TextStyle(color: _colors.text),
      behavior: SnackBarBehavior.floating,
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: _colors.accent),
  );
}

/// Geist Mono, used for quantities, timers and step numbers.
TextStyle monoStyle({double size = 13, FontWeight weight = FontWeight.w600, Color? color}) =>
    GoogleFonts.geistMono(fontSize: size, fontWeight: weight, color: color ?? _colors.accent);
