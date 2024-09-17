import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worklog_assistant/src/models/jiraapi/issue.dart';
import 'package:worklog_assistant/src/providers/jira_provider.dart';
import 'package:worklog_assistant/src/providers/jiraapi_provider.dart';
import 'package:worklog_assistant/src/providers/search_text_provider.dart';
import 'package:worklog_assistant/src/providers/settings.dart';
import 'package:worklog_assistant/src/providers/settings_provider.dart';
import 'package:worklog_assistant/src/providers/tracking_provider.dart';

import '../models/enums/worklogstatus.dart';
import '../models/worklogentry.dart';
import '../widgets/tracker.dart';

class FilterScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var filters = ref.watch(filtersAutocompleteProvider);
    var filterSelected = ref.watch(currentJiraFilterProvider);
    AsyncValue<List<Issue>> issues = ref.watch(
      // The provider is now a function expecting the activity type.
      // Let's pass a constant string for now, for the sake of simplicity.
      issuesForFilterProvider(filterSelected?.id),
    );

    return ScaffoldPage(
        header: PageHeader(
            title: const Text('Issue Search'),
            commandBar: filters.when(
                data: (list) => ComboboxFormField(
                      value: filterSelected?.id,
                      items: list.map((x) => ComboBoxItem(value: x.id, child: Text(x.name))).toList(),
                      onChanged: (value) => ref.read(currentJiraFilterProvider.notifier).set(value!),
                    ),
                error: (err, s) => Text("oh no"),
                loading: () => Text("loading"))),
        content: Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemCount: issues.valueOrNull?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("${issues.value![index].key}: ${issues.value![index].summary ?? 'No summary'}"),
                  cursor: SystemMouseCursors.click,
                  onPressed: () {
                    var tracking = ref.watch(trackingProvider);
                    var jira = ref.watch(jiraProvider);

                    tracking.stopTime();
                    var currentTime = tracking.secondsTimed;
                    var currentIssue = tracking.currentIssue;
                    jira.add(WorklogEntry(currentIssue, Duration(seconds: currentTime), WorklogStatus.pending));

                    tracking.resetTime();
                    tracking.currentIssue = issues.value![index].key;

                    print("Starting work on ${tracking.currentIssue} from button");

                    tracking.startTime();
                  },
                );
              },
            )),
            Tracker(),
          ],
        )
        // first the header - this will be a table layout with a first row that has a checkbox, then the id, the name and the time spent
        );
    // return Column(
    //   children: [
    //     Text('Issue List $query'),
    //     // Expanded(
    //     //     child: ListView.builder(
    //     //   itemCount: issues.valueOrNull?.length ?? 0,
    //     //   itemBuilder: (context, index) {
    //     //     return ListTile(
    //     //       title: Text("${issues.value![index].key}: ${issues.value![index].summaryText ?? 'No summary'}"),
    //     //       onTap: () {
    //     //         var tracking = ref.watch(trackingProvider);
    //     //         var jira = ref.watch(jiraProvider);

    //     //         tracking.stopTime();
    //     //         var currentTime = tracking.secondsTimed;
    //     //         var currentIssue = tracking.currentIssue;
    //     //         jira.add(WorklogEntry(currentIssue, Duration(seconds: currentTime), WorklogStatus.pending));

    //     //         tracking.resetTime();
    //     //         tracking.currentIssue = issues.value![index].key;

    //     //         print("Starting work on ${tracking.currentIssue} from button");

    //     //         tracking.startTime();
    //     //       },
    //     //     );
    //     //   },
    //     // ))
    //   ],
    // );
  }
}
