// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentThemeModeHash() => r'69e9467b1214d93df7c80f913ef0652416c93db2';

/// The current theme mode of the app.
///
/// When this provider is first read, it will read the saved value from storage,
/// and defaults to [ThemeMode.system] if the theme mode has not been set before.
///
/// Copied from [CurrentThemeMode].
@ProviderFor(CurrentThemeMode)
final currentThemeModeProvider =
    AutoDisposeNotifierProvider<CurrentThemeMode, ThemeMode>.internal(
  CurrentThemeMode.new,
  name: r'currentThemeModeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentThemeModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentThemeMode = AutoDisposeNotifier<ThemeMode>;
String _$currentJiraFilterHash() => r'f9f56369f497425430f15725f2f239c17d75b9af';

/// See also [CurrentJiraFilter].
@ProviderFor(CurrentJiraFilter)
final currentJiraFilterProvider =
    AutoDisposeNotifierProvider<CurrentJiraFilter, JiraFilter?>.internal(
  CurrentJiraFilter.new,
  name: r'currentJiraFilterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentJiraFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentJiraFilter = AutoDisposeNotifier<JiraFilter?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
