class Friend {
  final String friendID;
  final String fullName;
  final String username;
  final String? avatar;
  final bool isOnline;

  Friend({
    required this.friendID,
    required this.fullName,
    required this.username,
    this.avatar,
    required this.isOnline,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      friendID: json['FriendID'] as String,
      fullName: json['FullName'] as String,
      username: json['Username'] as String,
      avatar: json['Avatar'] as String?,
      isOnline: json['isOnline'] as bool,
    );
  }
}
