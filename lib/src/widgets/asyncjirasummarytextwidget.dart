import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worklog_assistant/src/providers/jiraapi_provider.dart';

final jiraSummaryProvider = FutureProvider<String>((ref) async {
  // Replace with your actual async logic to fetch Jira summary
  await Future.delayed(Duration(seconds: 2));
  return 'Jira Summary: Task completed successfully.';
});

class AsyncJiraSummaryTextWidget extends ConsumerWidget {
  final String jiraId;

  AsyncJiraSummaryTextWidget(this.jiraId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncJiraSummary = ref.watch(issueProvider(jiraId));

    return asyncJiraSummary.when(
      data: (summary) => Text(summary?.summary == null ? '' : '${summary?.summary}'),
      loading: () => ProgressRing(),
      error: (error, stack) => Text(''),
    );
  }
}
