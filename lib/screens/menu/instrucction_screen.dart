import 'package:flutter/material.dart';
import 'package:mica/widget/custom_app_bars/custom_app_bar.dart';
import 'package:mica/widget/custom_app_bars/custom_back_bar.dart';

class InstrucctionScreen extends StatelessWidget {
  const InstrucctionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackBar(
        route: "main",
      ),
      body: Text("asdfasdf"),
    );
  }
}
