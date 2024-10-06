import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mica/utils/constants.dart';
import 'package:mica/utils/secure_storage.dart';

class Authenticate {
  final Dio _dio = Dio();

  Future<bool> auth(String username, String password) async {
    String url = '${APIConstants.apiUrl}/user/token';

    try {
      // Realizar la solicitud POST
      Response<dynamic> response = await _dio.post(
        url,
        data: {
          'username': username,
          'password': password,
        },
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );

      // Verificar el código de estado de la respuesta
      if (response.statusCode == 200) {
        // Almacenar las credenciales de usuario en almacenamiento seguro
        await SecureStorage.write(key: "username", value: username);
        await SecureStorage.write(key: "password", value: password);
        await SecureStorage.write(key: username, value: password);

        // Actualizar las credenciales globales
        Credentials.password = password;
        Credentials.token = response.data["access_token"];
        Credentials.tokenRefresh = response.data["refresh_token"];

        // Decodificar el token JWT
        Map<String, dynamic> tokenDec =
            decodeToken(response.data["access_token"]);
        storeTokenData(tokenDec);

        // Imprimir para depuración
        print("Autenticación exitosa");
        print(tokenDec['email_verified']);

        // Devolver el estado de verificación del correo electrónico
        return tokenDec['email_verified'];
      } else {
        // Manejar el fallo en la autenticación
        print('Falló la autenticación: ${response.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      // Manejar excepciones Dio
      print('ERROR ---- DioException: ${e.message}');
      print('ERROR ---- Datos de la respuesta: ${e.response?.data}');
      print('ERROR ---- Código de estado: ${e.response?.statusCode}');
      if (e.response?.data.length > 0) {
        Fluttertoast.showToast(
            msg: "\n ${e.response?.data} \n",
            fontSize: 18,
            toastLength: Toast.LENGTH_LONG);
      }

      return false;
    } catch (e) {
      // Manejar cualquier otra excepción
      print('ERROR ----  Excepción desconocida: $e');
      return false;
    }
  }

  Map<String, dynamic> decodeToken(String token) {
    return JwtDecoder.decode(token);
  }

  void storeTokenData(Map<String, dynamic> decodedToken) {
    Credentials.lastName = decodedToken["family_name"];
    Credentials.firstName = decodedToken["given_name"];
    Credentials.id = decodedToken["sub"];
    Credentials.email = decodedToken["email"];
    Credentials.username = decodedToken["preferred_username"];
  }
}
