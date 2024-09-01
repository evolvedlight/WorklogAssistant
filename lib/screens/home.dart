import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:worklog_assistant/model/jira_model.dart';
import 'package:worklog_assistant/widgets/page.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:worklog_assistant/widgets/tableexample.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with PageMixin {
  bool selected = true;
  String? comboboxValue;

  List<WorklogEntry> getworklogEntries() {
    return [
      WorklogEntry('James', 'Project Lead', 20000),
      WorklogEntry('Kathryn', 'Manager', 30000),
      WorklogEntry('Lara', 'Developer', 15000),
      WorklogEntry('Michael', 'Designer', 15000),
      WorklogEntry('Martin', 'Developer', 15000),
      WorklogEntry('Newberry', 'Developer', 15000),
      WorklogEntry('Balnc', 'Developer', 15000),
      WorklogEntry('Perry', 'Developer', 15000),
      WorklogEntry('Gable', 'Developer', 15000),
      WorklogEntry('Grimes', 'Developer', 15000)
    ];
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    final theme = FluentTheme.of(context);

    List<WorklogEntry> worklogEntries = <WorklogEntry>[];
    worklogEntries = getworklogEntries();

    return ScaffoldPage(
        header: PageHeader(
          title: const Text('Worklog Assistant'),
          commandBar: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Consumer<JiraModel>(builder: (context, jiraModel, child) {
              return FilledButton(
                onPressed: () => onPressed(jiraModel),
                child: Row(
                  children: [
                    Icon(FluentIcons.cloud_upload),
                    SizedBox(width: 8.0),
                    Text("Submit Worklogs (${jiraModel.totalLoggedTime})")
                  ],
                ),
              );
            })
          ]),
        ),
        content: material.Material(child: DataTable2ScrollupDemo())
        // first the header - this will be a table layout with a first row that has a checkbox, then the id, the name and the time spent
        );
  }

  void onPressed(JiraModel jiraModel) {
    // write to console
    jiraModel.add(WorklogEntry('TEST-3', 'Project Lead', 120));
    print('Submit Worklogs');
  }
}
