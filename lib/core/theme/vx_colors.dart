import 'package:flutter/material.dart';

/// VortexSales palette — matched to AMREKA2 `tailwind.config` + `globals.css`.
abstract final class VxColors {
  static const ink950 = Color(0xFF04060C);
  static const ink900 = Color(0xFF070A14);
  static const ink850 = Color(0xFF0B1020);
  static const ink800 = Color(0xFF10182B);
  static const ink700 = Color(0xFF18223C);
  static const ink600 = Color(0xFF243056);

  static const mist50 = Color(0xFFF5F8FC);
  static const mist100 = Color(0xFFE7EEF8);
  static const mist200 = Color(0xFFC9D6EA);
  static const mist300 = Color(0xFF9AADC8);
  static const mist400 = Color(0xFF6D82A3);
  static const mist500 = Color(0xFF4C5F7E);

  static const cyan = Color(0xFF22E3D2);
  static const cyanGlow = Color(0xFF7AFFF2);
  static const cyanDim = Color(0xFF12B8A9);
  static const logoCore = Color(0xFF2EE6C8);
  static const logoMid = Color(0xFF5B8CFF);

  static const violet = Color(0xFF8B6CFF);
  static const violetGlow = Color(0xFFC4B5FD);
  static const violetDim = Color(0xFF6D4DFF);

  static const rose = Color(0xFFF43F5E);
  static const roseHover = Color(0xFFFB7185);

  /// white / 7% — CSS hairline on web.
  static const hairline = Color(0x12FFFFFF);

  /// white / 8% — glass border on web.
  static const glassBorder = Color(0x14FFFFFF);
  static const white08 = Color(0x14FFFFFF);
  static const white05 = Color(0x0DFFFFFF);
  static const selection = Color(0x4722E3D2);

  /// Glass fill — matches web `.glass` (ink-800/ink-850 with alpha).
  static const glassTop = Color(0xCC10182B);
  static const glassBottom = Color(0xB80B1020);

  /// Aurora blobs — web landing atmosphere (cyan + violet wash).
  static const auroraCyan = Color(0x4022E3D2);
  static const auroraViolet = Color(0x478B6CFF);
  static const gridLine = Color(0x08FFFFFF);

  static const List<Color> brandGradient = [cyan, violet];
}
