import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:touch_sender/provider/periodic_update_provider.dart';
import 'package:touch_sender/provider/udp_service_provider.dart';
import 'package:touch_sender/router/routes.dart';
import 'package:touch_sender/util/logger.dart';

class TouchScreenPage extends HookConsumerWidget {
  const TouchScreenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logBuildAction();
    final udpSenderService = ref.watch(udpSenderServiceProvider);
    useEffect(() {
      logger.d('useEffect画面遷移で毎回？');
      return null;
    }, []);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return Scaffold(
      body: Stack(
        // fit: StackFit.expand,
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
                        icon: const Icon(Icons.arrow_circle_left_outlined),
                        label: const Text('Back'),
                      ),
                      const UdpServiceIndicator(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Container(color: Colors.lime),
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
      ),
    );
  }
}

class UdpServiceIndicator extends HookConsumerWidget {
  const UdpServiceIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logBuildAction();
    final udpSenderService = ref.watch(udpSenderServiceProvider);
    final oneSecondUpdate = ref.watch(oneSecondUpdateProvider);
    return Column(
      children: [
        Text('Expected: ${udpSenderService.sendingRate} Hz'),
        Text('Actual: ${udpSenderService.actualSendingRate} Hz'),
      ],
    );
  }
}
