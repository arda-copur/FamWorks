import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam_works/feature/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocationView extends StatefulWidget {
  const LocationView({super.key});

  @override
  _LocationViewState createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).getCurrentLocation();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      // Konum izni verildi, işlemleri yapabilirsiniz
    } else {
      // Konum izni verilmedi, kullanıcıya bilgi verin
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Veri bulunamadı'));
          }

          var userData = snapshot.data!;
          String homeCode = userData['homeCode'];

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('locations')
                .where('homeCode', isEqualTo: homeCode)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return const Center(child: Text('Konum verisi bulunamadı'));
              }

              var locations = snapshot.data!.docs;

              return Consumer<LocationProvider>(
                builder: (context, locationManager, child) {
                  if (locationManager.currentPosition == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final currentPosition = locationManager.currentPosition!;
                  final latLng = LatLng(currentPosition.latitude, currentPosition.longitude);

                  return FlutterMap(
                    options: MapOptions(
                      minZoom: 3,
                      maxZoom: 25,
                      center: latLng,
                      zoom: 15.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: locations.map((location) {
                          var locData = location.data() as Map<String, dynamic>;
                          return Marker(
                            width: 80.0,
                            height: 80.0,
                            point: LatLng(locData['latitude'], locData['longitude']),
                            
                          
                               child: Column(
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        "${locData['name']} Konum",
                                        style:  TextStyle(
                                           color: locData['uid'] == user?.uid ? Colors.red : Colors.amber,
                                           fontWeight: FontWeight.bold
                                          ),
                                      ),
                                    ),
                                    Icon(
                                  Icons.location_on,
                                  color: locData['uid'] == user?.uid ? Colors.red : Colors.amber,
                                  size: 40.0,
                                ),
                                  ],
                                      
                              
                                ),
                            
                            
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<LocationProvider>(context, listen: false).getCurrentLocation();
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
