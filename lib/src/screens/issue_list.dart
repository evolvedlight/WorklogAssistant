import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worklog_assistant/src/models/jiraapi/issue.dart';
import 'package:worklog_assistant/src/providers/jiraapi_provider.dart';
import 'package:worklog_assistant/src/providers/search_text_provider.dart';

class IssueListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var query = ref.watch(searchTextProvider);
    AsyncValue<List<IssuePicker>> issues = ref.watch(
      // The provider is now a function expecting the activity type.
      // Let's pass a constant string for now, for the sake of simplicity.
      issuesAutocompleteProvider(query),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Issue List $query'),
      ),
      body: ListView.builder(
        itemCount: issues.valueOrNull?.length ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(issues.value![index].summaryText ?? 'No summary'),
          );
        },
      ),
    );
  }
}
