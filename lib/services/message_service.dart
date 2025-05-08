import 'dart:convert';
import 'package:chat_app_demo/models/DTOs/responseBase.dart';
import 'package:chat_app_demo/models/friend.dart';
import 'package:chat_app_demo/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class MessageService {
  static Future<responseBase<List<Friend>>> getFriends(String token) async {
    final res = await http.get(
      Uri.parse(RouteConstants.getUrl("/message/list-friend")),
      headers: {'Authorization': 'Bearer $token'},
    );
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200) {
      // final friends = (body['data'] as List<dynamic>)
      //     .map((item) => Friend.fromJson(item as Map<String, dynamic>))
      //     .toList();
      return responseBase.fromJson(
        body,
        (data) =>
            (data as List<dynamic>)
                .map((e) => Friend.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
    } else {
      throw Exception(body['message']);
    }
  }
}
