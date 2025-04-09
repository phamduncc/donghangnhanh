import 'package:json_annotation/json_annotation.dart';

part 'order_video_reponse.g.dart';
@JsonSerializable()
class ListVideoOrderResponse{
  List<OrderVideoResponse>? data;
  int? total;
  int? page;
  int? pageSize;
  ListVideoOrderResponse({
    this.data,
    this.total,
    this.page,
    this.pageSize,
  });
      // Factory constructor to create an instance from JSON
  factory ListVideoOrderResponse.fromJson(Map<String, dynamic> json) => _$ListVideoOrderResponseFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$ListVideoOrderResponseToJson(this);
}

@JsonSerializable()
class OrderVideoResponse {
  String? id;
  String? storeId;
  String? startTime;
  String? orderCode;
  String? orderType;
  String? orderNote;
  String? orderAddress;
  OrderVideoResponse({
    this.id,
    this.storeId,
    this.startTime,
    this.orderCode,
    this.orderType,
    this.orderNote,
    this.orderAddress,
  });
    // Factory constructor to create an instance from JSON
  factory OrderVideoResponse.fromJson(Map<String, dynamic> json) => _$OrderVideoResponseFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$OrderVideoResponseToJson(this);
}