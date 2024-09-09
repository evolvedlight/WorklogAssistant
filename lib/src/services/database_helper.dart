import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:worklog_assistant/src/database/jira_db_model.dart';

class DatabaseHelper {
  static const int _databaseVersion = 1;

  static const String _databaseName = "worklogassistant.db";

  static const String _jiraTable = "jira";

  static String dbPath = "";

  static Future<Database> _getDB() async {
    dbPath = join(await getDatabasesPath(), _databaseName);

    print("DB Path: $dbPath");

    return openDatabase(
      dbPath,
      onCreate: (db, version) =>
          {db.execute("CREATE TABLE $_jiraTable(id INTEGER PRIMARY KEY, jiraId TEXT, timeSpent INTEGER, startTime DATETIME, worklogStatus int);")},
      version: _databaseVersion,
    );
  }

  static Future<int> insertJira(JiraDbModel jira) async {
    final db = await _getDB();
    return await db.insert(_jiraTable, jira.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateJira(JiraDbModel jira) async {
    final db = await _getDB();
    return await db.update(_jiraTable, jira.toJson(), where: 'id = ?', whereArgs: [jira.id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteJira(int id) async {
    final db = await _getDB();
    return await db.delete(_jiraTable, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<JiraDbModel>> getJiras() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(_jiraTable);
    return List.generate(maps.length, (i) {
      return JiraDbModel.fromJson(maps[i]);
    });
  }

  static void deleteAllJiras() async {
    final db = await _getDB();
    db.execute("DELETE FROM $_jiraTable");
  }

  static String getDbPath() {
    return dbPath;
  }
}
