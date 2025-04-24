class Message {
  final String id;
  final String friendId;
  final String myId;
  final String? content;
  final List<String> files;
  final List<String> images;
  final int isSend;
  final DateTime createdAt;
  final int messageType;

  Message({
    required this.id,
    required this.myId,
    required this.friendId,
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
      myId: json['myId'] as String,
      friendId: json['friendId'] as String,
      files: List.from(json['files'] as List),
      content: json['content'] as String,
      images: List.from(json['images'] as List),
      isSend: json['isSend'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      messageType: json['messageType'] as int,);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'myId': myId,
      'friendId': friendId,
      'files': files,
      'content': content,
      'images': images,
      'isSend': isSend,
      'createdAt': createdAt.toIso8601String(),
      'messageType': messageType,
    };
  }
}

