import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:touch_sender/model/udp_payload.dart';
import 'package:touch_sender/util/logger.dart';

final maxIndex = 100000;

class UdpServiceAlreadyRunningError extends Error {
  final String message = 'The UDP service is already running.';
}

class UdpSenderService {
  final String destinationIp;
  final int destinationPortNumber;
  final int sendingRate;
  late final Duration sendingRateDuration;
  Timer? _timer;
  SingleTouch? _singleTouch;
  late DeviceInfo _deviceInfo;
  int _sendingCount = 0;
  int _successCount = 0;
  int _payloadId = 0;

  UdpSenderService({
    required this.destinationIp,
    required this.destinationPortNumber,
    required this.sendingRate,
  }) {
    sendingRateDuration = Duration(
      microseconds: (pow(10, 6) / sendingRate).round(),
    );
    _deviceInfo = DeviceInfo(width: 100, height: 100);
  }

  void setSingleTouchData(SingleTouch? touch) {
    _singleTouch = touch;
  }

  void setDeviceInfo(DeviceInfo deviceInfo) {
    _deviceInfo = deviceInfo;
  }

  double get successRate =>
      _sendingCount == 0 ? 1 : _successCount / _sendingCount;

  int get actualSendingRate => (sendingRate * successRate).round();

  Future<void> start({Function(Object, StackTrace)? onError}) async {
    if (isRunning()) {
      logger.w('既にUDP送信が開始されています。これは不正な状態です。');
      throw UdpServiceAlreadyRunningError();
    }

    logger.i('UDP通信で使用するソケットを準備します。');
    _payloadId = _sendingCount = _successCount = 0;
    // UDPソケットをバインド
    RawDatagramSocket socket;
    InternetAddress address;
    try {
      address = InternetAddress(destinationIp);
    } on ArgumentError catch (e) {
      logger.e('IPアドレスの解決に失敗しました', error: e);
      rethrow;
    }
    try {
      // Any IP address and any port number
      socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    } on SocketException catch (e) {
      logger.e('ソケットのバインドに失敗しました', error: e);
      rethrow;
    }
    logger.i('Timer.periodicによるUDPの定期送信を開始します。');
    _timer = Timer.periodic(sendingRateDuration, (timer) {
      try {
        // 画面の論理サイズを取得
        // final view = WidgetsBinding.instance.platformDispatcher.views.first;
        // final size = view.physicalSize / view.devicePixelRatio;
        logger.d('UDP送信$_payloadId');
        final dataSize = socket.send(
          const Utf8Codec().encode(
            jsonEncode(
              UdpPayload(
                id: _payloadId,
                deviceInfo: _deviceInfo,
                singleTouch: _singleTouch,
              ).toJson(),
            ),
          ),
          address,
          destinationPortNumber,
        );
        _sendingCount++;
        _successCount += dataSize > 0 ? 1 : 0;
        // 送信IDを更新。最大値に達したら0に戻す。
        _payloadId = (_payloadId + (dataSize > 0 ? 1 : 0)) % maxIndex;
      } catch (e, stackTrace) {
        logger.e('UDP送信中にエラーが発生しました', error: e, stackTrace: stackTrace);
        timer.cancel();
        onError?.call(e, stackTrace);
      }
    });
  }

  void stop() {
    logger.i('Timer.periodicによるUDPの定期送信を停止します。[タスク状態]:${isRunning()}');
    _timer?.cancel();
  }

  bool isRunning() {
    return _timer?.isActive == true;
  }

  @override
  String toString() {
    return '{IP: $destinationIp, PortNumber: $destinationPortNumber, Rate: $sendingRate Hz}';
  }
}
