import 'package:fluent_ui/fluent_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worklog_assistant/src/models/jiraapi/jira_filter.dart';
import 'package:worklog_assistant/src/providers/jiraapi_provider.dart';

import '../storage/prefs.dart';

part 'settings.g.dart';

/// The current theme mode of the app.
///
/// When this provider is first read, it will read the saved value from storage,
/// and defaults to [ThemeMode.system] if the theme mode has not been set before.
@riverpod
class CurrentThemeMode extends _$CurrentThemeMode {
  @override
  ThemeMode build() {
    final prefs = ref.watch(prefsProvider).requireValue;

    // Load the saved theme mode setting from shared preferences.
    final themeModeName = prefs.getString('themeMode');

    // Return [ThemeMode] based on the saved setting, or [ThemeMode.system]
    // if there's no saved setting yet.
    return ThemeMode.values.singleWhere(
      (themeMode) => themeMode.name == themeModeName,
      orElse: () => ThemeMode.system,
    );
  }

  void set(ThemeMode themeMode) {
    final prefs = ref.read(prefsProvider).requireValue;

    // Save the new theme mode to shared preferences.
    prefs.setString('themeMode', themeMode.name);

    ref.invalidateSelf();
  }
}

@riverpod
class CurrentJiraFilter extends _$CurrentJiraFilter {
  @override
  JiraFilter? build() {
    final prefs = ref.watch(prefsProvider).requireValue;

    // Load the saved theme mode setting from shared preferences.
    final jiraFilterId = prefs.getInt('currentJiraFilterId');

    if (jiraFilterId == null) {
      return null;
    }
    AsyncValue<JiraFilter> filter = ref.watch(
      filterProvider(jiraFilterId),
    );

    return filter.valueOrNull;
  }

  void set(int jiraFilterId) {
    final prefs = ref.read(prefsProvider).requireValue;

    // Save the new theme mode to shared preferences.
    prefs.setInt('currentJiraFilterId', jiraFilterId);

    ref.invalidateSelf();
  }
}
