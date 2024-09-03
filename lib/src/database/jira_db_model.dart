import '../models/enums/worklogstatus.dart';

class JiraDbModel {
  final int? id;
  final String jiraId;
  final Duration timeSpent;
  final DateTime startTime;
  final WorklogStatus worklogStatus;

  JiraDbModel({
    this.id,
    required this.jiraId,
    required this.timeSpent,
    required this.startTime,
    required this.worklogStatus,
  });

  factory JiraDbModel.fromJson(Map<String, dynamic> json) {
    return JiraDbModel(
      id: json['id'],
      jiraId: json['jiraId'],
      timeSpent: Duration(seconds: json['timeSpent']),
      startTime: DateTime.parse(json['startTime']),
      worklogStatus: WorklogStatus.values[json['worklogStatus']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jiraId': jiraId,
      'timeSpent': timeSpent.inSeconds,
      'startTime': startTime.toIso8601String(),
      'worklogStatus': worklogStatus.index,
    };
  }
}
