import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:touch_sender/provider/periodic_update_provider.dart';
import 'package:touch_sender/provider/udp_service_provider.dart';
import 'package:touch_sender/router/routes.dart';
import 'package:touch_sender/util/logger.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class TouchScreenPage extends HookConsumerWidget {
  const TouchScreenPage({super.key});
  static const double iconSize = 20;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logBuildAction();
    // フルスクリーン
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    final udpSenderService = ref.watch(udpSenderServiceProvider);
    final udpSenderServiceRunning = useState(udpSenderService.isRunning());
    useEffect(() {
      // この画面にいるときはスリープさせない
      WakelockPlus.enable();
      return WakelockPlus.disable;
    }, []);

    useOnAppLifecycleStateChange((before, current) {
      switch (current) {
        case AppLifecycleState.inactive:
          udpSenderService.stop();
          udpSenderServiceRunning.value = udpSenderService.isRunning();
          break;
        default:
          break;
      }
    });

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
                        icon: const Icon(
                          Icons.arrow_circle_left_outlined,
                          size: iconSize,
                        ),
                        label: const Text('Back'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (udpSenderServiceRunning.value) {
                            udpSenderService.stop();
                          } else {
                            udpSenderService.start();
                          }
                          udpSenderServiceRunning.value =
                              udpSenderService.isRunning();
                        },
                        child:
                            udpSenderServiceRunning.value
                                ? const Icon(Icons.stop, size: iconSize)
                                : const Icon(Icons.play_arrow, size: iconSize),
                      ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Expected: ${udpSenderService.sendingRate} Hz'),
        Text('Actual: ${udpSenderService.actualSendingRate} Hz'),
      ],
    );
  }
}
