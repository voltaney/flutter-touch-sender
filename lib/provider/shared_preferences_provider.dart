import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences_provider.g.dart';

@riverpod
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError();
}

// final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
//   throw UnimplementedError();
// });

// constant keys for shared preferences
class SharedPreferencesKeys {
  static const String isDarkTheme = 'isDarkTheme';
  static const String ipAddress = 'ipAddress';
  static const String portNumber = 'portNumber';
  static const String sendingRate = 'sendingRate';
}
