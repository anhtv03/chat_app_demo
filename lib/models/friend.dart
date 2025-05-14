class Friend {
  final String content;
  final List<String>? files;
  final List<String>? images;
  final int isSend;
  final String friendID;
  final String fullName;
  final String username;
  final String? avatar;
  final bool isOnline;

  Friend({
    required this.content,
    this.files,
    this.images,
    required this.isSend,
    required this.friendID,
    required this.fullName,
    required this.username,
    this.avatar,
    required this.isOnline,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      content: json['Content'] as String,
      files: (json['Files'] as List<dynamic>?)?.cast<String>(),
      images: (json['Images'] as List<dynamic>?)?.cast<String>(),
      isSend: json['isSend'] as int,
      friendID: json['FriendID'] as String,
      fullName: json['FullName'] as String,
      username: json['Username'] as String,
      avatar: json['Avatar'] as String?,
      isOnline: json['isOnline'] as bool,
    );
  }
}
