import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../models/enums/worklogstatus.dart';
import '../models/worklogentry.dart';
import '../providers/jira_provider.dart';
import '../providers/tracking_provider.dart';

class Tracker extends StatefulWidget {
  const Tracker({super.key});

  @override
  State<Tracker> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<Tracker> {
  final issueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

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
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: SizedBox(
                          width: double.infinity,
                          child: TextBox(
                            placeholder: 'Issue Key',
                            expands: false,
                            style: TextStyle(fontSize: 24),
                            onSubmitted: (value) => changeIssue(value),
                            controller: issueController,
                          ),
                        ),
                      ),
                    )),
                    Consumer<TrackingProvider>(
                        builder: (context, trackingContext, child) => Expanded(
                            child: Text(
                                formatTime(trackingContext.secondsTimed),
                                style: TextStyle(fontSize: 24)))),
                    Consumer<TrackingProvider>(
                      builder: (context, trackingContext, child) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: trackingContext.state == TrackingState.started
                            ? Button(
                                onPressed: stopTracking,
                                style: ButtonStyle(
                                  textStyle: WidgetStatePropertyAll(TextStyle(
                                      color: theme.accentColor, fontSize: 24)),
                                ),
                                child: Row(
                                  children: [
                                    Text("Stop"),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        width: 18,
                                        height: 18,
                                        child: ProgressRing(),
                                      ),
                                    )
                                  ],
                                ))
                            : Button(
                                onPressed: startTracking,
                                style: ButtonStyle(
                                  textStyle: WidgetStatePropertyAll(TextStyle(
                                      color: theme.accentColor, fontSize: 24)),
                                ),
                                child: Text("Start")),
                      ),
                    )
                  ],
                )),
              ]), // first the header - this will be a table layout with a first row that has a checkbox, then the id, the name and the time spent
            )));
  }

  changeIssue(String value) {
    Provider.of<TrackingProvider>(context, listen: false).currentIssue = value;
    Provider.of<TrackingProvider>(context, listen: false).startTime();
    print(value);
  }

  String formatTime(int seconds) {
    var hours = seconds ~/ 3600;
    var minutes = (seconds % 3600) ~/ 60;
    var remainingSeconds = seconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  void stopTracking() {
    var trackingModel = Provider.of<TrackingProvider>(context, listen: false);
    trackingModel.stopTime();
    var currentTime = trackingModel.secondsTimed;
    var jiraModel = Provider.of<JiraProvider>(context, listen: false);
    var currentIssue = trackingModel.currentIssue;
    jiraModel.add(WorklogEntry(
        currentIssue, Duration(seconds: currentTime), WorklogStatus.pending));
    trackingModel.resetTime();
  }

  void startTracking() {
    var trackingModel = Provider.of<TrackingProvider>(context, listen: false);
    trackingModel.currentIssue = issueController.text;
    trackingModel.startTime();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    issueController.dispose();
    super.dispose();
  }
}
