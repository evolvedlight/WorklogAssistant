import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:worklog_assistant/src/providers/settings.dart';

import '../models/enums/worklogstatus.dart';
import '../models/worklogentry.dart';
import '../providers/jira_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

class JiraTable extends riverpod.ConsumerStatefulWidget {
  const JiraTable({super.key});

  @override
  JiraTableState createState() => JiraTableState();
}

class JiraTableState extends riverpod.ConsumerState<JiraTable> {
  bool _sortAscending = true;
  int? _sortColumnIndex;
  late WorklogDataSource _worklogEntriesDataSource;
  bool _initialized = false;
  final ScrollController _controller = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _worklogEntriesDataSource = WorklogDataSource(ref);
      _initialized = true;
      _worklogEntriesDataSource.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _worklogEntriesDataSource.dispose();
    _controller.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appThemeMode = ref.watch(currentThemeModeProvider);
    final jiraModel = ref.watch(jiraProvider);

    return fluent.Column(children: [
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
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(children: [
              Theme(
                  // These makes scroll bars almost always visible. If horizontal scroll bar
                  // is displayed then vertical migh be hidden as it will go out of viewport
                  data: appThemeMode == ThemeMode.dark ? ThemeData.dark() : ThemeData.light(),
                  child: DataTable2(
                      scrollController: _controller,
                      horizontalScrollController: _horizontalController,
                      columnSpacing: 4,
                      horizontalMargin: 12,
                      bottomMargin: 10,
                      dividerThickness: 0.2,
                      minWidth: 600,
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _sortAscending,
                      empty: Center(
                          child: Container(
                              padding: const EdgeInsets.all(20),
                              color: const fluent.Color.fromARGB(255, 155, 135, 135),
                              child: const Text('Nothing yet tracked'))),
                      onSelectAll: (val) => setState(() => _worklogEntriesDataSource.selectAll(val)),
                      columns: [
                        DataColumn2(
                          label: const Text('Jira ID'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: const Text('Jira Summary'),
                          size: ColumnSize.M,
                          numeric: false,
                        ),
                        DataColumn2(
                          label: const Text('Time Logged'),
                          size: ColumnSize.S,
                          numeric: false,
                        ),
                        DataColumn2(
                          label: const Text('Status'),
                          size: ColumnSize.S,
                          numeric: false,
                        ),
                      ],
                      rows: List<DataRow>.generate(jiraModel.items.length, (index) => _worklogEntriesDataSource.getRow(index)))),
            ])),
      ),
    ]);
  }

  void deleteSelected() {
    var jiraModel = ref.watch(jiraProvider);
    jiraModel.deletedSelected();
  }

  void createManualWorklog() {
    var jiraModel = ref.watch(jiraProvider);
    jiraModel.add(WorklogEntry("New", Duration(), WorklogStatus.pending));
  }
}

class RestorableWorklogEntrySelections extends RestorableProperty<Set<int>> {
  Set<int> _worklogEntrySelections = {};

  bool isSelected(int index) => _worklogEntrySelections.contains(index);

  /// Takes a list of [WorklogEntry]s and saves the row indices of selected rows
  /// into a [Set].
  void setWorklogEntrySelections(List<WorklogEntry> worklogEntries) {
    final updatedSet = <int>{};
    for (var i = 0; i < worklogEntries.length; i += 1) {
      var worklogEntry = worklogEntries[i];
      if (worklogEntry.selected) {
        updatedSet.add(i);
      }
    }
    _worklogEntrySelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _worklogEntrySelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _worklogEntrySelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _worklogEntrySelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _worklogEntrySelections = value;
  }

  @override
  Object toPrimitives() => _worklogEntrySelections.toList();
}

/// Domain model entity
class WorklogDataSource extends DataTableSource {
  WorklogDataSource.empty(this.ref) {
    ref.watch(jiraProvider).removeAll();
  }

  WorklogDataSource(this.ref, [sortedByTimeLogged = false, this.hasRowTaps = false, this.hasRowHeightOverrides = false, this.hasZebraStripes = false]) {
    worklogEntries = ref.watch(jiraProvider).items;
    if (sortedByTimeLogged) {
      sort((d) => d.timeLogged, true);
    }
  }

  final riverpod.WidgetRef ref;
  late List<WorklogEntry> worklogEntries;
  // Add row tap handlers and show snackbar
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;

  void sort<T>(Comparable<T> Function(WorklogEntry d) getField, bool ascending) {
    worklogEntries.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  void updateSelectedWorklogs(RestorableWorklogEntrySelections selectedRows) {
    _selectedCount = 0;
    for (var i = 0; i < worklogEntries.length; i += 1) {
      var worklogEntry = worklogEntries[i];
      if (selectedRows.isSelected(i)) {
        worklogEntry.selected = true;
        _selectedCount += 1;
      } else {
        worklogEntry.selected = false;
      }
    }
    notifyListeners();
  }

  @override
  DataRow2 getRow(int index, [Color? color]) {
    assert(index >= 0);
    if (index >= worklogEntries.length) throw 'index > _worklogEntries.length';
    final worklogEntry = worklogEntries[index];
    return DataRow2.byIndex(
        index: index,
        selected: worklogEntry.selected,
        color: WidgetStateProperty.all(color),
        onSelectChanged: (value) {
          if (worklogEntry.selected != value) {
            _selectedCount += value! ? 1 : -1;
            assert(_selectedCount >= 0);
            worklogEntry.selected = value;
            notifyListeners();
          }
        },
        // specificRowHeight:
        // hasRowHeightOverrides && worklogEntry.fat >= 25 ? 100 : null,
        cells: [
          DataCell(
              TextFormField(
                  initialValue: worklogEntry.jiraId.toString(),
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (val) {
                    print('onSubmited jiraId ${worklogEntry.jiraId} $val');
                  }),
              showEditIcon: true),
          DataCell(Text(worklogEntry.jiraId)),
          // DataCell(
          //     fluent.NumberBox(
          //         value: worklogEntry.timeLogged,
          //         onChanged: (value) => updateValue(value)),
          //     showEditIcon: true),
          DataCell(
              TextFormField(
                  initialValue: worklogEntry.timeLogged.toString(),
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (val) {
                    print('onSubmited ${worklogEntry.jiraId} $val');
                  }),
              showEditIcon: true),
          DataCell(Text(convertWorklogToNiceString(worklogEntry.status))),
        ]);
  }

  @override
  int get rowCount => worklogEntries.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void selectAll(bool? checked) {
    for (final worklogEntry in worklogEntries) {
      worklogEntry.selected = checked ?? false;
    }
    _selectedCount = (checked ?? false) ? worklogEntries.length : 0;
    notifyListeners();
  }

  updateValue(double? value) {}

  convertWorklogToNiceString(WorklogStatus status) {
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

int _selectedCount = 0;

/// Define list of CommandBarItem
