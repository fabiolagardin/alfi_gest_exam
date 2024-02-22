import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Definisci i colori per il tema chiaro
const _primaryLight = Color(0xFF6052A6);
const _onPrimaryLight = Color(0xFFFFFFFF);
const _primaryContainerLight = Color(0xFFEADDFF);
const _onPrimaryContainerLight = Color(0xFF21005D);
const _secondaryLight = Color(0xFF625B71);
const _onSecondaryLight = Color(0xFFFFFFFF);
const _secondaryContainerLight = Color(0xFFE8DEF8);
const _onSecondaryContainerLight = Color(0xFFE8DEF8);
const _tertiaryLight = Color(0xFF7D5260);
const _onTertiaryLight = Color(0xFFFFFFFF);
const _tertiaryContainerLight = Color(0xFFFFD8E4);
const _onTertiaryContainerLight = Color(0xFF31111D);
const _errorLight = Color(0xFFB3261E);
const _onErrorLight = Color(0xFFFFFFFF);
const _errorContainerLight = Color(0xFF8C1D18);
const _onErrorContainerLight = Color(0xFF410E0B);
const _backgroundLight = Color(0xFFECE6F0);
const _onBackgroundLight = Color(0xFF1D1B20);
const _surfaceLight = Color(0xFFFEF7FF);
const _onSurfaceLight = Color(0xFF1D1B20);
const _surfaceVariantLight = Color(0xFFE7E0EC);
const _onSurfaceVariantLight = Color(0xFF49454F);
const _outlineLight = Color(0xFF79747E);
const _outlineVariantLight = Color(0xFFCAC4D0);
const _shadowLight = Color(0xFF000000);
const _scrimLight = Color(0xFF000000);
const _inverseSurfaceLight = Color(0xFF322F35);
const _onInverseSurfaceLight = Color(0xFFF5EFF7);
const _inversePrimaryLight = Color(0xFFD0BCFF);

