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
      friendID: json['FriendID']?.toString() ?? '',
      fullName: json['FullName']?.toString() ?? 'không có tên',
      username: json['Username']?.toString() ?? 'không có username',
      avatar: json['Avatar'] as String?,
      isOnline: _parseIsOnline(json['isOnline'])
    );
  }

  static bool _parseIsOnline(dynamic value) {
    if (value is bool) {
      return value;
    } else if (value is int) {
      return value == 1;
    }
    return false;
  }
}
