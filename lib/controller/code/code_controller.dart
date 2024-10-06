import 'package:dio/dio.dart';
import 'package:mica/controller/BaseController.dart';
import 'package:mica/utils/constants.dart';

class CodeController extends BaseController {
  Future<String?> getCode() async {
    try {
      String url = "/code/${Credentials.email}";

      Response response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${Credentials.token}',
          },
        ),
      );

      if (response.statusCode == 200) {
        String code = response.data['code'];
        return code;
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (err) {
      print('Error: $err');
      return null;
    }
  }
}
