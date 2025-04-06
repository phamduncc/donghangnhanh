// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_video_reponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderVideoResponse _$OrderVideoResponseFromJson(Map<String, dynamic> json) =>
    OrderVideoResponse(
      id: (json['id'] as num?)?.toInt(),
      url: json['url'] as String?,
      orderDate: json['orderDate'] as String?,
      orderStatus: json['orderStatus'] as String?,
      orderType: json['orderType'] as String?,
      orderNote: json['orderNote'] as String?,
      orderAddress: json['orderAddress'] as String?,
    );

Map<String, dynamic> _$OrderVideoResponseToJson(OrderVideoResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'orderDate': instance.orderDate,
      'orderStatus': instance.orderStatus,
      'orderType': instance.orderType,
      'orderNote': instance.orderNote,
      'orderAddress': instance.orderAddress,
    };
