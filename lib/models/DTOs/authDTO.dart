class authDTO {
  final String username;
  final String fullName;
  final String token;

  authDTO({
    required this.username,
    required this.fullName,
    required this.token,
  });

  factory authDTO.fromJson(Map<String, dynamic> json) {
    return authDTO(
      token: json['token'] as String,
      username: json['Username'] as String,
      fullName: json['FullName'] as String,
    );
  }
}
