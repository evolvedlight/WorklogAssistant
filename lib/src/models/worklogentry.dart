import 'enums/worklogstatus.dart';

class WorklogEntry {
  WorklogEntry(
    this.jiraId,
    this.timeLogged,
    this.status,
  );

  final String jiraId;
  final Duration timeLogged;
  final DateTime startTime = DateTime.now().toUtc();
  int? id;
  WorklogStatus status;
  bool selected = false;
}
