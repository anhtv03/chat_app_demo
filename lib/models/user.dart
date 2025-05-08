class User {
  final String username;
  final String fullname;
  final String? avatar;

  User({required this.username, required this.fullname, this.avatar});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json["Username"] as String,
      fullname: json["FullName"] as String,
      avatar: json["Avatar"] as String?,);
  }
}
