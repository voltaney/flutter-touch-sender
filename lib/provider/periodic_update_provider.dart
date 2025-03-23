import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:touch_sender/util/logger.dart';

part 'periodic_update_provider.g.dart';

@riverpod
class OneSecondUpdate extends _$OneSecondUpdate {
  late final Timer _timer;
  static const Duration _updateInterval = Duration(seconds: 1);
  @override
  DateTime build() {
    _timer = Timer.periodic(_updateInterval, (timer) {
      state = DateTime.now();
    });
    ref.onDispose(() {
      logger.i('OneSecondUpdateProvider disposed');
      _timer.cancel();
    });
    return DateTime.now();
  }
}
