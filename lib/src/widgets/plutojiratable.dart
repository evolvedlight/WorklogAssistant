import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:worklog_assistant/src/providers/jira_provider.dart';
import 'package:worklog_assistant/src/widgets/asyncjirasummarytextwidget.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../models/enums/worklogstatus.dart';
import '../models/worklogentry.dart';

class PlutoJiraTable extends ConsumerStatefulWidget {
  const PlutoJiraTable({super.key});

  @override
  ConsumerState createState() => _PlutoGridExamplePageState();
}

class _PlutoGridExamplePageState extends ConsumerState<PlutoJiraTable> {
  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Jira Key',
      field: 'jiraId',
      type: PlutoColumnType.text(),
      enableRowChecked: true,
    ),
    PlutoColumn(
        title: 'Name',
        field: 'name',
        type: PlutoColumnType.text(),
        enableEditingMode: false,
        renderer: (rendererContext) {
          return AsyncJiraSummaryTextWidget(rendererContext.row.cells[rendererContext.column.field]!.value.toString());
        }),
    PlutoColumn(
      title: 'Started At',
      field: 'started_at',
      type: PlutoColumnType.text(),
      formatter: (value) => DateFormat('yyyy-MM-dd HH:mm:ss').format(value),
    ),
    PlutoColumn(
        title: 'Working time',
        field: 'working_time',
        type: PlutoColumnType.text(),
        formatter: (dynamic value) {
          return formatForJiraTime(value);
        }),
    PlutoColumn(
        title: 'Status',
        field: 'status',
        type: PlutoColumnType.text(),
        formatter: (dynamic value) {
          return convertWorklogToNiceString(value);
        }),
  ];

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    var theme = PlutoGridConfiguration.dark(
        style: PlutoGridStyleConfig.dark(
            borderColor: Color.fromARGB(0, 0, 0, 0), gridBackgroundColor: Color.fromARGB(0, 0, 0, 0), gridBorderColor: Color.fromARGB(0, 0, 0, 0)));

    var jira = ref.watch(jiraProvider);
    jira.addListener(() {
      stateManager.resetCurrentState();
      stateManager.removeAllRows();
      stateManager.appendRows(jira.items.map((item) {
        return PlutoRow(
          key: Key(item.id!.toString()),
          cells: {
            'jiraId': PlutoCell(value: item.jiraId),
            'name': PlutoCell(value: item.jiraId),
            'started_at': PlutoCell(value: item.startTime),
            'working_time': PlutoCell(value: item.timeLogged),
            'status': PlutoCell(value: item.status),
          },
        );
      }).toList());
    });

    return Column(
      children: [
        fluent.Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: fluent.CommandBar(
            overflowBehavior: fluent.CommandBarOverflowBehavior.noWrap,
            primaryItems: [
              fluent.CommandBarBuilderItem(
                builder: (context, mode, w) => Tooltip(
                  message: "Add worklog manually",
                  child: w,
                ),
                wrappedItem: fluent.CommandBarButton(
                  icon: const Icon(fluent.FluentIcons.add),
                  label: const Text('New'),
                  onPressed: createManualWorklog,
                ),
              ),
              fluent.CommandBarBuilderItem(
                builder: (context, mode, w) => Tooltip(
                  message: "Delete selected worklogs",
                  child: w,
                ),
                wrappedItem: fluent.CommandBarButton(
                  icon: const Icon(fluent.FluentIcons.delete),
                  label: const Text('Delete'),
                  onPressed: deleteSelected,
                ),
              ),
            ],
          ),
        ),
        fluent.Expanded(
            child: PlutoGrid(
          columns: columns,
          rows: [],
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManager = event.stateManager;
            stateManager.setSelectingMode(PlutoGridSelectingMode.row);
          },
          onChanged: (PlutoGridOnChangedEvent event) {
            var jira = ref.watch(jiraProvider);
            var jiraModel = jira.get(int.parse((event.row!.key as ValueKey<String>).value));
            if (jiraModel == null) {
              return;
            }
            switch (event.column.field) {
              case 'jiraId':
                jiraModel.jiraId = event.value.toString();
              case 'started_at':
                jiraModel.startTime = event.value as DateTime;
              case 'working_time':
                jiraModel.timeLogged = event.value as Duration;
            }
            jira.update(jiraModel.id!, jiraModel);
          },
          configuration: theme,
        )),
      ],
    );
  }

  static String formatForJiraTime(Duration duration) {
    if (duration.inSeconds < 60) {
      return "${duration.inSeconds}s";
    }
    if (duration.inMinutes < 60) {
      return "${duration.inMinutes}m";
    }
    return "${duration.inHours}h";
  }

  void createManualWorklog() {
    var jiraModel = ref.watch(jiraProvider);
    jiraModel.add(WorklogEntry("New", Duration(), WorklogStatus.pending));
  }

  void deleteSelected() {
    var selected = stateManager.checkedRows;
    var jira = ref.watch(jiraProvider);
    for (var element in selected) {
      jira.delete(int.parse((element.key as ValueKey<String>).value));
    }
  }

  static convertWorklogToNiceString(WorklogStatus status) {
    switch (status) {
      case WorklogStatus.pending:
        return "Pending";
      case WorklogStatus.submitted:
        return "Submitted";
      case WorklogStatus.submitting:
        return "Submitting..";
      case WorklogStatus.error:
        return "Failed";
      default:
        return "Unknown";
    }
  }
}
