

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


}