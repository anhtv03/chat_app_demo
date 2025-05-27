import 'package:flutter/material.dart';
import 'package:chat_app_demo/constants/style_constants.dart';
import 'package:chat_app_demo/screens/chat_page.dart';
import 'package:chat_app_demo/screens/login_page.dart';
import 'package:chat_app_demo/services/token_service.dart';
import 'package:chat_app_demo/services/user_service.dart';
import 'package:chat_app_demo/services/message_service.dart';
import 'package:chat_app_demo/models/friend.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomeCustomPage();
}

class HomeCustomPage extends State<HomePage> {
  String? _avatar;
  List<Friend> _friends = [];
  List<Friend> _filteredFriends = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _handleInfo();
    _getFriends();
    _searchController.addListener(_onSearchFriends);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
              _buildLogo(_avatar),
              SizedBox(height: screenHeight * 0.03),

              _searchTextField(),
              _buildListFriendTitle(),

              Expanded(child: _buildListFriend(screenHeight)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(String? avatarUrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StyleConstants.logo,
        PopupMenuButton<String>(
          offset: const Offset(0, 50),
          onSelected: (value) {
            if (value == 'logout') {
              _handleLogout();
            }
          },
          itemBuilder:
              (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.black),
                      SizedBox(width: 10),
                      Text('Đăng xuất', style: StyleConstants.textStyle),
                    ],
                  ),
                ),
              ],
          child: StyleConstants.avatar(avatarUrl),
        ),
      ],
    );
  }

  //==========================handle logic==============================
  Future<void> _handleInfo() async {
    try {
      String token = await TokenService.getToken('user') as String;
      var result = await UserService.getUser(token);
      setState(() {
        _avatar = result.data.avatar;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _getFriends() async {
    try {
      String token = await TokenService.getToken('user') as String;
      var result = await MessageService.getFriends(token);
      setState(() {
        _friends = result.data;
        _filteredFriends = _friends;
      });
      print("home page: friend list size: ${_friends.length}");
    } catch (e) {
      print("home page: error when get friend: ${e.toString()}");
    }
  }

  Future<void> _handleLogout() async {
    await TokenService.deleteToken('user');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  void _onSearchFriends() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredFriends = _friends;
      } else {
        _filteredFriends =
            _friends.where((friend) {
              return friend.fullName.toLowerCase().contains(query);
            }).toList();
      }
    });
  }

  //==========build UI====================
  Widget _searchTextField() {
    return TextField(
      controller: _searchController,
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
            _searchController.clear();
          },
          child: Icon(Icons.close, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildListFriendTitle() {
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

  Widget _buildListFriend(double screenHeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: screenHeight * 0.02)),
          SliverList.builder(
            itemCount: _filteredFriends.length,
            itemBuilder: (BuildContext context, int index) {
              final friend = _filteredFriends[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(friend: friend),
                    ),
                  );
                },
                child: _buildDetailFriend(friend),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailFriend(Friend friend) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StyleConstants.avatarFriend(friend.avatar, friend.isOnline),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text(
                friend.fullName,
                style: StyleConstants.textTitleListUser,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
