import 'package:chat_app_demo/models/file_data.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

part 'hive_models/message.g.dart';

@HiveType(typeId: 1)
class Message {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? content;

  @HiveField(2)
  final List<FileData> files;

  @HiveField(3)
  final List<FileData> images;

  @HiveField(4)
  final int isSend;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final int messageType;

  Message({
    required this.id,
    this.content,
    required this.files,
    required this.images,
    required this.isSend,
    required this.createdAt,
    required this.messageType,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      content: json['Content'] as String?,
      files:
          (json['Files'] as List<dynamic>?)
              ?.map((item) => FileData.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      images:
          (json['Images'] as List<dynamic>?)
              ?.map((item) => FileData.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      isSend: json['isSend'] as int? ?? 0,
      createdAt: DateTime.parse(json['CreatedAt'] as String),
      messageType: json['MessageType'] as int? ?? 0,
    );
  }

  String getFormattedDate(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt).inDays;

    if (difference == 0) {
      return 'Hôm nay';
    } else if (difference == 1) {
      return 'Hôm qua';
    } else {
      return DateFormat('dd/MM/yyyy').format(createdAt);
    }
  }

  String getStatusIsSend(int isSend) {
    switch (isSend) {
      case 0:
        return "đã gửi";
      case 1:
        return "đã đọc";
      default:
        return "";
    }
  }
}
