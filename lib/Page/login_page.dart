import 'package:flutter/material.dart';
import 'package:chat_app_demo/constants/style_constants.dart';
import 'package:chat_app_demo/Page/register_constants.dart';
import 'package:chat_app_demo/Page/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginCustomPage();
}

class LoginCustomPage extends State<LoginPage> {
  final _formLogin = GlobalKey<FormState>();
  String errorMessage = '';
  String errorCheck = '';

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formLogin,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyleConstants.logo,
                SizedBox(height: screenHeight * 0.2),

                Text(
                  'Tài khoản',
                  style: StyleConstants.textStyle,
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: screenHeight * 0.001),
                TextFormField(
                  decoration: InputDecoration(border: UnderlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      errorCheck = 'username';
                      return '';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.04),

                Text(
                  'Mật khẩu',
                  style: StyleConstants.textStyle,
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: screenHeight * 0.001),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(border: UnderlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      errorCheck = 'password';
                      return '';
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
                              if (_formLogin.currentState!.validate())
                                {
                                  setState(() {
                                    errorMessage = '';
                                  }),
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomePage(),
                                    ),
                                  ),
                                }
                              else
                                {
                                  setState(() {
                                    if (errorCheck == ('username')) {
                                      errorMessage =
                                          'Tên đăng nhập không được để trống';
                                    } else if (errorCheck == ('password')) {
                                      errorMessage =
                                          'Mật khẩu không được để trống';
                                    }
                                  }),
                                },
                            },
                        style: StyleConstants.loginButtonStyle,
                        child: const Text(
                          'Đăng nhập',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),

                    GestureDetector(
                      onTap:
                          () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
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
