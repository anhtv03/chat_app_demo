import 'dart:convert';
import 'package:chat_app_demo/models/DTOs/responseList.dart';
import 'package:chat_app_demo/models/friend.dart';
import 'package:chat_app_demo/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class MessageService {
  static Future<responseList<Friend>> getFriends(String token) async {
    final res = await http.get(
      Uri.parse(RouteConstants.getUrl("/message/list-friend")),
      headers: {'Authorization': 'Bearer $token'},
    );
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200) {
      return responseList.fromJson(
        body,
        (data) => Friend.fromJson(data as Map<String, dynamic>),
      );
    } else {
      throw Exception(body['message']);
    }
  }
}
