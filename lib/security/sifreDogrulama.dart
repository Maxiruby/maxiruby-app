import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maxiruby/services/Uyari.dart';
import 'package:maxiruby/services/functions.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:maxiruby/widgets/button.dart';
import 'package:maxiruby/widgets/input.dart';
import 'package:maxiruby/widgets/maskInput.dart';
import 'package:maxiruby/widgets/select.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

AppFunctions appFunctions = AppFunctions();
Uyari uyari = new Uyari();
GetStorage box = GetStorage();

class SifreDogrulama extends StatefulWidget {
  const SifreDogrulama({Key? key}) : super(key: key);

  @override
  _SifreDogrulamaState createState() => _SifreDogrulamaState();
}

class _SifreDogrulamaState extends State<SifreDogrulama> {
  String dil = Platform.localeName == 'tr_TR' ? 'tr' : 'en';
  Map<String, dynamic> sistemCevirileri = {};

  TextEditingController dogrulamaKodu = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  bool pinValid = false;

  @override
  void initState() {
    super.initState();
    ceviriGonder();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future ceviriGonder() async {
    uyari.loadingShow('');
    sistemCevirileri = await appFunctions.ceviri(dil);

    uyari.loadingFade();
    setState(() {});
  }

  void dogrulamaYap() {
    if (pinValid == false) {
      uyari.warning(
          sistemCevirileri['Lütfen doğrulama kodunu tam giriniz.'] ?? '');
      return;
    } else {
      if (box.read('sifreDogrulamaKodu') != dogrulamaKodu.text) {
        uyari.warning(
            sistemCevirileri['Lütfen doğrulama kodunu doğru giriniz.'] ?? '');
        return;
      } else {
        Navigator.pushNamed(context, '/yeni-sifre');
      }
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
                            sistemCevirileri['Hesabınızı doğrulayın'] ?? '',
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 50),
                          child: Text(
                            sistemCevirileri[
                                    'Girişte kullandığınız numaraya 6 haneli şifre yenilemeniz için doğrulama kodu gönderilmiştir. Lütfen aşağıya giriniz.'] ??
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
                      ],
                    ),
                  ),
                  Button(
                    icon: FontAwesome5.check_circle,
                    backgroundColor: Settings.primary,
                    textColor: Colors.white,
                    text: sistemCevirileri['DOĞRULA'] ?? '',
                    onPress: dogrulamaYap,
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

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
