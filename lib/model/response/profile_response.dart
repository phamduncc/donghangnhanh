import 'package:json_annotation/json_annotation.dart';

part 'profile_response.g.dart';

@JsonSerializable()
class ProfileResponse{
  String username;
  String firstName;
  String email;
  String id;
  int numDayDeleteVideo;
  int plan;
  DateTime expireLicenseDate;
  DateTime createdAt;
  ProfileResponse({
    required this.expireLicenseDate,
    required this.firstName,
    required this.username,
    required this.email,
    required this.id,
    required this.createdAt,
    required this.plan,
    required this.numDayDeleteVideo,
});
  // Factory constructor to create an instance from JSON
  factory ProfileResponse.fromJson(Map<String, dynamic> json) => _$ProfileResponseFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}