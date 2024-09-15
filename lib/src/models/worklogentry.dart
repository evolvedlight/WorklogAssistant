import 'enums/worklogstatus.dart';

class WorklogEntry {
  WorklogEntry(
    this.jiraId,
    this.timeLogged,
    this.status,
  );

  String jiraId;
  Duration timeLogged;
  DateTime startTime = DateTime.now().toUtc();
  int? id;
  WorklogStatus status;
  bool selected = false;
}
