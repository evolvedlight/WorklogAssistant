import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worklog_assistant/src/services/database_helper.dart';

import '../database/jira_db_model.dart';
import '../models/enums/worklogstatus.dart';
import '../models/worklogentry.dart';

part 'jira_provider.g.dart';

@riverpod
class JiraNotifier extends _$JiraNotifier {
  @override
  Future<List<WorklogEntry>> build() async {
    return await fetchAndSetWorklogEntries();
  }

  Future<List<WorklogEntry>> fetchAndSetWorklogEntries() async {
    print("getting from the database");
    var data = await DatabaseHelper.getJiras();
    var items = data.map((e) => WorklogEntry(e.jiraId, e.timeSpent, e.startTime, e.worklogStatus)..id = e.id).toList();
    print("got from the database");
    return items;
  }

  double get totalLoggedTime {
    return state.maybeWhen(
      data: (items) => items.fold(0.0, (total, current) => total + current.timeLogged.inSeconds),
      orElse: () => 0.0,
    );
  }

  double get totalUnsubmittedTime {
    return state.maybeWhen(
      data: (items) => items.where((item) => item.status != WorklogStatus.submitted).fold(0.0, (total, current) => total + current.timeLogged.inSeconds),
      orElse: () => 0.0,
    );
  }

  Future<void> add(WorklogEntry item) async {
    print("adding item");
    var id = await DatabaseHelper.insertJira(JiraDbModel(
      jiraId: item.jiraId,
      timeSpent: item.timeLogged,
      startTime: DateTime.now(),
      worklogStatus: item.status,
    ));
    await fetchAndSetWorklogEntries(); // Refresh the state after adding
    ref.invalidateSelf(); // Invalidate to trigger a rebuild
  }

  Future<void> updateJira(int id, WorklogEntry item) async {
    print("updating item");
    state = state.whenData((items) {
      var updatedItems = List<WorklogEntry>.from(items);
      var entryIndex = updatedItems.indexWhere((element) => element.id == id);
      if (entryIndex != -1) {
        updatedItems[entryIndex] = item;
      }
      return updatedItems;
    });

    await DatabaseHelper.updateJira(JiraDbModel(
      id: item.id!,
      jiraId: item.jiraId,
      timeSpent: item.timeLogged,
      startTime: item.startTime,
      worklogStatus: item.status,
    ));
    ref.invalidateSelf();
  }

  Future<void> delete(int id) async {
    state = state.whenData((items) {
      var updatedItems = items.where((item) => item.id != id).toList();
      return updatedItems;
    });

    await DatabaseHelper.deleteJira(id);
    ref.invalidateSelf();
  }

  WorklogEntry? get(int id) {
    return state.maybeWhen(
      data: (items) => items.firstWhere((element) => element.id == id),
      orElse: () => null,
    );
  }

  Future<void> markAs(int id, WorklogStatus status) async {
    state = state.whenData((items) {
      var updatedItems = List<WorklogEntry>.from(items);
      var itemIndex = updatedItems.indexWhere((item) => item.id == id);
      if (itemIndex != -1) {
        updatedItems[itemIndex] = updatedItems[itemIndex].copyWith(status: status);
      }
      return updatedItems;
    });

    var item = state.value?.firstWhere((item) => item.id == id);
    if (item != null) {
      await DatabaseHelper.updateJira(JiraDbModel(
        id: item.id!,
        jiraId: item.jiraId,
        timeSpent: item.timeLogged,
        startTime: item.startTime,
        worklogStatus: item.status,
      ));
    }
    ref.invalidateSelf();
  }
}
