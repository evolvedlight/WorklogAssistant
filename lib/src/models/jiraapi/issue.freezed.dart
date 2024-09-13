// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'issue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Issue _$IssueFromJson(Map<String, dynamic> json) {
  return _Issue.fromJson(json);
}

/// @nodoc
mixin _$Issue {
  String get id => throw _privateConstructorUsedError;
  String get key =>
      throw _privateConstructorUsedError; // add all the fields which are key to dynamic
  Map<String, dynamic> get fields => throw _privateConstructorUsedError;

  /// Serializes this Issue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Issue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IssueCopyWith<Issue> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IssueCopyWith<$Res> {
  factory $IssueCopyWith(Issue value, $Res Function(Issue) then) =
      _$IssueCopyWithImpl<$Res, Issue>;
  @useResult
  $Res call({String id, String key, Map<String, dynamic> fields});
}

/// @nodoc
class _$IssueCopyWithImpl<$Res, $Val extends Issue>
    implements $IssueCopyWith<$Res> {
  _$IssueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Issue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? key = null,
    Object? fields = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      fields: null == fields
          ? _value.fields
          : fields // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IssueImplCopyWith<$Res> implements $IssueCopyWith<$Res> {
  factory _$$IssueImplCopyWith(
          _$IssueImpl value, $Res Function(_$IssueImpl) then) =
      __$$IssueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String key, Map<String, dynamic> fields});
}

/// @nodoc
class __$$IssueImplCopyWithImpl<$Res>
    extends _$IssueCopyWithImpl<$Res, _$IssueImpl>
    implements _$$IssueImplCopyWith<$Res> {
  __$$IssueImplCopyWithImpl(
      _$IssueImpl _value, $Res Function(_$IssueImpl) _then)
      : super(_value, _then);

  /// Create a copy of Issue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? key = null,
    Object? fields = null,
  }) {
    return _then(_$IssueImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      fields: null == fields
          ? _value._fields
          : fields // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IssueImpl extends _Issue {
  _$IssueImpl(
      {required this.id,
      required this.key,
      required final Map<String, dynamic> fields})
      : _fields = fields,
        super._();

  factory _$IssueImpl.fromJson(Map<String, dynamic> json) =>
      _$$IssueImplFromJson(json);

  @override
  final String id;
  @override
  final String key;
// add all the fields which are key to dynamic
  final Map<String, dynamic> _fields;
// add all the fields which are key to dynamic
  @override
  Map<String, dynamic> get fields {
    if (_fields is EqualUnmodifiableMapView) return _fields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_fields);
  }

  @override
  String toString() {
    return 'Issue(id: $id, key: $key, fields: $fields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IssueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.key, key) || other.key == key) &&
            const DeepCollectionEquality().equals(other._fields, _fields));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, key, const DeepCollectionEquality().hash(_fields));

  /// Create a copy of Issue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IssueImplCopyWith<_$IssueImpl> get copyWith =>
      __$$IssueImplCopyWithImpl<_$IssueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IssueImplToJson(
      this,
    );
  }
}

abstract class _Issue extends Issue {
  factory _Issue(
      {required final String id,
      required final String key,
      required final Map<String, dynamic> fields}) = _$IssueImpl;
  _Issue._() : super._();

  factory _Issue.fromJson(Map<String, dynamic> json) = _$IssueImpl.fromJson;

  @override
  String get id;
  @override
  String get key; // add all the fields which are key to dynamic
  @override
  Map<String, dynamic> get fields;

  /// Create a copy of Issue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IssueImplCopyWith<_$IssueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IssuePickerResult _$IssuePickerResultFromJson(Map<String, dynamic> json) {
  return _IssuePickerResult.fromJson(json);
}

/// @nodoc
mixin _$IssuePickerResult {
  List<IssueSection> get sections => throw _privateConstructorUsedError;

  /// Serializes this IssuePickerResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IssuePickerResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IssuePickerResultCopyWith<IssuePickerResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IssuePickerResultCopyWith<$Res> {
  factory $IssuePickerResultCopyWith(
          IssuePickerResult value, $Res Function(IssuePickerResult) then) =
      _$IssuePickerResultCopyWithImpl<$Res, IssuePickerResult>;
  @useResult
  $Res call({List<IssueSection> sections});
}

