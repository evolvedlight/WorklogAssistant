import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worklog_assistant/src/providers/settings_provider.dart';

import '../models/jiraapi/issue.dart';
import '../models/jiraapi/jira_filter.dart';

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
  var result = IssuePickerResult.fromJson(json);
  var issues = result.sections.expand((section) => section.issues).toList();

  return issues;
}

@riverpod
Future<List<JiraFilter>> filtersAutocomplete(FiltersAutocompleteRef ref) async {
  print('Loading favorite filters for user');

  var jiraUrl = ref.watch(jiraUrlProvider);
  var jiraPat = ref.watch(jiraPatProvider);

  var url = '$jiraUrl/rest/api/2/filter/favourite';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $jiraPat',
      'Content-Type': 'application/json',
    },
  );

  // Using dart:convert, we then decode the JSON payload into a Map data structure.
  final json = jsonDecode(response.body) as List<dynamic>;

  return json.map((f) => JiraFilter.fromJson(f)).toList();
}

@riverpod
Future<JiraFilter> filter(FilterRef ref, int filterId) async {
  print('Loading filter name from ID');

  var jiraUrl = ref.watch(jiraUrlProvider);
  var jiraPat = ref.watch(jiraPatProvider);

  var url = '$jiraUrl/rest/api/2/filter/$filterId';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $jiraPat',
      'Content-Type': 'application/json',
    },
  );

  // Using dart:convert, we then decode the JSON payload into a Map data structure.
  final json = jsonDecode(response.body) as Map<String, dynamic>;

  return JiraFilter(name: json['name'], id: int.parse(json['id']));
}

@riverpod
Future<List<Issue>> issuesForFilter(IssuesForFilterRef ref, int? filterId) async {
  print('Loading issues for filter $filterId');

  if (filterId == null) {
    return [];
  }

  var jiraUrl = ref.watch(jiraUrlProvider);
  var jiraPat = ref.watch(jiraPatProvider);

  var url = '$jiraUrl/rest/api/2/search?jql=filter=$filterId';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $jiraPat',
      'Content-Type': 'application/json',
    },
  );

  // Using dart:convert, we then decode the JSON payload into a Map data structure.
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  var issues = json['issues'] as List<dynamic>;

  return issues.map((i) => Issue.fromJson(i)).toList();
}
