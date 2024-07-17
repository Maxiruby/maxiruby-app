import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:maxiruby/services/Uyari.dart';
import 'package:maxiruby/services/functions.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:maxiruby/widgets/button.dart';
import 'package:maxiruby/widgets/input.dart';
import 'package:maxiruby/widgets/maskInput.dart';
import 'package:maxiruby/widgets/select.dart';
import 'package:maxiruby/widgets/telInput.dart';

AppFunctions appFunctions = AppFunctions();
Uyari uyari = new Uyari();
GetStorage box = GetStorage();

class Login1 extends StatefulWidget {
  const Login1({Key? key}) : super(key: key);

  @override
  _Login1State createState() => _Login1State();
}

class _Login1State extends State<Login1> {
  String dil = Platform.localeName == 'tr_TR' ? 'tr' : 'en';
  Map<String, dynamic> sistemCevirileri = {};

  TextEditingController telefonEditing = new TextEditingController();
  String? telefon = null;
  bool phoneValid = false;

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

  Future<void> dogrulamaGonder() async {
    if (phoneValid == false) {
      uyari.warning(
          sistemCevirileri['Telefon numaranızı yanlış girdiniz.'] ?? '');
      return;
    }

    uyari.loadingShow(sistemCevirileri['Gönderiliyor..'] ?? '');

    var formData = FormData.fromMap({
      "telefon": telefon?.replaceAll('+', ''),
      "dil": dil,
    });

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
        box.write('userTelefon', telefon);
        box.write('girisDogrulamaKodu', response.data['dogrulamaKodu']);
        box.write('userGEposta', response.data['userGEposta']);

        Navigator.pushNamed(context, '/login-2');
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
                            sistemCevirileri['Telefon Numarası'] ?? '',
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 50),
                          child: Text(
                            sistemCevirileri[
                                    'Doğrulama kodunuz telefon numaranıza SMS olarak gönderilecektir.'] ??
                                '',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                        TelInput(
                            controller: telefonEditing,
                            phoneNumber: (p0) {
                              setState(() {
                                telefon = p0.phoneNumber;
                              });
                            },
                            phoneValid: (p0) {
                              setState(() {
                                phoneValid = p0;
                              });
                            },
                            placeHolder:
                                sistemCevirileri['Telefon Numaranız'] ?? '',
                            searchPlaceHolder: sistemCevirileri[
                                    'Ülke adı veya telefon kodu arayın'] ??
                                '',
                            backgroundType: 1)
                      ],
                    ),
                  ),
                  Button(
                    icon: FontAwesome5.chevron_right,
                    backgroundColor: Settings.primary,
                    textColor: Colors.white,
                    text: sistemCevirileri['DEVAM'] ?? '',
                    onPress: dogrulamaGonder,
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
