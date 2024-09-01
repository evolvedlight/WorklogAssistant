import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/jira_model.dart';

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// The file was extracted from GitHub: https://github.com/flutter/gallery
// Changes and modifications by Maxim Saplin, 2021

class DataTable2ScrollupDemo extends StatefulWidget {
  const DataTable2ScrollupDemo({super.key});

  @override
  DataTable2ScrollupDemoState createState() => DataTable2ScrollupDemoState();
}

class DataTable2ScrollupDemoState extends State<DataTable2ScrollupDemo> {
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
      _worklogEntriesDataSource = WorklogDataSource(context);
      _initialized = true;
      _worklogEntriesDataSource.addListener(() {
        setState(() {});
      });
    }
  }

  void _sort<T>(
    Comparable<T> Function(WorklogEntry d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _worklogEntriesDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
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
    return Consumer<JiraModel>(builder: (context, jiraModel, child) {
      return Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(children: [
            Theme(
                // These makes scroll bars almost always visible. If horizontal scroll bar
                // is displayed then vertical migh be hidden as it will go out of viewport
                data: ThemeData(
                    scrollbarTheme: ScrollbarThemeData(
                        thumbVisibility: WidgetStateProperty.all(true),
                        thumbColor:
                            WidgetStateProperty.all<Color>(Colors.black))),
                child: DataTable2(
                    scrollController: _controller,
                    horizontalScrollController: _horizontalController,
                    columnSpacing: 0,
                    horizontalMargin: 12,
                    bottomMargin: 10,
                    dividerThickness: 0.2,
                    minWidth: 600,
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    onSelectAll: (val) => setState(
                        () => _worklogEntriesDataSource.selectAll(val)),
                    columns: [
                      DataColumn2(
                        label: const Text('Jira ID'),
                        size: ColumnSize.S,
                        onSort: (columnIndex, ascending) => _sort<String>(
                            (d) => d.jiraId, columnIndex, ascending),
                      ),
                      DataColumn2(
                        label: const Text('Summary'),
                        size: ColumnSize.S,
                        numeric: true,
                        onSort: (columnIndex, ascending) => _sort<String>(
                            (d) => d.summary, columnIndex, ascending),
                      ),
                      DataColumn2(
                        label: const Text('Time Logged'),
                        size: ColumnSize.S,
                        numeric: true,
                        onSort: (columnIndex, ascending) => _sort<num>(
                            (d) => d.timeLogged, columnIndex, ascending),
                      ),
                    ],
                    rows: List<DataRow>.generate(jiraModel.items.length,
                        (index) => _worklogEntriesDataSource.getRow(index)))),
          ]));
    });
  }
}

class _ScrollXYButton extends StatefulWidget {
  const _ScrollXYButton(this.controller, this.title);

  final ScrollController controller;
  final String title;

  @override
  _ScrollXYButtonState createState() => _ScrollXYButtonState();
}

class _ScrollXYButtonState extends State<_ScrollXYButton> {
  bool _showScrollXY = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (widget.controller.position.pixels > 20 && !_showScrollXY) {
        setState(() {
          _showScrollXY = true;
        });
      } else if (widget.controller.position.pixels < 20 && _showScrollXY) {
        setState(() {
          _showScrollXY = false;
        });
      }
      // On GitHub there was a question on how to determine the event
      // of widget being scrolled to the bottom. Here's the sample
      // if (widget.controller.position.hasViewportDimension &&
      //     widget.controller.position.pixels >=
      //         widget.controller.position.maxScrollExtent - 0.01) {
      //   print('Scrolled to bottom');
      //}
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showScrollXY
        ? OutlinedButton(
            onPressed: () => widget.controller.animateTo(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn),
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.grey[800]),
                foregroundColor: WidgetStateProperty.all(Colors.white)),
            child: Text(widget.title),
          )
        : const SizedBox();
  }
}

class RestorableDessertSelections extends RestorableProperty<Set<int>> {
  Set<int> _worklogEntrySelections = {};

  /// Returns whether or not a dessert row is selected by index.
  bool isSelected(int index) => _worklogEntrySelections.contains(index);

  /// Takes a list of [Dessert]s and saves the row indices of selected rows
  /// into a [Set].
  void setDessertSelections(List<WorklogEntry> worklogEntries) {
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

int _idCounter = 0;

/// Domain model entity

/// Data source implementing standard Flutter's DataTableSource abstract class
/// which is part of DataTable and PaginatedDataTable synchronous data fecthin API.
/// This class uses static collection of deserts as a data store, projects it into
/// DataRows, keeps track of selected items, provides sprting capability
class WorklogDataSource extends DataTableSource {
  WorklogDataSource.empty(this.context) {
    context.read<JiraModel>().removeAll();
  }

  WorklogDataSource(this.context,
      [sortedByTimeLogged = false,
      this.hasRowTaps = false,
      this.hasRowHeightOverrides = false,
      this.hasZebraStripes = false]) {
    worklogEntries = context.watch<JiraModel>().items;
    if (sortedByTimeLogged) {
      sort((d) => d.timeLogged, true);
    }
  }

  final BuildContext context;
  late List<WorklogEntry> worklogEntries;
  // Add row tap handlers and show snackbar
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;

  void sort<T>(
      Comparable<T> Function(WorklogEntry d) getField, bool ascending) {
    worklogEntries.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  void updateSelectedDesserts(RestorableDessertSelections selectedRows) {
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
    final format = NumberFormat.decimalPercentPattern(
      locale: 'en',
      decimalDigits: 0,
    );
    assert(index >= 0);
    if (index >= worklogEntries.length) throw 'index > _worklogEntries.length';
    final worklogEntry = worklogEntries[index];
    return DataRow2.byIndex(
      index: index,
      selected: worklogEntry.selected,
      color: color != null
          ? WidgetStateProperty.all(color)
          : (hasZebraStripes && index.isEven
              ? WidgetStateProperty.all(Theme.of(context).highlightColor)
              : null),
      onSelectChanged: (value) {
        if (worklogEntry.selected != value) {
          _selectedCount += value! ? 1 : -1;
          assert(_selectedCount >= 0);
          worklogEntry.selected = value;
          notifyListeners();
        }
      },
      onTap: hasRowTaps
          ? () =>
              _showSnackbar(context, 'Tapped on row ${worklogEntry.summary}')
          : null,
      onDoubleTap: hasRowTaps
          ? () => _showSnackbar(
              context, 'Double Tapped on row ${worklogEntry.summary}')
          : null,
      onLongPress: hasRowTaps
          ? () => _showSnackbar(
              context, 'Long pressed on row ${worklogEntry.summary}')
          : null,
      onSecondaryTap: hasRowTaps
          ? () => _showSnackbar(
              context, 'Right clicked on row ${worklogEntry.summary}')
          : null,
      onSecondaryTapDown: hasRowTaps
          ? (d) => _showSnackbar(
              context, 'Right button down on row ${worklogEntry.summary}')
          : null,
      // specificRowHeight:
      // hasRowHeightOverrides && worklogEntry.fat >= 25 ? 100 : null,
      cells: [
        DataCell(Text(worklogEntry.jiraId)),
        DataCell(Text(worklogEntry.summary)),
        DataCell(Text('${worklogEntry.timeLogged}'),
            onTap: () => _showSnackbar(
                context,
                'Tapped on a cell with "${worklogEntry.timeLogged}"',
                Colors.red)),
      ],
    );
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
}

int _selectedCount = 0;

_showSnackbar(BuildContext context, String text, [Color? color]) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: color,
    duration: const Duration(seconds: 1),
    content: Text(text),
  ));
}
