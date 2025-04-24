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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToEnd();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    friendID = widget.friendId;
    myID = widget.myId;

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
          StyleConstants.avatarFriend,
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bạn $friendID', style: StyleConstants.textStyle),
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
    messages =
        getMockMessages()
            .where((mess) => mess.friendId == friendID && mess.myId == myID)
            .toList();
    return Flexible(
      child: ListView.builder(
        physics: ClampingScrollPhysics(),
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
              child: Column(
                crossAxisAlignment:
                    message.messageType == 1
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                children: [
                  //=====================content message=======================
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          message.messageType == 1
                              ? Color.fromRGBO(32, 160, 144, 1)
                              : Color.fromRGBO(242, 247, 251, 1),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
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
                  //=====================time message=========================
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('h:mm a').format(message.createdAt),
                        style: TextStyle(
                          color: Color.fromRGBO(121, 124, 123, 1),
                          fontSize: 12,
                          fontWeight: FontWeight.w100,
                          fontStyle: FontStyle.italic,
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
                      onBackspacePressed: () {},
                      onEmojiSelected: (category, emoji) {},
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
              ),
            ),
          ),
          //============================send button=========================
          IconButton(
            icon: Icon(Icons.send, color: Color.fromRGBO(4, 125, 231, 1)),
            onPressed: () {
              if (textEditingController.text.isNotEmpty) {
                setState(() {
                  messages.add(
                    Message(
                      id: '1',
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
          ),
          //============================file button=========================
          IconButton(
            icon: Icon(
              Icons.file_present,
              color: Color.fromRGBO(4, 125, 231, 1),
            ),
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
            icon: Icon(Icons.image, color: Color.fromRGBO(4, 125, 231, 1)),
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

  List<Message> getMockMessages() {
    return [
      Message(
        id: '1',
        myId: '1',
        friendId: '2',
        files: [],
        content: "Xin chào! Lâu rồi không gặp.",
        images: [],
        isSend: 1,
        createdAt: DateTime(2025, 4, 16, 9, 0),
        messageType: 1,
      ),
      Message(
        id: '1',
        myId: '1',
        friendId: '2',
        files: [],
        content: "Chào bạn! Đúng là lâu rồi thật.",
        images: [],
        isSend: 1,
        createdAt: DateTime(2025, 4, 16, 9, 0),
        messageType: 0,
      ),
      Message(
        id: '1',
        myId: '1',
        friendId: '2',
        files: [],
        content: "Bạn khỏe không? 😊",
        images: [],
        isSend: 1,
        createdAt: DateTime(2025, 4, 16, 9, 0),
        messageType: 1,
      ),
      Message(
        id: '2',
        myId: '1',
        friendId: '2',
        files: [],
        content: "Mình cũng khỏe. Cậu dạo này sao rồi?",
        images: [],
        isSend: 1,
        createdAt: DateTime(2025, 4, 16, 9, 1),
        messageType: 0,
      ),
      Message(
        id: '3',
        myId: '1',
        friendId: '2',
        files: [],
        content: "Tớ vẫn ổn. À, tớ mới đi du lịch về đó.",
        images: [],
        isSend: 1,
        createdAt: DateTime(2025, 4, 16, 9, 2),
        messageType: 1,
      ),
      Message(
        id: '4',
        myId: '1',
        friendId: '2',
        files: [],
        content: "Ồ, thú vị đấy. Đi đâu vậy?",
        images: [],
        isSend: 1,
        createdAt: DateTime(2025, 4, 16, 9, 3),
        messageType: 0,
      ),
      Message(
        id: '4',
        myId: '1',
        friendId: '2',
        files: [],
        content: "Ồ, thú vị đấy. Đi đâu vậy?",
        images: [],
        isSend: 0,
        createdAt: DateTime(2025, 4, 16, 9, 3),
        messageType: 1,
      ),
      Message(
        id: '4',
        myId: '1',
        friendId: '2',
        files: [],
        content: "Ồ, thú vị đấy. Đi đâu vậy?",
        images: [],
        isSend: 1,
        createdAt: DateTime(2025, 4, 16, 9, 3),
        messageType: 0,
      ),
      Message(
        id: '4',
        myId: '1',
        friendId: '2',
        files: [],
        content: "Ồ, thú vị đấy. Đi đâu vậy?",
        images: [],
        isSend: 1,
        createdAt: DateTime(2025, 4, 16, 9, 3),
        messageType: 1,
      ),
      Message(
        id: '4',
        myId: '1',
        friendId: '2',
        files: [],
        content: "Ồ, thú vị đấy. Đi đâu vậy?",
        images: [],
        isSend: 1,
        createdAt: DateTime(2025, 4, 16, 9, 3),
        messageType: 0,
      ),
      Message(
        id: '4',
        myId: '1',
        friendId: '2',
        files: [],
        content: "Ồ, thú vị đấy. Đi đâu vậy?",
        images: [],
        isSend: 1,
        createdAt: DateTime(2025, 4, 16, 9, 3),
        messageType: 1,
      ),
      Message(
        id: '4',
        myId: '1',
        friendId: '2',
        files: [],
        content: "Ồ, thú vị đấy. Đi đâu vậy?",
        images: [],
        isSend: 1,
        createdAt: DateTime(2025, 4, 16, 9, 3),
        messageType: 0,
      ),

      Message(
        id: '4',
        myId: '1',
        friendId: '3',
        files: [],
        content: "Ồ, thú vị đấy. Đi đâu vậy?",
        images: [],
        isSend: 1,
        createdAt: DateTime(2025, 4, 16, 9, 3),
        messageType: 1,
      ),
      Message(
        id: '4',
        myId: '1',
        friendId: '3',
        files: [],
        content: "Ồ, thú vị đấy. Đi đâu vậy?",
        images: [],
        isSend: 1,
        createdAt: DateTime(2025, 4, 16, 9, 3),
        messageType: 0,
      ),
      Message(
        id: '4',
        myId: '1',
        friendId: '3',
        files: [],
        content: "Ồ, thú vị đấy. Đi đâu vậy?",
        images: [],
        isSend: 1,
        createdAt: DateTime(2025, 4, 16, 9, 3),
        messageType: 1,
      ),
      Message(
        id: '4',
        myId: '1',
        friendId: '3',
        files: [],
        content: "Ồ, thú vị đấy. Đi đâu vậy?",
        images: [],
        isSend: 1,
        createdAt: DateTime(2025, 4, 16, 9, 3),
        messageType: 0,
      ),
      Message(
        id: '4',
        myId: '1',
        friendId: '3',
        files: [],
        content: "Ồ, thú vị đấy. Đi đâu vậy?",
        images: [],
        isSend: 1,
        createdAt: DateTime(2025, 4, 16, 9, 3),
        messageType: 1,
      ),
      Message(
        id: '4',
        myId: '1',
        friendId: '3',
        files: [],
        content: "Ồ, thú vị đấy. Đi đâu vậy?",
        images: [],
        isSend: 1,
        createdAt: DateTime(2025, 4, 16, 9, 3),
        messageType: 0,
      ),
    ];
  }
}
