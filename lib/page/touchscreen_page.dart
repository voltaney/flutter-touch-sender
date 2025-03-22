import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:touch_sender/router/routes.dart';
import 'package:touch_sender/util/logger.dart';

class TouchScreenPage extends StatelessWidget {
  const TouchScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    logger.d('TouchScreenPage build');
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('FullScreenPage'),
            IconButton(
              onPressed: () => context.go(Routes.setting),
              icon: const Icon(Icons.play_arrow),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(Routes.setting),
        child: const Icon(Icons.play_arrow),
      ),
      extendBody: true,
    );
  }
}
