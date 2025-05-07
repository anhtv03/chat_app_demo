import 'dart:convert';
import 'package:chat_app_demo/models/DTOs/loginDTO.dart';
import 'package:chat_app_demo/models/DTOs/responseBase.dart';
import 'package:chat_app_demo/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class AuthManager {
  static Future<responseBase<loginDTO>> login(
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
      return responseBase.fromJson(body, loginDTO.fromJson);
    } else {
      throw Exception("Failed to login: ${res.statusCode} - ${res.body}");
    }
  }
}
