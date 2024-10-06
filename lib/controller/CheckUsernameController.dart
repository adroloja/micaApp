import 'package:mica/controller/BaseController.dart';

class CheckUsernameController extends BaseController {
  Future<dynamic> check(String username) {
    String url = "/user/check/$username";

    return dio.get(url);
  }
}
