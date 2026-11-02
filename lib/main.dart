import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vortexsales/app.dart';
import 'package:vortexsales/core/api/vx_api_config.dart';
import 'package:vortexsales/core/api/vx_session.dart';
import 'package:vortexsales/core/notify/vx_notify.dart';
import 'package:vortexsales/core/state/app_controller.dart';
import 'package:vortexsales/core/state/store_controller.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: VxColors.ink950,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  final controller = AppController();
  final store = StoreController();
  runApp(VxApp(controller: controller, store: store));
  await VxApiConfig.load();
  await VxSession.load();
  await VxNotify.init();
  await Future.wait([controller.load(), store.load()]);
}
