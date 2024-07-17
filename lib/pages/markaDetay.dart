import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';

import 'package:get_storage/get_storage.dart';
import 'package:maxiruby/pages/anasayfa.dart';
import 'package:maxiruby/pages/indirimDetay.dart';
import 'package:maxiruby/services/Uyari.dart';
import 'package:maxiruby/services/functions.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';

GetStorage box = GetStorage();
Uyari uyari = new Uyari();
AppFunctions function = new AppFunctions();

class MarkaDetay extends StatefulWidget {
  final int markaId;
  final String markaAdi;
  const MarkaDetay({Key? key, required this.markaId, required this.markaAdi})
      : super(key: key);

  @override
  _MarkaDetayState createState() => _MarkaDetayState();
}

class _MarkaDetayState extends State<MarkaDetay> {
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
    kampanyaGetir();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> kampanyaGetir() async {
    uyari.loadingShow(sistemCevirileri['Veriler getiriliyor..'] ?? '');

    var formData = FormData.fromMap({
      "uId": user['uId'],
      "dil": dil,
      "markaId": widget.markaId,
      "sehir": (box.read('konum') != null ? box.read('konum')['state'] : ''),
    });

    try {
      Response response = await Dio().post(
        Settings.apiUrl + "markalar/detay",
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
              widget.markaAdi,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
        actions: [],
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
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                      children: veriler.map((veri) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: GestureDetector(
                            onTap: () {
                              showBarModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) => IndirimDetay(
                                  uId: user['uId'],
                                  userUlke: user['ulkeId'],
                                  kampanya: veri,
                                  sistemCevirileri: sistemCevirileri,
                                ),
                              ).whenComplete(() {});
                            },
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                  topLeft: Radius.circular(8.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(77, 208, 208, 208),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Image.network(
                                    Settings.fileManagerUrl + veri['k_resim'],
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 10, 10, 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              (veri['sembol'] ?? '%') +
                                                  ' ' +
                                                  veri['k_deger']
                                                      .toStringAsFixed(2),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: veri['sembol'] == null
                                                    ? Settings.danger
                                                    : Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 0, 0, 0),
                                              child: Text(
                                                sistemCevirileri['İndirim'] ??
                                                    '',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 5, 0, 0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Settings.primary,
                                              borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(8.0),
                                                bottomLeft:
                                                    Radius.circular(8.0),
                                                topRight: Radius.circular(8.0),
                                                topLeft: Radius.circular(8.0),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                      77, 208, 208, 208),
                                                  spreadRadius: 1,
                                                  blurRadius: 5,
                                                  offset: Offset(0,
                                                      0), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      7, 3, 7, 3),
                                              child: Row(
                                                children: [
                                                  if (veri['kullanim'] ==
                                                      0) ...[
                                                    Text(
                                                      sistemCevirileri['Son'] ??
                                                          '',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(5, 0, 0, 0),
                                                      child: Text(
                                                        veri['diff'],
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ] else ...[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 0, 5, 0),
                                                      child: Icon(
                                                        FontAwesome5
                                                            .check_circle,
                                                        size: 15,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      sistemCevirileri[
                                                              'Kullanılmış'] ??
                                                          '',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ]
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
