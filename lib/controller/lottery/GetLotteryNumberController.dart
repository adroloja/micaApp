import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mica/controller/BaseController.dart';
import 'package:mica/dto/BuyLotteryDTO.dart';
import 'package:mica/dto/LotteryNumberDTO.dart';
import 'package:mica/utils/constants.dart';

class GetLotteryNumberController extends BaseController {
  Future<dynamic> getOwnNumbers() async {
    String url = "/lottery/${Credentials.email}/owner";

    return dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${Credentials.token}',
        },
      ),
    );
  }

  Future<dynamic> getGiftNumbers() async {
    String url = "/lottery/${Credentials.email}/gift";

    return dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${Credentials.token}',
        },
      ),
    );
  }
}
