import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:stack_trace/stack_trace.dart';

Logger get logger => Log.instance;

class Log extends Logger {
  Log._() : super(printer: SimplePrinter());
  static final instance = Log._();
}

// 直近のbuildメソッドをログに出力する
void logBuildAction() {
  if (!kDebugMode) return;
  final frames = Trace.current().frames;
  final nearestBuild = frames.firstWhereOrNull(
    (frame) => frame.member?.endsWith('.build') ?? false,
  );
  logger.d('<build> ${nearestBuild?.member ?? 'NotFound'}');
}
