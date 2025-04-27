import 'package:json_annotation/json_annotation.dart';

part 'list_parcel_items_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ListParcelItemsResponse {
  final List<ParcelItem> data;
  final int total;
  final int page;
  final int pageSize;

  ListParcelItemsResponse({
    required this.data,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory ListParcelItemsResponse.fromJson(Map<String, dynamic> json) =>
      _$ListParcelItemsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListParcelItemsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ParcelItem {
  final String id;
  final String parcelId;
  final String storeId;
  final String orderCode;
  final String fileMetadataId;
  final bool isDuplicate;
  final bool haveVideo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final Metadata metadata;

  ParcelItem({
    required this.id,
    required this.parcelId,
    required this.storeId,
    required this.orderCode,
    required this.fileMetadataId,
    required this.isDuplicate,
    required this.haveVideo,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.metadata,
  });

  factory ParcelItem.fromJson(Map<String, dynamic> json) =>
      _$ParcelItemFromJson(json);

  Map<String, dynamic> toJson() => _$ParcelItemToJson(this);
}

@JsonSerializable()
class Metadata {
  final String? id;
  final String? userId;
  final String? storeId;
  final String? ownerStore;
  final String? fieldName;
  final String? originalName;
  final String? encoding;
  final String? mimetype;
  final int? size;
  final String? destination;
  final String? filename;
  final String? path;
  final String? status;
  final String? bucketName;
  final String? system;
  final String? prefix;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deletedAt;

  Metadata({
    this.id,
    this.userId,
    this.storeId,
    this.ownerStore,
    this.fieldName,
    this.originalName,
    this.encoding,
    this.mimetype,
    this.size,
    this.destination,
    this.filename,
    this.path,
    this.status,
    this.bucketName,
    this.system,
    this.prefix,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataToJson(this);
}
