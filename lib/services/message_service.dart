import 'dart:convert';
import 'package:chat_app_demo/models/DTOs/response_base.dart';
import 'package:chat_app_demo/models/DTOs/response_list.dart';
import 'package:chat_app_demo/models/DTOs/message_dto.dart';
import 'package:chat_app_demo/models/friend.dart';
import 'package:chat_app_demo/constants/api_constants.dart';
import 'package:chat_app_demo/models/message.dart';
import 'package:http/http.dart' as http;

class MessageService {
  static Future<ResponseList<Friend>> getFriends(String token) async {
    final res = await http.get(
      Uri.parse(RouteConstants.getUrl("/message/list-friend")),
      headers: {'Authorization': 'Bearer $token'},
    );
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    //print(body);
    if (res.statusCode == 200) {
      return ResponseList.fromJson(
        body,
        (data) => Friend.fromJson(data as Map<String, dynamic>),
      );
    } else {
      throw Exception(body['message']);
    }
  }

  static Future<ResponseList<Message>> getMessages(
    String friendId,
    String token, {
    String? lastTime,
  }) async {
    final url =
        lastTime != null
            ? '/message/get-message?FriendID=$friendId&lastTime=$lastTime'
            : '/message/get-message?FriendID=$friendId';

    final res = await http.get(
      Uri.parse(RouteConstants.getUrl(url)),
      headers: {'Authorization': 'Bearer $token'},
    );
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200) {
      return ResponseList.fromJson(
        body,
        (data) => Message.fromJson(data as Map<String, dynamic>),
      );
    } else {
      throw Exception(body['message']);
    }
  }

  static Future<ResponseBase<Message>> sendMessage(
    String token,
    String friendId,
    MessageDTO dto,
  ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(RouteConstants.getUrl("/message/send-message")),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['FriendID'] = friendId;
    if (dto.content != null && dto.content!.isNotEmpty) {
      request.fields['Content'] = dto.content!;
    }

    if (dto.files != null && dto.files!.isNotEmpty) {
      for (var file in dto.files!) {
        request.files.add(
          await http.MultipartFile.fromPath('files', file.path),
        );
      }
    }

    final steamedRes = await request.send();
    final res = await http.Response.fromStream(steamedRes);

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200) {
      return ResponseBase.fromJson(body, Message.fromJson);
    } else {
      throw Exception(body['message']);
    }
  }
}
