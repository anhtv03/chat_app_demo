import 'package:flutter/material.dart';

class PopupInternet extends StatelessWidget {
  const PopupInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: Colors.white,
      content: Text(
        'Kết nối mạng không ổn định, bạn vui lòng thử lại sau',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => {Navigator.of(context).pop()},
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color.fromRGBO(28, 127, 217, 1),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          child: Text('Ok'),
        ),
      ],
    );
  }
}
