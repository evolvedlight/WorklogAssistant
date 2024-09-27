import 'dart:math';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

import '../models/jiraapi/issue.dart';
import '../models/jiraapi/jira_filter.dart';

typedef _ResponseData = Map<String, Object?>;

class JiraApiClient {
  final jiraApiLogger = Logger('JiraApiClient');

  static final BaseOptions _defaultOptions = BaseOptions(headers: {
    'User-Agent': 'Worklog Assistant',
    'Content-Type': 'application/json',
  });

  final Dio _httpClient;

  JiraApiClient(String baseUrl)
      : _httpClient = Dio(
          _defaultOptions.copyWith(
            baseUrl: baseUrl,
          ),
        ) {
    // _httpClient.interceptors.add(LogInterceptor(logPrint: (o) => jiraApiLogger.fine(o)));
  }

  JiraApiClient.withToken(String baseUrl, String token)
      : _httpClient = Dio(
          _defaultOptions.copyWith(
            baseUrl: baseUrl,
            headers: {
              ..._defaultOptions.headers,
              'Authorization': 'Bearer $token',
            },
          ),
        ) {
    // _httpClient.interceptors.add(LogInterceptor(logPrint: (o) => jiraApiLogger.fine(o)));
  }

  @override
  String toString() {
    return "ApiClient(_httpClient.options.headers['Authorization']: ${_httpClient.options.headers['Authorization']})";
  }

  Future<bool> uploadWorklog(String jiraId, Duration timeLogged, DateTime startTime) async {
    final response = await _httpClient.post(
      '/rest/api/2/issue/$jiraId/worklog?adjustEstimate=leave',
      data: {
        "started": _formatForJiraTime(startTime.toUtc()),
        "timeSpentSeconds": max(timeLogged.inSeconds, 60),
      },
    );

    if (response.statusCode != 201) {
      print("Failed to upload worklog: ${response.data}");
    }
    return response.statusCode == 201;
  }

  Future<List<IssuePicker>> getIssues(String searchPhrase, String? projectId) async {
    var queryParameters = {
      'query': searchPhrase,
      if (projectId != null) 'currentProjectId': projectId,
    };

    var url = Uri(
      path: '/rest/api/2/issue/picker',
      queryParameters: queryParameters,
    ).toString();

    final response = await _httpClient.get(url);
    var result = IssuePickerResult.fromJson(response.data);
    var issues = result.sections.expand((section) => section.issues).toList();
    return issues;
  }

  Future<List<JiraFilter>> getFilters() async {
    final response = await _httpClient.get("/rest/api/2/filter/favourite");
    return (response.data as List).cast<_ResponseData>().map(JiraFilter.fromJson).toList();
  }

  Future<JiraFilter> getFilter(int filterId) async {
    final response = await _httpClient.get("/rest/api/2/filter/$filterId");
    return JiraFilter(name: response.data['name'], id: int.parse(response.data['id']));
  }

  Future<List<Issue>> getIssuesForFilter(int? filterId) async {
    final response = await _httpClient.get("/rest/api/2/search?jql=filter=$filterId");
    return (response.data['issues'] as List).cast<_ResponseData>().map(Issue.fromJson).toList();
  }

  Future<Issue> getIssue(String jiraId) async {
    final response = await _httpClient.get("/rest/api/2/issue/$jiraId");
    return Issue.fromJson(response.data);
  }

  String _formatForJiraTime(DateTime startTime) {
    DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
    String formattedStartTime = formatter.format(startTime);
    String timezoneOffset = startTime.timeZoneOffset.isNegative ? '-' : '+';
    timezoneOffset += startTime.timeZoneOffset.inHours.abs().toString().padLeft(2, '0');
    timezoneOffset += (startTime.timeZoneOffset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    var result = "$formattedStartTime$timezoneOffset";
    return result;
  }
}
