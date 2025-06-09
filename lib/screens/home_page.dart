import 'package:flutter/material.dart';
import 'package:chat_app_demo/constants/style_constants.dart';
import 'package:chat_app_demo/screens/chat_page.dart';
import 'package:chat_app_demo/screens/login_page.dart';
import 'package:chat_app_demo/services/token_service.dart';
import 'package:chat_app_demo/services/user_service.dart';
import 'package:chat_app_demo/services/message_service.dart';
import 'package:chat_app_demo/models/friend.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomeCustomPage();
}

class HomeCustomPage extends State<HomePage> {
  String? _avatar;
  late Future<void> _initFriend;
  List<Friend> _filteredFriends = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _handleInfo();
    _initFriend = _initFriends();
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

              Expanded(
                child: FutureBuilder(
                  future: _initFriend,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text("Lỗi khởi tạo dữ liệu."));
                    }
                    return _buildListFriend(screenHeight);
                  },
                ),
              ),
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
  Future<void> _initFriends() async {
    await Hive.openBox<Friend>('friends');
    await _getFriends();
  }

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
      final friendBox = Hive.box<Friend>("friends");

      Map<String, Friend> friendsMap = {
        for (var item in result.data) item.friendID: item,
      };

      await friendBox.putAll(friendsMap);
    } catch (e) {
      print(e.toString());
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
    setState(() {});
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
    return ValueListenableBuilder(
      valueListenable: Hive.box<Friend>('friends').listenable(),

      builder: (context, box, _) {
        List<Friend> allFriends = box.values.toList();
        final query = _searchController.text.toLowerCase();

        if (query.isEmpty) {
          _filteredFriends = allFriends;
        } else {
          _filteredFriends =
              allFriends.where((friend) {
                return friend.fullName.toLowerCase().contains(query);
              }).toList();
        }

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
      },
    );
  }

  Widget _buildDetailFriend(Friend friend) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StyleConstants.avatarFriend(friend.avatar, friend.isOnline),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend.fullName,
                  style: StyleConstants.textTitleListUser,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 4),
                _buildLastMessagePreview(friend),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastMessagePreview(Friend friend) {
    if (friend.lastMessage == null || friend.lastMessage!.isEmpty) {
      return const SizedBox.shrink();
    }

    String displayText;
    if (friend.lastMessage == '[image]') {
      displayText = 'Đã gửi một ảnh';
    } else if (friend.lastMessage == '[file]') {
      displayText = 'Đã gửi một tệp đính kèm';
    } else {
      displayText = friend.lastMessage!;
    }

    return Text(
      displayText,
      style: StyleConstants.textMessagePreview,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}
