import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:worklog_assistant/model/jira_model.dart';
import 'package:worklog_assistant/widgets/page.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:worklog_assistant/widgets/jiratable.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with PageMixin {
  bool selected = true;
  String? comboboxValue;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));

    return ScaffoldPage(
        header: PageHeader(
          title: const Text('Worklog Assistant'),
          commandBar: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Consumer<JiraModel>(builder: (context, jiraModel, child) {
              return FilledButton(
                onPressed: () => uploadWorklogs(jiraModel),
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
        content: material.Material(child: JiraTable())
        // first the header - this will be a table layout with a first row that has a checkbox, then the id, the name and the time spent
        );
  }

  uploadWorklogs(JiraModel jiraModel) async {
    Future<http.Response> submitWorklogs(String jiraId, double timeLogged) {
      var url =
          'http://localhost:8080/rest/api/2/issue/$jiraId/worklog?adjustEstimate=leave';

      return http.post(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Bearer MDQ4NzY1MTQ4NDk1OrroeeMOMVWzFE/TwUSGnuDPT2bb',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "comment": "Did it",
          "created": "2024-09-01T16:31:29.042+0000",
          "updated": "2024-09-01T16:31:29.042+0000",
          "started": "2024-09-01T16:31:00.000+0000",
          "timeSpentSeconds": 3600
        }),
      );
    }

    for (var worklog in jiraModel.items) {
      jiraModel.markAs(worklog.jiraId, WorklogStatus.submitting);
      var result = await submitWorklogs(worklog.jiraId, worklog.timeLogged);

      if (result.statusCode != 201) {
        jiraModel.markAs(worklog.jiraId, WorklogStatus.error);
        print('Error submitting worklog');
        continue;
      } else {
        jiraModel.markAs(worklog.jiraId, WorklogStatus.submitted);
        print('Submitted Worklog');
      }
    }
  }
}
