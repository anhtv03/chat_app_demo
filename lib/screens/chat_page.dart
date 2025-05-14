import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:chat_app_demo/constants/style_constants.dart';
import 'package:chat_app_demo/models/message.dart';
import 'package:chat_app_demo/models/friend.dart';
import 'package:chat_app_demo/models/DTOs/MessageDTO.dart';
import 'package:chat_app_demo/services/token_service.dart';
import 'package:chat_app_demo/services/message_service.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final Friend friend;

  const ChatPage({super.key, required this.friend});

  @override
  State<StatefulWidget> createState() => ChatCustomPage();
}

class ChatCustomPage extends State<ChatPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> _messages = [];
  late Friend _friend;

  @override
  void initState() {
    super.initState();
    _friend = widget.friend;
    _loadMessage();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToEnd();
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_headerTitle()],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_contentMessage(), _buildInput(screenHeight)],
      ),
    );
  }

  //==========================handle logic==============================
  Future<void> _loadMessage() async {
    try {
      String token = await TokenService.getToken('user') as String;
      var result = await MessageService.getMessages(_friend.friendID, token);
      setState(() {
        _messages = result.data;
      });
      print(result.data.length);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _sendMessage() async {
    try {
      String token = await TokenService.getToken('user') as String;
      MessageDTO dto = MessageDTO(content: _textEditingController.text);
      var result = await MessageService.sendMessage(
        token,
        _friend.friendID,
        dto,
      );
      _loadMessage();
      print(
        "${result.data.id} / ${result.data.content} / ${result.data.createdAt} ",
      );
    } catch (e) {
      print(e.toString());
    }
  }

  //==========================build UI==============================
  Widget _headerTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StyleConstants.avatarFriend(_friend.avatar, _friend.isOnline),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _friend.fullName,
                  style: StyleConstants.textStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                if (_friend.isOnline)
                  Text(
                    'Trực tuyến',
                    style: TextStyle(
                      color: Color.fromRGBO(121, 124, 123, 1),
                      fontSize: 12,
                      fontWeight: FontWeight.w100,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contentMessage() {
    return Flexible(
      child: ListView.builder(
        physics: const ClampingScrollPhysics(),
        controller: _scrollController,
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final Message message = _messages[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Align(
              alignment:
                  message.messageType == 1
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
              child: Row(
                mainAxisAlignment:
                    message.messageType == 1
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //=====================Avatar===========================
                  if (message.messageType != 1)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: StyleConstants.avatarFriend(null, true),
                    ),
                  //=====================Content and Time=======================
                  Column(
                    crossAxisAlignment:
                        message.messageType == 1
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                    children: [
                      // Content message
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              message.messageType == 1
                                  ? const Color.fromRGBO(32, 160, 144, 1)
                                  : const Color.fromRGBO(242, 247, 251, 1),
                          borderRadius: BorderRadius.only(
                            bottomLeft: const Radius.circular(10),
                            bottomRight: const Radius.circular(10),
                            topLeft: Radius.circular(
                              message.messageType == 1 ? 10 : 0,
                            ),
                            topRight: Radius.circular(
                              message.messageType == 1 ? 0 : 10,
                            ),
                          ),
                        ),
                        child: Text(
                          message.content.toString(),
                          style: TextStyle(
                            color:
                                message.messageType == 1
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      //====================Time message======================
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: SizedBox(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              DateFormat('h:mm a').format(message.createdAt),
                              style: const TextStyle(
                                color: Color.fromRGBO(121, 124, 123, 1),
                                fontSize: 12,
                                fontWeight: FontWeight.w100,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInput(screenHeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Row(
        children: [
          //=============Emoji=========================
          IconButton(
            icon: Icon(Icons.insert_emoticon, color: Colors.black),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: screenHeight * 0.4,
                    child: EmojiPicker(
                      textEditingController: _textEditingController,
                    ),
                  );
                },
              );
            },
          ),
          //============================text input=========================
          Expanded(
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Nhập tin nhắn...',
                hintStyle: StyleConstants.textStyle,
                filled: true,
                fillColor: Color.fromRGBO(243, 246, 246, 1),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(16),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    if (_textEditingController.text.isNotEmpty) {
                      _sendMessage();
                      setState(() {
                        _textEditingController.clear();
                        _scrollToEnd();
                      });
                    }
                  },
                  child: Icon(
                    Icons.send,
                    color: Color.fromRGBO(4, 125, 231, 1),
                  ),
                ),
              ),
            ),
          ),
          //============================file button=========================
          IconButton(
            icon: Icon(Icons.file_present),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: screenHeight * 0.4,
                    child: Text('data'),
                  );
                },
              );
            },
          ),
          //============================picture button=========================
          IconButton(
            icon: Icon(Icons.image),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: screenHeight * 0.4,
                    child: Text('data'),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
      );
    }
  }
}
