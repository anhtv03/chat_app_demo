import 'package:flutter/material.dart';
import 'package:chat_app_demo/constants/style_constants.dart';
import 'package:chat_app_demo/screens//register_page.dart';
import 'package:chat_app_demo/screens//home_page.dart';
import 'package:chat_app_demo/services/token_manager.dart';
import 'package:chat_app_demo/services/auth_manager.dart';

String _errorMessage = '';
bool _isLoading = false;

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
          child: Stack(
            children: [
              Column(
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
                          onPressed: _isLoading ? null : () => _handleLogin(),
                          style: StyleConstants.loginButtonStyle,
                          child: const Text(
                            'Đăng nhập',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildTextRegister(context),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                ],
              ),
              if (_isLoading) const Center(child: CircularProgressIndicator()),
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
    final password = _passwordController.text;

    if (username.isEmpty) {
      setState(() {
        _errorMessage = 'Tên đăng nhập không được để trống';
      });
      return;
    } else if (password.isEmpty) {
      setState(() {
        _errorMessage = 'Mật khẩu không được để trống';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      var result = await AuthManager.login(username, password);

      if (result.status == 1) {
        final token = result.data.token;
        TokenManager.saveToken('user', token);
        setState(() {
          _isLoading = false;
        });
        _navigateToHomePage(context);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Bạn nhập sai tên tài khoản hoặc mật khẩu! ';
        print(e.toString());
      });
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
      _errorMessage.isEmpty ? '' : _errorMessage,
      style: StyleConstants.textErrorStyle,
      textAlign: TextAlign.center,
    ),
  );
}

Widget _buildTextRegister(BuildContext context) {
  return GestureDetector(
    onTap:
        _isLoading
            ? null
            : () => {
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
