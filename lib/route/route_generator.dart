import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maxiruby/pages/anasayfa.dart';
import 'package:maxiruby/pages/bildirim.dart';
import 'package:maxiruby/pages/markaDetay.dart';
import 'package:maxiruby/security/check.dart';
import 'package:maxiruby/security/login1.dart';
import 'package:maxiruby/security/login2.dart';
import 'package:maxiruby/security/login3.dart';
import 'package:maxiruby/security/login4.dart';
import 'package:maxiruby/security/login44.dart';
import 'package:maxiruby/security/sifreDogrulama.dart';
import 'package:maxiruby/security/yeniSifre.dart';

class RouteGenerator {
  static Route<dynamic>? routeGenerator(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: ((context) => Check()),
        );

      case '/login-1':
        return MaterialPageRoute(
          builder: ((context) => Login1()),
        );

      case '/login-2':
        return MaterialPageRoute(
          builder: ((context) => Login2()),
        );

      case '/login-3':
        return MaterialPageRoute(
          builder: ((context) => Login3()),
        );

      case '/login-4':
        return MaterialPageRoute(
          builder: ((context) => Login4()),
        );

      case '/login-44':
        return MaterialPageRoute(
          builder: ((context) => Login44()),
        );
      case '/s-dogrulama':
        return MaterialPageRoute(
          builder: ((context) => SifreDogrulama()),
        );
      case '/yeni-sifre':
        return MaterialPageRoute(
          builder: ((context) => YeniSifre()),
        );
    }

    return null;
  }
}
