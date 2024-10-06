import 'package:dio/dio.dart';
import 'package:mica/controller/BaseController.dart';
import 'package:mica/utils/constants.dart';

class GetWinnerController extends BaseController {
  Future<dynamic> getWinner() async {
    try {
      String url = "/winner/get";

      return dio.get(url,
          options: Options(headers: {
            'Authorization': 'Bearer ${Credentials.token}',
          }));
    } catch (e) {
      print("Todavia no hay ganador");
    }
  }
}
