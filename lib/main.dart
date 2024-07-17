// ignore_for_file: unused_local_variable

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:maxiruby/services/notiServise.dart';
import 'package:maxiruby/route/route_generator.dart';
import 'package:maxiruby/services/custom_animation.dart';
import 'package:maxiruby/services/fireBase.dart';
import 'package:maxiruby/services/setting.dart';

notiService nServis = notiService();
FirebaseNotificationService _fcmServis = FirebaseNotificationService();
GetStorage box = GetStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _fcmServis.connectNotification();

  FirebaseMessaging.onBackgroundMessage(_fcmServis.backgroundMessage);

  await GetStorage.init();
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.threeBounce
    ..maskType = EasyLoadingMaskType.custom
    ..loadingStyle = EasyLoadingStyle.custom
    ..textColor = Settings.primary
    ..indicatorColor = Colors.amber
    ..progressColor = Colors.pink
    ..backgroundColor = Colors.transparent
    ..boxShadow = <BoxShadow>[
      BoxShadow(
        color: Colors.transparent,
        spreadRadius: 5,
        blurRadius: 7,
        offset: Offset(0, 3), // changes position of shadow
      )
    ]
    ..maskColor = Color.fromARGB(149, 255, 255, 255)
    ..dismissOnTap = false
    ..userInteractions = false
    ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Settings.primary,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Settings.primary,
          onPrimary: Colors.white,
          onSurface: Colors.black,
        ),
        primarySwatch: Colors.red,
        fontFamily: "Rubik",
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Settings.primary,
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Settings.primary,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      onGenerateRoute: RouteGenerator.routeGenerator,
      builder: EasyLoading.init(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('tr', 'TR'),
      ],
    );
  }
}
