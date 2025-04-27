// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderStats _$OrderStatsFromJson(Map<String, dynamic> json) => OrderStats(
      totalInbound: (json['totalInbound'] as num?)?.toInt(),
      totalInDay: (json['totalInDay'] as num?)?.toInt(),
      totalOutbound: (json['totalOutbound'] as num?)?.toInt(),
      totalPacking: (json['totalPacking'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OrderStatsToJson(OrderStats instance) =>
    <String, dynamic>{
      'totalInDay': instance.totalInDay,
      'totalInbound': instance.totalInbound,
      'totalOutbound': instance.totalOutbound,
      'totalPacking': instance.totalPacking,
    };
