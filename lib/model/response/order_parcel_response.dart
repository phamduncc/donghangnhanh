import 'package:json_annotation/json_annotation.dart';

part 'order_parcel_response.g.dart';
@JsonSerializable()
class ListOrderParcelResponse{
  List<OrderParcelResponse>? data;
  int? total;
  int? page;
  int? pageSize;
  ListOrderParcelResponse({
    this.data,
    this.total,
    this.page,
    this.pageSize,
  });
  // Factory constructor to create an instance from JSON
  factory ListOrderParcelResponse.fromJson(Map<String, dynamic> json) => _$ListOrderParcelResponseFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$ListOrderParcelResponseToJson(this);
}

@JsonSerializable()
class OrderParcelResponse {
  String? id;
  String? storeId;
  String? parcelCode;
  String? name;
  int? numItems;
  String? shippingCompany;
  String? shippingCompanyDescription;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? createdBy;
  OrderParcelResponse({
    this.id,
    this.storeId,
    this.name,
    this.createdAt,
    this.createdBy,
    this.numItems,
    this.parcelCode,
    this.shippingCompany,
    this.shippingCompanyDescription,
    this.updatedAt,
  });
  // Factory constructor to create an instance from JSON
  factory OrderParcelResponse.fromJson(Map<String, dynamic> json) => _$OrderParcelResponseFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$OrderParcelResponseToJson(this);
}