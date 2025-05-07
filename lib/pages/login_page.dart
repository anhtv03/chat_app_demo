import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chat_app_demo/constants/style_constants.dart';
import 'package:chat_app_demo/pages//register_constants.dart';
import 'package:chat_app_demo/pages//home_page.dart';
import 'package:chat_app_demo/utils/popup.dart';
import 'package:chat_app_demo/models/DTOs/loginDTO.dart';
import 'package:chat_app_demo/models/DTOs/responseBase.dart';
import 'package:http/http.dart' as http;

String errorMessage = '';
const String url = 'http://30.30.30.86:8888/api/auth/login';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginCustomPage();
}

class LoginCustomPage extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StyleConstants.logo,
              SizedBox(height: screenHeight * 0.2),
              _buildTextLabel('Tài khoản'),
              SizedBox(height: screenHeight * 0.001),
              _buildTextField(false, _usernameController),
              SizedBox(height: screenHeight * 0.04),
              _buildTextLabel('Mật khẩu'),
              SizedBox(height: screenHeight * 0.001),
              _buildTextField(true, _passwordController),
              SizedBox(height: screenHeight * 0.15),
              _buildTextError(),
              const Spacer(),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _handleLogin(),
                      style: StyleConstants.loginButtonStyle,
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  _buildTextRegister(context),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty) {
      setState(() {
        errorMessage = 'Tên đăng nhập không được để trống';
      });
      return;
    } else if (password.isEmpty) {
      setState(() {
        errorMessage = 'Mật khẩu không được để trống';
      });
      return;
    }

    try {
      var result = await login(username, password);

      if (result.status == 1) {
        _navigateToHomePage(context);
        errorMessage = '';
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Bạn nhập sai tên tài khoản hoặc mật khẩu! ';
      });
    }
  }

  Future<responseBase<loginDTO>> login(String username, String password) async {
    final res = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (res.statusCode == 200) {
      return responseBase.fromJson(
        jsonDecode(res.body) as Map<String, dynamic>,
        loginDTO.fromJson,
      );
    } else {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return const PopupInternet();
        },
      );
      throw Exception("Failed to login: ${res.statusCode} - ${res.body}");
    }
  }

  void _navigateToHomePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
}

Widget _buildTextField(bool isPassword, TextEditingController controller) {
  return TextFormField(
    obscureText: isPassword,
    controller: controller,
    decoration: InputDecoration(border: UnderlineInputBorder()),
  );
}

Widget _buildTextLabel(String label) {
  return Text(
    label,
    style: StyleConstants.textStyle,
    textAlign: TextAlign.left,
  );
}

Widget _buildTextError() {
  return SizedBox(
    width: double.infinity,
    child: Text(
      errorMessage.isEmpty ? '' : errorMessage,
      style: StyleConstants.textErrorStyle,
      textAlign: TextAlign.center,
    ),
  );
}

Widget _buildTextRegister(BuildContext context) {
  return GestureDetector(
    onTap:
        () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterPage()),
          ),
        },
    child: const Text(
      'Đăng ký',
      style: TextStyle(
        color: Color.fromRGBO(4, 125, 231, 1),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
