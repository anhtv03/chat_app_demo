import 'package:flutter/material.dart';
import 'package:chat_app_demo/constants/style_constants.dart';

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
  final _confirmpasswordController = TextEditingController();
  String errorMessage = '';

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmpasswordController.dispose();
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

                Text(
                  'Tên hiển thị',
                  style: StyleConstants.textStyle,
                  textAlign: TextAlign.right,
                ),
                TextFormField(
                  decoration: InputDecoration(border: UnderlineInputBorder()),
                ),
                SizedBox(height: screenHeight * 0.01),

                Text(
                  'Tài khoản',
                  style: StyleConstants.textStyle,
                  textAlign: TextAlign.right,
                ),
                TextFormField(
                  decoration: InputDecoration(border: UnderlineInputBorder()),
                ),
                SizedBox(height: screenHeight * 0.01),

                Text(
                  'Mật khẩu',
                  style: StyleConstants.textStyle,
                  textAlign: TextAlign.right,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(border: UnderlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.01),

                Text(
                  'Nhập lại mật khẩu',
                  style: StyleConstants.textStyle,
                  textAlign: TextAlign.right,
                ),
                TextFormField(
                  controller: _confirmpasswordController,
                  obscureText: true,
                  decoration: InputDecoration(border: UnderlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.15),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        errorMessage.isEmpty ? '' : errorMessage,
                        style: StyleConstants.textErrorStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
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
                                      _confirmpasswordController.text)
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
                                }
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
