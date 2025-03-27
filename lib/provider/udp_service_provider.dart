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
  logger.i('[UdpSenderServiceProvider] 生成');
  final service = UdpSenderService(
    destinationIp: ref.read(ipAddressProvider),
    destinationPortNumber: ref.read(portNumberProvider),
    sendingRate: ref.read(sendingRateProvider),
  );
  ref.onDispose(() {
    logger.i('[UdpSenderServiceProvider] Disposed');
    // service.stop();
  });
  return service;
}

/// [UdpSenderServiceWorker]のプロバイダ
///
/// このプロバイダは、[UdpSenderServiceWorker]のインスタンスを生成する。
/// Dispose時にWorkerがクローズされることを保証する。
@riverpod
UdpSenderServiceWorker udpSenderServiceWorkerInstance(Ref ref) {
  logger.i('[udpSenderServiceWorkerInstanceProvider] 生成');
  final worker = UdpSenderServiceWorker();
  ref.onDispose(() {
    logger.i('[udpSenderServiceWorkerInstanceProvider] Disposed');
    // Providerが破棄されたときに、必ずIsolateを終了させる。
    worker.close();
  });

  return worker;
}

/// [UdpSenderServiceWorker]の状態[IsolateWorkerState]プロバイダ
///
/// 各Widgetはこの[AsyncNotifierProvider]を介して[UdpSenderServiceWorker]を操作することで、
/// [UdpSenderServiceWorkerState]の変化に応じたビルドを実行できる。
///
/// タッチ状況の設定は[udpSenderServiceWorkerInstanceProvider]を介して行うこと。
///
/// Provider Dependencies:
/// - [udpSenderServiceWorkerInstanceProvider]

@riverpod
class UdpSenderServiceWorkerState extends _$UdpSenderServiceWorkerState {
  late final UdpSenderServiceWorker _worker;
  @override
  FutureOr<IsolateWorkerState> build() {
    logger.i('[UdpSenderServiceWorkerStateProvider] 生成');
    _worker = ref.watch(udpSenderServiceWorkerInstanceProvider);
    ref.onDispose(() {
      logger.i('[UdpSenderServiceWorkerStateProvider] disposed');
    });
    return _worker.currentState;
  }

  Future<void> start() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _worker.start(
        service: ref.read(_udpSenderServiceProvider),
        onRemoteIsolateError: (e) {
          logger.e('Remote Isolateでエラーが発生しました', error: e);
          state = AsyncValue.error(e, StackTrace.current);
        },
      );
      return _worker.currentState;
    });
  }

  void close() {
    state = const AsyncValue.loading();
    _worker.close();
    state = AsyncValue.data(_worker.currentState);
  }
}
