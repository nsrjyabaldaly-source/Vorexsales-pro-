import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vortexsales/core/brand/brand_assets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('rasterize official logo.svg to logo.png', () async {
    const outSize = 1024;
    final svg = await rootBundle.loadString(BrandAssets.logoSvg);
    final picture = await vg.loadPicture(SvgStringLoader(svg), null);
    final src = picture.size;
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    canvas.scale(outSize / src.width, outSize / src.height);
    canvas.drawPicture(picture.picture);
    picture.picture.dispose();
    final image = await recorder.endRecording().toImage(outSize, outSize);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    expect(bytes, isNotNull);
    await File('assets/brand/logo.png').writeAsBytes(bytes!.buffer.asUint8List());
    expect(File('assets/brand/logo.png').lengthSync(), greaterThan(20000));
  });
}
