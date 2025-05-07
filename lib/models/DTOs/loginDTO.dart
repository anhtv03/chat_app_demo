class loginDTO {
  final String username;
  final String password;
  final String token;
  final String? avatar;

  loginDTO({
    required this.username,
    required this.password,
    required this.token,
    this.avatar,
  });

  factory loginDTO.fromJson(Map<String, dynamic> json) {
    return loginDTO(
      token: json['token'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      avatar: json['avatar'] as String?,
    );
  }
}
