import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:touch_sender/l10n/app_localizations.dart';
import 'package:touch_sender/model/udp_payload.dart';
import 'package:touch_sender/provider/settings_provider.dart';
import 'package:touch_sender/provider/udp_service_provider.dart';
import 'package:touch_sender/router/routes.dart';
import 'package:touch_sender/service/udp_sender_service.dart';
import 'package:touch_sender/util/logger.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// タッチスクリーンページ
class TouchScreenPage extends HookConsumerWidget {
  const TouchScreenPage({super.key});
  static const double iconSize = 20;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logBuildAction();
    // フルスクリーン
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    final udpSenderServiceWorkerStateManager = ref.watch(
      udpSenderServiceWorkerStateManagerProvider,
    );

    useEffect(() {
      // 最初のフレーム描画後にUDPサービスを自動的に実行させる
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(udpSenderServiceWorkerStateManagerProvider.notifier).start();
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
          ref.read(udpSenderServiceWorkerStateManagerProvider.notifier).close();
          break;
        default:
          break;
      }
    });

    // UdpSenderServiceRunnerの状態によって表示を切り替える
    return Scaffold(
      body: switch (udpSenderServiceWorkerStateManager) {
        AsyncError(:final error) => ErrorScreen(error: error),
        AsyncData(:final value) => TouchScreen(currentState: value),
        _ => const CircularProgressIndicator(),
      },
    );
  }
}

/// タッチスクリーンページ上部に表示する、UDP送信を開始・停止するボタン
class ControlButton extends ConsumerWidget {
  const ControlButton({super.key, required this.currentState});
  final UdpSenderServiceWorkerState currentState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logBuildAction();
    return switch (currentState) {
      UdpSenderServiceWorkerState.running => ElevatedButton(
        onPressed: () {
          ref.read(udpSenderServiceWorkerStateManagerProvider.notifier).close();
        },
        child: const Icon(Icons.stop, size: TouchScreenPage.iconSize),
      ),
      UdpSenderServiceWorkerState.closed ||
      UdpSenderServiceWorkerState.notStarted => ElevatedButton(
        onPressed: () async {
          await ref
              .read(udpSenderServiceWorkerStateManagerProvider.notifier)
              .start();
        },
        child: const Icon(Icons.play_arrow, size: TouchScreenPage.iconSize),
      ),
    };
  }
}

/// タッチ状況を記録するウィジェット
class TouchScreen extends HookConsumerWidget {
  const TouchScreen({super.key, required this.currentState});
  final UdpSenderServiceWorkerState currentState;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logBuildAction();
    final udpSenderServiceWorker = ref.watch(
      udpSenderServiceWorkerInstanceProvider,
    );
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
        Listener(
          behavior: HitTestBehavior.translucent,
          onPointerUp: (_) {
            udpSenderServiceWorker?.setSingleTouchData(null);
          },
          onPointerDown: (event) {
            udpSenderServiceWorker?.setSingleTouchData(
              SingleTouch(x: event.position.dx, y: event.position.dy),
            );
          },
          onPointerMove: (event) {
            udpSenderServiceWorker?.setSingleTouchData(
              SingleTouch(x: event.position.dx, y: event.position.dy),
            );
          },
        ),
      ],
    );
  }
}

/// UDP送信でエラーが起きた際に表示される画面
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.error});
  final Object error;

  @override
  Widget build(BuildContext context) {
    logBuildAction();
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // textBaseline: TextBaseline.ideographic,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 30,
                      color: Theme.of(context).textTheme.displaySmall!.color,
                    ),
                    Text(
                      AppLocalizations.of(context)!.errorTitle,
                      style: const TextStyle(fontSize: 45),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              spacing: 30,
              children: [
                Text(_getLocalizedErrorMessage(context, error)),
                FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                  onPressed: () => context.go(Routes.setting),
                  child: Text(
                    AppLocalizations.of(context)!.backToSetting,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // エラーメッセージをローカライズ
  String _getLocalizedErrorMessage(BuildContext context, Object e) {
    logger.e('エラーテキスト分岐', error: e);
    if (e is UdpServiceAlreadyRunningError) {
      return AppLocalizations.of(context)!.udpServiceAlreadyRunningErrorMessage;
    }
    if (e is ArgumentError) {
      final message = e.message.toString().toLowerCase();
      if (message.contains('internet address')) {
        return AppLocalizations.of(context)!.ipAddressInvalidErrorMessage;
      } else if (message.contains('port')) {
        return AppLocalizations.of(context)!.portNumberInvalidErrorMessage;
      }
    }
    if (e is SocketException) {
      return AppLocalizations.of(context)!.socketExceptionErrorMessage;
    }
    return '${AppLocalizations.of(context)!.somethingWentWrongErrorMessage}\n${e.toString().substring(0, 200)}';
  }
}

/// UDP送信レートを表示するウィジェット
///
/// メインスレッドで[UdpSenderService]を動かしていたときは、
/// 簡単に実際のレートを取得できたが、今はRemote Isolateで動かしているため、
/// 設定されたレートを表示するだけにしている。
class UdpServiceIndicator extends HookConsumerWidget {
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
