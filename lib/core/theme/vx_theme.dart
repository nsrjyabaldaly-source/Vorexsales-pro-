import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';
import 'package:vortexsales/core/theme/vx_typography.dart';


abstract final class VxTheme {
  static ThemeData dark(Locale locale) {
    final text = VxTypography.of(locale);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: {'ar', 'fa', 'ur'}.contains(locale.languageCode)
          ? VxTypography.arabic
          : VxTypography.sans,
      scaffoldBackgroundColor: VxColors.ink900,
      canvasColor: VxColors.ink900,
      colorScheme: const ColorScheme.dark(
        surface: VxColors.ink900,
        primary: VxColors.cyan,
        secondary: VxColors.violet,
        onPrimary: VxColors.ink950,
        onSecondary: Colors.white,
        onSurface: VxColors.mist100,
        error: VxColors.rose,
      ),
      textTheme: text,
      splashFactory: InkRipple.splashFactory,
      dividerColor: VxColors.hairline,
      iconTheme: const IconThemeData(color: VxColors.mist300, size: 20),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: VxColors.white05,
        hintStyle: const TextStyle(color: VxColors.mist500, fontSize: 14),
        labelStyle: const TextStyle(color: VxColors.mist400, fontSize: 12),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VxRadii.input),
          borderSide: const BorderSide(color: VxColors.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VxRadii.input),
          borderSide: const BorderSide(color: VxColors.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VxRadii.input),
          borderSide: BorderSide(color: VxColors.cyan.withValues(alpha: 0.5)),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: VxColors.cyan,
        thumbColor: VxColors.cyan,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
        overlayColor: VxColors.cyan.withValues(alpha: 0.12),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: VxColors.ink950,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
    );
  }
}
