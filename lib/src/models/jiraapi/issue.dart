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

  String summary() {
    return fields['summary'] as String;
  }

  /// Convert a JSON object into an [Activity] instance.
  /// This enables type-safe reading of the API response.
  factory Issue.fromJson(Map<String, dynamic> json) => _$IssueFromJson(json);
}
