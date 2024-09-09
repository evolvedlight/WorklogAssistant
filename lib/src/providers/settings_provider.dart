import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worklog_assistant/src/storage/prefs.dart';

part 'settings_provider.g.dart';

@riverpod
class JiraUrl extends _$JiraUrl {
  @override
  String? build() {
    final prefs = ref.watch(prefsProvider).requireValue;

    // Load the saved theme mode setting from shared preferences.
    final jiraUrl = prefs.getString('jiraUrl');

    // Return [ThemeMode] based on the saved setting, or [ThemeMode.system]
    // if there's no saved setting yet.
    return jiraUrl;
  }

  void set(String jiraUrl) {
    final prefs = ref.read(prefsProvider).requireValue;

    prefs.setString('jiraUrl', jiraUrl);

    ref.invalidateSelf();
  }
}

@riverpod
class JiraPat extends _$JiraPat {
  @override
  String? build() {
    final prefs = ref.watch(prefsProvider).requireValue;

    // Load the saved theme mode setting from shared preferences.
    final jiraPat = prefs.getString('jiraPat');

    // Return [ThemeMode] based on the saved setting, or [ThemeMode.system]
    // if there's no saved setting yet.
    return jiraPat;
  }

  void set(String jiraPat) {
    final prefs = ref.read(prefsProvider).requireValue;

    prefs.setString('jiraPat', jiraPat);

    ref.invalidateSelf();
  }
}
