import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vortexsales/core/brand/vortex_mark.dart';
import 'package:vortexsales/core/brand/vortex_wordmark.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_theme.dart';
import 'package:vortexsales/core/theme/vx_typography.dart';
import 'package:vortexsales/core/widgets/vx_aurora.dart';
import 'package:vortexsales/core/widgets/vx_button.dart';
import 'package:vortexsales/core/widgets/vx_glass.dart';

Future<void> _loadBrandFonts() async {
  final loader = FontLoader(VxTypography.display)
    ..addFont(rootBundle.load('assets/fonts/Outfit-Regular.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Outfit-Medium.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Outfit-SemiBold.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Outfit-Bold.ttf'));
  await loader.load();
  final sans = FontLoader(VxTypography.sans)
    ..addFont(rootBundle.load('assets/fonts/PlusJakartaSans-Variable.ttf'));
  await sans.load();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(_loadBrandFonts);

  testWidgets('vector mark and Outfit wordmark render on aurora glass', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: VxTheme.dark(const Locale('en')),
        home: Scaffold(
          body: VxAurora(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const VortexWordmark(markSize: 40),
                    const SizedBox(height: 28),
                    VxGlass(
                      radius: 28.8,
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Enter the vortex',
                            style: TextStyle(
                              fontFamily: VxTypography.display,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.4,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Your agents are waiting.',
                            style: TextStyle(
                              fontFamily: VxTypography.sans,
                              fontSize: 14,
                              color: VxColors.mist400,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Row(
                            children: [
                              VortexMark(size: 56, glow: true),
                              SizedBox(width: 16),
                              VortexMark(size: 32, glow: true),
                            ],
                          ),
                          const SizedBox(height: 20),
                          VxButton(
                            label: 'Continue',
                            expanded: true,
                            size: VxButtonSize.lg,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(VortexWordmark), findsOneWidget);
    expect(find.byType(VortexMark), findsNWidgets(3));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/brand_identity.png'),
    );
  });
}
