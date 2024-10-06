import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mica/main.dart';
import 'package:mica/utils/constants.dart';
import 'package:mica/utils/secure_storage.dart';

class BaseController {
  late Dio dio;

  String? _accessToken;

  // Constructor
  BaseController() {
    BaseOptions options = BaseOptions(
      baseUrl: APIConstants.apiUrl,
      connectTimeout: Duration(milliseconds: 5000),
      receiveTimeout: Duration(milliseconds: 35000),
    );
    dio = Dio(options);
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = 'Bearer ${Credentials.token}';
        options.headers['Content-Type'] = 'application/json';
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        // Manejar el error de token caducado
        if (e.response?.statusCode == 401) {
          // Intentar renovar el token aquí
          bool refreshSuccess = await _refreshToken();
          if (refreshSuccess) {
            // Si la renovación del token fue exitosa, reintentar la solicitud original
            RequestOptions options = e.requestOptions;
            options.headers['Authorization'] = 'Bearer ${Credentials.token}';

            try {
              var retryResponse = await dio.request(
                options.path,
                options: Options(
                  method: options.method,
                  headers: options.headers,
                  responseType: options.responseType,
                  contentType: options.contentType,
                ),
                data: options.data,
                queryParameters: options.queryParameters,
              );
              return handler.resolve(retryResponse);
            } catch (e) {
              // Manejar cualquier error que ocurra durante la solicitud
              return handler.next(DioException(
                requestOptions: options,
                error: e.toString(),
              ));
            }
          } else {
            // Intentar obtener un nuevo token si el refresh token ha caducado
            bool newTokenSuccess = await _obtainNewToken();
            if (newTokenSuccess) {
              // Si obtener un nuevo token fue exitoso, reintentar la solicitud original
              RequestOptions options = e.requestOptions;
              options.headers['Authorization'] = 'Bearer ${Credentials.token}';

              try {
                var retryResponse = await dio.request(
                  options.path,
                  options: Options(
                    method: options.method,
                    headers: options.headers,
                    responseType: options.responseType,
                    contentType: options.contentType,
                  ),
                  data: options.data,
                  queryParameters: options.queryParameters,
                );
                return handler.resolve(retryResponse);
              } catch (e) {
                // Manejar cualquier error que ocurra durante la solicitud
                return handler.next(DioException(
                  requestOptions: options,
                  error: e.toString(),
                ));
              }
            } else {
              navigatorKey.currentState?.pushReplacementNamed('/splash');
            }
          }
        }
        // Si no se puede manejar el error de token caducado, pasa el error al siguiente interceptor
        return handler.next(e);
      },
    ));
  }

  Future<bool> _refreshToken() async {
    Dio dio = Dio();
    var body = {'refresh_token': Credentials.tokenRefresh};
    var headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await dio.post(
        '${APIConstants.apiUrl}/user/refresh',
        data: body,
        options: Options(headers: headers),
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        var responseData = response.data;
        Credentials.token = responseData['access_token'];
        Credentials.tokenRefresh = responseData['refresh_token'];
        return true;
      } else {
        print('Error: ${response.statusCode} ${response.statusMessage}');
        print('Response data: ${response.data}');
        return false;
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response data: ${e.response?.data}');
      print('Status code: ${e.response?.statusCode}');
      return false;
    }
  }

  Future<bool> _obtainNewToken() async {
    String? username = await SecureStorage.read(key: "username");
    String? password = await SecureStorage.read(key: "password");
    String? password2 = await SecureStorage.read(key: username!);

    if (password == null) {
      password = password2;
    }
    print("Username: $username, Password: $password");
    // var headers = {
    //   'Content-Type': 'application/json',
    // };
    String url = '${APIConstants.apiUrl}/user/token';
    try {
      Response<dynamic> response = await dio.post(
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

      if (response.statusCode == 200) {
        Credentials.token = response.data["access_token"];
        Credentials.tokenRefresh = response.data["refresh_token"];
        Map<String, dynamic> tokenDec =
            decodeToken(response.data["access_token"]);
        storeTokenData(tokenDec);

        return tokenDec['email_verified'];
      }

      if (response.statusCode == 401) {
        print("entro");
        return false;
      } else {
        print('Failed to authenticate');
        return false;
      }
    } catch (err) {
      print('Error: $err');
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

  void updateAccessToken(String accessToken) {
    _accessToken = accessToken;
  }
}
