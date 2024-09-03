import 'package:flutter/material.dart';

import 'settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late String _jiraUrl;

  // Allow Widgets to read the user's preferred ThemeMode.
  String get jiraUrl => _jiraUrl;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _jiraUrl = await _settingsService.jiraUrl();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateJiraUrl(String? newJiraUrl) async {
    if (newJiraUrl == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newJiraUrl == _jiraUrl) return;

    // Otherwise, store the new ThemeMode in memory
    _jiraUrl = newJiraUrl;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateJiraUrl(newJiraUrl);
  }
}
