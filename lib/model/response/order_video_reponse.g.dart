// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_video_reponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListVideoOrderResponse _$ListVideoOrderResponseFromJson(
        Map<String, dynamic> json) =>
    ListVideoOrderResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => VideoOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ListVideoOrderResponseToJson(
        ListVideoOrderResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'total': instance.total,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };

VideoOrder _$VideoOrderFromJson(Map<String, dynamic> json) => VideoOrder(
      id: json['id'] as String,
      storeId: json['storeId'] as String,
      duration: (json['duration'] as num).toInt(),
      startTime: json['startTime'] as String,
      orderCode: json['orderCode'] as String,
      prepareCode: json['prepareCode'] as String,
      metadataId: json['metadataId'] as String,
      metadataCam2Id: json['metadataCam2Id'] as String?,
      metadataCompleteId: json['metadataCompleteId'] as String?,
      status: json['status'] as String,
      slug: json['slug'] as String,
      type: json['type'] as String,
      tagId: json['tagId'] as String?,
      ownerOrg: json['ownerOrg'] as String,
      referralBy: json['referralBy'] as String?,
      ownerStore: json['ownerStore'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] as String?,
      deletedTimeline: json['deletedTimeline'] as String,
      createdBy: json['createdBy'] as String,
      driveLink: json['driveLink'] as String?,
      convertTime: json['convertTime'] as String?,
      metadata: Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VideoOrderToJson(VideoOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storeId': instance.storeId,
      'duration': instance.duration,
      'startTime': instance.startTime,
      'orderCode': instance.orderCode,
      'prepareCode': instance.prepareCode,
      'metadataId': instance.metadataId,
      'metadataCam2Id': instance.metadataCam2Id,
      'metadataCompleteId': instance.metadataCompleteId,
      'status': instance.status,
      'slug': instance.slug,
      'type': instance.type,
      'tagId': instance.tagId,
      'ownerOrg': instance.ownerOrg,
      'referralBy': instance.referralBy,
      'ownerStore': instance.ownerStore,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt,
      'deletedTimeline': instance.deletedTimeline,
      'createdBy': instance.createdBy,
      'driveLink': instance.driveLink,
      'convertTime': instance.convertTime,
      'metadata': instance.metadata.toJson(),
      'user': instance.user.toJson(),
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String?,
      profilePicture: json['profilePicture'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePicture': instance.profilePicture,
      'phoneNumber': instance.phoneNumber,
    };
