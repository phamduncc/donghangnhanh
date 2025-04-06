import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  String email;
  String password;

  LoginRequest({
    required this.password,
    required this.email,
  });

  // Factory constructor to create an instance from JSON
  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}