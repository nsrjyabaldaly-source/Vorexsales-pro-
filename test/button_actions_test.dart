import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vortexsales/app.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/l10n/vx_locales.dart';
import 'package:vortexsales/core/state/app_controller.dart';
import 'package:vortexsales/core/state/store_controller.dart';
import 'package:vortexsales/core/theme/vx_theme.dart';
import 'package:vortexsales/core/theme/vx_typography.dart';
import 'package:vortexsales/core/widgets/vx_button.dart';
import 'package:vortexsales/features/channels/channels_screen.dart';
import 'package:vortexsales/features/settings/settings_screen.dart';

late VxL10n _english;

Future<void> _loadFonts() async {
  final display = FontLoader(VxTypography.display)
    ..addFont(rootBundle.load('assets/fonts/Outfit-Regular.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Outfit-Medium.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Outfit-SemiBold.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Outfit-Bold.ttf'));
  await display.load();
  final sans = FontLoader(VxTypography.sans)
    ..addFont(rootBundle.load('assets/fonts/PlusJakartaSans-Variable.ttf'));
  await sans.load();
  final en = await VxL10n.loadMessages('en');
  _english = VxL10n(
    locale: const Locale('en'),
    info: vxLocaleInfo('en'),
    messages: en,
    fallback: en,
  );
}

Widget _hosted(Widget home) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: VxTheme.dark(const Locale('en')),
    builder: (context, child) => VxL10nHost(l10n: _english, child: child!),
    home: home,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(_loadFonts);

  testWidgets('connect button explains where the channel will live', (tester) async {
    await tester.pumpWidget(_hosted(const ChannelsScreen()));
    await tester.pump();

    expect(find.byType(AlertDialog), findsNothing);
    await tester.tap(find.text('Show where it will connect').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(
      find.descendant(of: find.byType(AlertDialog), matching: find.text('WhatsApp')),
      findsOneWidget,
    );
    expect(find.text('Got it'), findsOneWidget);

    await tester.tap(find.text('Got it'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('settings channels button opens the channels tab', (tester) async {
    var opened = false;
    await tester.pumpWidget(
      _hosted(
        Scaffold(
          body: SettingsScreen(
            initialTab: 'channels',
            onOpenChannels: () => opened = true,
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.widgetWithText(VxButton, 'Channels'));
    await tester.pump();

    expect(opened, isTrue);
  });

  testWidgets('coach marks let the highlighted nav button receive the tap', (tester) async {
    final controller = AppController()
      ..localeCode = 'en'
      ..languageChosen = true
      ..loggedIn = true
      ..onboarded = true
      ..tutorialDone = true
      ..coachDone = false
      ..gate = VxGate.app;

    await tester.pumpWidget(
      VxApp(controller: controller, store: StoreController()),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('inbox.title'), findsNothing);
    await tester.tap(find.text('app.inbox'));
    await tester.pump();

    expect(find.text('inbox.title'), findsOneWidget);
  });
}
