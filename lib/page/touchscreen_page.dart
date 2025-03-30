import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:touch_sender/page/touchscreen_page_screens/error_screen.dart';
import 'package:touch_sender/page/touchscreen_page_screens/touch_screen.dart';
import 'package:touch_sender/provider/udp_service_provider.dart';
import 'package:touch_sender/util/logger.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// タッチスクリーンページ
class TouchScreenPage extends HookConsumerWidget {
  const TouchScreenPage({super.key});
  static const double iconSize = 20;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logBuildAction();

    final udpSenderServiceWorkerState = ref.watch(
      udpSenderServiceWorkerStateProvider,
    );

    useEffect(() {
      // 最初のフレーム描画後にUDPサービスを自動的に実行させる
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(udpSenderServiceWorkerStateProvider.notifier).start();
      });
      return null;
    }, []);
    useEffect(() {
      // この画面にいるときはスリープさせない
      WakelockPlus.enable();
      return WakelockPlus.disable;
    }, []);

    useOnAppLifecycleStateChange((before, current) {
      // アプリがバックグラウンドに行ったらUDP送信を停止する
      switch (current) {
        case AppLifecycleState.inactive:
          ref.read(udpSenderServiceWorkerStateProvider.notifier).close();
          break;
        default:
          break;
      }
    });

    // UdpSenderServiceRunnerの状態によって表示を切り替える
    return Scaffold(
      body: switch (udpSenderServiceWorkerState) {
        AsyncError(:final error) => ErrorScreen(error: error),
        AsyncData(:final value) => TouchScreen(currentState: value),
        _ => const CircularProgressIndicator(),
      },
    );
  }
}