// Definisci il tema chiaro
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: _primaryLight,
  colorScheme: const ColorScheme.light(
    primary: _primaryLight,
    onPrimary: _onPrimaryLight,
    primaryContainer: _primaryContainerLight,
    onPrimaryContainer: _onPrimaryContainerLight,
    secondary: _secondaryLight,
    onSecondary: _onSecondaryLight,
    secondaryContainer: _secondaryContainerLight,
    onSecondaryContainer: _onSecondaryContainerLight,
    tertiary: _tertiaryLight,
    onTertiary: _onTertiaryLight,
    tertiaryContainer: _tertiaryContainerLight,
    onTertiaryContainer: _onTertiaryContainerLight,
    error: _errorLight,
    onError: _onErrorLight,
    errorContainer: _errorContainerLight,
    onErrorContainer: _onErrorContainerLight,
    background: _backgroundLight,
    onBackground: _onBackgroundLight,
    surface: _surfaceLight,
    onSurface: _onSurfaceLight,
    surfaceVariant: _surfaceVariantLight,
    onSurfaceVariant: _onSurfaceVariantLight,
    outline: _outlineLight,
    outlineVariant: _outlineVariantLight,
    shadow: _shadowLight,
    scrim: _scrimLight,
    inverseSurface: _inverseSurfaceLight,
    onInverseSurface: _onInverseSurfaceLight,
    inversePrimary: _inversePrimaryLight,
  ),
  scaffoldBackgroundColor: _onInverseSurfaceLight,
  textTheme: GoogleFonts.robotoTextTheme().copyWith(
    titleLarge: GoogleFonts.roboto(
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.roboto(
      fontWeight: FontWeight.bold,
    ),
    titleSmall: GoogleFonts.roboto(
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: GoogleFonts.roboto(
      fontWeight: FontWeight.w400,
      height: 0.09,
      letterSpacing: 0.50,
      fontSize: 16,
      color: _onSurfaceVariantLight,
    ),
    labelMedium: GoogleFonts.roboto(
      fontWeight: FontWeight.normal,
      fontSize: 12,
      letterSpacing: 0.5,
      color: _onSurfaceVariantLight,
    ),
  ),
  // ... altre proprietà
);

// Definisci i colori per il tema scuro
const _primaryDark = Color(0xFFD0BCFE);
const _onPrimaryDark = Color(0xFF381E72);
const _primaryContainerDark = Color(0xFF4F378B);
const _onPrimaryContainerDark = Color(0xFFEADDFF);
const _secondaryDark = Color(0xFFCCC2DC);
const _onSecondaryDark = Color(0xFF332D41);
const _secondaryContainerDark = Color(0xFF4A4458);
const _onSecondaryContainerDark = Color(0xFFE8DEF8);
const _tertiaryDark = Color(0xFFEFB8C8);
const _onTertiaryDark = Color(0xFFFFFFFF);
const _tertiaryContainerDark = Color(0xFF633B48);
const _onTertiaryContainerDark = Color(0xFFFFD8E4);
const _errorDark = Color(0xFFF2B8B5);
const _onErrorDark = Color(0xFF601410);
const _errorContainerDark = Color(0xFF8C1D18);
const _onErrorContainerDark = Color(0xFFF9DEDC);
const _backgroundDark = Color(0xFF2B2930);
const _onBackgroundDark = Color(0xFFE6E0E9);
const _surfaceDark = Color(0xFF141218);
const _onSurfaceDark = Color(0xFFE6E0E9);
const _surfaceVariantDark = Color(0xFF49454F);
const _onSurfaceVariantDark = Color(0xFFCAC4D0);
const _outlineDark = Color(0xFF938F99);
const _outlineVariantDark = Color(0xFF49454F);
const _shadowDark = Color(0xFF000000);
const _scrimDark = Color(0xFF000000);
const _inverseSurfaceDark = Color(0xFFE6E0E9);
const _onInverseSurfaceDark = Color(0xFF322F35);
const _inversePrimaryDark = Color(0xFF6750A4);

// Definisci il tema scuro
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: _primaryDark,
  colorScheme: const ColorScheme.dark(
    primary: _primaryDark,
    onPrimary: _onPrimaryDark,
    primaryContainer: _primaryContainerDark,
    onPrimaryContainer: _onPrimaryContainerDark,
    secondary: _secondaryDark,
    onSecondary: _onSecondaryDark,
    secondaryContainer: _secondaryContainerDark,
    onSecondaryContainer: _onSecondaryContainerDark,
    tertiary: _tertiaryDark,
    onTertiary: _onTertiaryDark,
    tertiaryContainer: _tertiaryContainerDark,
    onTertiaryContainer: _onTertiaryContainerDark,
    error: _errorDark,
    onError: _onErrorDark,
    errorContainer: _errorContainerDark,
    onErrorContainer: _onErrorContainerDark,
    background: _backgroundDark,
    onBackground: _onBackgroundDark,
    surface: _surfaceDark,
    onSurface: _onSurfaceDark,
    surfaceVariant: _surfaceVariantDark,
    onSurfaceVariant: _onSurfaceVariantDark,
    outline: _outlineDark,
    outlineVariant: _outlineVariantDark,
    shadow: _shadowDark,
    scrim: _scrimDark,
    inverseSurface: _inverseSurfaceDark,
    onInverseSurface: _onInverseSurfaceDark,
    inversePrimary: _inversePrimaryDark,
  ),
  scaffoldBackgroundColor: _onInverseSurfaceDark,
  textTheme: GoogleFonts.robotoTextTheme().copyWith(
    titleLarge: GoogleFonts.roboto(
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.roboto(
      fontWeight: FontWeight.bold,
    ),
    titleSmall: GoogleFonts.roboto(
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: GoogleFonts.roboto(
      fontWeight: FontWeight.w400,
      height: 0.09,
      letterSpacing: 0.50,
      fontSize: 16,
      color: _onSurfaceVariantDark,
    ),
    labelMedium: GoogleFonts.roboto(
      fontWeight: FontWeight.normal,
      fontSize: 12,
      letterSpacing: 0.5,
      color: _onSurfaceVariantDark,
    ),
  ),
  // ... altre proprietà
);
