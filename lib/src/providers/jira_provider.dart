import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:worklog_assistant/src/database/jira_db_model.dart';
import 'package:worklog_assistant/src/services/database_helper.dart';

import '../models/enums/worklogstatus.dart';
import '../models/worklogentry.dart';

class JiraProvider extends ChangeNotifier {
  late Future isInitCompleted;

  /// Internal, private state of the cart.
  final List<WorklogEntry> _items = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<WorklogEntry> get items => UnmodifiableListView(_items);

  JiraProvider() {
    isInitCompleted = fetchAndSetJiras();
  }

  Future fetchAndSetJiras() async {
    var data = await DatabaseHelper.getJiras();

    _items.addAll(data.map((e) =>
        WorklogEntry(e.jiraId, e.timeSpent, e.worklogStatus)..id = e.id));
    notifyListeners();
  }

  /// The sum of all worklogs's time logged
  double get totalLoggedTime => _items.fold(
      0.0, (total, current) => total + current.timeLogged.inSeconds);

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(WorklogEntry item) async {
    var id = await DatabaseHelper.insertJira(JiraDbModel(
        jiraId: item.jiraId,
        timeSpent: item.timeLogged,
        startTime: DateTime.now(),
        worklogStatus: item.status));
    item.id = id;
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void deletedSelected() {
    var selected = _items.where((element) => element.selected).toList();
    for (var element in selected) {
      _items.remove(element);
      if (element.id != null) {
        DatabaseHelper.deleteJira(element.id!);
      }
    }
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    DatabaseHelper.deleteAllJiras();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void markAs(int id, WorklogStatus status) {
    var item = _items.firstWhere((element) => element.id == id);
    item.status = status;
    DatabaseHelper.updateJira(JiraDbModel(
        id: item.id,
        jiraId: item.jiraId,
        timeSpent: item.timeLogged,
        startTime: DateTime.now(),
        worklogStatus: status));

    notifyListeners();
  }
}
