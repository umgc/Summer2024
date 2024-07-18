class ApiResponse<T> {
  bool success;
  T data;
  String message;

  ApiResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      data: fromJsonT(json['data']),
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) {
    return {
      'success': success,
      'data': toJsonT(data),
      'message': message,
    };
  }
}
