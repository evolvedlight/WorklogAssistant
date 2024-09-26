import 'dart:convert';
import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';
import 'package:worklog_assistant/src/models/worklogentry.dart';
import 'package:worklog_assistant/src/providers/jira_provider.dart';
import 'package:worklog_assistant/src/widgets/page.dart';
import 'package:http/http.dart' as http;

import '../models/enums/worklogstatus.dart';
import '../providers/settings_provider.dart';
import '../widgets/plutojiratable.dart';
import '../widgets/tracker.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

class HomePage extends riverpod.ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends riverpod.ConsumerState<HomePage> with PageMixin {
  bool selected = true;
  String? comboboxValue;
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));

    final jiraProviderRef = ref.watch(jiraNotifierProvider.notifier);

    return ScaffoldPage(
        header: PageHeader(
          title: const Text('Worklog Assistant'),
          commandBar: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            FilledButton(
              onPressed: isSubmitting ? null : () => uploadWorklogs(ref),
              child: Row(
                children: [
                  if (isSubmitting)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SizedBox(width: 16, height: 16, child: ProgressRing()),
                    ),
                  if (!isSubmitting) Icon(FluentIcons.cloud_upload),
                  SizedBox(width: 8.0),
                  Text("Submit Worklogs (${formatTotalLoggedTime(jiraProviderRef.totalUnsubmittedTime)})"),
                ],
              ),
            ),
          ]),
        ),
        content: Column(
          children: [
            // Expanded(child: material.Material(child: JiraTable())),
            Expanded(child: material.Material(child: PlutoJiraTable())),
            Tracker(),
          ],
        )
        // first the header - this will be a table layout with a first row that has a checkbox, then the id, the name and the time spent
        );
  }

  uploadWorklogs(riverpod.WidgetRef ref) async {
    var worklogEntries = ref.read(jiraNotifierProvider);
    var worklogNotifier = ref.read(jiraNotifierProvider.notifier);
    Future<http.Response> submitWorklogs(String jiraId, Duration timeLogged, DateTime startTime) {
      var jiraUrl = ref.watch(jiraUrlProvider);
      var jiraPat = ref.watch(jiraPatProvider);
      var url = '$jiraUrl/rest/api/2/issue/$jiraId/worklog?adjustEstimate=leave';

      var body = jsonEncode({"started": formatForJiraTime(startTime.toUtc()), "timeSpentSeconds": max(timeLogged.inSeconds, 60)});

      print(body);
      return http.post(Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $jiraPat',
            'Content-Type': 'application/json',
          },
          body: body);
    }

    isSubmitting = true;
    setState(() {});

    try {
      for (var worklog in worklogEntries.value!.where((worklog) => worklog.status != WorklogStatus.submitted)) {
        if (worklog.id == null) {
          continue;
        }
        worklogNotifier.markAs(worklog.id!, WorklogStatus.submitting);
        var result = await submitWorklogs(worklog.jiraId, worklog.timeLogged, worklog.startTime);

        if (result.statusCode != 201) {
          worklogNotifier.markAs(worklog.id!, WorklogStatus.error);
          print('Error submitting worklog: ${result.body}');
          continue;
        } else {
          worklogNotifier.markAs(worklog.id!, WorklogStatus.submitted);
          print('Submitted Worklog');
        }
      }
      setState(() {});
    } finally {
      isSubmitting = false;
      setState(() {});
    }
  }

  String formatForJiraTime(DateTime startTime) {
    DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
    String formattedStartTime = formatter.format(startTime);
    String timezoneOffset = startTime.timeZoneOffset.isNegative ? '-' : '+';
    timezoneOffset += startTime.timeZoneOffset.inHours.abs().toString().padLeft(2, '0');
    timezoneOffset += (startTime.timeZoneOffset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    var result = "$formattedStartTime$timezoneOffset";
    return result;
  }

  formatTotalLoggedTime(double totalLoggedTime) {
    // if less than a minute, display in seconds but round to the nearest second
    if (totalLoggedTime < 60) {
      return "${totalLoggedTime.round()}s";
    }
    // if less than an hour, display in minutes
    if (totalLoggedTime < 3600) {
      var minutes = totalLoggedTime ~/ 60;
      return "${minutes}m";
    }
    // example: 3600 -> 1h
    var hours = totalLoggedTime ~/ 3600;
    return "${hours}h";
  }
}
