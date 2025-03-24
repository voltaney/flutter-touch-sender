// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'udp_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UdpPayload _$UdpPayloadFromJson(Map<String, dynamic> json) => UdpPayload(
  id: (json['id'] as num).toInt(),
  deviceInfo: DeviceInfo.fromJson(json['deviceInfo'] as Map<String, dynamic>),
  singleTouch: SingleTouch.fromJson(
    json['singleTouch'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$UdpPayloadToJson(UdpPayload instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deviceInfo': instance.deviceInfo.toJson(),
      'singleTouch': instance.singleTouch.toJson(),
    };

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) => DeviceInfo(
  width: (json['width'] as num).toInt(),
  height: (json['height'] as num).toInt(),
);

Map<String, dynamic> _$DeviceInfoToJson(DeviceInfo instance) =>
    <String, dynamic>{'width': instance.width, 'height': instance.height};

SingleTouch _$SingleTouchFromJson(Map<String, dynamic> json) => SingleTouch(
  x: (json['x'] as num?)?.toDouble(),
  y: (json['y'] as num?)?.toDouble(),
);

Map<String, dynamic> _$SingleTouchToJson(SingleTouch instance) =>
    <String, dynamic>{'x': instance.x, 'y': instance.y};
