import 'enums/worklogstatus.dart';

class WorklogEntry {
  WorklogEntry(
    this.jiraId,
    this.timeLogged,
    this.startTime,
    this.status,
  );

  String jiraId;
  Duration timeLogged;
  DateTime startTime;
  int? id;
  WorklogStatus status;
  bool selected = false;

  // getter and setter for timelogged that can convert with things like "1h 30m" and "1h" and "30m" and "1h 30m 15s"
  String get timeLoggedString {
    return formatForJiraTime(timeLogged);
  }

  static String formatForJiraTime(Duration duration) {
    var builder = StringBuffer();
    if (duration.inHours > 0) {
      builder.write("${duration.inHours}h ");
    }
    if (duration.inMinutes % 60 != 0) {
      builder.write("${duration.inMinutes % 60}m ");
    }
    if (duration.inSeconds % 60 != 0) {
      builder.write("${duration.inSeconds % 60}s");
    }
    return builder.toString();
  }

  //setter
  set timeLoggedString(String value) {
    timeLogged = tryParseJiraWorklogUpdate(value);
  }

  Duration tryParseJiraWorklogUpdate(String value) {
    var parts = value.split(" ");
    Duration result = Duration();
    for (var part in parts) {
      if (part.endsWith("h")) {
        result += Duration(hours: int.parse(part.substring(0, part.length - 1)));
      } else if (part.endsWith("m")) {
        result += Duration(minutes: int.parse(part.substring(0, part.length - 1)));
      } else if (part.endsWith("s")) {
        result += Duration(seconds: int.parse(part.substring(0, part.length - 1)));
      }
    }
    return result;
  }
}
