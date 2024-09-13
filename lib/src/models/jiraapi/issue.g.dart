// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IssueImpl _$$IssueImplFromJson(Map<String, dynamic> json) => _$IssueImpl(
      id: json['id'] as String,
      key: json['key'] as String,
      fields: json['fields'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$IssueImplToJson(_$IssueImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'fields': instance.fields,
    };

_$IssuePickerResultImpl _$$IssuePickerResultImplFromJson(
        Map<String, dynamic> json) =>
    _$IssuePickerResultImpl(
      sections: (json['sections'] as List<dynamic>)
          .map((e) => IssueSection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$IssuePickerResultImplToJson(
        _$IssuePickerResultImpl instance) =>
    <String, dynamic>{
      'sections': instance.sections,
    };

_$IssueSectionImpl _$$IssueSectionImplFromJson(Map<String, dynamic> json) =>
    _$IssueSectionImpl(
      label: json['label'] as String?,
      msg: json['msg'] as String?,
      issues: (json['issues'] as List<dynamic>)
          .map((e) => IssuePicker.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$IssueSectionImplToJson(_$IssueSectionImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'msg': instance.msg,
      'issues': instance.issues,
    };

_$IssuePickerImpl _$$IssuePickerImplFromJson(Map<String, dynamic> json) =>
    _$IssuePickerImpl(
      key: json['key'] as String,
      keyHtml: json['keyHtml'] as String,
      summary: json['summary'] as String?,
      summaryText: json['summaryText'] as String?,
    );

Map<String, dynamic> _$$IssuePickerImplToJson(_$IssuePickerImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'keyHtml': instance.keyHtml,
      'summary': instance.summary,
      'summaryText': instance.summaryText,
    };
