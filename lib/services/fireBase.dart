// ignore_for_file: unnecessary_null_comparison

import 'package:maxiruby/services/firebase_options.dart';
import 'package:maxiruby/services/notiServise.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseNotificationService {
  notiService nServis = notiService();

  late final FirebaseMessaging messaging;

  void settingNotification() async {
    nServis.main();
    nServis.isAndroidPermissionGranted();
    nServis.requestPermissions();
    await messaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );
  }

  void connectNotification() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    messaging = FirebaseMessaging.instance;

    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );
    settingNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      Map<String, dynamic> veriler = event.data;

      nServis.showNotification(
        event.notification.hashCode,
        event.notification?.title as String,
        event.notification?.body as String,
        veriler['payload'] ?? "/home",
      );
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    messaging.onTokenRefresh;

    messaging
        .getToken(
            vapidKey:
                'BGrn-Bs2Uob0Yn7wadccAX_DSgBGX56WF2mXROh8aCXXc1ljkK_jqzbNnixJF2Pa8A0iBRrn3zydPGS-uGjF2rQ')
        .then((value) {
      prefs.setString('appFbToken', value!);
      if (value == null) {
        prefs.setString('appFbToken', "");
      }

      print("token:" + value);
    });
  }

  Future<void> backgroundMessage(RemoteMessage event) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    settingNotification();

    Map<String, dynamic> veriler = event.data;

    nServis.showNotification(
      event.notification.hashCode,
      event.notification?.title as String,
      event.notification?.body as String,
      veriler['payload'] ?? "/home",
    );
  }
}
