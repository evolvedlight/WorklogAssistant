import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  String _jiraUrl = "";
  String get jiraUrl => _jiraUrl;

  SettingsProvider() {
    loadSettings();
  }

  Future loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _jiraUrl = prefs.getString("jiraUrl") ?? "";
    _jiraPat = prefs.getString("jiraPat") ?? "";
    notifyListeners();
  }

  updateJiraUrl(String url) async {
    _jiraUrl = url;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("jiraUrl", url);

    notifyListeners();
  }

  String _jiraPat = "";
  String get jiraPat => _jiraPat;

  updateJiraPat(String pat) async {
    _jiraPat = pat;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("jiraPat", pat);

    notifyListeners();
  }
}
