import 'package:flutter/material.dart';

class StyleConstants {
  static const logo = Text(
    'Bkav Chat',
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Color(0xFF146AE0),
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w700,
      fontSize: 24,
      height: 1,
    ),
  );

  static const avatar = SizedBox(
    height: 42,
    width: 43,
    child: CircleAvatar(
      radius: 50,
      backgroundColor: Color.fromRGBO(103, 131, 231, 1),
      backgroundImage: NetworkImage(
        'https://res.cloudinary.com/djj5gopcs/image/upload/v1744612363/download20230704194701_ult1ta.png', // Replace with your image URL
      ),
      // child: Icon(Icons.person, size: 30, color: Colors.white),
    ),
  );

  static const avatarFriend = SizedBox(
    height: 50,
    width: 50,
    child: CircleAvatar(
      radius: 50,
      backgroundColor: Color.fromRGBO(103, 131, 231, 1),
      backgroundImage: NetworkImage(
        'https://res.cloudinary.com/djj5gopcs/image/upload/v1744612363/download20230704194701_ult1ta.png', // Replace with your image URL
      ),
      // child: Icon(Icons.person, size: 30, color: Colors.white),
    ),
  );

  static const textStyle = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );

  static const textErrorStyle = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1,
    color: Color.fromRGBO(236, 70, 34, 1),
  );

  static const textTitleRegister = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 18,
  );

  static const textTitleListUser = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 20,
    height: 1,
  );

  static ButtonStyle loginButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Color.fromRGBO(103, 131, 231, 1),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );
}
