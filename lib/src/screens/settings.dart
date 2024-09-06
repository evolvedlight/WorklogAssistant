// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;

import '../providers/settings_provider.dart';
import '../widgets/page.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

class SettingsView extends riverpod.ConsumerStatefulWidget {
  const SettingsView({super.key});

  static const routeName = '/settings';

  @override
  SettingsViewState createState() => SettingsViewState();
}

class SettingsViewState extends riverpod.ConsumerState<SettingsView> with PageMixin {
  final jiraUrlController = TextEditingController();
  final patController = TextEditingController();

  @override
  void initState() {
    var settings = ref.watch(settingsProvider);
    jiraUrlController.text = settings.jiraUrl;
    patController.text = settings.jiraPat;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(header: const PageHeader(title: Text('Settings')), children: [
      Text("JIRA Connection"),
      TextBox(
        placeholder: 'JIRA URL',
        expands: false,
        controller: jiraUrlController,
      ),
      RadioButton(checked: false, onChanged: onChangeAuthType, content: Text("Basic Auth")),
      RadioButton(checked: false, onChanged: onChangeAuthType, content: Text("OAuth")),
      RadioButton(checked: true, onChanged: onChangeAuthType, content: Text("PAT Auth")),
      TextBox(placeholder: 'PAT Token', controller: patController),
      Button(child: Text("Test Server"), onPressed: () => checkServer(jiraUrlController.text)),
      Button(child: Text("Save"), onPressed: () => saveSettings())
    ]);
  }

  checkServer(String value) async {
    // try and connect using PAT token
    Future<http.Response> checkServerInt() {
      var url = '${jiraUrlController.text}/rest/auth/1/session';

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
            content: Text('Success! You are logged into JIRA as "$name". You can now start tracking your worklogs.'),
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
            content: Text('The server was reachable but returned an error code ${response.statusCode}.'),
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

  saveSettings() async {
    var settings = ref.watch(settingsProvider.notifier);

    settings.updateJiraUrl(jiraUrlController.text);
    settings.updateJiraPat(patController.text);
  }
}
