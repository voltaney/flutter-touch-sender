// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'udp_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$udpSenderServiceHash() => r'b66cd6d2e616570a27d4c9dfebfee5c4a3992228';

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
    r'532b18d967594d68be3fa1b31bcd874173938795';

/// [UdpSenderServiceWorker]のStateプロバイダ
///
/// 自動生成されたプロバイダに依存するプロバイダも自動生成されているべき、というRiverpodの仕様（警告表示）により、
/// [StateProvider]による直接的な定義は避けている。
///
/// Copied from [UdpSenderServiceWorkerInstance].
@ProviderFor(UdpSenderServiceWorkerInstance)
final udpSenderServiceWorkerInstanceProvider = AutoDisposeNotifierProvider<
  UdpSenderServiceWorkerInstance,
  UdpSenderServiceWorker?
>.internal(
  UdpSenderServiceWorkerInstance.new,
  name: r'udpSenderServiceWorkerInstanceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$udpSenderServiceWorkerInstanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UdpSenderServiceWorkerInstance =
    AutoDisposeNotifier<UdpSenderServiceWorker?>;
String _$udpSenderServiceWorkerStateManagerHash() =>
    r'2380d007af24e19667d0c6554dc22472ad95df6a';

/// [UdpSenderServiceWorkerState]のStateプロバイダ
///
/// 各Widgetはこの[FutureProvider]を介して[UdpSenderServiceWorker]を操作することで、
/// [UdpSenderServiceWorkerState]の変化に応じたビルドを実行できる。
///
/// ただし、タッチ状況の設定は[udpSenderServiceWorkerInstanceProvider]を介して行うこと。
///
/// Copied from [UdpSenderServiceWorkerStateManager].
@ProviderFor(UdpSenderServiceWorkerStateManager)
final udpSenderServiceWorkerStateManagerProvider =
    AutoDisposeAsyncNotifierProvider<
      UdpSenderServiceWorkerStateManager,
      UdpSenderServiceWorkerState
    >.internal(
      UdpSenderServiceWorkerStateManager.new,
      name: r'udpSenderServiceWorkerStateManagerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$udpSenderServiceWorkerStateManagerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UdpSenderServiceWorkerStateManager =
    AutoDisposeAsyncNotifier<UdpSenderServiceWorkerState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
