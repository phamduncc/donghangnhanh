class ListResponse<T> {
  final List<T> data;
  final int total;

  ListResponse({
    required this.data,
    required this.total,
  });

  factory ListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ListResponse<T>(
      data: (json['data'] as List<dynamic>)
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson(
    Map<String, dynamic> Function(T) toJsonT,
  ) {
    return {
      'data': data.map((e) => toJsonT(e)).toList(),
    };
  }
}
