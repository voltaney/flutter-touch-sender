import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:touch_sender/l10n/app_localizations.dart';
import 'package:touch_sender/router/routes.dart';
import 'package:touch_sender/util/logger.dart';

class ScreenBaseLayoutPage extends StatelessWidget {
  const ScreenBaseLayoutPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    logBuildAction();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: navigationShell),
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.help),
            label: AppLocalizations.of(context)!.help,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)!.setting,
          ),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
      ),
      floatingActionButton: Container(
        height: 70,
        width: 70,
        margin: const EdgeInsets.only(top: 10),
        child: FloatingActionButton(
          onPressed: () => context.go(Routes.touchScreen),
          shape: const CircleBorder(),
          child: const Icon(Icons.play_circle, size: 45),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
