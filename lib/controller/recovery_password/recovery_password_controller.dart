import 'package:dio/dio.dart';
import 'package:mica/controller/BaseController.dart';
import 'package:mica/utils/constants.dart';

class RecoveryPasswordController {
  Dio dio = Dio();
  Future<dynamic> recovery(String email) async {
    String url = "${APIConstants.apiUrl}/user/recovery";
    try {
      Response<dynamic> response = await dio.put(
        url,
        data: "{\"email\":\"$email\"}",
      );
    } catch (err) {
      print(err);
    }
  }
}
