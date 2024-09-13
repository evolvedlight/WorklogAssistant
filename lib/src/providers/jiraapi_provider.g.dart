// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jiraapi_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$issueHash() => r'ac6990904cbd5f478403a695386a1dd603ed3ef9';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [issue].
@ProviderFor(issue)
const issueProvider = IssueFamily();

/// See also [issue].
class IssueFamily extends Family<AsyncValue<Issue?>> {
  /// See also [issue].
  const IssueFamily();

  /// See also [issue].
  IssueProvider call(
    String jiraId,
  ) {
    return IssueProvider(
      jiraId,
    );
  }

  @override
  IssueProvider getProviderOverride(
    covariant IssueProvider provider,
  ) {
    return call(
      provider.jiraId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'issueProvider';
}

/// See also [issue].
class IssueProvider extends AutoDisposeFutureProvider<Issue?> {
  /// See also [issue].
  IssueProvider(
    String jiraId,
  ) : this._internal(
          (ref) => issue(
            ref as IssueRef,
            jiraId,
          ),
          from: issueProvider,
          name: r'issueProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$issueHash,
          dependencies: IssueFamily._dependencies,
          allTransitiveDependencies: IssueFamily._allTransitiveDependencies,
          jiraId: jiraId,
        );

  IssueProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.jiraId,
  }) : super.internal();

  final String jiraId;

  @override
  Override overrideWith(
    FutureOr<Issue?> Function(IssueRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IssueProvider._internal(
        (ref) => create(ref as IssueRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        jiraId: jiraId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Issue?> createElement() {
    return _IssueProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IssueProvider && other.jiraId == jiraId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, jiraId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IssueRef on AutoDisposeFutureProviderRef<Issue?> {
  /// The parameter `jiraId` of this provider.
  String get jiraId;
}

class _IssueProviderElement extends AutoDisposeFutureProviderElement<Issue?>
    with IssueRef {
  _IssueProviderElement(super.provider);

  @override
  String get jiraId => (origin as IssueProvider).jiraId;
}

String _$issuesAutocompleteHash() =>
    r'434626903ba732ba2260cc0af90467eb3d7a9bec';

/// See also [issuesAutocomplete].
@ProviderFor(issuesAutocomplete)
const issuesAutocompleteProvider = IssuesAutocompleteFamily();

/// See also [issuesAutocomplete].
class IssuesAutocompleteFamily extends Family<AsyncValue<List<IssuePicker>>> {
  /// See also [issuesAutocomplete].
  const IssuesAutocompleteFamily();

  /// See also [issuesAutocomplete].
  IssuesAutocompleteProvider call(
    String searchPhrase,
  ) {
    return IssuesAutocompleteProvider(
      searchPhrase,
    );
  }

  @override
  IssuesAutocompleteProvider getProviderOverride(
    covariant IssuesAutocompleteProvider provider,
  ) {
    return call(
      provider.searchPhrase,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'issuesAutocompleteProvider';
}

/// See also [issuesAutocomplete].
class IssuesAutocompleteProvider
    extends AutoDisposeFutureProvider<List<IssuePicker>> {
  /// See also [issuesAutocomplete].
  IssuesAutocompleteProvider(
    String searchPhrase,
  ) : this._internal(
          (ref) => issuesAutocomplete(
            ref as IssuesAutocompleteRef,
            searchPhrase,
          ),
          from: issuesAutocompleteProvider,
          name: r'issuesAutocompleteProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$issuesAutocompleteHash,
          dependencies: IssuesAutocompleteFamily._dependencies,
          allTransitiveDependencies:
              IssuesAutocompleteFamily._allTransitiveDependencies,
          searchPhrase: searchPhrase,
        );

  IssuesAutocompleteProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchPhrase,
  }) : super.internal();

  final String searchPhrase;

  @override
  Override overrideWith(
    FutureOr<List<IssuePicker>> Function(IssuesAutocompleteRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IssuesAutocompleteProvider._internal(
        (ref) => create(ref as IssuesAutocompleteRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchPhrase: searchPhrase,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<IssuePicker>> createElement() {
    return _IssuesAutocompleteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IssuesAutocompleteProvider &&
        other.searchPhrase == searchPhrase;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchPhrase.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IssuesAutocompleteRef on AutoDisposeFutureProviderRef<List<IssuePicker>> {
  /// The parameter `searchPhrase` of this provider.
  String get searchPhrase;
}

class _IssuesAutocompleteProviderElement
    extends AutoDisposeFutureProviderElement<List<IssuePicker>>
    with IssuesAutocompleteRef {
  _IssuesAutocompleteProviderElement(super.provider);

  @override
  String get searchPhrase =>
      (origin as IssuesAutocompleteProvider).searchPhrase;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
