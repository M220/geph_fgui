import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final appLightTheme = FlexThemeData.light(
  colors: const FlexSchemeColor(
    primary: Color(0xff00296b),
    primaryContainer: Color(0xffa0c2ed),
    secondary: Color(0xffd26900),
    secondaryContainer: Color(0xffffd270),
    tertiary: Color(0xff5c5c95),
    tertiaryContainer: Color(0xffc8dbf8),
    appBarColor: Color(0xffc8dcf8),
    error: null,
  ),
  subThemesData: const FlexSubThemesData(
    interactionEffects: false,
    tintedDisabledControls: false,
    blendOnColors: false,
    useTextTheme: true,
    elevatedButtonRadius: 8,
    outlinedButtonRadius: 8,
    textButtonRadius: 8,
    elevatedButtonTextStyle:
        MaterialStatePropertyAll(TextStyle(fontSize: 18, color: Colors.black)),
    outlinedButtonTextStyle:
        MaterialStatePropertyAll(TextStyle(fontSize: 18, color: Colors.black)),
    textButtonTextStyle:
        MaterialStatePropertyAll(TextStyle(fontSize: 18, color: Colors.black)),
    elevatedButtonSchemeColor: SchemeColor.onBackground,
    outlinedButtonSchemeColor: SchemeColor.onBackground,
    textButtonSchemeColor: SchemeColor.onBackground,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    inputDecoratorUnfocusedBorderIsColored: false,
    alignedDropdown: true,
    tooltipRadius: 4,
    tooltipSchemeColor: SchemeColor.inverseSurface,
    tooltipOpacity: 0.9,
    useInputDecoratorThemeInDialogs: true,
    snackBarElevation: 6,
    snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
    navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
    navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
    navigationBarMutedUnselectedLabel: false,
    navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
    navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
    navigationBarMutedUnselectedIcon: false,
    navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
    navigationBarIndicatorOpacity: 1.00,
    navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
    navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
    navigationRailMutedUnselectedLabel: false,
    navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
    navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
    navigationRailMutedUnselectedIcon: false,
    navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
    navigationRailIndicatorOpacity: 1.00,
    navigationRailBackgroundSchemeColor: SchemeColor.surface,
    navigationRailLabelType: NavigationRailLabelType.none,
  ),
  keyColors: const FlexKeyColors(),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  fontFamily: GoogleFonts.notoSans().fontFamily,
);

final appDarkTheme = FlexThemeData.dark(
  colors: const FlexSchemeColor(
    primary: Color(0xffb1cff5),
    primaryContainer: Color(0xff3873ba),
    secondary: Color(0xffffd270),
    secondaryContainer: Color(0xffd26900),
    tertiary: Color(0xffc9cbfc),
    tertiaryContainer: Color(0xff535393),
    appBarColor: Color(0xff00102b),
    error: null,
  ),
  subThemesData: const FlexSubThemesData(
    interactionEffects: false,
    tintedDisabledControls: false,
    useTextTheme: true,
    elevatedButtonRadius: 8,
    outlinedButtonRadius: 8,
    textButtonRadius: 8,
    elevatedButtonTextStyle:
        MaterialStatePropertyAll(TextStyle(fontSize: 18, color: Colors.white)),
    outlinedButtonTextStyle:
        MaterialStatePropertyAll(TextStyle(fontSize: 18, color: Colors.white)),
    textButtonTextStyle:
        MaterialStatePropertyAll(TextStyle(fontSize: 18, color: Colors.white)),
    elevatedButtonSchemeColor: SchemeColor.onBackground,
    outlinedButtonSchemeColor: SchemeColor.onBackground,
    textButtonSchemeColor: SchemeColor.onBackground,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    inputDecoratorUnfocusedBorderIsColored: false,
    alignedDropdown: true,
    tooltipRadius: 4,
    tooltipSchemeColor: SchemeColor.inverseSurface,
    tooltipOpacity: 0.9,
    useInputDecoratorThemeInDialogs: true,
    snackBarElevation: 6,
    snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
    navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
    navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
    navigationBarMutedUnselectedLabel: false,
    navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
    navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
    navigationBarMutedUnselectedIcon: false,
    navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
    navigationBarIndicatorOpacity: 1.00,
    navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
    navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
    navigationRailMutedUnselectedLabel: false,
    navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
    navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
    navigationRailMutedUnselectedIcon: false,
    navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
    navigationRailIndicatorOpacity: 1.00,
    navigationRailBackgroundSchemeColor: SchemeColor.surface,
    navigationRailLabelType: NavigationRailLabelType.none,
  ),
  keyColors: const FlexKeyColors(),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  fontFamily: GoogleFonts.notoSans().fontFamily,
);

/// Heights smaller than this will have their scrolling enabled on
/// some routes like [HomeRoute] and [StatsRoute].
const double scrollingHeight = 330;

const gephLogoPath = "assets/gephlogo.png";
