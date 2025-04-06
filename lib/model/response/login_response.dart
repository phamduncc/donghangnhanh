import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse{
  String token;
  String refreshToken;
  int expiresIn;
  LoginResponse({
    required this.expiresIn,
    required this.refreshToken,
    required this.token,
});
  // Factory constructor to create an instance from JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}