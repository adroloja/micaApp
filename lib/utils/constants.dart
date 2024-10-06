import 'dart:io';
import 'package:flutter/material.dart';

class APIConstants {
  static const String apiUrl = 'http://192.168.100.141:8030/api';
  // static const String apiUrl = 'https://adroyoyo.es:8445/api';
  // static const String apiUrl = 'https://centscompany.com:8445/api';
}

class KeycloakUrl {
  static const String url = "https://centscompany.com:8444";
}

class KeycloakCredentials {
  static const String client_id = "mica-client";
  // static const String client_secret = "5Rvp9bVXopGyfubIu8ojYgERW4m4QtvX";   // localhost
  // static const String client_secret = "OGpesSfWVbVefv2FMQ4S15JLxHngEejd";  // adroyoyo
  static const String client_secret =
      "5vCz1cOC6SFWoq4PCVLgE1sVewOHzElx"; // cents company
}

class Credentials {
  static String? id;
  static String? token;
  static String? tokenRefresh;
  static String? password;
  static String? email;
  static String? username;
  static String? firstName;
  static String? lastName;
  static File? selfie;
  static bool? verified;
  static DateTime? countdown;
  static bool isEnabled = true;
  static String defaultPassword = "W9z!6Pq#Vt8Lx7";
  static bool isExternal = false;
  static String? giftEmail;
}

class CustomIcons {
  static const IconData facebook =
      IconData(0xe255, fontFamily: 'MaterialIcons');
  static const IconData apple = IconData(0xf04be, fontFamily: 'MaterialIcons');
}
