import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_palette.dart';

class AppTheme {
  static _border(Color color) => OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 3),
        borderRadius: BorderRadius.circular(10),
      );

  static _inputDecorationTheme(
          Color enabledBoredColor,
          Color focusedBorderColor,
          Color errorBorderColor,
          Color focusedErrorBorderColor) =>
      InputDecorationTheme(
        contentPadding: const EdgeInsets.all(25),
        enabledBorder: _border(enabledBoredColor),
        focusedBorder: _border(focusedBorderColor),
        errorBorder: _border(errorBorderColor),
        focusedErrorBorder: _border(focusedBorderColor),
        errorStyle: const TextStyle(height: 0),
      );

  // Tamna tema
  static final darkTheme = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(
      primary: ColorPalette.primaryDark,
      onPrimary: ColorPalette.onPrimaryDark,
      secondary: ColorPalette.secondaryDark,
      onSecondary: ColorPalette.onSecondaryDark,
      surface: ColorPalette.surfaceDark,
      onSurface: ColorPalette.onSurfaceDark,
      error: ColorPalette.errorDark,
      onError: ColorPalette.onErrorDark,
    ),
    inputDecorationTheme: _inputDecorationTheme(
      ColorPalette.borderEnabledDark,
      ColorPalette.secondaryDark,
      ColorPalette.errorDark,
      ColorPalette.onErrorDark,
    ),
    textTheme: GoogleFonts.robotoMonoTextTheme(
      ThemeData.dark().textTheme,
    ),
  );

  // Svetla tema
  static final lightTheme = ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light(
      primary: ColorPalette.primaryLight,
      onPrimary: ColorPalette.onPrimaryLight,
      secondary: ColorPalette.secondaryLight,
      onSecondary: ColorPalette.onSecondaryLight,
      surface: ColorPalette.surfaceLight,
      onSurface: ColorPalette.onSurfaceLight,
      error: ColorPalette.errorLight,
      onError: ColorPalette.onErrorLight,
    ),
    inputDecorationTheme: _inputDecorationTheme(
        ColorPalette.borderEnabledLight,
        ColorPalette.secondaryLight,
        ColorPalette.errorLight,
        ColorPalette.onErrorLight),
    textTheme: GoogleFonts.robotoMonoTextTheme(
      ThemeData.light().textTheme,
    ),
  );
}
