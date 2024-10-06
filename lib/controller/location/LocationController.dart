import 'package:dio/dio.dart';
import 'package:mica/controller/BaseController.dart';
import 'package:mica/dto/LocationDTO.dart';
import 'package:mica/utils/constants.dart';

class LocationController extends BaseController {
  void sendLocation(double lat, double lng) {
    PositionDTO positionDTO =
        PositionDTO(email: Credentials.email!, lat: lat, lng: lng);
    String url = "/position";

    dio.post(
      url,
      data: positionDTO,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${Credentials.token}',
        },
      ),
    );
  }
}
