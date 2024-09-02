class JiraDbModel {
  final int? id;
  final String jiraId;
  final Duration timeSpent;
  final DateTime startTime;

  JiraDbModel({
    this.id,
    required this.jiraId,
    required this.timeSpent,
    required this.startTime,
  });

  factory JiraDbModel.fromJson(Map<String, dynamic> json) {
    return JiraDbModel(
      id: json['id'],
      jiraId: json['jiraId'],
      timeSpent: Duration(seconds: json['timeSpent']),
      startTime: DateTime.parse(json['startTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jiraId': jiraId,
      'timeSpent': timeSpent.inSeconds,
      'startTime': startTime.toIso8601String(),
    };
  }
}
