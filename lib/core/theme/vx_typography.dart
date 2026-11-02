import 'package:flutter/material.dart';
import 'package:vortexsales/core/l10n/vx_locales.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';

abstract final class VxTypography {
  static const sans = 'PlusJakartaSans';
  static const display = 'Outfit';
  static const arabic = 'IBMPlexSansArabic';

  static TextTheme of(Locale locale) {
    final code = vxLocaleCodeFromParts(locale.languageCode, locale.countryCode);
    final arabicScript = {'ar', 'fa', 'ur'}.contains(code);
    final family = arabicScript ? arabic : sans;
    final heading = arabicScript ? arabic : display;
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: heading,
        fontSize: 40,
        fontWeight: FontWeight.w600,
        height: 1.05,
        letterSpacing: -0.6,
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontFamily: heading,
        fontSize: 30,
        fontWeight: FontWeight.w600,
        height: 1.05,
        letterSpacing: -0.4,
        color: Colors.white,
      ),
      displaySmall: TextStyle(
        fontFamily: heading,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.1,
        letterSpacing: -0.3,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontFamily: heading,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontFamily: family,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontFamily: family,
        fontSize: 16,
        height: 1.55,
        color: VxColors.mist200,
      ),
      bodyMedium: TextStyle(
        fontFamily: family,
        fontSize: 14,
        height: 1.55,
        color: VxColors.mist200,
      ),
      bodySmall: TextStyle(
        fontFamily: family,
        fontSize: 12,
        height: 1.45,
        color: VxColors.mist400,
      ),
      labelSmall: TextStyle(
        fontFamily: family,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 2.16,
        color: VxColors.mist500,
      ),
    );
  }

  static TextStyle kicker([bool isArabic = false]) {
    return TextStyle(
      fontFamily: isArabic ? arabic : sans,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 2.16,
      color: VxColors.cyan,
    );
  }
}
