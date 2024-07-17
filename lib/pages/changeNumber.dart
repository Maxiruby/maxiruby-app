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
import 'package:maxiruby/pages/changeNumberSms.dart';
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

class ChangeNumber extends StatefulWidget {
  const ChangeNumber({Key? key}) : super(key: key);

  @override
  _ChangeNumberState createState() => _ChangeNumberState();
}

class _ChangeNumberState extends State<ChangeNumber> {
  String dil = Platform.localeName == 'tr_TR' ? 'tr' : 'en';
  Map<String, dynamic> sistemCevirileri = {};
  TextEditingController telefon = new TextEditingController();
  bool phoneValid = false;
  String? tel = null;

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

  Future<void> gonder() async {
    if (phoneValid == false) {
      uyari.warning(
          sistemCevirileri['Telefon numaranızı yanlış girdiniz.'] ?? '');
      return;
    }

    var formData = FormData.fromMap({
      "telefon": tel?.replaceAll('+', ''),
      "dil": dil,
      "ic": 1,
    });

    uyari.loadingShow(sistemCevirileri['Gönderiliyor..'] ?? '');

    try {
      Response response = await Dio().post(
        Settings.apiUrl + "dogrulamaSmsGonder",
        data: formData,
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        box.write('info_userTelefon', tel);
        box.write('info_girisDogrulamaKodu', response.data['dogrulamaKodu']);
        box.write('info_userGEposta', response.data['userGEposta']);

        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTop,
            child: ChangeNumberSms(),
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
            TelInput(
                controller: telefon,
                phoneNumber: (p0) {
                  setState(() {
                    tel = p0.phoneNumber;
                  });
                },
                phoneValid: (p0) {
                  setState(() {
                    phoneValid = p0;
                  });
                },
                placeHolder: sistemCevirileri['Yeni Telefon Numaranız'] ?? '',
                searchPlaceHolder:
                    sistemCevirileri['Ülke adı veya telefon kodu arayın'] ?? '',
                backgroundType: 1),
            Button(
              backgroundColor: Settings.primary,
              textColor: Colors.white,
              text: sistemCevirileri['Doğrula'] ?? '',
              onPress: gonder,
              loading: false,
              icon: FontAwesome5.check,
            ),
          ],
        ),
      ),
    );
  }
}
