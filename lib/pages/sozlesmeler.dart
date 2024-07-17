import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';

import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maxiruby/pages/anasayfa.dart';
import 'package:maxiruby/pages/changePassword.dart';
import 'package:maxiruby/pages/indirimDetay.dart';
import 'package:maxiruby/security/sozlesme.dart';
import 'package:maxiruby/services/Uyari.dart';
import 'package:maxiruby/services/functions.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:maxiruby/widgets/button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

GetStorage box = GetStorage();
Uyari uyari = new Uyari();
AppFunctions function = new AppFunctions();

class Sozlesmeler extends StatefulWidget {
  const Sozlesmeler({
    Key? key,
  }) : super(key: key);

  @override
  _SozlesmelerState createState() => _SozlesmelerState();
}

class _SozlesmelerState extends State<Sozlesmeler> {
  String dil = Platform.localeName == 'tr_TR' ? 'tr' : 'en';
  Map<String, dynamic> sistemCevirileri = {};

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

    uyari.loadingFade();
    getir();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getir() async {
    uyari.loadingShow(sistemCevirileri['Veriler getiriliyor..'] ?? '');

    var formData = FormData.fromMap({
      "uId": user['uId'],
    });

    try {
      Response response = await Dio().post(
        Settings.apiUrl + "sozlesmeler/getir",
        data: formData,
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        uyari.loadingFade();
        veriler = response.data;

        setState(() {});
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
              sistemCevirileri['Sözleşmeler'] ?? '',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            for (var veri in veriler) ...[
              userSekil(() {
                var newVeri = {
                  'baslik':
                      (dil == 'tr' ? veri['s_baslik'] : veri['s_baslikEn']),
                  'metin': dil == 'tr' ? veri['s_metin'] : veri['s_metinEn']
                };
                showBarModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Sozlesme(
                    veri: newVeri,
                  ),
                ).whenComplete(() {});
              }, dil == 'tr' ? veri['s_baslik'] : veri['s_baslikEn']),
            ]
          ],
        ),
      ),
    );
  }

  Widget userSekil(void Function()? onTab, String baslik) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Container(
        clipBehavior: Clip.hardEdge,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromARGB(255, 250, 250, 250),
          border: Border.all(
            width: 1,
            color: Color.fromARGB(255, 240, 240, 240),
          ),
        ),
        child: ListTile(
          tileColor: Colors.white,
          onTap: onTab,
          title: Text(
            baslik,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Color.fromARGB(255, 79, 79, 79),
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
