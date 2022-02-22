import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class PushNotificationService {
  PushNotificationService._();

  factory PushNotificationService() => _instance;

  static final PushNotificationService _instance = PushNotificationService._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestPermission(sound: true, badge: true, alert: true);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("onMessage: $message");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("onMessageOpenedApp: $message");
      }
    });

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      if (kDebugMode) {
        print("onBackgroundMessage: $message");
      }
    });
  }

  Future<String> getToken() async {
    /*   if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      print('FlutterFire Messaging Example: Getting APNs token...');
      return await FirebaseMessaging.instance.getAPNSToken();
    } else {*/
    String token = "";
    await _fcm.getToken().then((value) async {
      token = value!;

      return;
    });

    if (kDebugMode) {
      print("onMessagetoke: $token");
    }
    return token;
  }
}
