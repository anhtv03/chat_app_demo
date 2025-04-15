import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:chat_app_demo/constants/style_constants.dart';

class ChatPage extends StatefulWidget {
  final int id;

  const ChatPage({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => ChatCustomPage();
}

class ChatCustomPage extends State<ChatPage> {
  bool showEmoji = false;
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final int friendID = widget.id;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_headerTitle(friendID)],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _contentMessage(friendID),
          _buildInput(context, textEditingController, screenHeight),
        ],
      ),
    );
  }
}

Widget _headerTitle(int friendID) {
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

Widget _contentMessage(int friendID) {
  return Expanded(
    child: ListView.builder(
      physics: ClampingScrollPhysics(),
      itemCount: 50,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //=====================content message===============================
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(32, 160, 144, 1),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(0),
                    ),
                  ),
                  child: Text(
                    'Tin nhắn của bạn $friendID',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              //=====================time message===============================
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '9:00 AM',
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
        );
      },
    ),
  );
}

Widget _buildInput(context, textEditingController, screenHeight) {
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
                return Container(
                  height: screenHeight * 0.4,
                  child: EmojiPicker(
                    textEditingController: textEditingController,
                    onBackspacePressed: () {},
                    onEmojiSelected: (category, emoji) {

                    },
                    config: Config(),
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
        //============================send message=========================
        IconButton(
          icon: Icon(Icons.send, color: Color.fromRGBO(4, 125, 231, 1)),
          onPressed: () {
            // Handle send button press
          },
        ),
      ],
    ),
  );
}
