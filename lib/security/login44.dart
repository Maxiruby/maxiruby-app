import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:maxiruby/pages/anasayfa.dart';
import 'package:maxiruby/security/sozlesme.dart';
import 'package:maxiruby/services/Uyari.dart';
import 'package:maxiruby/services/functions.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:maxiruby/widgets/button.dart';
import 'package:maxiruby/widgets/input.dart';
import 'package:maxiruby/widgets/maskInput.dart';
import 'package:maxiruby/widgets/select.dart';
import 'package:maxiruby/widgets/switchh.dart';
import 'package:maxiruby/widgets/telInput.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

AppFunctions appFunctions = AppFunctions();
Uyari uyari = new Uyari();
GetStorage box = GetStorage();

class Login44 extends StatefulWidget {
  const Login44({Key? key}) : super(key: key);

  @override
  _Login44State createState() => _Login44State();
}

class _Login44State extends State<Login44> {
  String dil = Platform.localeName == 'tr_TR' ? 'tr' : 'en';
  Map<String, dynamic> sistemCevirileri = {};

  TextEditingController sifre = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  bool pinValid = false;

  @override
  void initState() {
    super.initState();

    ceviriGonder();
  }

  Future ceviriGonder() async {
    uyari.loadingShow('');
    sistemCevirileri = await appFunctions.ceviri(dil);

    uyari.loadingFade();
    setState(() {});
  }

  Future<void> girisYap() async {
    if (pinValid == false) {
      uyari.warning(sistemCevirileri['Lütfen şifrenizi tam giriniz.'] ?? '');
      return;
    }

    uyari.loadingShow(sistemCevirileri['Lütfen bekleyin..'] ?? '');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var appFbToken = prefs.getString('appFbToken') ?? "";

    var formData = jsonEncode(<String, String>{
      "username": box.read('userGEposta')!,
      "password": sifre.text!,
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
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        uyari.loadingFade();
        Map<String, dynamic> veriler = response.data;

        box.write('user', response.data);

        prefs.setBool('giris', true);
        prefs.setString('u_username', box.read('userGEposta'));
        prefs.setString('u_password', sifre.text);
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
        uyari.loadingFade();
        uyari.danger(sistemCevirileri['Geçersiz kimlik bilgileri'] ?? '');
        return;
      }
    } on DioError catch (e) {
      uyari.loadingFade();
      uyari.danger(sistemCevirileri['Sunucu Hatası!'] ?? '');
      return;
    }
  }

  Future<void> sifremiUnuttum() async {
    uyari.loadingShow(sistemCevirileri['Gönderiliyor..'] ?? '');

    var formData = FormData.fromMap({
      "telefon": box.read('userTelefon').replaceAll('+', ''),
      "dil": dil,
    });

    try {
      Response response = await Dio().post(
        Settings.apiUrl + "dogrulamaSmsGonderSifre",
        data: formData,
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        box.write('sifreDogrulamaKodu', response.data['dogrulamaKodu']);
        box.write('userGEposta', response.data['userGEposta']);

        Navigator.pushNamed(context, '/s-dogrulama');
      } else {
        uyari.danger(response.data['error']);
        return;
      }
    } on DioError catch (e) {
      uyari.danger(sistemCevirileri['Sunucu Hatası!'] ?? '');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                          child: Text(
                            sistemCevirileri['Şifreni gir'] ?? '',
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                          child: Text(
                            sistemCevirileri['6 haneli şifreni girmelisin'] ??
                                '',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                        PinCodeTextField(
                          autoDismissKeyboard: true,
                          autoFocus: true,
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 6,
                          obscureText: true,
                          blinkWhenObscuring: true,
                          animationType: AnimationType.fade,
                          validator: (v) {
                            if (v!.length < 6) {
                              pinValid = false;
                            } else {
                              pinValid = true;
                            }
                          },
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeFillColor: Colors.white,
                            selectedColor: Color.fromARGB(255, 203, 203, 203),
                            selectedFillColor: Colors.white,
                            inactiveFillColor: Colors.white,
                            inactiveColor: Color.fromARGB(255, 203, 203, 203),
                          ),
                          cursorColor: Colors.black,
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: sifre,
                          keyboardType: TextInputType.number,
                          boxShadows: const [
                            BoxShadow(
                              offset: Offset(0, 1),
                              color: Colors.black12,
                              blurRadius: 10,
                            )
                          ],
                          onChanged: (String value) {},
                        ),
                        GestureDetector(
                          onTap: sifremiUnuttum,
                          child: Text(
                            sistemCevirileri["Şifremi unuttum"] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Settings.primary,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Button(
                    icon: FontAwesome5.chevron_right,
                    backgroundColor: Settings.primary,
                    textColor: Colors.white,
                    text: sistemCevirileri['GİRİŞ YAP'] ?? '',
                    onPress: girisYap,
                    loading: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
