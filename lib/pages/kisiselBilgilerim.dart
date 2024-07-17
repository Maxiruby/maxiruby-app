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
import 'package:maxiruby/services/Uyari.dart';
import 'package:maxiruby/services/functions.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:maxiruby/widgets/button.dart';
import 'package:maxiruby/widgets/input.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

GetStorage box = GetStorage();
Uyari uyari = new Uyari();
AppFunctions function = new AppFunctions();

class KisiselBilgilerim extends StatefulWidget {
  const KisiselBilgilerim({Key? key}) : super(key: key);

  @override
  _KisiselBilgilerimState createState() => _KisiselBilgilerimState();
}

class _KisiselBilgilerimState extends State<KisiselBilgilerim> {
  String dil = Platform.localeName == 'tr_TR' ? 'tr' : 'en';
  Map<String, dynamic> sistemCevirileri = {};
  TextEditingController adsoyad = new TextEditingController();
  TextEditingController eposta = new TextEditingController();

  late Map<String, dynamic> user;
  List veriler = [];

  @override
  void initState() {
    super.initState();
    user = box.read('user');

    adsoyad.text = user['adsoyad'];
    eposta.text = user['email'];

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

  Future<void> guncelle() async {
    if (eposta.text == '' || adsoyad.text == '') {
      uyari.warning(
          sistemCevirileri['Lütfen zorunlu alanları doldurunuz.'] ?? '');
      return;
    }

    if (!EmailValidator.validate(eposta.text!)) {
      uyari.danger(
          sistemCevirileri['Lütfen geçerli bir e-posta adresi giriniz.'] ?? '');
      return;
    }

    uyari.loadingShow(sistemCevirileri['Lütfen bekleyin..'] ?? '');

    var formData = FormData.fromMap(
        {"uId": user['uId'], "adsoyad": adsoyad.text, "eposta": eposta.text});

    try {
      Response response = await Dio().post(
        Settings.apiUrl + "security/changeInformation",
        data: formData,
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        uyari.success(
            sistemCevirileri['Kişisel bilgileriniz başarıyla güncellendi.'] ??
                '');

        user['adsoyad'] = adsoyad.text;
        user['email'] = eposta.text;

        box.write('user', user);
        setState(() {});

        Navigator.of(context, rootNavigator: true).pop();
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
              sistemCevirileri['Kişisel Bilgilerim'] ?? '',
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
            Input(
              controller: adsoyad,
              placeHolder: sistemCevirileri['Ad Soyad'] ?? '',
              backgroundType: 1,
              keyboardAction: TextInputAction.next,
            ),
            Input(
              controller: eposta,
              placeHolder: sistemCevirileri['E-Posta Adresi'] ?? '',
              backgroundType: 1,
              keyboardAction: TextInputAction.done,
              keyboardType: TextInputType.emailAddress,
            ),
            Button(
              backgroundColor: Settings.primary,
              textColor: Colors.white,
              text: sistemCevirileri['Güncelle'] ?? '',
              onPress: guncelle,
              loading: false,
              icon: FontAwesome5.check,
            ),
          ],
        ),
      ),
    );
  }
}
