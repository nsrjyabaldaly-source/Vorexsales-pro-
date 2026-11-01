import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vortexsales/app.dart';
import 'package:vortexsales/core/state/app_controller.dart';
import 'package:vortexsales/core/state/store_controller.dart';

void main() {
  testWidgets('boots the language gate', (tester) async {
    final controller = AppController()..gate = VxGate.language;
    await tester.pumpWidget(
      VxApp(controller: controller, store: StoreController()),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
