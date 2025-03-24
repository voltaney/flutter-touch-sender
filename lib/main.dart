import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touch_sender/l10n/app_localizations.dart';
import 'package:touch_sender/provider/settings_provider.dart';
import 'package:touch_sender/provider/shared_preferences_provider.dart';
import 'package:touch_sender/router/app_router.dart';

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
