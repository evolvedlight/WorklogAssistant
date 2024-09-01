import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:worklog_assistant/model/tracking_model.dart';
import 'package:worklog_assistant/widgets/page.dart';

import '../model/jira_model.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> with PageMixin {
  final issueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return ScaffoldPage(
        header: PageHeader(
          title: const Text('Live Work Tracker'),
        ),
        content: Padding(
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
                    Consumer<TrackingModel>(
                        builder: (context, trackingContext, child) => Expanded(
                            child:
                                Text(trackingContext.secondsTimed.toString()))),
                    Consumer<TrackingModel>(
                      builder: (context, trackingContext, child) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: trackingContext.state == TrackingState.started
                            ? Button(
                                onPressed: stopTracking,
                                style: ButtonStyle(
                                  textStyle: WidgetStatePropertyAll(TextStyle(
                                      color: theme.accentColor, fontSize: 24)),
                                ),
                                child: Text("Stop"))
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
              ]),
            ),
          ),
        )
        // first the header - this will be a table layout with a first row that has a checkbox, then the id, the name and the time spent
        );
  }

  changeIssue(String value) {
    Provider.of<TrackingModel>(context, listen: false).currentIssue = value;
    Provider.of<TrackingModel>(context, listen: false).startTime();
    print(value);
  }

  void stopTracking() {
    var trackingModel = Provider.of<TrackingModel>(context, listen: false);
    trackingModel.stopTime();
    var currentTime = trackingModel.secondsTimed;
    var jiraModel = Provider.of<JiraModel>(context, listen: false);
    var currentIssue = trackingModel.currentIssue;
    jiraModel.add(WorklogEntry(
        currentIssue, currentTime.toDouble(), WorklogStatus.pending));
  }

  void startTracking() {
    var trackingModel = Provider.of<TrackingModel>(context, listen: false);
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
