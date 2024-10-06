import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mica/dto/NewUserDTO.dart';
import 'package:mica/utils/constants.dart';

class Signupcontroller {
  final Dio _dio = Dio();

  Future<Response<dynamic>> doSignUp(
      NewUserDTO newUser, File selfieImage) async {
    String fileName = selfieImage.path.split('/').last;
    FormData formData = FormData.fromMap({
      'username': newUser.email,
      'password': newUser.password,
      'firstName': newUser.firstName,
      'lastName': newUser.lastName,
      'email': newUser.email,
      'phoneNumber': newUser.number,
      'verified': newUser.verified,
      'selfie':
          await MultipartFile.fromFile(selfieImage.path, filename: fileName),
    });
    return _dio.post("${APIConstants.apiUrl}/user",
        data: formData, options: Options(contentType: Headers.jsonContentType));
  }
}
