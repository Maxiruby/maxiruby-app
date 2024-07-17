import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
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

AppFunctions appFunctions = AppFunctions();
Uyari uyari = new Uyari();
GetStorage box = GetStorage();

class Login3 extends StatefulWidget {
  const Login3({Key? key}) : super(key: key);

  @override
  _Login3State createState() => _Login3State();
}

class _Login3State extends State<Login3> {
  String dil = Platform.localeName == 'tr_TR' ? 'tr' : 'en';
  Map<String, dynamic> sistemCevirileri = {};

  TextEditingController referans = new TextEditingController();
  TextEditingController adsoyad = new TextEditingController();
  TextEditingController eposta = new TextEditingController();
  bool kvkk = false;
  bool kbk = false;
  bool pks = false;

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

  Future<void> sozlesmeGetir(int id, String tur) async {
    uyari.loadingShow(sistemCevirileri['Veri getiriliyor..'] ?? '');

    var formData = FormData.fromMap({
      'id': id,
      'dil': dil,
    });

    try {
      Response response = await Dio().post(
        Settings.apiUrl + "sozlesmeGetir",
        data: formData,
      );
      if (response.statusCode == 200) {
        uyari.loadingFade();
        Map<String, dynamic> duzenleVeri = response.data;

        showBarModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => Sozlesme(
            veri: duzenleVeri,
          ),
        ).whenComplete(() {
          if (tur == 'kvkk') {
            setState(() {
              kvkk = true;
            });
          }

          if (tur == 'kbk') {
            setState(() {
              kbk = true;
            });
          }

          if (tur == 'pks') {
            setState(() {
              pks = true;
            });
          }
        });
      } else {
        uyari.danger(sistemCevirileri['Sunucu Hatası!'] ?? '');
        return;
      }
    } on DioError catch (e) {
      uyari.danger(sistemCevirileri['Sunucu Hatası!'] ?? '');
      return;
    }
  }

  Future<void> kayitKontrol() async {
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

    if (kvkk == false || kbk == false || pks == false) {
      uyari.warning(
          sistemCevirileri['Lütfen politikaları okuyun ve onaylayın.'] ?? '');
      return;
    }

    uyari.loadingShow(sistemCevirileri['Lütfen bekleyin..'] ?? '');

    var formData = FormData.fromMap({
      "eposta": eposta.text,
      "referans": referans.text,
      "dil": dil,
    });

    try {
      Response response = await Dio().post(
        Settings.apiUrl + "security/epostaKontrol",
        data: formData,
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        box.write('userEposta', eposta.text);
        box.write('userAdSoyad', adsoyad.text);
        box.write('userReferans', referans.text);

        Navigator.pushNamed(context, '/login-4');
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
              child: ListView(
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                          child: Text(
                            sistemCevirileri['Tamam! Kayıt ol'] ?? '',
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                          child: Text(
                            sistemCevirileri[
                                    'Bilgilerin ile kaydı tamamlayabilirsin.'] ??
                                '',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                        Input(
                          controller: referans,
                          placeHolder:
                              (sistemCevirileri['Referans Kodu'] ?? ''),
                          backgroundType: 1,
                          keyboardAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          leftIcon: FontAwesome5.barcode,
                        ),
                        Input(
                          controller: eposta,
                          placeHolder:
                              "* " + (sistemCevirileri['E-Posta'] ?? ''),
                          backgroundType: 1,
                          keyboardAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          leftIcon: FontAwesome5.envelope,
                        ),
                        Input(
                          controller: adsoyad,
                          placeHolder:
                              "* " + (sistemCevirileri['Ad Soyad'] ?? ''),
                          backgroundType: 1,
                          keyboardAction: TextInputAction.done,
                          keyboardType: TextInputType.name,
                          leftIcon: FontAwesome5.user_alt,
                        ),
                        Switchh(
                          label: sistemCevirileri[
                                  'KVKK kullanım sözleşmesini okudum, onaylıyorum.'] ??
                              '',
                          value: kvkk,
                          checkUpdate: (value) {
                            setState(() {
                              kvkk = value;
                            });
                          },
                          labelClick: () {
                            sozlesmeGetir(2, 'kvkk');
                          },
                        ),
                        Switchh(
                          label: sistemCevirileri[
                                  "Kişisel bilgilerin kullanılması sözleşmesini okudum, onaylıyorum."] ??
                              '',
                          value: kbk,
                          checkUpdate: (value) {
                            setState(() {
                              kbk = value;
                            });
                          },
                          labelClick: () {
                            sozlesmeGetir(3, 'kbk');
                          },
                        ),
                        Switchh(
                          label: sistemCevirileri[
                                  "Platform kullanım sözleşmesini okudum, onaylıyorum."] ??
                              '',
                          value: pks,
                          checkUpdate: (value) {
                            setState(() {
                              pks = value;
                            });
                          },
                          labelClick: () {
                            sozlesmeGetir(4, 'pks');
                          },
                        ),
                      ],
                    ),
                  ),
                  Button(
                    icon: FontAwesome5.chevron_right,
                    backgroundColor: Settings.primary,
                    textColor: Colors.white,
                    text: sistemCevirileri['KAYDOL'] ?? '',
                    onPress: kayitKontrol,
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
