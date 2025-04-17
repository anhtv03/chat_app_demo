import 'package:flutter/material.dart';
import 'package:chat_app_demo/constants/style_constants.dart';

String errorMessage = '';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegisterCustomPage();
  }
}

class RegisterCustomPage extends State<RegisterPage> {
  final _registerForm = GlobalKey<FormState>();
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _registerForm,
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
                TextFormField(
                  decoration: InputDecoration(border: UnderlineInputBorder()),
                ),
                SizedBox(height: screenHeight * 0.01),
                _buildTextLabel('Tài khoản'),

                TextFormField(
                  decoration: InputDecoration(border: UnderlineInputBorder()),
                ),
                SizedBox(height: screenHeight * 0.01),

                _buildTextLabel('Mật khẩu'),
                _buildTextField(_passwordController),
                SizedBox(height: screenHeight * 0.01),

                _buildTextLabel('Nhập lại mật khẩu'),
                _buildTextField(_confirmPasswordController),
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
                        onPressed:
                            () => {
                              if (_registerForm.currentState!.validate())
                                {
                                  if (_passwordController.text !=
                                      _confirmPasswordController.text)
                                    {
                                      setState(() {
                                        errorMessage = 'Mật khẩu không khớp !';
                                      }),
                                    }
                                  else
                                    {
                                      setState(() {
                                        errorMessage = '';
                                      }),
                                    },
                                },
                            },
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
}

Widget _buildTextField(TextEditingController controller) {
  return TextFormField(
    controller: controller,
    obscureText: true,
    decoration: InputDecoration(border: UnderlineInputBorder()),
    validator: (value) {
      if (value == null || value.isEmpty) {}
      return null;
    },
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
