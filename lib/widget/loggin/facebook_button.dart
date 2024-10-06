import 'package:flutter/material.dart';

class FacebookSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FacebookSignInButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    Color miColor = Color.fromRGBO(60, 90, 154, 1.0);

    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(miColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      child: Image.asset(
        'assets/face.png',
        height: 30.0,
        scale: 2,
      ),
    );
  }
}
