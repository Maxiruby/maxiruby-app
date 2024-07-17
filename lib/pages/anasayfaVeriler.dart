import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maxiruby/pages/indirimDetay.dart';
import 'package:maxiruby/services/Uyari.dart';
import 'package:maxiruby/services/location.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:maxiruby/widgets/select.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

GetStorage box = GetStorage();
Uyari uyari = new Uyari();
Locations locations = new Locations();

class AnasayfaVeriler extends StatefulWidget {
  final Map<String, dynamic> sistemCevirileri;

  const AnasayfaVeriler({Key? key, required this.sistemCevirileri})
      : super(key: key);

  @override
  _AnasayfaVerilerState createState() => _AnasayfaVerilerState();
}

class _AnasayfaVerilerState extends State<AnasayfaVeriler> {
  String dil = Platform.localeName == 'tr_TR' ? 'tr' : 'en';

  late Map<String, dynamic> user;
  double veriYokOpacity = 0;
  String konum = '';
  List kampanyalar = [];
  String konumUyari = '';

  @override
  void initState() {
    super.initState();
    user = box.read('user');
    if (box.read('konum') == null) {
      konum = user['ulke'];
    } else {
      konum = box.read('konum')['adress'] + ', ' + box.read('konum')['country'];
    }
    kampanyaGetir();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> kampanyaGetir() async {
    uyari.loadingShow(widget.sistemCevirileri['Veriler getiriliyor..'] ?? '');

    var formData = FormData.fromMap({
      "uId": user['uId'],
      "dil": dil,
      "sehir": (box.read('konum') != null ? box.read('konum')['state'] : ''),
    });

    try {
      Response response = await Dio().post(
        Settings.apiUrl + "kampanyalar/getir",
        data: formData,
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        uyari.loadingFade();
        kampanyalar = response.data;
        veriYokOpacity = 1;
        setState(() {});
      } else {
        uyari.danger(response.data['error']);
        return;
      }
    } on DioError catch (e) {
      uyari.danger(widget.sistemCevirileri['Sunucu Hatası!'] ?? '');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: GestureDetector(
            onTap: () async {
              var konum =
                  await locations.mecvutKonum(context, widget.sistemCevirileri);
              if (konum != '') {
                setState(() {});
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color.fromARGB(255, 248, 248, 248),
                border: Border.all(
                  width: 2,
                  color: Settings.primary,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesome5.map_marker_alt,
                      color: Settings.primary,
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(box.read('konum') == null
                            ? konum +
                                '\n' +
                                (widget.sistemCevirileri[
                                        'Size en yakın kampanya için konuma izin verin.'] ??
                                    '')
                            : konum),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (kampanyalar.length == 0) ...[
          Container(
            width: MediaQuery.of(context).size.width,
            color: Color.fromARGB(255, 253, 253, 253),
            child: Opacity(
              opacity: veriYokOpacity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Column(
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
                        widget.sistemCevirileri["Hiç kampanya bulunamadı."] ??
                            '',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black26,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Wrap(
              children: [
                for (var kampanya in kampanyalar) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 15),
                    child: GestureDetector(
                      onTap: () {
                        showBarModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => IndirimDetay(
                            uId: user['uId'],
                            userUlke: user['ulkeId'],
                            kampanya: kampanya,
                            sistemCevirileri: widget.sistemCevirileri,
                          ),
                        ).whenComplete(() {});
                      },
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        width: MediaQuery.of(context).size.width / 2 - 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color.fromARGB(255, 250, 250, 250),
                          border: Border.all(
                            width: 1,
                            color: Color.fromARGB(255, 240, 240, 240),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              Settings.fileManagerUrl + kampanya['k_resim'],
                              width: MediaQuery.of(context).size.width / 2 - 30,
                              height:
                                  MediaQuery.of(context).size.width / 2 - 30,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 3,
                              color: kampanya['sembol'] == null
                                  ? Settings.danger
                                  : Colors.black,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        (kampanya['sembol'] ?? '%') +
                                            ' ' +
                                            kampanya['k_deger']
                                                .toStringAsFixed(2),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: kampanya['sembol'] == null
                                              ? Settings.danger
                                              : Colors.black,
                                        ),
                                      ),
                                      Text(
                                        widget.sistemCevirileri['İndirim'] ??
                                            '',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      if (kampanya['kullanim'] == 0) ...[
                                        Text(
                                          widget.sistemCevirileri['Son'] ?? '',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        Text(
                                          kampanya['diff'],
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ] else ...[
                                        Icon(
                                          FontAwesome5.check_circle,
                                          size: 15,
                                          color: Settings.primary,
                                        ),
                                        Text(
                                          widget.sistemCevirileri[
                                                  'Kullanılmış'] ??
                                              '',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            color: Settings.primary,
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 1,
                              color: kampanya['sembol'] == null
                                  ? Settings.danger
                                  : Colors.black,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.network(
                                Settings.fileManagerUrl + kampanya['m_logo'],
                                width: 90,
                                height: 25,
                                fit: BoxFit.contain,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          )
        ]
      ],
    );
  }
}
