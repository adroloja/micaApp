import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mica/utils/constants.dart';
import 'package:mica/utils/secure_storage.dart';

class UpdatePasswordController {
  Dio _dio = Dio();

  // Define tus credenciales y URL de Keycloak
  final String keycloakUrl = 'http://192.168.100.141:8181';
  final String realm = 'mica-realm';
  final String clientId = KeycloakCredentials.client_id;
  final String clientSecret = KeycloakCredentials.client_secret;

  // Método para obtener el token de acceso
  Future<String?> getAccessToken() async {
    try {
      final response = await _dio.post(
        '$keycloakUrl/realms/$realm/protocol/openid-connect/token',
        data: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'grant_type': 'client_credentials',
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      // Extrae el token de acceso del mapa de respuesta
      final accessToken = response.data['access_token'] as String?;
      return accessToken;
    } catch (e) {
      print('Error obteniendo el token de acceso: $e');
      return null;
    }
  }

  Future<void> updatePassword(String newPassword, BuildContext context) async {
    final accessToken = await getAccessToken();
    final userId = Credentials.id;
    if (accessToken == null) {
      return;
    }

    try {
      await _dio.put(
        'http://192.168.100.141:8181/admin/realms/mica-realm/users/$userId/reset-password',
        data: {
          'type': 'password',
          'value': newPassword,
          'temporary': false,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );
      Fluttertoast.showToast(
          msg: "\n Contraseña actualizada con éxito. \n",
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG);
      SecureStorage.write(key: Credentials.email!, value: newPassword);
      Navigator.of(context).pushReplacementNamed("/profile");
    } catch (e) {
      Fluttertoast.showToast(
          msg: "\n Error actualizando la contraseña: $e \n",
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG);
    }
  }
}
