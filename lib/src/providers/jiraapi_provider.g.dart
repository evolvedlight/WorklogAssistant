// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jiraapi_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$issueHash() => r'2c7e8bda5dc0c11f287ba06cb7614f674f59474b';

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
class IssueFamily extends Family<AsyncValue<Issue>> {
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
class IssueProvider extends AutoDisposeFutureProvider<Issue> {
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
    FutureOr<Issue> Function(IssueRef provider) create,
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
  AutoDisposeFutureProviderElement<Issue> createElement() {
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

mixin IssueRef on AutoDisposeFutureProviderRef<Issue> {
  /// The parameter `jiraId` of this provider.
  String get jiraId;
}

class _IssueProviderElement extends AutoDisposeFutureProviderElement<Issue>
    with IssueRef {
  _IssueProviderElement(super.provider);

  @override
  String get jiraId => (origin as IssueProvider).jiraId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
