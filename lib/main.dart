import 'package:flutter/material.dart';
import 'package:chat_app_demo/screens/login_page.dart';
import 'package:chat_app_demo/screens/home_page.dart';
import 'package:chat_app_demo/services/token_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData && snapshot.data == true) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }

  Future<bool> _checkLoginStatus() async {
    String? token = await TokenService.getToken('user');
    return token != null && token.isNotEmpty;
  }
}
