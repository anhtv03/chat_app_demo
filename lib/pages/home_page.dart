import 'package:flutter/material.dart';
import 'package:chat_app_demo/constants/style_constants.dart';
import 'package:chat_app_demo/pages/chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomeCustomPage();
}

class HomeCustomPage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerLogo(),
              SizedBox(height: screenHeight * 0.03),
              _searchTextField(),
              _listFriendTitle(),
              Expanded(child: _listFriend(screenHeight)),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _searchTextField() {
  final TextEditingController searchController = TextEditingController();
  return TextField(
    controller: searchController,
    decoration: InputDecoration(
      hintText: 'Tìm kiếm',
      hintStyle: StyleConstants.textStyle,
      prefixIcon: Icon(Icons.search, color: Colors.black),
      filled: true,
      fillColor: Color.fromRGBO(243, 246, 246, 1),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(16),
      ),
      suffixIcon: GestureDetector(
        onTap: () {
          searchController.clear();
        },
        child: Icon(Icons.close, color: Colors.black),
      ),
    ),
  );
}

Widget _headerLogo() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [StyleConstants.logo, StyleConstants.avatar],
  );
}

Widget _listFriendTitle() {
  return Padding(
    padding: EdgeInsets.only(top: 20, left: 40, right: 40),
    child: Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        'Danh sách bạn bè',
        textAlign: TextAlign.start,
        style: StyleConstants.textTitleListUser,
      ),
    ),
  );
}

Widget _listFriend(double screenHeight) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
    child: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: screenHeight * 0.02)),
        SliverList.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(friendId: '${index + 2}', myId: '1',),
                  ),
                );
              },
              child: _detailFriend(index + 2),
            );
          },
        ),
      ],
    ),
  );
}

Widget _detailFriend(int index) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        StyleConstants.avatarFriend,
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Text('Bạn $index', style: StyleConstants.textTitleListUser),
        ),
      ],
    ),
  );
}
