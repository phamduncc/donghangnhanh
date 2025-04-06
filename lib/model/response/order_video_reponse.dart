import 'package:json_annotation/json_annotation.dart';

part 'order_video_reponse.g.dart';

@JsonSerializable()
class OrderVideoResponse {
  int? id;
  String? url;
  String? orderDate;
  String? orderStatus;
  String? orderType;
  String? orderNote;
  String? orderAddress;
  OrderVideoResponse({
    this.id,
    this.url,
    this.orderDate,
    this.orderStatus,
    this.orderType,
    this.orderNote,
    this.orderAddress,
  });
    // Factory constructor to create an instance from JSON
  factory OrderVideoResponse.fromJson(Map<String, dynamic> json) => _$OrderVideoResponseFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$OrderVideoResponseToJson(this);
}