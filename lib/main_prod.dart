import 'package:flutter/material.dart';

import '/app/my_app.dart';
import '/flavors/build_config.dart';
import '/flavors/env_config.dart';
import '/flavors/environment.dart';
import 'app/bindings/initial_binding.dart';
import 'app/core/session_manager/session_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// uncomment below 2 lines to set the orientation of the app
  //await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final prodConfig = EnvConfig(
    appName: 'Flutter GetX Template Prod',
    baseUrl: 'https://api.github.com',
    shouldCollectCrashLog: true,
  );

  BuildConfig.instantiate(
    envType: Environment.production,
    envConfig: prodConfig,
  );

  await InitialBinding().dependencies();
  final prefs = SessionManager();
  final lang = await prefs.getString(prefLanguage) ?? 'en';

  runApp(
    MyApp(
      lang: lang,
    ),
  );
}
