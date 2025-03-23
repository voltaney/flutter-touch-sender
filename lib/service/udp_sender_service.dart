import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:touch_sender/model/udp_payload.dart';
import 'package:touch_sender/util/logger.dart';

class UdpSenderService {
  final String destinationIp;
  final int destinationPortNumber;
  final int sendingRate;
  late final Duration sendingRateDuration;
  Timer? _timer;
  final _singleTouch = SingleTouch();
  int sendingCount = 0;
  int successCount = 0;

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

  double get successRate => sendingCount == 0 ? 1 : successCount / sendingCount;

  int get actualSendingRate => (sendingRate * successRate).round();

  void start() {
    // Start sending UDP packets
    sendingCount = successCount = 0;
    logger.i('送信開始！${toString()}');
    _timer = Timer.periodic(sendingRateDuration, (timer) {
      final view = WidgetsBinding.instance.platformDispatcher.views.first;
      final size = view.physicalSize / view.devicePixelRatio;
      // final window =
      //     WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
      logger.i(
        UdpPayload(
          deviceInfo: DeviceInfo(
            width: size.width.toInt(),
            height: size.height.toInt(),
          ),
          singleTouch: _singleTouch,
        ).toJson(),
      );
      sendingCount++;
      successCount++;
    });
  }

  void stop() {
    // Stop sending UDP packets
    logger.i('送信停止！');
    _timer?.cancel();
  }

  bool isRunning() {
    return _timer?.isActive ?? false;
  }

  @override
  String toString() {
    return '{IP: $destinationIp, PortNumber: $destinationPortNumber, Rate: $sendingRate Hz}';
  }
}

// class Touch
