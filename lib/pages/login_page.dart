import 'package:flutter/material.dart';
import 'package:chat_app_demo/constants/style_constants.dart';
import 'package:chat_app_demo/pages//register_constants.dart';
import 'package:chat_app_demo/pages//home_page.dart';

String errorMessage = '';

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
      resizeToAvoidBottomInset: false,
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
                      onPressed: () => {_handleLogin()},
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

  void _handleLogin() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      if (username.isEmpty) {
        errorMessage = 'Tên đăng nhập không được để trống';
      } else if (password.isEmpty) {
        errorMessage = 'Mật khẩu không được để trống';
      } else {
        if (username == 'admin' && password == '123') {
          _navigateToHomePage(context);
          errorMessage = '';
        } else {
          errorMessage = 'Bạn nhập sai tên tài khoản hoặc mật khẩu! ';
        }
      }
    });
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
