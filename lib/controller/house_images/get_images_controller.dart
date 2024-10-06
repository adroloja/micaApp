import 'package:dio/dio.dart';
import 'package:mica/controller/BaseController.dart';
import 'package:mica/dto/ImageHouseDTO.dart';
import 'package:mica/utils/constants.dart';
import 'package:mica/utils/secure_storage.dart';

class GetImagesController extends BaseController {
  Future<List<ImageHouseDTO>> getImages() async {
    try {
      String url = "/house";

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

        imageList.forEach((image) => SecureStorage.write(
            key: image.id.toString(), value: image.imageBase64!));

        return imageList;
      } else {
        throw Exception('Error al obtener las imágenes');
      }
    } catch (err) {
      throw Exception('Error de red: $err');
    }
  }
}
