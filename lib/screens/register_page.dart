import 'package:flutter/material.dart';
import 'package:chat_app_demo/constants/style_constants.dart';
import 'package:chat_app_demo/constants/api_constants.dart';
import 'package:chat_app_demo/models/DTOs/responseBase.dart';

String errorMessage = '';

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
          child: Form(
            child: Column(
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
                        onPressed: () => handleRegister(),
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
      username: 'Tên đăng nhập không được để trống',
      name: 'Tên hiển thị không được để trống',
      password: 'Mật khẩu không được để trống',
      confirmPassword: 'Nhập lại mật khẩu không được để trống',
    };

    for (var item in fields.entries) {
      if (item.key.isEmpty) {
        setState(() {
          errorMessage = item.value;
        });
        return;
      }
    }

    if (password != confirmPassword) {
      setState(() {
        errorMessage = 'Mật khẩu không khớp !';
      });
      return;
    }

    setState(() {
      errorMessage = '';
    });

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
      errorMessage.isEmpty ? '' : errorMessage,
      style: StyleConstants.textErrorStyle,
      textAlign: TextAlign.center,
    ),
  );
}
