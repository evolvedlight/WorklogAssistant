import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class JiraModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<WorklogEntry> _items = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<WorklogEntry> get items => UnmodifiableListView(_items);

  /// The sum of all worklogs's time logged
  double get totalLoggedTime =>
      _items.fold(0.0, (total, current) => total + current.timeLogged);

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(WorklogEntry item) {
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}

class WorklogEntry {
  WorklogEntry(
    this.jiraId,
    this.summary,
    this.timeLogged,
  );

  final String jiraId;
  final String summary;
  final double timeLogged;
  bool selected = false;
}
