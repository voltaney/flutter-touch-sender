import 'package:logger/logger.dart';

Logger get logger => Log.instance;

class Log extends Logger {
  Log._() : super(printer: SimplePrinter());
  static final instance = Log._();
}
