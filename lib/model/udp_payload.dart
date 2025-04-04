import 'package:json_annotation/json_annotation.dart';

part 'udp_payload.g.dart';

@JsonSerializable(explicitToJson: true)
class UdpPayload {
  int id;
  DeviceInfo deviceInfo;
  SingleTouch? singleTouch;

  UdpPayload({
    required this.id,
    required this.deviceInfo,
    required this.singleTouch,
  });
  factory UdpPayload.fromJson(Map<String, dynamic> json) =>
      _$UdpPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$UdpPayloadToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DeviceInfo {
  int width;
  int height;

  DeviceInfo({required this.width, required this.height});
  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SingleTouch {
  double x;
  double y;

  SingleTouch({required this.x, required this.y});
  factory SingleTouch.fromJson(Map<String, dynamic> json) =>
      _$SingleTouchFromJson(json);
  Map<String, dynamic> toJson() => _$SingleTouchToJson(this);
}
