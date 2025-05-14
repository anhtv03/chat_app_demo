class ResponseList<T> {
  final int status;
  final List<T> data;
  final String message;

  ResponseList({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ResponseList.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJson,
  ) {
    return ResponseList<T>(
      status: json['status'] as int,
      data:
          (json['data'] as List<dynamic>)
              .map((item) => fromJson(item))
              .toList(), // Convert List<dynamic> to List<T>
      message: json['message'] as String,
    );
  }
}
