import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../models/enums/worklogstatus.dart';
import '../models/jiraapi/issue.dart';
import '../models/worklogentry.dart';
import '../providers/jira_provider.dart';
import '../providers/jiraapi_provider.dart';
import '../providers/tracking_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:hooks_riverpod/hooks_riverpod.dart' as riverpod_hooks;

class Tracker extends riverpod_hooks.HookConsumerWidget {
  Tracker({super.key});

  final issueController = TextEditingController();

  @override
  Widget build(BuildContext context, riverpod.WidgetRef ref) {
    final theme = FluentTheme.of(context);
    final trackingProviderRef = ref.watch(trackingProvider);
    final search = useValueListenable(issueController).text;

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: theme.resources.controlStrokeColorSecondary,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Column(children: [
                Mica(
                    child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: SizedBox(
                          width: 150,
                          child: TextBox(
                            placeholder: 'Issue Key',
                            expands: false,
                            style: TextStyle(fontSize: 24),
                            onEditingComplete: () => changeIssue(ref),
                            onSubmitted: (value) => onTrackerSubmitted(value, ref),
                            controller: issueController,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: riverpod.Consumer(builder: (context, ref, child) {
                            riverpod.AsyncValue<Issue> issue = ref.watch(
                              // The provider is now a function expecting the activity type.
                              // Let's pass a constant string for now, for the sake of simplicity.
                              issueProvider(search),
                            );

                            return Container(
                                child: switch (issue) {
                              riverpod.AsyncData(:final value) => Text(style: TextStyle(fontSize: 24), textAlign: TextAlign.start, value.summary()),
                              riverpod.AsyncError() => Text('Issue not found'),
                              _ => Text('loading..')
                            });
                          })),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(formatTime(trackingProviderRef.secondsTimed), style: TextStyle(fontSize: 24)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: trackingProviderRef.state == TrackingState.started
                          ? Button(
                              onPressed: () => stopTracking(ref),
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(TextStyle(color: theme.accentColor, fontSize: 24)),
                              ),
                              child: Row(
                                children: [
                                  Text("Stop"),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: ProgressRing(),
                                    ),
                                  )
                                ],
                              ))
                          : Button(
                              onPressed: () => startTracking(ref),
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(TextStyle(color: theme.accentColor, fontSize: 24)),
                              ),
                              child: Text("Start")),
                    )
                  ],
                )),
              ]),
            )));
  }

  changeIssue(riverpod.WidgetRef ref) {
    print('Changing issue');
    // var newIssue = issueController.text;
    // final tracking = ref.watch(trackingProvider);
    // tracking.currentIssue = newIssue;

    // final jira = ref.read(jiraProvider);
    // jira.add(WorklogEntry(newIssue, Duration(seconds: tracking.secondsTimed), WorklogStatus.pending));

    // tracking.resetTime();
  }

  String formatTime(int seconds) {
    var hours = seconds ~/ 3600;
    var minutes = (seconds % 3600) ~/ 60;
    var remainingSeconds = seconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  void stopTracking(riverpod.WidgetRef ref) {
    final tracking = ref.watch(trackingProvider);
    tracking.stopTime();
    var currentTime = tracking.secondsTimed;

    final jira = ref.read(jiraProvider);
    var currentIssue = tracking.currentIssue;
    jira.add(WorklogEntry(currentIssue, Duration(seconds: currentTime), WorklogStatus.pending));

    tracking.resetTime();
  }

  void startTracking(riverpod.WidgetRef ref) {
    final tracking = ref.watch(trackingProvider);
    tracking.currentIssue = issueController.text;

    print("Starting work on ${tracking.currentIssue} from button");

    tracking.startTime();
  }

  onTrackerSubmitted(String value, riverpod.WidgetRef ref) {
    print("Starting work on $value");
    // at this point we want to take it and just start logging
    final tracking = ref.watch(trackingProvider);
    tracking.currentIssue = value;

    tracking.startTime();
  }
}
