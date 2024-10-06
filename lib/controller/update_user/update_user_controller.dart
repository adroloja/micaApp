import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mica/controller/BaseController.dart';
import 'package:mica/dto/UpdateUserDTO.dart';
import 'package:mica/utils/constants.dart';

class UpdateUserController extends BaseController {
  Future<void> update() async {
    try {
      String url = "/user";

      UpdateUserDTO updateUserDTO = UpdateUserDTO(
          id: Credentials.id,
          firstName: Credentials.firstName,
          lastName: Credentials.lastName,
          email: Credentials.email);

      Response response = await dio.put(url,
          data: updateUserDTO.toJson(),
          options: Options(headers: {
            'Authorization': 'Bearer ${Credentials.token}',
          }));
      Map<String, dynamic> responseData = jsonDecode(response.data!);
      Fluttertoast.showToast(
          msg: '\n ${responseData["message"]} \n',
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG);
    } catch (err) {
      Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          msg:
              "\n Ha ocurrido un error al actualizar el usuario, por favor intentelo más tarde \n");
    }
  }
}
