import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:touch_sender/provider/settings_provider.dart';
import 'package:touch_sender/service/udp_sender_service.dart';
import 'package:touch_sender/util/logger.dart';

part 'udp_service_provider.g.dart';

@riverpod
UdpSenderService udpSenderService(Ref ref) {
  final service = UdpSenderService(
    destinationIp: ref.read(ipAddressProvider),
    destinationPortNumber: ref.read(portNumberProvider),
    sendingRate: ref.read(sendingRateProvider),
  );
  ref.onDispose(() {
    logger.i('UdpSenderServiceProvider disposed');
    service.stop();
  });
  service.start();
  return service;
}
