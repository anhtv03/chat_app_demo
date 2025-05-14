class AuthDTO {
  final String username;
  final String fullName;
  final String token;

  AuthDTO({
    required this.username,
    required this.fullName,
    required this.token,
  });

  factory AuthDTO.fromJson(Map<String, dynamic> json) {
    return AuthDTO(
      token: json['token'] as String,
      username: json['Username'] as String,
      fullName: json['FullName'] as String,
    );
  }
}
