class User {
  final String username;
  final String fullName;
  final String? avatar;

  User({required this.username, required this.fullName, this.avatar});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json["Username"] as String,
      fullName: json["FullName"] as String,
      avatar: json["Avatar"] as String?,
    );
  }
}
