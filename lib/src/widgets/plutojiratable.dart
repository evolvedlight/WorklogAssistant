import 'package:fluent_ui/fluent_ui.dart';
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
      // formatter: (dynamic value) {
      //   return formatForJiraTime(value);
      // }
    ),
    PlutoColumn(
        title: 'Status',
        field: 'status',
        type: PlutoColumnType.text(),
        enableAutoEditing: false,
        renderer: (rendererContext) => Text(convertWorklogToNiceString(rendererContext.row.cells[rendererContext.column.field]!.value)))
  ];

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    var theme = PlutoGridConfiguration.dark(
        style: PlutoGridStyleConfig.dark(
            borderColor: Color.fromARGB(0, 0, 0, 0), gridBackgroundColor: Color.fromARGB(0, 0, 0, 0), gridBorderColor: Color.fromARGB(0, 0, 0, 0)));

    var jiraState = ref.watch(jiraNotifierProvider);

    ref.listen(jiraNotifierProvider, (previous, current) {
      refreshTable(current.valueOrNull ?? []);
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
            print("Loaded");
            stateManager = event.stateManager;
            stateManager.setSelectingMode(PlutoGridSelectingMode.row);

            refreshTable(jiraState.valueOrNull ?? []);
          },
          onChanged: (PlutoGridOnChangedEvent event) {
            var jira = ref.watch(jiraNotifierProvider.notifier);
            var jiraModel = jira.get(int.parse((event.row.key as ValueKey<String>).value));
            if (jiraModel == null) {
              return;
            }
            switch (event.column.field) {
              case 'jiraId':
                jiraModel.jiraId = event.value.toString();
              case 'started_at':
                jiraModel.startTime = event.value as DateTime;
              case 'working_time':
                jiraModel.timeLogged = tryParseJiraWorklogUpdate(event.value);
            }
            var jiraN = ref.read(jiraNotifierProvider.notifier);

            jiraN.updateJira(jiraModel.id!, jiraModel);
          },
          configuration: theme,
        )),
      ],
    );
  }

  void createManualWorklog() {
    var jiraModel = ref.watch(jiraNotifierProvider.notifier);
    jiraModel.add(WorklogEntry("", Duration(), DateTime.now(), WorklogStatus.pending));
  }

  void deleteSelected() {
    var selected = stateManager.checkedRows;
    var jira = ref.watch(jiraNotifierProvider.notifier);
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

  // This function tries to understand things like "1h 30m" and "1h" and "30m" and "1h 30m 15s"
  Duration tryParseJiraWorklogUpdate(value) {
    var parts = value.toString().split(" ");
    var hours = 0;
    var minutes = 0;
    var seconds = 0;
    for (var part in parts) {
      if (part.contains("h")) {
        hours = int.parse(part.replaceAll("h", ""));
      }
      if (part.contains("m")) {
        minutes = int.parse(part.replaceAll("m", ""));
      }
      if (part.contains("s")) {
        seconds = int.parse(part.replaceAll("s", ""));
      }
    }
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  void refreshTable(List<WorklogEntry> worklogEntries) {
    stateManager.resetCurrentState();
    stateManager.removeAllRows();
    stateManager.appendRows(worklogEntries.map((item) {
      return PlutoRow(
        key: Key(item.id!.toString()),
        cells: {
          'jiraId': PlutoCell(value: item.jiraId),
          'name': PlutoCell(value: item.jiraId),
          'started_at': PlutoCell(value: item.startTime),
          'working_time': PlutoCell(value: item.timeLoggedString),
          'status': PlutoCell(value: item.status),
        },
      );
    }).toList());
  }
}
