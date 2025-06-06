import 'dart:convert';
import 'package:chat_app_demo/models/DTOs/auth_dto.dart';
import 'package:chat_app_demo/models/DTOs/response_base.dart';
import 'package:chat_app_demo/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<ResponseBase<AuthDTO>> login(
    String username,
    String password,
  ) async {
    final res = await http.post(
      Uri.parse(RouteConstants.getUrl("/auth/login")),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'Username': username, 'Password': password}),
    );
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200) {
      return ResponseBase.fromJson(body, AuthDTO.fromJson);
    } else {
      throw Exception(body["message"]);
    }
  }

  static Future<ResponseBase<AuthDTO>> register(
    String username,
    String name,
    String password,
  ) async {
    final res = await http.post(
      Uri.parse(RouteConstants.getUrl("/auth/register")),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'FullName': name,
        'Username': username,
        'Password': password,
      }),
    );
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200) {
      return ResponseBase.fromJson(body, AuthDTO.fromJson);
    } else {
      throw Exception(body["message"]);
    }
  }
}
