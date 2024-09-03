import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worklog_assistant/src/theme.dart';
import 'src/app.dart';
import 'src/providers/settings_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:system_theme/system_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:window_manager/window_manager.dart';

void main() async {
  // Setup SQLite
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
  }
  databaseFactory = databaseFactoryFfi;

  if (!kIsWeb &&
      [
        TargetPlatform.windows,
        TargetPlatform.android,
      ].contains(defaultTargetPlatform)) {
    SystemTheme.accentColor.load();
  }

  await flutter_acrylic.Window.initialize();
  if (defaultTargetPlatform == TargetPlatform.windows) {
    await flutter_acrylic.Window.hideWindowControls();
  }
  await WindowManager.instance.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitleBarStyle(
      TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
    await windowManager.setMinimumSize(const Size(500, 600));
    await windowManager.show();
    await windowManager.setPreventClose(true);
    await windowManager.setSkipTaskbar(false);
  });

  var settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  var appTheme = AppTheme();
  final prefs = await SharedPreferences.getInstance();
  var mode = prefs.getString('appTheme.mode');
  if (mode != null) {
    appTheme.mode = mode == 'dark' ? ThemeMode.dark : ThemeMode.light;
  } else {
    appTheme.mode = ThemeMode.system;
  }

  runApp(MyApp(settingsProvider: settingsProvider, appTheme: appTheme));
}
