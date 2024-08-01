import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;

  Position? get currentPosition => _currentPosition;

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Konum servislerinin etkin olup olmadığını kontrol edin.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Konum izni olup olmadığını kontrol edin.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // Konumu alın ve Firestore'a kaydedin.
    _currentPosition = await Geolocator.getCurrentPosition();

    // Firebase Auth ile şu anki kullanıcıyı alın
   User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      String name = userDoc['name'] ?? 'Kullanıcı';
      String homeCode = userDoc['homeCode'];

      await FirebaseFirestore.instance
          .collection('locations')
          .doc(user.uid) // Kullanıcıya özgü belgeyi güncelle
          .set({
            'latitude': _currentPosition!.latitude,
            'longitude': _currentPosition!.longitude,
            'name': name,
            'homeCode': homeCode,
          }, SetOptions(merge: true)); // Belgeyi güncellemek için `merge: true` kullanılır

      notifyListeners();
    }
  }
}
