import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touch_sender/l10n/app_localizations.dart';
import 'package:touch_sender/router/routes.dart';
import 'package:touch_sender/service/udp_sender_service.dart';
import 'package:touch_sender/util/logger.dart';

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
    logger.e;
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
