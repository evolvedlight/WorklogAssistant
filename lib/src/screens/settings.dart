import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;
import 'package:worklog_assistant/src/services/database_helper.dart';
import '../providers/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

class SettingsView extends riverpod.ConsumerWidget {
  SettingsView({super.key});

  static const routeName = '/settings';

  final jiraUrlController = TextEditingController();
  final patController = TextEditingController();

  @override
  Widget build(BuildContext context, riverpod.WidgetRef ref) {
    var jiraUrl = ref.watch(jiraUrlProvider);
    var jiraPat = ref.watch(jiraPatProvider);
    jiraUrlController.text = jiraUrl ?? "";
    patController.text = jiraPat ?? "";

    return ScaffoldPage.scrollable(header: const PageHeader(title: Text('Settings')), children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InfoLabel(
                  label: "JIRA Connection",
                  child: TextBox(
                    placeholder: 'JIRA URL',
                    expands: false,
                    controller: jiraUrlController,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: InfoLabel(
                label: "Authentication Type:",
                child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: RadioButton(checked: false, onChanged: onChangeAuthType, content: Text("Basic Auth")),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: RadioButton(checked: false, onChanged: onChangeAuthType, content: Text("OAuth")),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: RadioButton(checked: true, onChanged: onChangeAuthType, content: Text("PAT Auth")),
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InfoLabel(
                label: "PAT Token",
                child: TextBox(
                  placeholder: 'PAT Token',
                  expands: false,
                  controller: patController,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Button(child: Text("Test Server"), onPressed: () async => checkServer(jiraUrlController.text, context)),
                  ),
                  Button(child: Text("Save"), onPressed: () => saveSettings(ref)),
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.only(top: 8.0), child: Divider()),
            Text("Debug Information:"),
            Padding(padding: const EdgeInsets.all(8.0), child: Text("DB Path: ${DatabaseHelper.getDbPath()}"))
          ],
        ),
      )
    ]);
  }

  Future<void> checkServer(String value, BuildContext bcontext) async {
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
        await displayInfoBar(bcontext, builder: (context, close) {
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
        await displayInfoBar(bcontext, builder: (context, close) {
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
      await displayInfoBar(bcontext, builder: (context, close) {
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

  saveSettings(riverpod.WidgetRef ref) {
    ref.read(jiraUrlProvider.notifier).set(jiraUrlController.text);
    ref.read(jiraPatProvider.notifier).set(patController.text);
  }
}
