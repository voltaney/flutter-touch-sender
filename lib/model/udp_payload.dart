import 'package:json_annotation/json_annotation.dart';

part 'udp_payload.g.dart';

@JsonSerializable(explicitToJson: true, createFactory: true, createToJson: true)
class UdpPayload {
  DeviceInfo deviceInfo;
  SingleTouch singleTouch;

  UdpPayload({required this.deviceInfo, required this.singleTouch});
  factory UdpPayload.fromJson(Map<String, dynamic> json) =>
      _$UdpPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$UdpPayloadToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DeviceInfo {
  int? width;
  int? height;

  DeviceInfo({this.width, this.height});
  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SingleTouch {
  int? x;
  int? y;

  SingleTouch({this.x, this.y});
  factory SingleTouch.fromJson(Map<String, dynamic> json) =>
      _$SingleTouchFromJson(json);
  Map<String, dynamic> toJson() => _$SingleTouchToJson(this);
}
