// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreResponse _$StoreResponseFromJson(Map<String, dynamic> json) =>
    StoreResponse(
      stores: (json['stores'] as List<dynamic>)
          .map((e) => Store.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeStore: json['activeStore'] as String?,
      recordingTime: (json['recordingTime'] as num?)?.toInt(),
      expireLicenseDate: json['expireLicenseDate'] == null
          ? null
          : DateTime.parse(json['expireLicenseDate'] as String),
    );

Map<String, dynamic> _$StoreResponseToJson(StoreResponse instance) =>
    <String, dynamic>{
      'stores': instance.stores.map((e) => e.toJson()).toList(),
      'activeStore': instance.activeStore,
      'recordingTime': instance.recordingTime,
      'expireLicenseDate': instance.expireLicenseDate?.toIso8601String(),
    };
