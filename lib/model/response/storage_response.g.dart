// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StorageResponse _$StorageResponseFromJson(Map<String, dynamic> json) =>
    StorageResponse(
      amount: (json['amount'] as num).toInt(),
      limitAmount: (json['limitAmount'] as num).toInt(),
    );

Map<String, dynamic> _$StorageResponseToJson(StorageResponse instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'limitAmount': instance.limitAmount,
    };
