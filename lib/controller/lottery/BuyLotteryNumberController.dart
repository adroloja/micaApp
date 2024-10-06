import 'package:dio/dio.dart';
import 'package:mica/controller/BaseController.dart';
import 'package:mica/dto/BuyLotteryDTO.dart';
import 'package:mica/utils/constants.dart';

class BuyLotteryNumberController extends BaseController {
  Future<dynamic> buyLotteryNumber(BuyLotteryDTO data) async {
    String url = "/lottery/buy";

    try {
      Response<dynamic> response = await dio.post(
        url,
        data: data,
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
