import 'dart:async';
import 'dart:isolate';

import 'package:touch_sender/model/udp_payload.dart';
import 'package:touch_sender/service/udp_sender_service.dart';
import 'package:touch_sender/util/logger.dart';

enum IsolateWorkerState { starting, notStarted, running, closed }

enum DataType { singleTouch, deviceInfo }

/// [UdpSenderService]を**Main isolate**と**Remote isolate**間で強調して実行するWorker。
///
/// Remote isolateにおいて発生した例外はMain isolateに通知される。
class UdpSenderServiceWorker {
  var _state = IsolateWorkerState.notStarted;
  SendPort? _commands;
  ReceivePort? _responses;
  Function(Object)? _onRemoteIsolateError;

  /// **Main isolate**
  ///
  /// [SingleTouch]オブジェクトをRemote Isolateに送信する。
  void setSingleTouchData(SingleTouch? touch) {
    if (!isRunning) return;
    _commands?.send((DataType.singleTouch, touch));
  }

  void setDeviceInfo(DeviceInfo deviceInfo) {
    if (!isRunning) return;
    _commands?.send((DataType.deviceInfo, deviceInfo));
  }

  /// **Main Isolate**
  ///
  /// 新しいIsolate（Remote Isolate）を生成し、Isolate間で通信するためのポートを割り当てる。
  /// スポーンされたIsolateでサービス([UdpSenderService])が開始される。
  ///
  /// [onRemoteIsolateError]コールバックは、**REMOTE** Isolateでエラーが発生したときに、**MAIN** Isolateで呼び出される。
  ///
  /// ```dart
  /// final worker = await UdpSenderServiceWorker.spawn(service, onError: (error)=> print(error));
  /// ```
  Future<void> start({
    required UdpSenderService service,
    Function(Object)? onRemoteIsolateError,
  }) async {
    if (!_canStart) {
      throw StateError('Isolateが既に起動しています。');
    }
    _state = IsolateWorkerState.starting;

    final initPort = RawReceivePort();
    final connection = Completer<(ReceivePort, SendPort)>.sync();
    initPort.handler = (message) {
      final commandPort = message as SendPort;
      connection.complete((
        ReceivePort.fromRawReceivePort(initPort),
        commandPort,
      ));
    };
    try {
      await Isolate.spawn(_startRemoteIsolate(service), initPort.sendPort);
    } on Object {
      initPort.close();
      rethrow;
    }

    final (ReceivePort receivePort, SendPort sendPort) =
        await connection.future;
    _responses = receivePort;
    _commands = sendPort;
    _onRemoteIsolateError = onRemoteIsolateError;

    _responses?.listen(_handleResponsesFromIsolate);
    _state = IsolateWorkerState.running;
  }

  bool get isRunning => _state == IsolateWorkerState.running;

  IsolateWorkerState get currentState => _state;
  bool get _canStart =>
      _state == IsolateWorkerState.notStarted ||
      _state == IsolateWorkerState.closed;

  /// **Main isolate**
  ///
  /// Remote Isolateからのメッセージを処理する。メッセージは[Error]または[Exception]のみを想定。
  /// それ以外のメッセージが送信された場合は、[StateError]をスローする。
  void _handleResponsesFromIsolate(dynamic message) {
    if (message is Error || message is Exception) {
      close();
      _onRemoteIsolateError?.call(message);
    } else {
      throw StateError('Remote Isolateからの不正なメッセージ: $message');
    }
  }

  /// **Remote isolate**
  ///
  /// Main isolateから送られてきたコマンドを処理する。
  ///
  /// メッセージが[shutdown]の場合、サービスを停止しIsolateを終了する。
  /// それ以外のメッセージは[SingleTouch]オブジェクトであることを想定し、[service]に渡す。
  ///
  /// クローズ処理:
  /// 1. サービスを停止する。
  /// 2. 受信ポートをクローズする。
  /// 3. 現在のIsolate（自分自身）を終了する。
  static void _handleCommandsToIsolate(
    ReceivePort receivePort,
    SendPort sendPort,
    UdpSenderService service,
  ) async {
    receivePort.listen((message) {
      if (message == 'shutdown') {
        logger.i('Remote isolateをシャットダウンします。');
        service.stop();
        receivePort.close();
        Isolate.current.kill();
        return;
      }
      final (DataType t, dynamic data) = message;
      switch (t) {
        case DataType.singleTouch:
          service.setSingleTouchData(data);
          break;
        case DataType.deviceInfo:
          service.setDeviceInfo(data);
          break;
      }
    });
  }

  /// **Remote isolate**
  ///
  /// Remote Isolateで実行される関数を返す。
  /// [UdpSenderService]は外部のデータをそのまま引き渡したいため、クロージャの形をとっている。
  ///
  /// ただし、[UdpSenderService]への変更はRemote Isolate内でのみ有効であり、Main Isolateには影響しない。
  /// 例外が発生した場合は、Main Isolateにエラーオブジェクトを送信する。
  static Function(SendPort) _startRemoteIsolate(UdpSenderService service) {
    return (SendPort sendPort) async {
      final receivePort = ReceivePort();
      sendPort.send(receivePort.sendPort);
      try {
        await service.start(
          // サービス内部のTimer.periodicで発生したエラーは、このコールバックで受け取る。
          onError: (error, stackTrace) {
            sendPort.send(error);
          },
        );
      } catch (e) {
        // サービス内部のその他のエラーはここで処理する。
        sendPort.send(e);
      }
      _handleCommandsToIsolate(receivePort, sendPort, service);
    };
  }

  /// **Main isolate**
  ///
  /// Remote Isolateにシャットダウン命令を送信し、[ReceivePort]をクローズする。
  void close() {
    if (isRunning) {
      logger.i('Remote isolateにシャットダウン命令＆Main Isolateのポートクローズ');
      _commands?.send('shutdown');
      _responses?.close();
      _state = IsolateWorkerState.closed;
    }
  }
}
