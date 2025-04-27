import 'package:json_annotation/json_annotation.dart';

import 'list_parcel_items_response.dart';

part 'order_stats.g.dart';
@JsonSerializable()
class OrderStats{
  int? totalInDay;
  int? totalInbound;
  int? totalOutbound;
  int? totalPacking;
  OrderStats({
    this.totalInbound,
    this.totalInDay,
    this.totalOutbound,
    this.totalPacking,
  });
      // Factory constructor to create an instance from JSON
  factory OrderStats.fromJson(Map<String, dynamic> json) => _$OrderStatsFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$OrderStatsToJson(this);
}