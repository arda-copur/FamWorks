import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalManager {

  void connection() {
  OneSignal.initialize("a45dd3f7-4937-4f9c-98ee-561c0604ec06");
  OneSignal.Debug.setLogLevel(OSLogLevel.none);
}


  static void get login async {
    var userId = 'unique userId';
    // Bir kullanıcının OneSignal SDK'ya giriş yapması, 
    // kullanıcı bağlamını söz konusu kullanıcıya değiştirecektir.
    // OneSignal tarafında externalId ile cihaz eşleştirmesi yapılarak
    // kullanıcıya özel bildirim gönderirken bu değer ile özel bildirim
    // gönderebiliriz.
    await OneSignal.login(userId);
  }

  static void get logout async {
    await OneSignal.logout();
  }

  static void initialize() async {
    await OneSignal.Debug.setLogLevel(OSLogLevel.none);
    OneSignal.initialize("YOUR APP ID");
    login;
    // Bildirim izni yoksa kullanıcıdan bildirim izni alıyoruz
    await OneSignal.Notifications.requestPermission(true).then((accepted) {});
  }

  static get onClick {
    OneSignal.Notifications.addClickListener((OSNotificationClickEvent result) async {
      // Bildirime tıkladığında yapılacak işlemleri burada gerçekleştiriyoruz
      print('notification onClick');
    });
  }
}