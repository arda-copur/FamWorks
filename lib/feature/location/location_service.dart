// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:geolocator/geolocator.dart';

// class LocationService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<void> updateUserLocation() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);

//       await _firestore.collection('users').doc(user.uid).update({
//         'location': GeoPoint(position.latitude, position.longitude),
//       });
//     }
//   }
// }
