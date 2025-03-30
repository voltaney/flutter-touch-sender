import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:touch_sender/l10n/app_localizations.dart';
import 'package:touch_sender/model/udp_payload.dart';
import 'package:touch_sender/page/touchscreen_page.dart';
import 'package:touch_sender/provider/settings_provider.dart';
import 'package:touch_sender/provider/udp_service_provider.dart';
import 'package:touch_sender/router/routes.dart';
import 'package:touch_sender/service/udp_sender_service_worker.dart';
import 'package:touch_sender/util/logger.dart';

/// UDP送信サービスの状態・タッチ状況の更新を行う画面
class TouchScreen extends StatelessWidget {
  const TouchScreen({super.key, required this.currentState});
  final IsolateWorkerState currentState;

  @override
  Widget build(BuildContext context) {
    logBuildAction();
    // フルスクリーン
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Stack(
      children: [
        SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 10,
                left: 10,
                child: Row(
                  spacing: 10,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => context.go(Routes.setting),
                      icon: const Icon(
                        Icons.arrow_circle_left_outlined,
                        size: TouchScreenPage.iconSize,
                      ),
                      label: Text(AppLocalizations.of(context)!.back),
                    ),
                    ControlButton(currentState: currentState),
                    const UdpServiceIndicator(),
                  ],
                ),
              ),
            ],
          ),
        ),
        const OrientationListener(),
        TouchScreenListener(currentState: currentState),
      ],
    );
  }
}

/// タッチスクリーンページ上部に表示する、UDP送信を開始・停止するボタン
class ControlButton extends ConsumerWidget {
  const ControlButton({super.key, required this.currentState});
  final IsolateWorkerState currentState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logBuildAction();
    return switch (currentState) {
      IsolateWorkerState.running => ElevatedButton(
        onPressed: () {
          logger.i('停止ボタン');
          ref.read(udpSenderServiceWorkerStateProvider.notifier).close();
        },
        child: const Icon(Icons.stop, size: TouchScreenPage.iconSize),
      ),
      IsolateWorkerState.closed ||
      IsolateWorkerState.notStarted => ElevatedButton(
        onPressed: () async {
          logger.i('開始ボタン');
          await ref.read(udpSenderServiceWorkerStateProvider.notifier).start();
        },
        child: const Icon(Icons.play_arrow, size: TouchScreenPage.iconSize),
      ),
      _ => const SizedBox.shrink(),
    };
  }
}

/// タッチスクリーンのタッチイベントをリッスンするウィジェット
///
/// [Listener]ウィジェットを使用して、タッチイベントをリッスンする。
/// 視覚的な情報は一切提供しない。
///
/// [UdpSenderServiceWorker]が動作していない場合は、[SizedBox.shrink]を返す。
class TouchScreenListener extends ConsumerWidget {
  const TouchScreenListener({super.key, required this.currentState});
  final IsolateWorkerState currentState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logBuildAction();
    final udpSenderServiceWorker = ref.watch(
      udpSenderServiceWorkerInstanceProvider,
    );

    return currentState == IsolateWorkerState.running
        ? Listener(
          behavior: HitTestBehavior.translucent,
          onPointerUp: (_) {
            udpSenderServiceWorker.setSingleTouchData(null);
          },
          onPointerDown: (event) {
            udpSenderServiceWorker.setSingleTouchData(
              SingleTouch(x: event.position.dx, y: event.position.dy),
            );
          },
          onPointerMove: (event) {
            udpSenderServiceWorker.setSingleTouchData(
              SingleTouch(x: event.position.dx, y: event.position.dy),
            );
          },
        )
        : const SizedBox.shrink();
  }
}

/// デバイスの向きが変更された際に、[UdpSenderServiceWorker]にデバイスの情報を送信するウィジェット
///
/// 視覚的な情報は一切提供せず、[SizedBox.shrink]を返す。
/// Orientationの検知には[OrientationBuilder]を使用。
class OrientationListener extends ConsumerWidget {
  const OrientationListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logBuildAction();
    return OrientationBuilder(
      builder: (context, orientation) {
        logger.i('Orientation: $orientation');
        final size = MediaQuery.of(context).size;
        ref
            .read(udpSenderServiceWorkerInstanceProvider)
            .setDeviceInfo(
              DeviceInfo(
                width: size.width.toInt(),
                height: size.height.toInt(),
              ),
            );
        return const SizedBox.shrink();
      },
    );
  }
}

/// UDP送信レートを表示するウィジェット
///
/// メインスレッドで[UdpSenderService]を動かしていたときは、
/// 簡単に実際のレートを取得できたが、今はRemote Isolateで動かしているため、
/// 設定されたレートを表示するだけにしている。
class UdpServiceIndicator extends ConsumerWidget {
  const UdpServiceIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logBuildAction();
    // 1秒ごとに値を更新するためのプロバイダ
    final sendingRate = ref.read(sendingRateProvider);
    // ignore: unused_local_variable
    // final oneSecondUpdate = ref.watch(oneSecondUpdateProvider);
    return Text(AppLocalizations.of(context)!.showSendingRate(sendingRate));
  }
}
