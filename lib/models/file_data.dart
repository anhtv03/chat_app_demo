class FileData {
  final String url;
  final String fileName;
  final String id;

  FileData({required this.url, required this.fileName, required this.id});

  factory FileData.fromJson(Map<String, dynamic> json) {
    return FileData(
      url: json['urlImage'] as String? ?? json['urlFile'] as String? ?? '',
      fileName: json['FileName'] as String? ?? '',
      id: json['_id'] as String? ?? '',
    );
  }
}
