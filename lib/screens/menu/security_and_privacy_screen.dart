import 'package:flutter/material.dart';
import 'package:mica/widget/custom_app_bars/custom_back_bar.dart';

class SecurityAndPrivacyScreen extends StatelessWidget {
  const SecurityAndPrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackBar(
        route: "main",
      ),
      body: Text("privacidad"),
    );
  }
}
