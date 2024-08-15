import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fam_works/feature/services/connectivy/connectivy_manager.dart';
import 'package:fam_works/feature/services/firebase_service.dart';
import 'package:fam_works/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

abstract class HomeViewModel extends State<HomeView> {
  late StreamSubscription<ConnectivityResult> subscription;
  String connectionStatus = 'Bağlantı durumu: Bilinmiyor';
  final String tasksText = "Görevler";
  FirebaseService service = FirebaseService();

  @override
  void initState() {
    super.initState();
    subscription = ConnectivityManager()
        .connectivityStream
        .listen((ConnectivityResult result) {
      setState(() {
        connectionStatus =
            ConnectivityManager().getConnectionStatusString(result);
      });
    });

    _checkCurrentConnectivity();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<void> _checkCurrentConnectivity() async {
    ConnectivityResult result =
        await ConnectivityManager().getCurrentConnectivity();
    setState(() {
      connectionStatus =
          ConnectivityManager().getConnectionStatusString(result);
    });
  }


   void showRatingDialog(String taskId, String completedById) {
    double rate = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Görevi tamamlayan kişiye puan verin'),
          content: RatingBar.builder(
            initialRating: 1,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                rate = rating;
              });
            },
          ),
          actions: [
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Puan Ver'),
              onPressed: () {
                service.rateUser(taskId, completedById, rate);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
