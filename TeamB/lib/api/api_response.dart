class ApiResponse<T> {
  bool success;
  T data;
  String message;

  ApiResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
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

  factory ApiResponse.success(T data) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: '',
    );
  }

  factory ApiResponse.error(String message) {
    return ApiResponse<T>(
      success: false,
      data: null as T,
      message: message,
    );
  }
}
