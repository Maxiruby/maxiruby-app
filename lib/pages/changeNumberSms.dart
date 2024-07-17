import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';

import 'package:get_storage/get_storage.dart';
import 'package:maxiruby/pages/anasayfa.dart';
import 'package:maxiruby/pages/profil.dart';
import 'package:maxiruby/services/Uyari.dart';
import 'package:maxiruby/services/functions.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:maxiruby/widgets/button.dart';
import 'package:maxiruby/widgets/input.dart';
import 'package:maxiruby/widgets/telInput.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

GetStorage box = GetStorage();
Uyari uyari = new Uyari();
AppFunctions function = new AppFunctions();

class ChangeNumberSms extends StatefulWidget {
  const ChangeNumberSms({Key? key}) : super(key: key);

  @override
  _ChangeNumberSmsState createState() => _ChangeNumberSmsState();
}

class _ChangeNumberSmsState extends State<ChangeNumberSms> {
  String dil = Platform.localeName == 'tr_TR' ? 'tr' : 'en';
  Map<String, dynamic> sistemCevirileri = {};

  TextEditingController dogrulamaKodu = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  bool pinValid = false;

  late Map<String, dynamic> user;
  List veriler = [];

  @override
  void initState() {
    super.initState();
    user = box.read('user');

    ceviriGonder();
  }

  Future ceviriGonder() async {
    uyari.loadingShow('');
    sistemCevirileri = await function.ceviri(dil);
    setState(() {});
    uyari.loadingFade();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> dogrulamaYap() async {
    if (pinValid == false) {
      uyari.warning(
          sistemCevirileri['Lütfen doğrulama kodunu tam giriniz.'] ?? '');
      return;
    } else {
      if (box.read('info_girisDogrulamaKodu') != dogrulamaKodu.text) {
        uyari.warning(
            sistemCevirileri['Lütfen doğrulama kodunu doğru giriniz.'] ?? '');
        return;
      } else {
        uyari.loadingShow(sistemCevirileri['Gönderiliyor..'] ?? '');

        var formData = FormData.fromMap({
          "telefon": box.read('info_userTelefon'),
          "uId": user['uId'],
        });

        try {
          Response response = await Dio().post(
            Settings.apiUrl + "security/changeNumber",
            data: formData,
            options: Options(
              validateStatus: (status) {
                return status! < 500;
              },
            ),
          );
          if (response.statusCode == 200) {
            uyari.success(
                sistemCevirileri['Telefon numaranız değiştirildi.'] ?? '');

            user['telefon'] = box.read('info_userTelefon');
            box.write('user', user);

            setState(() {});

            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.bottomToTop,
                child: Profil(),
              ),
            );
          } else {
            uyari.loadingFade();

            uyari.danger(response.data['error']);
            return;
          }
        } on DioError catch (e) {
          uyari.danger(sistemCevirileri['Sunucu Hatası!'] ?? '');
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromARGB(188, 47, 47, 47),
        ),
        backgroundColor: Color.fromARGB(255, 248, 248, 248),
        centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              Settings.fileManagerUrl + 'logo.webp',
              width: 160,
              fit: BoxFit.fitWidth,
            ),
            Text(
              sistemCevirileri['Numara Değiştir'] ?? '',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: Text(
                (sistemCevirileri['Doğrulama Kodu'] ?? '') + ':',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
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
              obscureText: false,
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
              controller: dogrulamaKodu,
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
            Button(
              backgroundColor: Settings.primary,
              textColor: Colors.white,
              text: sistemCevirileri['Değiştir'] ?? '',
              onPress: dogrulamaYap,
              loading: false,
              icon: FontAwesome5.check,
            ),
          ],
        ),
      ),
    );
  }
}
