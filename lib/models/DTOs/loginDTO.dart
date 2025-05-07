class loginDTO {
  final String username;
  final String fullName;
  final String token;

  loginDTO({
    required this.username,
    required this.fullName,
    required this.token,
  });

  factory loginDTO.fromJson(Map<String, dynamic> json) {
    return loginDTO(
      token: json['token'] as String,
      username: json['Username'] as String,
      fullName: json['FullName'] as String,
    );
  }
}