/// @nodoc
class _$IssuePickerResultCopyWithImpl<$Res, $Val extends IssuePickerResult>
    implements $IssuePickerResultCopyWith<$Res> {
  _$IssuePickerResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IssuePickerResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sections = null,
  }) {
    return _then(_value.copyWith(
      sections: null == sections
          ? _value.sections
          : sections // ignore: cast_nullable_to_non_nullable
              as List<IssueSection>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IssuePickerResultImplCopyWith<$Res>
    implements $IssuePickerResultCopyWith<$Res> {
  factory _$$IssuePickerResultImplCopyWith(_$IssuePickerResultImpl value,
          $Res Function(_$IssuePickerResultImpl) then) =
      __$$IssuePickerResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<IssueSection> sections});
}

/// @nodoc
class __$$IssuePickerResultImplCopyWithImpl<$Res>
    extends _$IssuePickerResultCopyWithImpl<$Res, _$IssuePickerResultImpl>
    implements _$$IssuePickerResultImplCopyWith<$Res> {
  __$$IssuePickerResultImplCopyWithImpl(_$IssuePickerResultImpl _value,
      $Res Function(_$IssuePickerResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of IssuePickerResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sections = null,
  }) {
    return _then(_$IssuePickerResultImpl(
      sections: null == sections
          ? _value._sections
          : sections // ignore: cast_nullable_to_non_nullable
              as List<IssueSection>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IssuePickerResultImpl extends _IssuePickerResult {
  _$IssuePickerResultImpl({required final List<IssueSection> sections})
      : _sections = sections,
        super._();

  factory _$IssuePickerResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$IssuePickerResultImplFromJson(json);

  final List<IssueSection> _sections;
  @override
  List<IssueSection> get sections {
    if (_sections is EqualUnmodifiableListView) return _sections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sections);
  }

  @override
  String toString() {
    return 'IssuePickerResult(sections: $sections)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IssuePickerResultImpl &&
            const DeepCollectionEquality().equals(other._sections, _sections));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_sections));

  /// Create a copy of IssuePickerResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IssuePickerResultImplCopyWith<_$IssuePickerResultImpl> get copyWith =>
      __$$IssuePickerResultImplCopyWithImpl<_$IssuePickerResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IssuePickerResultImplToJson(
      this,
    );
  }
}

abstract class _IssuePickerResult extends IssuePickerResult {
  factory _IssuePickerResult({required final List<IssueSection> sections}) =
      _$IssuePickerResultImpl;
  _IssuePickerResult._() : super._();

  factory _IssuePickerResult.fromJson(Map<String, dynamic> json) =
      _$IssuePickerResultImpl.fromJson;

  @override
  List<IssueSection> get sections;

  /// Create a copy of IssuePickerResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IssuePickerResultImplCopyWith<_$IssuePickerResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IssueSection _$IssueSectionFromJson(Map<String, dynamic> json) {
  return _IssueSection.fromJson(json);
}

/// @nodoc
mixin _$IssueSection {
  String? get label => throw _privateConstructorUsedError;
  String? get msg => throw _privateConstructorUsedError;
  List<IssuePicker> get issues => throw _privateConstructorUsedError;

  /// Serializes this IssueSection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IssueSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IssueSectionCopyWith<IssueSection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IssueSectionCopyWith<$Res> {
  factory $IssueSectionCopyWith(
          IssueSection value, $Res Function(IssueSection) then) =
      _$IssueSectionCopyWithImpl<$Res, IssueSection>;
  @useResult
  $Res call({String? label, String? msg, List<IssuePicker> issues});
}

/// @nodoc
class _$IssueSectionCopyWithImpl<$Res, $Val extends IssueSection>
    implements $IssueSectionCopyWith<$Res> {
  _$IssueSectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IssueSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = freezed,
    Object? msg = freezed,
    Object? issues = null,
  }) {
    return _then(_value.copyWith(
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      msg: freezed == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String?,
      issues: null == issues
          ? _value.issues
          : issues // ignore: cast_nullable_to_non_nullable
              as List<IssuePicker>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IssueSectionImplCopyWith<$Res>
    implements $IssueSectionCopyWith<$Res> {
  factory _$$IssueSectionImplCopyWith(
          _$IssueSectionImpl value, $Res Function(_$IssueSectionImpl) then) =
      __$$IssueSectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? label, String? msg, List<IssuePicker> issues});
}

/// @nodoc
class __$$IssueSectionImplCopyWithImpl<$Res>
    extends _$IssueSectionCopyWithImpl<$Res, _$IssueSectionImpl>
    implements _$$IssueSectionImplCopyWith<$Res> {
  __$$IssueSectionImplCopyWithImpl(
      _$IssueSectionImpl _value, $Res Function(_$IssueSectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of IssueSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = freezed,
    Object? msg = freezed,
    Object? issues = null,
  }) {
    return _then(_$IssueSectionImpl(
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      msg: freezed == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String?,
      issues: null == issues
          ? _value._issues
          : issues // ignore: cast_nullable_to_non_nullable
              as List<IssuePicker>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IssueSectionImpl extends _IssueSection {
  _$IssueSectionImpl(
      {this.label, this.msg, required final List<IssuePicker> issues})
      : _issues = issues,
        super._();

  factory _$IssueSectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$IssueSectionImplFromJson(json);

  @override
  final String? label;
  @override
  final String? msg;
  final List<IssuePicker> _issues;
  @override
  List<IssuePicker> get issues {
    if (_issues is EqualUnmodifiableListView) return _issues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_issues);
  }

  @override
  String toString() {
    return 'IssueSection(label: $label, msg: $msg, issues: $issues)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IssueSectionImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.msg, msg) || other.msg == msg) &&
            const DeepCollectionEquality().equals(other._issues, _issues));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, label, msg, const DeepCollectionEquality().hash(_issues));

  /// Create a copy of IssueSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IssueSectionImplCopyWith<_$IssueSectionImpl> get copyWith =>
      __$$IssueSectionImplCopyWithImpl<_$IssueSectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IssueSectionImplToJson(
      this,
    );
  }
}

abstract class _IssueSection extends IssueSection {
  factory _IssueSection(
      {final String? label,
      final String? msg,
      required final List<IssuePicker> issues}) = _$IssueSectionImpl;
  _IssueSection._() : super._();

  factory _IssueSection.fromJson(Map<String, dynamic> json) =
      _$IssueSectionImpl.fromJson;

  @override
  String? get label;
  @override
  String? get msg;
  @override
  List<IssuePicker> get issues;

  /// Create a copy of IssueSection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IssueSectionImplCopyWith<_$IssueSectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IssuePicker _$IssuePickerFromJson(Map<String, dynamic> json) {
  return _IssuePicker.fromJson(json);
}

/// @nodoc
mixin _$IssuePicker {
  String get key => throw _privateConstructorUsedError;
  String get keyHtml => throw _privateConstructorUsedError;
  String? get summary => throw _privateConstructorUsedError;
  String? get summaryText => throw _privateConstructorUsedError;

  /// Serializes this IssuePicker to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IssuePicker
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IssuePickerCopyWith<IssuePicker> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IssuePickerCopyWith<$Res> {
  factory $IssuePickerCopyWith(
          IssuePicker value, $Res Function(IssuePicker) then) =
      _$IssuePickerCopyWithImpl<$Res, IssuePicker>;
  @useResult
  $Res call({String key, String keyHtml, String? summary, String? summaryText});
}

/// @nodoc
class _$IssuePickerCopyWithImpl<$Res, $Val extends IssuePicker>
    implements $IssuePickerCopyWith<$Res> {
  _$IssuePickerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IssuePicker
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? keyHtml = null,
    Object? summary = freezed,
    Object? summaryText = freezed,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      keyHtml: null == keyHtml
          ? _value.keyHtml
          : keyHtml // ignore: cast_nullable_to_non_nullable
              as String,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      summaryText: freezed == summaryText
          ? _value.summaryText
          : summaryText // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IssuePickerImplCopyWith<$Res>
    implements $IssuePickerCopyWith<$Res> {
  factory _$$IssuePickerImplCopyWith(
          _$IssuePickerImpl value, $Res Function(_$IssuePickerImpl) then) =
      __$$IssuePickerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String key, String keyHtml, String? summary, String? summaryText});
}

/// @nodoc
class __$$IssuePickerImplCopyWithImpl<$Res>
    extends _$IssuePickerCopyWithImpl<$Res, _$IssuePickerImpl>
    implements _$$IssuePickerImplCopyWith<$Res> {
  __$$IssuePickerImplCopyWithImpl(
      _$IssuePickerImpl _value, $Res Function(_$IssuePickerImpl) _then)
      : super(_value, _then);

  /// Create a copy of IssuePicker
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? keyHtml = null,
    Object? summary = freezed,
    Object? summaryText = freezed,
  }) {
    return _then(_$IssuePickerImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      keyHtml: null == keyHtml
          ? _value.keyHtml
          : keyHtml // ignore: cast_nullable_to_non_nullable
              as String,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      summaryText: freezed == summaryText
          ? _value.summaryText
          : summaryText // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IssuePickerImpl extends _IssuePicker {
  _$IssuePickerImpl(
      {required this.key,
      required this.keyHtml,
      this.summary,
      this.summaryText})
      : super._();

  factory _$IssuePickerImpl.fromJson(Map<String, dynamic> json) =>
      _$$IssuePickerImplFromJson(json);

  @override
  final String key;
  @override
  final String keyHtml;
  @override
  final String? summary;
  @override
  final String? summaryText;

  @override
  String toString() {
    return 'IssuePicker(key: $key, keyHtml: $keyHtml, summary: $summary, summaryText: $summaryText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IssuePickerImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.keyHtml, keyHtml) || other.keyHtml == keyHtml) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.summaryText, summaryText) ||
                other.summaryText == summaryText));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, key, keyHtml, summary, summaryText);

  /// Create a copy of IssuePicker
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IssuePickerImplCopyWith<_$IssuePickerImpl> get copyWith =>
      __$$IssuePickerImplCopyWithImpl<_$IssuePickerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IssuePickerImplToJson(
      this,
    );
  }
}

abstract class _IssuePicker extends IssuePicker {
  factory _IssuePicker(
      {required final String key,
      required final String keyHtml,
      final String? summary,
      final String? summaryText}) = _$IssuePickerImpl;
  _IssuePicker._() : super._();

  factory _IssuePicker.fromJson(Map<String, dynamic> json) =
      _$IssuePickerImpl.fromJson;

  @override
  String get key;
  @override
  String get keyHtml;
  @override
  String? get summary;
  @override
  String? get summaryText;

  /// Create a copy of IssuePicker
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IssuePickerImplCopyWith<_$IssuePickerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
