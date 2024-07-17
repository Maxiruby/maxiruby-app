import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';

import 'package:get_storage/get_storage.dart';
import 'package:maxiruby/pages/anasayfa.dart';
import 'package:maxiruby/services/Uyari.dart';
import 'package:maxiruby/services/functions.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:page_transition/page_transition.dart';

GetStorage box = GetStorage();
Uyari uyari = new Uyari();
AppFunctions function = new AppFunctions();

class Bildirim extends StatefulWidget {
  const Bildirim({Key? key}) : super(key: key);

  @override
  _BildirimState createState() => _BildirimState();
}

class _BildirimState extends State<Bildirim> {
  String dil = Platform.localeName == 'tr_TR' ? 'tr' : 'en';
  Map<String, dynamic> sistemCevirileri = {};

  late Map<String, dynamic> user;
  List veriler = [];

  @override
  void initState() {
    super.initState();
    user = box.read('user');

    getir();
    ceviriGonder();
  }

  Future ceviriGonder() async {
    uyari.loadingShow('');
    sistemCevirileri = await function.ceviri(dil);

    uyari.loadingFade();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getir() async {
    uyari.loadingShow(sistemCevirileri['Veriler getiriliyor..'] ?? '');

    var formData = FormData.fromMap({"uId": user['uId']});

    try {
      Response response = await Dio().post(
        Settings.apiUrl + "bildirim/getir",
        data: formData,
      );
      if (response.statusCode == 200) {
        uyari.loadingFade();
        veriler = response.data;

        setState(() {});
      } else {
        uyari.danger(sistemCevirileri['Sunucu Hatası!']);
        return;
      }
    } on DioError catch (e) {
      uyari.danger(sistemCevirileri['Sunucu Hatası!']);
      return;
    }
  }

  Future<void> okuma(int? id, String? yonlendirme) async {
    uyari.loadingShow(sistemCevirileri['Okundu olarak işaretleniyor..'] ?? '');

    var formData = FormData.fromMap({"uId": user['uId'], 'id': id});

    try {
      Response response = await Dio().post(
        Settings.apiUrl + "bildirim/okuma",
        data: formData,
      );
      if (response.statusCode == 200) {
        uyari.loadingFade();
        getir();
        // Yönlendirme gidebilir.

        setState(() {});
      } else {
        uyari.danger('Sunucu hatası!');
        return;
      }
    } on DioError catch (e) {
      uyari.danger(sistemCevirileri['Sunucu Hatası!']);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.bottomToTop,
                child: Anasayfa(
                  index: 0,
                )));

        return false;
      },
      child: Scaffold(
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
                sistemCevirileri['Bildirimler'] ?? '',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                okuma(null, null);
              },
              icon: Icon(
                Icons.remove_red_eye,
                size: 25,
                color: Color.fromARGB(188, 47, 47, 47),
              ),
            )
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          color: Color.fromARGB(255, 253, 253, 253),
          child: veriler.length == 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 70,
                      color: Colors.black26,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text(
                        sistemCevirileri["Hiç veri bulunamadı."] ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black26,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        semanticChildCount: veriler.length,
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
                        children: veriler.map((veri) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color.fromARGB(255, 250, 250, 250),
                                border: Border.all(
                                  width: 1,
                                  color: Color.fromARGB(255, 240, 240, 240),
                                ),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      okuma(
                                          veri['b_id'], veri['b_yonlendirme']);
                                    },
                                    title: Text(
                                      veri['b_baslik'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: veri['b_okuma'] == false
                                            ? Settings.primary
                                            : Colors.black,
                                      ),
                                    ),
                                    subtitle: Text(
                                      veri['b_metin'] +
                                          '\n' +
                                          function.tarih_format(
                                              veri['b_tarih'], true),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                    ),
                                    trailing: veri['b_okuma'] == false
                                        ? Icon(
                                            FontAwesome5.eye,
                                            size: 18,
                                            color: veri['b_okuma'] == false
                                                ? Settings.primary
                                                : Colors.black54,
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
