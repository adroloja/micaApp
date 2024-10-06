import 'package:dio/dio.dart';
import 'package:mica/controller/BaseController.dart';
import 'package:mica/utils/constants.dart';

class DescriptionController extends BaseController {
  Future<String?> getDescription() async {
    String url = "/description";
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
        return response.data['text'];
      } else {
        return "Error al obtener la descripción. Intente más tarde.";
      }
    } catch (err) {
      print(err);
    }
  }
}
