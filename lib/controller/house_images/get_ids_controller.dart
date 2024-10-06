import 'package:dio/dio.dart';
import 'package:mica/controller/BaseController.dart';
import 'package:mica/dto/ImageHouseDTO.dart';
import 'package:mica/utils/constants.dart';

class GetIdsController extends BaseController {
  Future<dynamic> getIds() async {
    try {
      String url = "/house/id";

      Response response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${Credentials.token}',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<ImageHouseDTO> imageList =
            data.map((item) => ImageHouseDTO.fromJson(item)).toList();

        return imageList;
      } else {
        throw Exception('Error al obtener las imágenes');
      }
    } catch (err) {
      throw Exception('Error de red: $err');
    }
  }
}
