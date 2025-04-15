// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_parcel_items_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListParcelItemsResponse _$ListParcelItemsResponseFromJson(
        Map<String, dynamic> json) =>
    ListParcelItemsResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => ParcelItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
    );

Map<String, dynamic> _$ListParcelItemsResponseToJson(
        ListParcelItemsResponse instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };

ParcelItem _$ParcelItemFromJson(Map<String, dynamic> json) => ParcelItem(
      id: json['id'] as String,
      parcelId: json['parcelId'] as String,
      storeId: json['storeId'] as String,
      orderCode: json['orderCode'] as String,
      fileMetadataId: json['fileMetadataId'] as String,
      isDuplicate: json['isDuplicate'] as bool,
      haveVideo: json['haveVideo'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String,
      metadata: Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ParcelItemToJson(ParcelItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parcelId': instance.parcelId,
      'storeId': instance.storeId,
      'orderCode': instance.orderCode,
      'fileMetadataId': instance.fileMetadataId,
      'isDuplicate': instance.isDuplicate,
      'haveVideo': instance.haveVideo,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'metadata': instance.metadata.toJson(),
    };

Metadata _$MetadataFromJson(Map<String, dynamic> json) => Metadata(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      storeId: json['storeId'] as String?,
      ownerStore: json['ownerStore'] as String?,
      fieldName: json['fieldName'] as String?,
      originalName: json['originalName'] as String?,
      encoding: json['encoding'] as String?,
      mimetype: json['mimetype'] as String?,
      size: (json['size'] as num?)?.toInt(),
      destination: json['destination'] as String?,
      filename: json['filename'] as String?,
      path: json['path'] as String?,
      status: json['status'] as String?,
      bucketName: json['bucketName'] as String?,
      system: json['system'] as String?,
      prefix: json['prefix'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] as String?,
    );

Map<String, dynamic> _$MetadataToJson(Metadata instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'storeId': instance.storeId,
      'ownerStore': instance.ownerStore,
      'fieldName': instance.fieldName,
      'originalName': instance.originalName,
      'encoding': instance.encoding,
      'mimetype': instance.mimetype,
      'size': instance.size,
      'destination': instance.destination,
      'filename': instance.filename,
      'path': instance.path,
      'status': instance.status,
      'bucketName': instance.bucketName,
      'system': instance.system,
      'prefix': instance.prefix,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt,
    };
