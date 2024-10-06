import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mica/controller/BaseController.dart';
import 'package:mica/dto/CreatePromotionDTO.dart';
import 'package:mica/utils/constants.dart';

class PromotionController extends BaseController {
  Future<String?> createPromotion(CreatePromotionDTO promotion) async {
    try {
      String url = "/promotion";

      Response response = await dio.post(
        url,
        data: promotion,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${Credentials.token}',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        print("entro en 200");
        Map<String, dynamic> message = jsonDecode(response.data);
        print(message);
        print(message["message"]);
        return message["message"];
      } else {
        Map<String, dynamic> message = jsonDecode(response.data);
        print("entro en otro");

        print(response.data);
        return message['message'];
      }
    } on DioException catch (e) {
      print("Error capturado en catch de DioException");

      if (e.response != null && e.response?.data != null) {
        try {
          Map<String, dynamic> errorData = e.response!.data;
          print("Error desde el servidor: ${errorData['message']}");
          return errorData['message'];
        } catch (parseError) {
          print("No se pudo parsear el cuerpo del error: ${e.response!.data}");
          return "Ocurrió un error desconocido.";
        }
      } else {
        print("Error sin respuesta del servidor.");
        return "Ocurrió un error al intentar conectar con el servidor.";
      }
    } catch (e) {
      print("Otro tipo de error capturado: ${e.toString()}");
      return "Ocurrió un error inesperado.";
    }
  }
}
