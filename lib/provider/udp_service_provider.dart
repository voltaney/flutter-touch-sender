import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:touch_sender/provider/settings_provider.dart';
import 'package:touch_sender/service/udp_sender_service.dart';
import 'package:touch_sender/util/logger.dart';

part 'udp_service_provider.g.dart';

// UdpSenderServiceインスタンスを提供するProvider
@riverpod
UdpSenderService udpSenderService(Ref ref) {
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

// UdpSenderServiceの状態を管理するProvider
// UdpSenderServiceのTimerは、このProviderを介して操作する。
@riverpod
class UdpSenderServiceRunner extends _$UdpSenderServiceRunner {
  @override
  FutureOr<UdpSenderServiceState> build() async {
    ref.onDispose(() => logger.i('UdpSenderServiceRunner disposed'));
    return UdpSenderServiceState.stopped;
  }

  Future<UdpSenderServiceState> _startService() async {
    final service = ref.watch(udpSenderServiceProvider);
    await service.start(
      onError: (error, stackTrace) {
        logger.e('timer periodic中の失敗', error: error, stackTrace: stackTrace);
        state = AsyncValue.error(error, StackTrace.current);
      },
    );
    return service.currentState;
  }

  Future<void> start() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_startService);
  }

  void stop() {
    final service = ref.watch(udpSenderServiceProvider);
    service.stop();
    state = AsyncValue.data(service.currentState);
  }
}
