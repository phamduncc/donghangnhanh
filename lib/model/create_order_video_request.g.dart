// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_video_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderVideoRequest _$CreateOrderVideoRequestFromJson(
        Map<String, dynamic> json) =>
    CreateOrderVideoRequest(
      orderCode: json['orderCode'] as String?,
      type: json['type'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      fileMetadataId: json['fileMetadataId'] as String?,
      prepareCode: json['prepareCode'] as String?,
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      updateStorage: json['updateStorage'] as bool?,
    );

Map<String, dynamic> _$CreateOrderVideoRequestToJson(
        CreateOrderVideoRequest instance) =>
    <String, dynamic>{
      'fileMetadataId': instance.fileMetadataId,
      'orderCode': instance.orderCode,
      'type': instance.type,
      'prepareCode': instance.prepareCode,
      'updateStorage': instance.updateStorage,
      'startTime': instance.startTime?.toIso8601String(),
      'duration': instance.duration,
    };
