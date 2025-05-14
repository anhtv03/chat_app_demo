class ResponseBase<T> {
  final int status;
  final T data;
  final String message;

  ResponseBase({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ResponseBase.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ResponseBase<T>(
      status: json['status'] as int,
      data: fromJsonT(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
    );
  }
}
