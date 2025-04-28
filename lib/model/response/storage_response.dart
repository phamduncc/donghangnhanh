import 'package:json_annotation/json_annotation.dart';

part 'storage_response.g.dart';

@JsonSerializable()
class StorageResponse{
  int amount;
  int limitAmount;
  StorageResponse({
    required this.amount,
    required this.limitAmount,
});
  // Factory constructor to create an instance from JSON
  factory StorageResponse.fromJson(Map<String, dynamic> json) => _$StorageResponseFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$StorageResponseToJson(this);
}