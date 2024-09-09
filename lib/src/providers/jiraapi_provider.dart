import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worklog_assistant/src/providers/settings_provider.dart';

import '../models/jiraapi/issue.dart';

// Necessary for code-generation to work
part 'jiraapi_provider.g.dart';

@riverpod
Future<Issue> issue(IssueRef ref, String jiraId) async {
  // Using package:http, we fetch a random activity from the Bored API.
  print('Fetching issue $jiraId');

  var settings = ref.watch(settingsProvider);
  var url = '${settings.jiraUrl}/rest/api/2/issue/$jiraId';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer ${settings.jiraPat}',
      'Content-Type': 'application/json',
    },
  );

  // Using dart:convert, we then decode the JSON payload into a Map data structure.
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  // Finally, we convert the Map into an Activity instance.
  var x = Issue.fromJson(json);
  return x;
}
