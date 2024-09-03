import 'package:fluent_ui/fluent_ui.dart';
import 'package:worklog_assistant/src/widgets/page.dart';

import '../widgets/tracker.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> with PageMixin {
  final issueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: const Text('Live Work Tracker'),
      ),
      content: Tracker(),
      // first the header - this will be a table layout with a first row that has a checkbox, then the id, the name and the time spent
    );
  }
}
