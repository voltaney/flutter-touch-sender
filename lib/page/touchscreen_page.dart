import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:touch_sender/l10n/app_localizations.dart';
import 'package:touch_sender/provider/periodic_update_provider.dart';
import 'package:touch_sender/provider/udp_service_provider.dart';
import 'package:touch_sender/router/routes.dart';
import 'package:touch_sender/service/udp_sender_service.dart';
import 'package:touch_sender/util/logger.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class ControlButton extends ConsumerWidget {
  const ControlButton({super.key, required this.currentState});
  final UdpSenderServiceState currentState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logBuildAction();
    return switch (currentState) {
      UdpSenderServiceState.running => ElevatedButton(
        onPressed: () {
          ref.read(udpSenderServiceRunnerProvider.notifier).stop();
        },
        child: const Icon(Icons.stop, size: TouchScreenPage.iconSize),
      ),
      UdpSenderServiceState.stopped => ElevatedButton(
        onPressed: () async {
          await ref.read(udpSenderServiceRunnerProvider.notifier).start();
        },
        child: const Icon(Icons.play_arrow, size: TouchScreenPage.iconSize),
      ),
    };
  }
}

class TouchScreen extends HookConsumerWidget {
  const TouchScreen({super.key, required this.currentState});
  final UdpSenderServiceState currentState;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logBuildAction();
    final udpSenderService = ref.watch(udpSenderServiceProvider);
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
            udpSenderService.setSingleTouchData(x: null, y: null);
          },
          onPointerMove: (event) {
            udpSenderService.setSingleTouchData(
              x: event.position.dx.toInt(),
              y: event.position.dy.toInt(),
            );
          },
        ),
      ],
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.error});
  final Object error;

  @override
  Widget build(BuildContext context) {
    logBuildAction();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TODO: ローカライズ
          Text(
            'エラーが発生しました。',
            style: Theme.of(context).primaryTextTheme.displayMedium,
          ),
          Text(_getLocalizedErrorMessage(context, error)),
          ElevatedButton(
            onPressed: () => context.go(Routes.setting),
            child: const Text('設定画面に戻る'),
          ),
        ],
      ),
    );
  }

  // TODO: ローカライズ
  String _getLocalizedErrorMessage(BuildContext context, Object e) {
    logger.w('エラーテキスト分岐: $e');
    if (e is UdpServiceAlreadyRunningError) return 'UDPサービスは既に実行中です。';
    if (e is ArgumentError) {
      final message = e.message.toString().toLowerCase();
      if (message.contains('internet address')) {
        return 'IPアドレスの解決に失敗しました。';
      } else if (message.contains('port')) {
        return 'ポート番号が不正です。';
      }
    }
    if (e is SocketException) return 'ソケットのバインドに失敗しました。';
    return 'エラーが発生しました。';
  }
}

class TouchScreenPage extends HookConsumerWidget {
  const TouchScreenPage({super.key});
  static const double iconSize = 20;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logBuildAction();
    // フルスクリーン
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    final udpSenderServiceRunner = ref.watch(udpSenderServiceRunnerProvider);

    useEffect(() {
      // この画面にいるときはスリープさせない
      WakelockPlus.enable();
      return WakelockPlus.disable;
    }, []);

    useOnAppLifecycleStateChange((before, current) {
      // アプリがバックグラウンドに行ったらUDP送信を停止する
      switch (current) {
        case AppLifecycleState.inactive:
          ref.read(udpSenderServiceRunnerProvider.notifier).stop();
          break;
        default:
          break;
      }
    });

    // UdpSenderServiceRunnerの状態によって表示を切り替える
    return Scaffold(
      body: switch (udpSenderServiceRunner) {
        AsyncError(:final error) => ErrorScreen(error: error),
        AsyncData(:final value) => TouchScreen(currentState: value),
        _ => const CircularProgressIndicator(),
      },
    );
  }
}

class UdpServiceIndicator extends HookConsumerWidget {
  const UdpServiceIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logBuildAction();
    final udpSenderService = ref.watch(udpSenderServiceProvider);
    // 1秒ごとに値を更新するためのプロバイダ
    // ignore: unused_local_variable
    final oneSecondUpdate = ref.watch(oneSecondUpdateProvider);
    final sendingRate = useState(udpSenderService.sendingRate);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.expectedSendingRate(sendingRate.value),
        ),
        Text(
          AppLocalizations.of(
            context,
          )!.actualSendingRate(udpSenderService.actualSendingRate),
        ),
      ],
    );
  }
}
