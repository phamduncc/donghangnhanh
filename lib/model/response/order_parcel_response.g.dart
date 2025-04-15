// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_parcel_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListOrderParcelResponse _$ListOrderParcelResponseFromJson(
        Map<String, dynamic> json) =>
    ListOrderParcelResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => OrderParcelResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ListOrderParcelResponseToJson(
        ListOrderParcelResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'total': instance.total,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };

OrderParcelResponse _$OrderParcelResponseFromJson(Map<String, dynamic> json) =>
    OrderParcelResponse(
      id: json['id'] as String?,
      storeId: json['storeId'] as String?,
      name: json['name'] as String?,
      createAt: json['createAt'] == null
          ? null
          : DateTime.parse(json['createAt'] as String),
      createBy: json['createBy'] as String?,
      numItems: (json['numItems'] as num?)?.toInt(),
      parcelCode: json['parcelCode'] as String?,
      shippingCompany: json['shippingCompany'] as String?,
      shippingCompanyDescription: json['shippingCompanyDescription'] as String?,
      updateAt: json['updateAt'] == null
          ? null
          : DateTime.parse(json['updateAt'] as String),
    );

Map<String, dynamic> _$OrderParcelResponseToJson(
        OrderParcelResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storeId': instance.storeId,
      'parcelCode': instance.parcelCode,
      'name': instance.name,
      'numItems': instance.numItems,
      'shippingCompany': instance.shippingCompany,
      'shippingCompanyDescription': instance.shippingCompanyDescription,
      'createAt': instance.createAt?.toIso8601String(),
      'updateAt': instance.updateAt?.toIso8601String(),
      'createBy': instance.createBy,
    };
