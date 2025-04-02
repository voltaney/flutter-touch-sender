import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touch_sender/main_screen/help_screen.dart';
import 'package:touch_sender/main_screen/settings_screen.dart';
import 'package:touch_sender/page/main_screen_base_layout_page.dart';
import 'package:touch_sender/page/touchscreen_page.dart';
import 'package:touch_sender/router/routes.dart';
import 'package:touch_sender/util/logger.dart';

final appRouter = GoRouter(
  initialLocation: Routes.setting,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        logger.i('StatefulShellブランチビルド発火');
        return MainScreenBaseLayoutPage(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.help,
              pageBuilder:
                  (context, state) => MaterialPage(
                    key: state.pageKey,
                    child: const HelpScreen(),
                  ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.setting,
              pageBuilder:
                  (context, state) => MaterialPage(
                    key: state.pageKey,
                    child: const SettingsScreen(),
                  ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: Routes.touchScreen,
      pageBuilder:
          (context, state) =>
              MaterialPage(key: state.pageKey, child: const TouchScreenPage()),
    ),
  ],
);
