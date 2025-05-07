class responseBase<T> {
  final int status;
  final T data;
  final String message;

  responseBase({
    required this.status,
    required this.data,
    required this.message,
  });

  factory responseBase.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return responseBase<T>(
      status: json['status'] as int,
      data: fromJsonT(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
    );
  }
}
