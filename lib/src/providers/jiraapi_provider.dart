import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/jiraapi/issue.dart';

// Necessary for code-generation to work
part 'jiraapi_provider.g.dart';

@riverpod
Future<Issue> issue(IssueRef ref, String jiraId) async {
  // Using package:http, we fetch a random activity from the Bored API.
  print('Fetching issue $jiraId');
  final response = await http.get(
    Uri.http('localhost:8080', '/rest/api/2/issue/$jiraId'),
    headers: {
      'Authorization': 'Bearer MDQ4NzY1MTQ4NDk1OrroeeMOMVWzFE/TwUSGnuDPT2bb',
      'Content-Type': 'application/json',
    },
  );
  // Using dart:convert, we then decode the JSON payload into a Map data structure.
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  // Finally, we convert the Map into an Activity instance.
  var x = Issue.fromJson(json);
  return x;
}
