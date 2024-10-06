import 'package:dio/dio.dart';
import 'package:mica/controller/BaseController.dart';
import 'package:mica/utils/constants.dart';

class GetLotteryDate extends BaseController {
  Future<dynamic> getDate() async {
    String url = "/lottery_date";
    print(Credentials.token);
    try {
      Response<dynamic> response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${Credentials.token}',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        print('Error al obtener los datos: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
