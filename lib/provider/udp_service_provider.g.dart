// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'udp_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$udpSenderServiceHash() => r'5d3da467b59e5f2768d1ef48e8b85a3fbcad785c';

/// See also [udpSenderService].
@ProviderFor(udpSenderService)
final udpSenderServiceProvider = AutoDisposeProvider<UdpSenderService>.internal(
  udpSenderService,
  name: r'udpSenderServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$udpSenderServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UdpSenderServiceRef = AutoDisposeProviderRef<UdpSenderService>;
String _$udpSenderServiceRunnerHash() =>
    r'd43a79d16aa52834f9db808686a60d8c04298df6';

/// See also [UdpSenderServiceRunner].
@ProviderFor(UdpSenderServiceRunner)
final udpSenderServiceRunnerProvider = AutoDisposeAsyncNotifierProvider<
  UdpSenderServiceRunner,
  UdpSenderServiceState
>.internal(
  UdpSenderServiceRunner.new,
  name: r'udpSenderServiceRunnerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$udpSenderServiceRunnerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UdpSenderServiceRunner =
    AutoDisposeAsyncNotifier<UdpSenderServiceState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
