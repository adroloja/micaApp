import 'package:flutter/material.dart';
import 'package:mica/utils/constants.dart';

class AppleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AppleSignInButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
        child: Icon(CustomIcons.apple, size: 35, color: Colors.white,)
    );
  }
}
