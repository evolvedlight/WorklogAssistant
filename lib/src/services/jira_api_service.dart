import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worklog_assistant/src/providers/settings_provider.dart';

import 'jira_api_client.dart';

part 'jira_api_service.g.dart';

@riverpod
JiraApiClient? jiraApiService(JiraApiServiceRef ref) {
  final token = ref.watch(jiraPatProvider);
  final jiraUrl = ref.watch(jiraUrlProvider);

  final JiraApiClient client;

  if (jiraUrl == null) {
    return null;
  }

  client = token != null ? JiraApiClient.withToken(jiraUrl, token) : JiraApiClient(jiraUrl);
  ref.keepAlive();

  return client;
}
