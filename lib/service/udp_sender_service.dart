import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:touch_sender/model/udp_payload.dart';
import 'package:touch_sender/util/logger.dart';

enum UdpSenderServiceState { stopped, running }

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
  final _singleTouch = SingleTouch();
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
  }

  void setSingleTouchData({required int? x, required int? y}) {
    _singleTouch.x = x;
    _singleTouch.y = y;
  }

  double get successRate =>
      _sendingCount == 0 ? 1 : _successCount / _sendingCount;

  int get actualSendingRate => (sendingRate * successRate).round();

  Future<void> start({Function(Object, StackTrace)? onError}) async {
    if (currentState == UdpSenderServiceState.running) {
      logger.w('既にUDP送信が開始されています。これは不正な状態です。');
      throw UdpServiceAlreadyRunningError();
    }
    // Start sending UDP packets
    _payloadId = _sendingCount = _successCount = 0;
    logger.w('送信開始！${toString()}');
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
    _timer = Timer.periodic(sendingRateDuration, (timer) {
      try {
        // 画面の論理サイズを取得
        final view = WidgetsBinding.instance.platformDispatcher.views.first;
        final size = view.physicalSize / view.devicePixelRatio;
        logger.i(
          UdpPayload(
            id: _payloadId,
            deviceInfo: DeviceInfo(
              width: size.width.toInt(),
              height: size.height.toInt(),
            ),
            singleTouch: _singleTouch,
          ).toJson(),
        );
        final dataSize = socket.send(
          const Utf8Codec().encode(
            jsonEncode(
              UdpPayload(
                id: _payloadId,
                deviceInfo: DeviceInfo(
                  width: size.width.toInt(),
                  height: size.height.toInt(),
                ),
                singleTouch: _singleTouch,
              ).toJson(),
            ),
          ),
          address,
          destinationPortNumber,
        );
        _sendingCount++;
        _successCount += dataSize > 0 ? 1 : 0;
        _payloadId = (_payloadId + (dataSize > 0 ? 1 : 0)) % maxIndex;
      } catch (e, stackTrace) {
        logger.e('UDP送信中にエラーが発生しました', error: e, stackTrace: stackTrace);
        onError?.call(e, stackTrace);
        timer.cancel();
      }
    });
  }

  void stop() {
    // Stop sending UDP packets
    logger.i('送信停止！');
    _timer?.cancel();
  }

  UdpSenderServiceState get currentState =>
      _timer?.isActive == true
          ? UdpSenderServiceState.running
          : UdpSenderServiceState.stopped;

  @override
  String toString() {
    return '{IP: $destinationIp, PortNumber: $destinationPortNumber, Rate: $sendingRate Hz}';
  }
}
