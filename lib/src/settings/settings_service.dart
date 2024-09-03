import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<String> jiraUrl() async =>
      (await SharedPreferences.getInstance()).getString('jiraUrl') ?? '';

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateJiraUrl(String jiraUrl) async {
    // get shared prefs and update
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jiraUrl', jiraUrl);
  }
}
