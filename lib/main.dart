import 'package:fam_works/core/providers/bottom_provider.dart';
import 'package:fam_works/core/providers/location_provider.dart';
import 'package:fam_works/core/providers/media_provider.dart';
import 'package:fam_works/core/providers/auth_module_provider.dart.dart';
import 'package:fam_works/feature/services/auth/user_status.dart';
import 'package:fam_works/feature/utils/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: []);
    // _startLocationUpdate();
 runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthModuleProvider()),
        ChangeNotifierProvider(create: (_) => MediaProvider()),
        ChangeNotifierProvider(create: (_) => BottomProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(     
      ),
       home: const UserAuthStatus(),
       routes: Routes.appRoutes
//image picker sdk hatası veriyor daha düşük paketine geç
    );
  }

}
//   void _startLocationUpdate() {
//   Timer.periodic(Duration(minutes: 5), (timer) {
//     LocationService().updateUserLocation();
//   });
// }