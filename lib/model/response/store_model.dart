import 'package:json_annotation/json_annotation.dart';

import 'order_video_reponse.dart';

part 'store_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Store {
  final String id;
  final String? owner;
  final String? name;
  final String? email;
  final String? profilePicture;
  final String? bio;
  final String? urls;
  final String? phoneNumber;
  final String? field;
  final int? plan;
  final bool? allowBackup;
  final int? recordingTime;
  final String? ownerOrg;
  final String? referralBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;

  Store({
    required this.id,
    required this.owner,
    required this.name,
    this.email,
    this.profilePicture,
    this.bio,
    this.urls,
    this.phoneNumber,
    required this.field,
    required this.plan,
    required this.allowBackup,
    required this.recordingTime,
    required this.ownerOrg,
    required this.referralBy,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  Map<String, dynamic> toJson() => _$StoreToJson(this);
}
