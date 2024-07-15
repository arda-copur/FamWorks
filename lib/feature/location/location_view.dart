// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FamilyMapScreen extends StatefulWidget {
//   @override
//   _FamilyMapScreenState createState() => _FamilyMapScreenState();
// }

// class _FamilyMapScreenState extends State<FamilyMapScreen> {
//   final MapController _mapController = MapController();
//   List<Marker> _markers = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadFamilyMembersLocations();
//   }

//   Future<void> _loadFamilyMembersLocations() async {
//     User? user = FirebaseAuth.instance.currentUser;

//     if (user != null) {
//       FirebaseFirestore.instance
//           .collection('users')
//           .where('homeCode', isEqualTo: user.uid)
//           .snapshots()
//           .listen((snapshot) {
//         List<Marker> newMarkers = [];

//         for (var doc in snapshot.docs) {
//           var data = doc.data()!;
//           if (data['location'] != null) {
//             GeoPoint location = data['location'];
//             newMarkers.add(
//               Marker(
//                 width: 80.0,
//                 height: 80.0,
//                 point: LatLng(location.latitude, location.longitude),
             
//                   child: Icon(
//                     Icons.location_on,
//                     color: Colors.red,
//                     size: 40.0,),
                  
                 
//               ),
//             );
//           }
//         }

//         setState(() {
//           _markers = newMarkers;
//         });
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FlutterMap(
//         mapController: _mapController,
//         options: MapOptions(
//           center: LatLng(37.7749, -122.4194), 
//           zoom: 10.0,
//         ),
       
//          children: [
//           TileLayer(urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//           subdomains: ['a', 'b', 'c'],),
//           MarkerLayer(markers: _markers)
//         ],
//       ),
//     );
//   }
// }
