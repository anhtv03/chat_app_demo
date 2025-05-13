import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:chat_app_demo/constants/style_constants.dart';
import 'package:chat_app_demo/models/message.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String friendId;
  final String myId;

  const ChatPage({super.key, required this.friendId, required this.myId});

  @override
  State<StatefulWidget> createState() => ChatCustomPage();
}

class ChatCustomPage extends State<ChatPage> {
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<Message> messages = [];
  String friendID = "", myID = "";

  @override
  void initState() {
    super.initState();
    friendID = widget.friendId;
    myID = widget.myId;
    _loadMessage();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToEnd();
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    scrollController.dispose();
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

  Widget _headerTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StyleConstants.avatarFriend(null, true),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bạn ', style: StyleConstants.textStyle),
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
        controller: scrollController,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final Message message = messages[index];
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
                      textEditingController: textEditingController,
                    ),
                  );
                },
              );
            },
          ),
          //============================text input=========================
          Expanded(
            child: TextField(
              controller: textEditingController,
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
                    if (textEditingController.text.isNotEmpty) {
                      setState(() {
                        messages.add(
                          Message(
                            id: (messages.length + 1).toString(),
                            myId: myID,
                            friendId: friendID,
                            files: [],
                            content: textEditingController.text,
                            images: [],
                            isSend: 1,
                            createdAt: DateTime.now(),
                            messageType: 1,
                          ),
                        );
                        textEditingController.clear();
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
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
      );
    }
  }

  Future<void> _loadMessage() async {
    try {
      final String jsonString = await DefaultAssetBundle.of(
        context,
      ).loadString('assets/messages.txt');
      final List<dynamic> jsonData = jsonDecode(jsonString) as List<dynamic>;
      final List<Message> loadedMessages =
          jsonData
              .map(
                (message) => Message.fromJson(message as Map<String, dynamic>),
              )
              .toList();

      setState(() {
        messages =
            loadedMessages
                .where((mess) => mess.friendId == friendID && mess.myId == myID)
                .toList();
      });
    } catch (e) {
      print('Error loading messages: $e\n');
    }
  }
}
