import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? username;
  final String? profilePicture;
  final String password;
  final String? jobTitle;
  final String? bio;
  final String? urls;
  final int? plan;
  final String? status;
  final String? billingCode;
  final int? limitStorage;
  final String? phoneNumber;
  final String? currentStoreId;
  final String? changePassTxId;
  final String? ownerOrg;
  final String? referralBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? resetToken;
  final DateTime? resetTokenDate;
  final int? resetTokenCount;
  final int? failedLogin;
  final int? numDayDeleteVideo;
  final DateTime? licenseStartDate;
  final DateTime? expireLicenseDate;
  final int? currentMoney;
  final int? monthlyMoney;
  final bool? verified;
  final String? source;

  User({
    required this.id,
    required this.firstName,
    this.lastName,
    required this.email,
    required this.username,
    this.profilePicture,
    required this.password,
    this.jobTitle,
    this.bio,
    this.urls,
    required this.plan,
    required this.status,
    required this.billingCode,
    required this.limitStorage,
    this.phoneNumber,
    this.currentStoreId,
    this.changePassTxId,
    required this.ownerOrg,
    required this.referralBy,
    required this.createdAt,
    required this.updatedAt,
    this.resetToken,
    this.resetTokenDate,
    this.resetTokenCount,
    this.failedLogin,
    required this.numDayDeleteVideo,
    this.licenseStartDate,
    required this.expireLicenseDate,
    required this.currentMoney,
    required this.monthlyMoney,
    required this.verified,
    required this.source,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
