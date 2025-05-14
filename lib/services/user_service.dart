import 'dart:convert';
import 'package:chat_app_demo/models/DTOs/response_base.dart';
import 'package:chat_app_demo/models/user.dart';
import 'package:chat_app_demo/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<ResponseBase<User>> getUser(String token) async {
    final res = await http.get(
      Uri.parse(RouteConstants.getUrl("/user/info")),
      headers: {'Authorization': 'Bearer $token'},
    );
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200) {
      return ResponseBase.fromJson(body, User.fromJson);
    } else {
      throw Exception(body['message']);
    }
  }
}
