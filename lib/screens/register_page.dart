import 'package:chat_app_demo/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_demo/constants/style_constants.dart';

String _errorMessage = '';
bool _isLoading = false;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegisterCustomPage();
  }
}

class RegisterCustomPage extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
                  GestureDetector(
                    onTap: () => {Navigator.pop(context)},
                    child: const Icon(Icons.arrow_back),
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Tạo tài khoản',
                          style: StyleConstants.textTitleRegister,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  _buildTextLabel('Tên hiển thị'),
                  _buildTextField(false, _nameController),
                  SizedBox(height: screenHeight * 0.01),

                  _buildTextLabel('Tài khoản'),
                  _buildTextField(false, _usernameController),
                  SizedBox(height: screenHeight * 0.01),

                  _buildTextLabel('Mật khẩu'),
                  _buildTextField(true, _passwordController),
                  SizedBox(height: screenHeight * 0.01),

                  _buildTextLabel('Nhập lại mật khẩu'),
                  _buildTextField(true, _confirmPasswordController),
                  SizedBox(height: screenHeight * 0.15),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [_buildTextError()],
                  ),
                  const Spacer(),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : () => handleRegister(),
                          style: StyleConstants.loginButtonStyle,
                          child: const Text(
                            'Tạo tài khoản',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (_isLoading) const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  void handleRegister() async {
    final username = _usernameController.text.trim();
    final name = _nameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    final fields = {
      confirmPassword: 'Nhập lại mật khẩu không được để trống',
      password: 'Mật khẩu không được để trống',
      username: 'Tên đăng nhập không được để trống',
      name: 'Tên hiển thị không được để trống',
    };

    for (var item in fields.entries) {
      if (item.key.isEmpty) {
        setState(() {
          _errorMessage = item.value;
        });
        return;
      }
    }

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Mật khẩu không khớp !';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      var result = await AuthService.register(username, name, password);
      if (result.status == 1) {
        setState(() {
          _isLoading = false;
        });
        _buildNotiSucces(context);
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        String mess = e.toString().replaceAll('Exception: ', '');
        _errorMessage =
        mess == 'Username already exists'
            ? 'Tài khoản đã tồn tại!'
            : 'Đăng ký thất bại do lỗi hệ thống';
        print(e.toString());
      });
    }
  }
}

Widget _buildTextField(bool isPassword, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    obscureText: isPassword,
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

void _buildNotiSucces(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Center(
        child: Text(
          'Đăng ký tài khoản thành công!',
          textAlign: TextAlign.center,
        ),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.lightGreen,
    ),
  );
}
