import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;

class OneSignalManager {
  final oneSignalAppId = dotenv.env['ONESIGNAL_APP_ID'] ?? 'default-value';

  void connection() {
    OneSignal.initialize(oneSignalAppId);
    OneSignal.Debug.setLogLevel(OSLogLevel.none);
  }

  static void get login async {
    var userId = 'unique userId';
    await OneSignal.login(userId);
  }

  static void get logout async {
    await OneSignal.logout();
  }

  static void initialize() async {
    await OneSignal.Debug.setLogLevel(OSLogLevel.none);
    OneSignal.initialize("YOUR APP ID");
    login;
    await OneSignal.Notifications.requestPermission(true).then((accepted) {});
  }

  static get onClick {
    OneSignal.Notifications.addClickListener(
        (OSNotificationClickEvent result) async {
      print('notification onClick');
    });
  }

  final String oneSignalApiKey = 'YOUR_ONESIGNAL_API_KEY';

  Future<void> sendNotification(String playerId) async {
    final url = 'https://onesignal.com/api/v1/notifications';
    final headers = {
      'Authorization': 'Basic $oneSignalApiKey',
      'Content-Type': 'application/json'
    };
    final body = jsonEncode({
      'app_id': oneSignalAppId,
      'include_player_ids': [playerId],
      'contents': {'en': 'You have successfully logged in!'},
      'headings': {'en': 'Login Notification'}
    });

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Notification sent successfully');
        print('Response: ${response.body}');
      } else {
        print('Failed to send notification');
        print('Status Code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
