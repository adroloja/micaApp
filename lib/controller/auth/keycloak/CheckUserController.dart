import 'package:dio/dio.dart';
import 'package:mica/controller/BaseController.dart';
import 'package:mica/utils/constants.dart';

class CheckUserController {
  final Dio dio = Dio();

  Future<dynamic> check(String email) async {
    try {
      if (email != "") {
        String url = "${APIConstants.apiUrl}/user/$email";
        Response<dynamic> response = await dio.get(url);

        return response.data;
      } else {
        return null;
      }
    } catch (err) {
      print(err);
    }
  }
}
