import 'dart:convert';
import 'package:chat_app_demo/models/DTOs/responseBase.dart';
import 'package:chat_app_demo/models/DTOs/responseList.dart';
import 'package:chat_app_demo/models/DTOs/MessageDTO.dart';
import 'package:chat_app_demo/models/friend.dart';
import 'package:chat_app_demo/constants/api_constants.dart';
import 'package:chat_app_demo/models/message.dart';
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

  static Future<responseList<Message>> getMessages(
    String friendId,
    String token,
  ) async {
    final res = await http.get(
      Uri.parse(
        RouteConstants.getUrl("/message/get-message?FriendID=$friendId"),
      ),
      headers: {'Authorization': 'Bearer $token'},
    );
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200) {
      return responseList.fromJson(
        body,
        (data) => Message.fromJson(data as Map<String, dynamic>),
      );
    } else {
      throw Exception(body['message']);
    }
  }

  static Future<responseBase<Message>> sendMessage(
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
    request.fields['Content'] = dto.content ?? '';

    if (dto.files != null && dto.files!.isNotEmpty) {
      for (var file in dto.files!) {
        request.files.add(
          await http.MultipartFile.fromPath('Files', file.path),
        );
      }
    }

    final steamedRes = await request.send();
    final res = await http.Response.fromStream(steamedRes);

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200) {
      return responseBase.fromJson(body, Message.fromJson);
    } else {
      throw Exception(body['message']);
    }
  }
}
