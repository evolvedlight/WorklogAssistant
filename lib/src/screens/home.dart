import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';
import 'package:worklog_assistant/src/services/jira_api_service.dart';
import 'package:worklog_assistant/src/providers/jira_provider.dart';
import 'package:worklog_assistant/src/widgets/page.dart';

import '../models/enums/worklogstatus.dart';
import '../models/worklogentry.dart';
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

    final jiras = ref.watch(jiraNotifierProvider);

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
                  Text("Submit Worklogs (${formatTotalLoggedTime(totalUnsubmittedTime(jiras))})"),
                ],
              ),
            ),
          ]),
        ),
        content: Column(
          children: [
            Expanded(child: material.Material(child: PlutoJiraTable())),
            Tracker(),
          ],
        ));
  }

  double totalUnsubmittedTime(riverpod.AsyncValue<List<WorklogEntry>> state) {
    return state.maybeWhen(
      data: (items) {
        return items.where((item) => item.status != WorklogStatus.submitted).fold(0.0, (total, current) => total + current.timeLogged.inSeconds);
      },
      orElse: () {
        return 0.0;
      },
    );
  }

  uploadWorklogs(riverpod.WidgetRef ref) async {
    var worklogEntries = ref.read(jiraNotifierProvider);
    var worklogNotifier = ref.read(jiraNotifierProvider.notifier);
    var jiraApiService = ref.read(jiraApiServiceProvider);

    if (jiraApiService == null) {
      print("No Jira API Service as base URL is not set");
      return;
    }

    isSubmitting = true;
    setState(() {});

    try {
      for (var worklog in worklogEntries.value!.where((worklog) => worklog.status != WorklogStatus.submitted)) {
        if (worklog.id == null) {
          continue;
        }
        worklogNotifier.markAs(worklog.id!, WorklogStatus.submitting);
        var result = await jiraApiService.uploadWorklog(worklog.jiraId, worklog.timeLogged, worklog.startTime);

        if (result != true) {
          worklogNotifier.markAs(worklog.id!, WorklogStatus.error);
          continue;
        } else {
          worklogNotifier.markAs(worklog.id!, WorklogStatus.submitted);
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
