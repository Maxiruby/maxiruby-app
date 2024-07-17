import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maxiruby/security/sozlesme.dart';
import 'package:maxiruby/services/Uyari.dart';
import 'package:maxiruby/services/functions.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:maxiruby/widgets/button.dart';
import 'package:maxiruby/widgets/input.dart';
import 'package:maxiruby/widgets/maskInput.dart';
import 'package:html/parser.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Uyari uyari = new Uyari();
AppFunctions function = new AppFunctions();
GetStorage box = GetStorage();

class IndirimDetay extends StatefulWidget {
  final kampanya;
  final int uId;
  final int userUlke;
  final Map<String, dynamic> sistemCevirileri;

  const IndirimDetay({
    Key? key,
    this.kampanya,
    required this.uId,
    required this.sistemCevirileri,
    required this.userUlke,
  }) : super(key: key);

  @override
  _IndirimDetayState createState() => _IndirimDetayState();
}

class _IndirimDetayState extends State<IndirimDetay> {
  String dil = Platform.localeName == 'tr_TR' ? 'tr' : 'en';
  String aciklama = '';
  String kosullar = '';

  @override
  void initState() {
    super.initState();
    aciklama = (dil == 'en'
        ? widget.kampanya['k_aciklamaEn']
        : widget.kampanya['k_aciklama']);

    kosullar = (dil == 'en'
        ? widget.kampanya['k_kosullarEn']
        : widget.kampanya['k_kosullar']);
  }

  Future<void> katilimYap() async {
    uyari.loadingShow(widget.sistemCevirileri['Lütfen bekleyin..'] ?? '');

    var formData = FormData.fromMap({
      "uId": widget.uId,
      "kId": widget.kampanya['k_id'],
      "dil": dil,
    });

    try {
      Response response = await Dio().post(
        Settings.apiUrl + "katilim",
        data: formData,
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        uyari.success(
            widget.sistemCevirileri['Kampanya katılma işlemi tamamlandı.'] ??
                '');

        Timer(Duration(seconds: 1), () {
          Navigator.pop(context);
        });
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          height: MediaQuery.of(context).size.height * 0.90,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Stack(
            children: [
              ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              (widget.kampanya['sembol'] ?? '%') +
                                  ' ' +
                                  widget.kampanya['k_deger'].toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: widget.kampanya['sembol'] == null
                                    ? Settings.danger
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              widget.sistemCevirileri['İndirim'] ?? '',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: Image.network(
                                Settings.fileManagerUrl +
                                    widget.kampanya['m_logo'],
                                width: 100,
                                height: 40,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.sistemCevirileri['Son'] ?? '',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: Text(
                                    widget.kampanya['diff'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            FontAwesome5.times,
                            color: Settings.danger,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 2,
                    color: widget.kampanya['sembol'] == null
                        ? Settings.danger
                        : Colors.black,
                  ),
                  Image.network(
                    Settings.fileManagerUrl + widget.kampanya['k_resim'],
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 3,
                    color: widget.kampanya['sembol'] == null
                        ? Settings.danger
                        : Colors.black,
                  ),
                  if (_parseHtmlString(aciklama) != '') ...[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Html(
                        data: aciklama,
                        shrinkWrap: true,
                        style: {
                          "table": Style(
                            backgroundColor: Colors.transparent,
                          ),
                          "tr": Style(
                              padding: HtmlPaddings.all(3),
                              border: Border.all(
                                  color: Color.fromARGB(255, 97, 97, 97),
                                  width: 1)),
                        },
                      ),
                    ),
                  ],
                  for (var mKonum in widget.kampanya['m_konumlar']) ...[
                    if (box.read('konum') == null) ...[
                      if (widget.userUlke.toString() ==
                          mKonum['ulke']['id']) ...[
                        konumWidget(mKonum),
                      ]
                    ] else ...[
                      if (box.read('konum')['state'] ==
                          mKonum['il']['name']) ...[
                        konumWidget(mKonum),
                      ]
                    ]
                  ],
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                    child: GestureDetector(
                      onTap: () {
                        Map<String, dynamic> kosulVeri = {
                          'baslik':
                              widget.sistemCevirileri['Kullanım Koşulları'] ??
                                  '',
                          'metin': kosullar
                        };

                        showBarModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Sozlesme(
                            veri: kosulVeri,
                          ),
                        ).whenComplete(() {});
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color.fromARGB(255, 253, 253, 253),
                          border: Border.all(
                            width: 2,
                            color: Color.fromARGB(255, 238, 238, 238),
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(FontAwesome5.file_signature,
                              color: Colors.black54),
                          title: Text(
                            widget.sistemCevirileri['Kullanım Koşulları'] ?? '',
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            widget.sistemCevirileri[
                                    'Mutlaka okuyun ve inceleyin!'] ??
                                '',
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: widget.kampanya['kullanim'] == 0
                        ? GestureDetector(
                            onTap: () {
                              katilimYap();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Settings.primary,
                                border: Border.all(
                                  width: 2,
                                  color: Color.fromARGB(255, 249, 249, 249),
                                ),
                              ),
                              child: ListTile(
                                title: Text(
                                  widget.sistemCevirileri['HEMEN KATILIN'] ??
                                      '',
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Text(
                                  widget.sistemCevirileri[
                                          'Size özel oluşturulmuş kod ile katılın!'] ??
                                      '',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.qr_code,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color.fromARGB(255, 235, 235, 235),
                              border: Border.all(
                                width: 2,
                                color: Color.fromARGB(255, 249, 249, 249),
                              ),
                            ),
                            child: ListTile(
                              title: Text(
                                widget.sistemCevirileri['Kullanılmış'] ?? '',
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                              subtitle: Text(
                                widget.sistemCevirileri[
                                        'Kampanyaya daha önce katıldınız!'] ??
                                    '',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              trailing: Icon(
                                FontAwesome5.check_circle,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget konumWidget(Map<String, dynamic> mKonum) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
      child: Row(
        children: [
          Icon(
            FontAwesome5.map_marker_alt,
            color: Colors.black54,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mKonum['mahalle']['name'] +
                      ', ' +
                      mKonum['sokak']['name'] +
                      ', ' +
                      mKonum['semt']['name'],
                ),
                Text(
                  mKonum['ilce']['name'] +
                      ', ' +
                      mKonum['il']['name'] +
                      ', ' +
                      mKonum['ulke']['name'],
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

String _parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;

  return parsedString;
}
