class BaseApiResponse<T> {
  final int? code;
  final T? data;
  final String? message;
  final bool success;

  BaseApiResponse({
    this.code,
    this.data,
    this.message,
    required this.success,
  });

  factory BaseApiResponse.fromJson(Map<String, dynamic> json) {
    return BaseApiResponse(
      code: json['code'],
      data: json['data'],
      message: json['message'],
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'data': data,
      'message': message,
      'success': success,
    };
  }
}