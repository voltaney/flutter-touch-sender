// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'udp_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$udpSenderServiceHash() => r'69de85c0fc09f6f88aa0ca4c4a401a1a51bbc31d';

/// [UdpSenderService]のプロバイダ
///
/// 設定画面の設定値プロバイダを元に、UDP送信サービスを生成。
/// Dispose時にサービスを停止。
///
/// ただし、実際の送信処理は[udpSenderServiceWorkerInstanceProvider]で得られる
/// [UdpSenderServiceWorker]で行う。
/// ※別スレッドでUDP送信を行うため。
///
/// Copied from [_udpSenderService].
@ProviderFor(_udpSenderService)
final _udpSenderServiceProvider =
    AutoDisposeProvider<UdpSenderService>.internal(
      _udpSenderService,
      name: r'_udpSenderServiceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$udpSenderServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _UdpSenderServiceRef = AutoDisposeProviderRef<UdpSenderService>;
String _$udpSenderServiceWorkerInstanceHash() =>
    r'4421667390812c3b7b3183528e6e4a5d66eecf32';

/// [UdpSenderServiceWorker]のプロバイダ
///
/// このプロバイダは、[UdpSenderServiceWorker]のインスタンスを生成する。
/// Dispose時にWorkerがクローズされることを保証する。
///
/// Copied from [udpSenderServiceWorkerInstance].
@ProviderFor(udpSenderServiceWorkerInstance)
final udpSenderServiceWorkerInstanceProvider =
    AutoDisposeProvider<UdpSenderServiceWorker>.internal(
      udpSenderServiceWorkerInstance,
      name: r'udpSenderServiceWorkerInstanceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$udpSenderServiceWorkerInstanceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UdpSenderServiceWorkerInstanceRef =
    AutoDisposeProviderRef<UdpSenderServiceWorker>;
String _$udpSenderServiceWorkerStateHash() =>
    r'da41509e18aeefd8fa215140b0981c5c84152ce7';

/// [UdpSenderServiceWorker]の状態[IsolateWorkerState]プロバイダ
///
/// 各Widgetはこの[AsyncNotifierProvider]を介して[UdpSenderServiceWorker]を操作することで、
/// [UdpSenderServiceWorkerState]の変化に応じたビルドを実行できる。
///
/// タッチ状況の設定は[udpSenderServiceWorkerInstanceProvider]を介して行うこと。
///
/// Provider Dependencies:
/// - [udpSenderServiceWorkerInstanceProvider]
///
/// Copied from [UdpSenderServiceWorkerState].
@ProviderFor(UdpSenderServiceWorkerState)
final udpSenderServiceWorkerStateProvider = AutoDisposeAsyncNotifierProvider<
  UdpSenderServiceWorkerState,
  IsolateWorkerState
>.internal(
  UdpSenderServiceWorkerState.new,
  name: r'udpSenderServiceWorkerStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$udpSenderServiceWorkerStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UdpSenderServiceWorkerState =
    AutoDisposeAsyncNotifier<IsolateWorkerState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
