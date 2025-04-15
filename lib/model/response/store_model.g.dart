// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
      id: json['id'] as String,
      owner: json['owner'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      profilePicture: json['profilePicture'] as String?,
      bio: json['bio'] as String?,
      urls: json['urls'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      field: json['field'] as String?,
      plan: (json['plan'] as num?)?.toInt(),
      allowBackup: json['allowBackup'] as bool?,
      recordingTime: (json['recordingTime'] as num?)?.toInt(),
      ownerOrg: json['ownerOrg'] as String?,
      referralBy: json['referralBy'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner,
      'name': instance.name,
      'email': instance.email,
      'profilePicture': instance.profilePicture,
      'bio': instance.bio,
      'urls': instance.urls,
      'phoneNumber': instance.phoneNumber,
      'field': instance.field,
      'plan': instance.plan,
      'allowBackup': instance.allowBackup,
      'recordingTime': instance.recordingTime,
      'ownerOrg': instance.ownerOrg,
      'referralBy': instance.referralBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'user': instance.user?.toJson(),
    };
