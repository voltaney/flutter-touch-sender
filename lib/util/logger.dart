import 'package:logger/logger.dart';
import 'package:stack_trace/stack_trace.dart';

Logger get logger => Log.instance;

class Log extends Logger {
  Log._() : super(printer: SimplePrinter());
  static final instance = Log._();
}

void logBuildAction() {
  final frames = Trace.current().frames;
  // frames[0] is the current method
  final frame = frames[1];
  logger.d('<build> ${frame.member}');
}
