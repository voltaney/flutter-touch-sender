import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touch_sender/l10n/app_localizations.dart';
import 'package:touch_sender/provider/settings_provider.dart';
import 'package:touch_sender/provider/shared_preferences_provider.dart';
import 'package:touch_sender/router/app_router.dart';
import 'package:touch_sender/util/logger.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: Colors.amber,
  brightness: Brightness.light,
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: Colors.amber,
  brightness: Brightness.dark,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MainApp(),
    ),
  );
}

class UdpSender {
  final String _targetIp = '192.168.0.15';
  Timer? sendTimer;
  void startTimer() async {
    if (sendTimer != null) {
      if (sendTimer?.isActive ?? false) {
        sendTimer?.cancel();
        logger.d('Timer canceled');
        return;
      }
    } else {
      logger.d('Timer not found. Start new timer');
    }
    var count = 0;
    var fails = 0;
    final srcPort = 60000;
    final targetPort = 60001;
    const Duration interval = Duration(microseconds: 10);
    // UDPソケットをバインド
    RawDatagramSocket socket;
    try {
      socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, srcPort);
    } on SocketException catch (e) {
      logger.e('ソケットのバインドに失敗しました', error: e);
      return;
    }
    sendTimer = Timer.periodic(interval, (timer) {
      String message = 'tick(${timer.tick}) count($count)\n';
      if (!socket.writeEventsEnabled) return;
      // Uint8List data = Uint8List.fromList(message.codeUnits);

      final dataSize = socket.send(
        const Utf8Codec().encode(message),
        InternetAddress(_targetIp),
        targetPort,
      );
      if (dataSize <= 0) {
        fails += 1;
      } else {
        count += 1;
      }
      // logger.d(
      //   'tick(${timer.tick}) count($count) fails($fails) hertz(${count / (timer.tick * 10 / 1000)}) ($dataSize)',
      // );
    });
  }
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(isDarkThemeProvider);
    return MaterialApp.router(
      title: 'Touch Sender',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      routerConfig: appRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
