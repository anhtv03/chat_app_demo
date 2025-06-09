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

  static Widget avatar(String? avatarUrl) {
    return SizedBox(
      height: 42,
      width: 43,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Color.fromRGBO(103, 131, 231, 1),
        backgroundImage:
            avatarUrl != null
                ? NetworkImage(avatarUrl)
                : NetworkImage(
                  'https://res.cloudinary.com/djj5gopcs/image/upload/v1744612363/download20230704194701_ult1ta.png',
                ),
      ),
    );
  }

  static Widget avatarFriend(String? avatarUrl, bool isOnline) {
    return SizedBox(
      height: 50,
      width: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage:
                avatarUrl != null
                    ? NetworkImage(avatarUrl)
                    : NetworkImage(
                      'https://res.cloudinary.com/djj5gopcs/image/upload/v1744612363/download20230704194701_ult1ta.png',
                    ),
          ),
          if (isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: SizedBox(
                height: 10,
                width: 10,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

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

  static const textMessagePreview = TextStyle(
    color: Colors.grey,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic
  );

  static ButtonStyle loginButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Color.fromRGBO(103, 131, 231, 1),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );
}
