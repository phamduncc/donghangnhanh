// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    ProfileResponse(
      expireLicenseDate: DateTime.parse(json['expireLicenseDate'] as String),
      firstName: json['firstName'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      plan: (json['plan'] as num).toInt(),
      numDayDeleteVideo: (json['numDayDeleteVideo'] as num).toInt(),
    );

Map<String, dynamic> _$ProfileResponseToJson(ProfileResponse instance) =>
    <String, dynamic>{
      'username': instance.username,
      'firstName': instance.firstName,
      'email': instance.email,
      'id': instance.id,
      'numDayDeleteVideo': instance.numDayDeleteVideo,
      'plan': instance.plan,
      'expireLicenseDate': instance.expireLicenseDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
