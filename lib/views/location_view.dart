import 'package:fam_works/core/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class LocationView extends StatefulWidget {
  const LocationView({super.key});

  @override
  _LocationViewState createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  @override
  void initState() {
    super.initState();
    // Konum güncellemesi almak için LocationManager'dan current location'ı isteyin.
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
    return Scaffold(
      body: Consumer<LocationProvider>(
        builder: (context, locationManager, child) {
          if (locationManager.currentPosition == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final currentPosition = locationManager.currentPosition!;
          final latLng = LatLng(currentPosition.latitude, currentPosition.longitude);

          return FlutterMap(
            options: MapOptions(minZoom: 3,
            maxZoom: 15,
            
              center: latLng,
              zoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: latLng,
                   
                     child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
            ],
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
