// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../theme.dart';
import '../widgets/page.dart';

const List<String> accentColorNames = [
  'System',
  'Yellow',
  'Orange',
  'Red',
  'Magenta',
  'Purple',
  'Blue',
  'Teal',
  'Green',
];

bool get kIsWindowEffectsSupported {
  return !kIsWeb &&
      [
        TargetPlatform.windows,
        TargetPlatform.linux,
        TargetPlatform.macOS,
      ].contains(defaultTargetPlatform);
}

const _LinuxWindowEffects = [
  WindowEffect.disabled,
  WindowEffect.transparent,
];

const _WindowsWindowEffects = [
  WindowEffect.disabled,
  WindowEffect.solid,
  WindowEffect.transparent,
  WindowEffect.aero,
  WindowEffect.acrylic,
  WindowEffect.mica,
  WindowEffect.tabbed,
];

const _MacosWindowEffects = [
  WindowEffect.disabled,
  WindowEffect.titlebar,
  WindowEffect.selection,
  WindowEffect.menu,
  WindowEffect.popover,
  WindowEffect.sidebar,
  WindowEffect.headerView,
  WindowEffect.sheet,
  WindowEffect.windowBackground,
  WindowEffect.hudWindow,
  WindowEffect.fullScreenUI,
  WindowEffect.toolTip,
  WindowEffect.contentBackground,
  WindowEffect.underWindowBackground,
  WindowEffect.underPageBackground,
];

List<WindowEffect> get currentWindowEffects {
  if (kIsWeb) return [];

  if (defaultTargetPlatform == TargetPlatform.windows) {
    return _WindowsWindowEffects;
  } else if (defaultTargetPlatform == TargetPlatform.linux) {
    return _LinuxWindowEffects;
  } else if (defaultTargetPlatform == TargetPlatform.macOS) {
    return _MacosWindowEffects;
  }

  return [];
}

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with PageMixin {
  final jiraUrlController = TextEditingController();
  final patController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final appTheme = context.watch<AppTheme>();
    const spacer = SizedBox(height: 10.0);
    const biggerSpacer = SizedBox(height: 40.0);

    const supportedLocales = FluentLocalizations.supportedLocales;
    final currentLocale =
        appTheme.locale ?? Localizations.maybeLocaleOf(context);

    return ScaffoldPage.scrollable(
        header: const PageHeader(title: Text('Settings')),
        children: [
          new Text("JIRA Connection"),
          TextBox(
            placeholder: 'JIRA URL',
            expands: false,
            onSubmitted: (value) => checkServer(value),
            controller: jiraUrlController,
          ),
          RadioButton(
              checked: false,
              onChanged: onChangeAuthType,
              content: Text("Basic Auth")),
          RadioButton(
              checked: false,
              onChanged: onChangeAuthType,
              content: Text("OAuth")),
          RadioButton(
              checked: true,
              onChanged: onChangeAuthType,
              content: Text("PAT Auth")),
          TextBox(placeholder: 'PAT Token', controller: patController),
          Button(
              child: Text("Test Server"),
              onPressed: () => checkServer(jiraUrlController.text)),
        ]);
  }

  checkServer(String value) async {
    // try and connect using PAT token
    Future<http.Response> checkServerInt() {
      var url = 'http://localhost:8080/rest/auth/1/session';

      return http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${patController.text}',
          'Content-Type': 'application/json',
        },
      );
    }

    try {
      var response = await checkServerInt();
      print("Server check response: ${response.body}");

      if (response.statusCode == 200) {
        print("Server is up and running");

        // get the "name" from json
        var name = jsonDecode(response.body)['name'];
        print("Server name: $name");
        await displayInfoBar(context, builder: (context, close) {
          return InfoBar(
            title: const Text('Success'),
            content: Text(
                'Success! You are logged into JIRA as "$name". You can now start tracking your worklogs.'),
            action: IconButton(
              icon: const Icon(FluentIcons.clear),
              onPressed: close,
            ),
            severity: InfoBarSeverity.warning,
          );
        });
      } else {
        await displayInfoBar(context, builder: (context, close) {
          return InfoBar(
            title: const Text('Failure'),
            content: Text(
                'The server was reachable but returned an error code ${response.statusCode}.'),
            action: IconButton(
              icon: const Icon(FluentIcons.clear),
              onPressed: close,
            ),
            severity: InfoBarSeverity.warning,
          );
        });
      }
      // Use the response variable here if needed
    } catch (e) {
      await displayInfoBar(context, builder: (context, close) {
        return InfoBar(
          title: const Text('Fail :()'),
          content: Text('This failed with error $e'),
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
          severity: InfoBarSeverity.warning,
        );
      });
      // Handle the error here
    }
  }

  void onChangeAuthType(bool value) {
    print("Auth type changed: $value");
  }
}
