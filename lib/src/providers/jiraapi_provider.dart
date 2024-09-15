import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worklog_assistant/src/providers/settings_provider.dart';

import '../models/jiraapi/issue.dart';

// Necessary for code-generation to work
part 'jiraapi_provider.g.dart';

@riverpod
Future<Issue?> issue(IssueRef ref, String jiraId) async {
  if (jiraId.isEmpty) {
    return null;
  }

  var jiraUrl = ref.watch(jiraUrlProvider);
  var jiraPat = ref.watch(jiraPatProvider);
  var url = '$jiraUrl/rest/api/2/issue/$jiraId';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $jiraPat',
      'Content-Type': 'application/json',
    },
  );

  // Using dart:convert, we then decode the JSON payload into a Map data structure.
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  // Finally, we convert the Map into an Activity instance.
  var x = Issue.fromJson(json);
  return x;
}

@riverpod
Future<List<IssuePicker>> issuesAutocomplete(IssuesAutocompleteRef ref, String searchPhrase) async {
  print('Autocompleting issues for $searchPhrase');

  var jiraUrl = ref.watch(jiraUrlProvider);
  var jiraPat = ref.watch(jiraPatProvider);

  const projectId = "DEMO1";

  var url = '$jiraUrl/rest/api/2/issue/picker?currentProjectId=$projectId&query=$searchPhrase';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $jiraPat',
      'Content-Type': 'application/json',
    },
  );

  // Using dart:convert, we then decode the JSON payload into a Map data structure.
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  print(json);
  var result = IssuePickerResult.fromJson(json);
  print(result.sections.length);
  var issues = result.sections.expand((section) => section.issues).toList();

  for (var issue in issues) {
    print(issue.key);
  }

  return issues;
}

// @riverpod
// Future<List<Issue>> issues(IssuesRef ref, String jiraId) async {
//   print('Fetching issues for $jiraId');

//   var jiraUrl = ref.watch(jiraUrlProvider);
//   var jiraPat = ref.watch(jiraPatProvider);
//   var url = '$jiraUrl/rest/api/2/search?jql=issue=$jiraId';
//   final response = await http.get(
//     Uri.parse(url),
//     headers: {
//       'Authorization': 'Bearer $jiraPat',
//       'Content-Type': 'application/json',
//     },
//   );

//   // Using dart:convert, we then decode the JSON payload into a Map data structure.
//   final json = jsonDecode(response.body) as Map<String, dynamic>;
//   // Extract the list of issues from the JSON response.
//   final issuesJson = json['issues'] as List<dynamic>;
//   // Convert each issue JSON into an Issue instance.
//   final issues = issuesJson.map((issueJson) => Issue.fromJson(issueJson as Map<String, dynamic>)).toList();
//   return issues;
// }
