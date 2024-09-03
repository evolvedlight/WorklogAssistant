import 'enums/worklogstatus.dart';

class WorklogEntry {
  WorklogEntry(
    this.jiraId,
    this.timeLogged,
    this.status,
  );

  final String jiraId;
  final Duration timeLogged;
  int? id;
  WorklogStatus status;
  bool selected = false;
}
