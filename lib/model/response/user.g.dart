// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      profilePicture: json['profilePicture'] as String?,
      password: json['password'] as String,
      jobTitle: json['jobTitle'] as String?,
      bio: json['bio'] as String?,
      urls: json['urls'] as String?,
      plan: (json['plan'] as num?)?.toInt(),
      status: json['status'] as String?,
      billingCode: json['billingCode'] as String?,
      limitStorage: (json['limitStorage'] as num?)?.toInt(),
      phoneNumber: json['phoneNumber'] as String?,
      currentStoreId: json['currentStoreId'] as String?,
      changePassTxId: json['changePassTxId'] as String?,
      ownerOrg: json['ownerOrg'] as String?,
      referralBy: json['referralBy'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      resetToken: json['resetToken'] as String?,
      resetTokenDate: json['resetTokenDate'] == null
          ? null
          : DateTime.parse(json['resetTokenDate'] as String),
      resetTokenCount: (json['resetTokenCount'] as num?)?.toInt(),
      failedLogin: (json['failedLogin'] as num?)?.toInt(),
      numDayDeleteVideo: (json['numDayDeleteVideo'] as num?)?.toInt(),
      licenseStartDate: json['licenseStartDate'] == null
          ? null
          : DateTime.parse(json['licenseStartDate'] as String),
      expireLicenseDate: json['expireLicenseDate'] == null
          ? null
          : DateTime.parse(json['expireLicenseDate'] as String),
      currentMoney: (json['currentMoney'] as num?)?.toInt(),
      monthlyMoney: (json['monthlyMoney'] as num?)?.toInt(),
      verified: json['verified'] as bool?,
      source: json['source'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'username': instance.username,
      'profilePicture': instance.profilePicture,
      'password': instance.password,
      'jobTitle': instance.jobTitle,
      'bio': instance.bio,
      'urls': instance.urls,
      'plan': instance.plan,
      'status': instance.status,
      'billingCode': instance.billingCode,
      'limitStorage': instance.limitStorage,
      'phoneNumber': instance.phoneNumber,
      'currentStoreId': instance.currentStoreId,
      'changePassTxId': instance.changePassTxId,
      'ownerOrg': instance.ownerOrg,
      'referralBy': instance.referralBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'resetToken': instance.resetToken,
      'resetTokenDate': instance.resetTokenDate?.toIso8601String(),
      'resetTokenCount': instance.resetTokenCount,
      'failedLogin': instance.failedLogin,
      'numDayDeleteVideo': instance.numDayDeleteVideo,
      'licenseStartDate': instance.licenseStartDate?.toIso8601String(),
      'expireLicenseDate': instance.expireLicenseDate?.toIso8601String(),
      'currentMoney': instance.currentMoney,
      'monthlyMoney': instance.monthlyMoney,
      'verified': instance.verified,
      'source': instance.source,
    };
