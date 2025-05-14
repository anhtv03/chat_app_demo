class Message {
  final String id;
  final String? content;
  final List<String> files;
  final List<String> images;
  final int isSend;
  final DateTime createdAt;
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
      files: (json['Files'] as List<dynamic>?)?.cast<String>() ?? [],
      images: (json['Images'] as List<dynamic>?)?.cast<String>() ?? [],
      isSend: json['isSend'] as int? ?? 0,
      createdAt: DateTime.parse(json['CreatedAt'] as String),
      messageType: json['MessageType'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Files': files,
      'Content': content,
      'Images': images,
      'isSend': isSend,
      'CreatedAt': createdAt.toIso8601String(),
      'MessageType': messageType,
    };
  }
}
