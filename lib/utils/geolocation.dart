import 'package:geolocator/geolocator.dart';

class Geolocation {
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Los servicios de ubicación no están habilitados, devuelve null
      print("Los servicios de ubicación están deshabilitados.");
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Los permisos de ubicación están denegados.");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Los permisos de ubicación están denegados para siempre.");
      return null;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return position;
  }
}
