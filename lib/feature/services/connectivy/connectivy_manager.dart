import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityManager {
  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectivityResult> _connectivityStreamController = StreamController<ConnectivityResult>.broadcast();

  ConnectivityManager._internal() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectivityStreamController.add(result);
    });
  }

  static final ConnectivityManager _instance = ConnectivityManager._internal();

  factory ConnectivityManager() {
    return _instance;
  }

  Stream<ConnectivityResult> get connectivityStream => _connectivityStreamController.stream;

  Future<ConnectivityResult> getCurrentConnectivity() async {
    return await _connectivity.checkConnectivity();
  }

  String getConnectionStatusString(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'Bağlantı durumu: Wi-Fi 🌐';
      case ConnectivityResult.mobile:
        return 'Bağlantı durumu: Mobil Veri 📱';
      case ConnectivityResult.none:
        return 'Bağlantı durumu: Bağlantı Yok ❌';
      default:
        return 'Bağlantı durumu: Bilinmiyor ❔';
    }
  }

  void dispose() {
    _connectivityStreamController.close();
  }
}
