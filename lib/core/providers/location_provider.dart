import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  Position ? _lastPosition;

  Position? get currentPosition => _currentPosition;
  Position? get lastPosition => _lastPosition;

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Konum servislerinin etkin olup olmadığını kontrol edin.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Konum servisleri etkin değilse, kullanıcıya bildir.
      return Future.error('Location services are disabled.');
    }

    // Konum izni olup olmadığını kontrol edin.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // İzin reddedildi.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // İzin kalıcı olarak reddedildi.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Konumu alın ve bildirimde bulunun.
    _currentPosition = await Geolocator.getCurrentPosition();
   
    notifyListeners();
  }
}
