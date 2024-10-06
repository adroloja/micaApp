import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mica/controller/auth/Authenticate.dart';
import 'package:mica/controller/lottery_date/get_lottery_date.dart';
import 'package:mica/utils/constants.dart';
import 'package:mica/utils/secure_storage.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    resetGeolocation();
    createDefaultPassword();
    _controller = VideoPlayerController.asset('assets/intro.mp4')
      ..initialize().then((_) {
        _controller.play();
        setState(() {});
      });

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        Future.delayed(const Duration(seconds: 1), () {
          determineInitialRoute();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  Future<void> resetGeolocation() async {
    await _storage.write(key: "counter", value: "0");
  }

  Future<void> determineInitialRoute() async {
    // await SecureStorage.deleteAll();
    String? username = await _storage.read(key: 'username');
    String? password;
    if (username != null) {
      Credentials.username = username;
      password = await _storage.read(key: username);
      if (password == Credentials.defaultPassword) {
        Credentials.isExternal = true;
      }
      if (password != null) {
        // username != null && password != null
        try {
          final bool isValid = await Authenticate().auth(username, password);
          String initRoute = isValid ? '/main' : '/';
          Credentials.password = isValid ? password : "";
          if (mounted) {
            Navigator.of(context).pushReplacementNamed(initRoute);
          }
          return;
        } catch (e) {
          print("entro en el error");
          // Fluttertoast.showToast(
          //     fontSize: 18,
          //     toastLength: Toast.LENGTH_LONG,
          //     msg: '\n ${e.toString()} \n');
          Navigator.of(context).pushNamed("/");
        }
      } else {
        Navigator.of(context).pushNamed("/");
        return;
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed("/");
      }
    }
  }

  createDefaultPassword() async {
    await SecureStorage.write(key: "defaultPassword", value: "W9z!6Pq#Vt8Lx7");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
