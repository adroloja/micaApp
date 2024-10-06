import 'package:dio/dio.dart';
import 'package:mica/dto/UserGoogleInfo.dart';
import 'package:mica/utils/constants.dart';
import 'package:mica/utils/secure_storage.dart';

class GoogleController {
  final Dio dio = Dio();

  Future<UserGoogleInfo?> getUserInfo(String token) async {
    String url = "https://www.googleapis.com/oauth2/v3/userinfo";

    try {
      Response<dynamic> response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        String defaultPassword = Credentials.defaultPassword;

        UserGoogleInfo user = UserGoogleInfo.fromJson(response.data);
        Credentials.email = user.email;
        Credentials.firstName = user.givenName;
        Credentials.lastName = user.name.substring(user.givenName.length);
        Credentials.verified = user.emailVerified;
        Credentials.username = user.email;

        SecureStorage.write(key: "username", value: user.email);

        String? passwordStored = await SecureStorage.read(key: user.email);

        if (passwordStored != null && passwordStored != defaultPassword) {
          Credentials.password = passwordStored;
        } else {
          SecureStorage.write(key: user.email, value: defaultPassword);
          Credentials.password = defaultPassword;
        }
        return user;
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
