import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maxiruby/pages/anasayfa.dart';
import 'package:maxiruby/services/Uyari.dart';
import 'package:maxiruby/services/location.dart';
import 'package:maxiruby/services/notiServise.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:maxiruby/loading.dart';
import 'package:maxiruby/services/notiServise.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetStorage box = GetStorage();
notiService nServis = notiService();
Uyari uyari = new Uyari();
Locations locations = new Locations();

class Check extends StatefulWidget {
  const Check({super.key});

  @override
  State<Check> createState() => _CheckState();
}

class _CheckState extends State<Check> {
  String dil = Platform.localeName == 'tr_TR' ? 'tr' : 'en';

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    String defaultLocale = Platform.localeName;
    box.write('dil', defaultLocale == 'tr_TR' ? 'tr' : 'en');

    loginCheck();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Stack(
        children: [
          Loading(),
        ],
      ),
    );
  }

  void loginCheck() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('giris') == false) {
      Navigator.pushNamed(context, '/login-1');
    } else {
      if (prefs.getString('u_username') != null) {
        gizliLogin();
      } else {
        Navigator.pushNamed(context, '/login-1');
      }
    }
  }

  void gizliLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var appFbToken = prefs.getString('appFbToken') ?? "";
    var username = prefs.getString('u_username');
    var password = prefs.getString('u_password');

    var formData = jsonEncode(<String, String>{
      "username": username!,
      "password": password!,
    });

    try {
      Response response = await Dio().post(
        Settings.apiUrl +
            "security/login?appFbToken=" +
            appFbToken +
            '&dil=' +
            dil +
            '&ulke=' +
            Platform.localeName,
        data: formData,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> veriler = response.data;
        box.write('user', response.data);

        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTop,
            child: Anasayfa(
              index: 0,
            ),
          ),
        );
      } else {
        Navigator.pushNamed(context, '/login-1');
      }
    } on DioError catch (e) {
      Navigator.pushNamed(context, '/login-1');
    }
  }
}
