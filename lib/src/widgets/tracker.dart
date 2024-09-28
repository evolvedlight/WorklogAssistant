import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../models/enums/worklogstatus.dart';
import '../models/worklogentry.dart';
import '../providers/jira_provider.dart';
import '../providers/jiraapi_provider.dart';
import '../providers/tracking_provider.dart';

import 'package:flutter_use/flutter_use.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:hooks_riverpod/hooks_riverpod.dart' as riverpod_hooks;

class Tracker extends riverpod_hooks.HookConsumerWidget {
  Tracker({super.key});

  void useDebounce(VoidCallback fn, Duration delay, [List<Object?>? keys]) {
    final timeout = useTimeoutFn(fn, delay);
    useEffect(() => timeout.reset, keys);
  }

  @override
  Widget build(BuildContext context, riverpod.WidgetRef ref) {
    final theme = FluentTheme.of(context);
    final trackingProviderRef = ref.watch(trackingNotifierProvider);

    final issueController = useListenable(useTextEditingController(text: trackingProviderRef.currentIssue));
    final search = useState(trackingProviderRef.currentIssue);

    final issue = ref.watch(issueProvider(search.value));
    final color = useState(theme.resources.controlStrokeColorSecondary);

    ref.listen<TrackingStateData>(trackingNotifierProvider, (previous, current) {
      search.value = current.currentIssue;
      issueController.text = current.currentIssue;

      if (previous?.currentIssue != current.currentIssue) {
        color.value = Colors.successPrimaryColor;
        Future.delayed(const Duration(milliseconds: 300), () {
          color.value = theme.resources.controlStrokeColorSecondary;
        });
      }
    });

    useDebounce(
      () => search.value = issueController.text,
      const Duration(milliseconds: 500),
      [issueController.text],
    );

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: color.value,
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
                            return Container(
                                child: switch (issue) {
                              riverpod.AsyncData(:final value) => Text(style: TextStyle(fontSize: 24), textAlign: TextAlign.start, value?.summary ?? ''),
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
                              onPressed: () => startTracking(ref, issueController.text),
                              style: ButtonStyle(
                                textStyle: WidgetStatePropertyAll(TextStyle(color: theme.accentColor, fontSize: 24)),
                              ),
                              child: Text("Start")),
                    ),
                  ],
                )),
              ]),
            )));
  }

  String formatTime(int seconds) {
    var hours = seconds ~/ 3600;
    var minutes = (seconds % 3600) ~/ 60;
    var remainingSeconds = seconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  void stopTracking(riverpod.WidgetRef ref) {
    final trackingNotifier = ref.read(trackingNotifierProvider.notifier);
    trackingNotifier.stopTrackingAndAddWorklog();
  }

  void startTracking(riverpod.WidgetRef ref, String text) {
    final tracking = ref.read(trackingNotifierProvider.notifier);
    tracking.changeIssue(text);
    tracking.startTime();
  }

  onTrackerSubmitted(String value, riverpod.WidgetRef ref) {
    final tracking = ref.read(trackingNotifierProvider.notifier);
    tracking.changeIssue(value);
    tracking.startTime();
  }
}
