import 'package:hive/hive.dart';

part 'hive_models/friend.g.dart';

@HiveType(typeId: 3)
class Friend {
  @HiveField(0)
  final String friendID;

  @HiveField(1)
  final String fullName;

  @HiveField(3)
  final String username;

  @HiveField(4)
  final String? avatar;

  @HiveField(5)
  final bool isOnline;

  @HiveField(6)
  final String? lastMessage;

  Friend({
    required this.friendID,
    required this.fullName,
    required this.username,
    this.avatar,
    required this.isOnline,
    this.lastMessage,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      friendID: json['FriendID']?.toString() ?? '',
      fullName: json['FullName']?.toString() ?? 'không có tên',
      username: json['Username']?.toString() ?? 'không có username',
      avatar: json['Avatar'] as String?,
      isOnline: _parseIsOnline(json['isOnline']),
      lastMessage: _parseMessage(json),
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

  static String? _parseMessage(Map<String, dynamic> json) {
    if (json['Content'] != null && (json['Content'] as String).isNotEmpty) {
      return json['Content'] as String;
    }

    if (json['Images'] != null && (json['Images'] as List).isNotEmpty) {
      return '[image]';
    }

    if (json['Files'] != null && (json['Files'] as List).isNotEmpty) {
      return '[file]';
    }

    return null;
  }
}
