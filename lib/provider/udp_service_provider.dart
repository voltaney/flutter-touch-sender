import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:touch_sender/provider/settings_provider.dart';
import 'package:touch_sender/service/udp_sender_service.dart';
import 'package:touch_sender/service/udp_sender_service_worker.dart';
import 'package:touch_sender/util/logger.dart';

part 'udp_service_provider.g.dart';

/// [UdpSenderService]のプロバイダ
///
/// 設定画面の設定値プロバイダを元に、UDP送信サービスを生成。
/// Dispose時にサービスを停止。
///
/// ただし、実際の送信処理は[udpSenderServiceWorkerInstanceProvider]で得られる
/// [UdpSenderServiceWorker]で行う。
/// ※別スレッドでUDP送信を行うため。
@riverpod
UdpSenderService _udpSenderService(Ref ref) {
  final service = UdpSenderService(
    destinationIp: ref.read(ipAddressProvider),
    destinationPortNumber: ref.read(portNumberProvider),
    sendingRate: ref.read(sendingRateProvider),
  );
  ref.onDispose(() {
    logger.i('UdpSenderServiceProvider disposed');
    service.stop();
  });
  return service;
}

/// [UdpSenderServiceWorker]のStateプロバイダ
///
/// 自動生成されたプロバイダに依存するプロバイダも自動生成されているべき、というRiverpodの仕様（警告表示）により、
/// [StateProvider]による直接的な定義は避けている。
@riverpod
class UdpSenderServiceWorkerInstance extends _$UdpSenderServiceWorkerInstance {
  @override
  UdpSenderServiceWorker? build() {
    ref.onDispose(() {
      logger.i('UdpSenderServiceWorkerInstanceProvider disposed');
      state?.close();
    });
    return null;
  }

  void set(UdpSenderServiceWorker? worker) {
    state = worker;
  }
}

/// [UdpSenderServiceWorker]のState
/// [UdpSenderServiceWorkerStateManagerProvider]で管理される。
enum UdpSenderServiceWorkerState { notStarted, running, closed }

/// [UdpSenderServiceWorkerState]のStateプロバイダ
///
/// 各Widgetはこの[FutureProvider]を介して[UdpSenderServiceWorker]を操作することで、
/// [UdpSenderServiceWorkerState]の変化に応じたビルドを実行できる。
///
/// ただし、タッチ状況の設定は[udpSenderServiceWorkerInstanceProvider]を介して行うこと。
@riverpod
class UdpSenderServiceWorkerStateManager
    extends _$UdpSenderServiceWorkerStateManager {
  @override
  FutureOr<UdpSenderServiceWorkerState> build() {
    ref.onDispose(
      () => logger.i('UdpSenderServiceWorkerStateManagerProvider disposed'),
    );
    return UdpSenderServiceWorkerState.notStarted;
  }

  Future<void> start() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_startService);
  }

  void close() {
    ref.read(udpSenderServiceWorkerInstanceProvider)?.close();
    ref.read(udpSenderServiceWorkerInstanceProvider.notifier).set(null);
    state = const AsyncValue.data(UdpSenderServiceWorkerState.closed);
  }

  Future<UdpSenderServiceWorkerState> _startService() async {
    if (ref.read(udpSenderServiceWorkerInstanceProvider) != null) {
      throw StateError('Already worker spawned');
    }
    final service = ref.read(_udpSenderServiceProvider);
    logger.i(
      'udpSenderServiceWorkerStateManagerProviderを介してUdpSenderServiceWorkerを生成します。',
    );
    // ここで引き渡したserviceは、Remote Isolateで実行されるため、
    // このIsolateでのserviceの状態は変わらないことに注意
    ref
        .read(udpSenderServiceWorkerInstanceProvider.notifier)
        .set(
          await UdpSenderServiceWorker.spawn(
            service,
            onError: (error) {
              logger.e('timer periodic中の失敗', error: error);
              state = AsyncValue.error(error, StackTrace.current);
            },
          ),
        );
    return UdpSenderServiceWorkerState.running;
  }
}
