import 'package:json_annotation/json_annotation.dart';

import 'list_parcel_items_response.dart';

part 'order_video_reponse.g.dart';
@JsonSerializable()
class ListVideoOrderResponse{
  List<VideoOrder>? data;
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

@JsonSerializable(explicitToJson: true)
class VideoOrder {
  final String id;
  final String storeId;
  final int duration;
  final String startTime;
  final String orderCode;
  final String? prepareCode;
  final String? metadataId;
  final String? metadataCam2Id;
  final String? metadataCompleteId;
  final String status;
  final String slug;
  final String type;
  final String? tagId;
  final String ownerOrg;
  final String? referralBy;
  final String ownerStore;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deletedAt;
  final String? deletedTimeline;
  final String? createdBy;
  final String? driveLink;
  final String? convertTime;
  final Metadata? metadata;
  final User user;

  VideoOrder({
    required this.id,
    required this.storeId,
    required this.duration,
    required this.startTime,
    required this.orderCode,
    required this.prepareCode,
    required this.metadataId,
    this.metadataCam2Id,
    this.metadataCompleteId,
    required this.status,
    required this.slug,
    required this.type,
    this.tagId,
    required this.ownerOrg,
    this.referralBy,
    required this.ownerStore,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.deletedTimeline,
    required this.createdBy,
    this.driveLink,
    this.convertTime,
    required this.metadata,
    required this.user,
  });

  factory VideoOrder.fromJson(Map<String, dynamic> json) => _$VideoOrderFromJson(json);
  Map<String, dynamic> toJson() => _$VideoOrderToJson(this);
}

@JsonSerializable()
class User {
  final String id;
  final String email;
  final String firstName;
  final String? lastName;
  final String? profilePicture;
  final String? phoneNumber;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    this.lastName,
    this.profilePicture,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}