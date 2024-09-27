import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worklog_assistant/src/providers/settings_provider.dart';
import 'package:worklog_assistant/src/services/jira_api_service.dart';

import '../models/jiraapi/issue.dart';
import '../models/jiraapi/jira_filter.dart';

// Necessary for code-generation to work
part 'jiraapi_provider.g.dart';

@riverpod
Future<Issue?> issue(IssueRef ref, String jiraId) async {
  var jiraApi = ref.watch(jiraApiServiceProvider);
  if (jiraApi == null) {
    return null;
  }

  if (jiraId.isEmpty) {
    return null;
  }

  return await jiraApi.getIssue(jiraId);
}

@riverpod
Future<List<IssuePicker>> issuesAutocomplete(IssuesAutocompleteRef ref, String searchPhrase) async {
  var jiraApi = ref.watch(jiraApiServiceProvider);
  if (jiraApi == null) {
    return [];
  }

  return await jiraApi.getIssues(searchPhrase, null);
}

@riverpod
Future<List<JiraFilter>> filtersAutocomplete(FiltersAutocompleteRef ref) async {
  var jiraApi = ref.watch(jiraApiServiceProvider);
  if (jiraApi == null) {
    return [];
  }

  return await jiraApi.getFilters();
}

@riverpod
Future<JiraFilter?> filter(FilterRef ref, int filterId) async {
  var jiraApi = ref.watch(jiraApiServiceProvider);
  if (jiraApi == null) {
    return null;
  }

  return await jiraApi.getFilter(filterId);
}

@riverpod
Future<List<Issue>> issuesForFilter(IssuesForFilterRef ref, int? filterId) async {
  var jiraApi = ref.watch(jiraApiServiceProvider);
  if (jiraApi == null) {
    return [];
  }

  if (filterId == null) {
    return [];
  }

  return await jiraApi.getIssuesForFilter(filterId);
}
