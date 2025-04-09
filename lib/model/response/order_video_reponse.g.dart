// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_video_reponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListVideoOrderResponse _$ListVideoOrderResponseFromJson(
        Map<String, dynamic> json) =>
    ListVideoOrderResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => OrderVideoResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ListVideoOrderResponseToJson(
        ListVideoOrderResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'total': instance.total,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };

OrderVideoResponse _$OrderVideoResponseFromJson(Map<String, dynamic> json) =>
    OrderVideoResponse(
      id: json['id'] as String?,
      storeId: json['storeId'] as String?,
      startTime: json['startTime'] as String?,
      orderCode: json['orderCode'] as String?,
      orderType: json['orderType'] as String?,
      orderNote: json['orderNote'] as String?,
      orderAddress: json['orderAddress'] as String?,
    );

Map<String, dynamic> _$OrderVideoResponseToJson(OrderVideoResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storeId': instance.storeId,
      'startTime': instance.startTime,
      'orderCode': instance.orderCode,
      'orderType': instance.orderType,
      'orderNote': instance.orderNote,
      'orderAddress': instance.orderAddress,
    };
