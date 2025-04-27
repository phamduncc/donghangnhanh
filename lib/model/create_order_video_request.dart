import 'package:json_annotation/json_annotation.dart';

part 'create_order_video_request.g.dart';
@JsonSerializable()
class CreateOrderVideoRequest{
  String? fileMetadataId;
  String? orderCode;
  String? type;
  String? prepareCode;
  bool? updateStorage;
  DateTime? startTime;
  int? duration;

  CreateOrderVideoRequest({
    this.orderCode,
    this.type,
    this.duration,
    this.fileMetadataId,
    this.prepareCode,
    this.startTime,
    this.updateStorage,
  });

  // Factory constructor to create an instance from JSON
  factory CreateOrderVideoRequest.fromJson(Map<String, dynamic> json) => _$CreateOrderVideoRequestFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$CreateOrderVideoRequestToJson(this);
}