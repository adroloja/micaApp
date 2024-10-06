import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';

class ImageHandler {
  static ImageProvider handleImage(String? base64String) {
    if (base64String == null) {
      return AssetImage('assets/images/default_image.png');
    } else {
      Uint8List bytes = base64Decode(base64String);
      return MemoryImage(bytes);
    }
  }
}
