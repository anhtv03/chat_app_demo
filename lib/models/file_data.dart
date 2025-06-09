import 'package:hive/hive.dart';
part 'file_data.g.dart';

@HiveType(typeId: 2)
class FileData {
  @HiveField(0)
  final String url;

  @HiveField(1)
  final String fileName;

  @HiveField(2)
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
