import 'package:freezed_annotation/freezed_annotation.dart';

part 'issue.freezed.dart';
part 'issue.g.dart';

@freezed
class Issue with _$Issue {
  const Issue._();

  factory Issue({
    required String id,
    required String key,

    // add all the fields which are key to dynamic
    required Map<String, dynamic> fields,
  }) = _Issue;

  String get summary {
    return fields['summary'] as String;
  }

  /// Convert a JSON object into an [Activity] instance.
  /// This enables type-safe reading of the API response.
  factory Issue.fromJson(Map<String, dynamic> json) => _$IssueFromJson(json);
}

@freezed
class IssuePickerResult with _$IssuePickerResult {
  const IssuePickerResult._();

  factory IssuePickerResult({
    required List<IssueSection> sections,
  }) = _IssuePickerResult;

  /// Convert a JSON object into an [Activity] instance.
  /// This enables type-safe reading of the API response.
  factory IssuePickerResult.fromJson(Map<String, dynamic> json) => _$IssuePickerResultFromJson(json);
}

@freezed
class IssueSection with _$IssueSection {
  const IssueSection._();

  factory IssueSection({
    String? label,
    String? msg,
    required List<IssuePicker> issues,
  }) = _IssueSection;

  /// Convert a JSON object into an [Activity] instance.
  /// This enables type-safe reading of the API response.
  factory IssueSection.fromJson(Map<String, dynamic> json) => _$IssueSectionFromJson(json);
}

@freezed
class IssuePicker with _$IssuePicker {
  const IssuePicker._();

  factory IssuePicker({
    required String key,
    required String keyHtml,
    String? summary,
    String? summaryText,
  }) = _IssuePicker;

  /// Convert a JSON object into an [Activity] instance.
  /// This enables type-safe reading of the API response.
  factory IssuePicker.fromJson(Map<String, dynamic> json) => _$IssuePickerFromJson(json);
}
