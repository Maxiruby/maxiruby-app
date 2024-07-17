import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maxiruby/pages/indirimDetay.dart';
import 'package:maxiruby/pages/markaDetay.dart';
import 'package:maxiruby/services/Uyari.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:maxiruby/widgets/select.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

GetStorage box = GetStorage();
Uyari uyari = new Uyari();

class Brands extends StatefulWidget {
  final Map<String, dynamic> sistemCevirileri;

  const Brands({Key? key, required this.sistemCevirileri}) : super(key: key);

  @override
  _BrandsState createState() => _BrandsState();
}

class _BrandsState extends State<Brands> {
  late Map<String, dynamic> user;
  double veriYokOpacity = 0;
  String konum = '';
  List markalar = [];

  @override
  void initState() {
    super.initState();
    user = box.read('user');
    if (box.read('konum') == null) {
      konum = user['ulke'];
    } else {
      konum = box.read('konum')['adress'] + ', ' + box.read('konum')['country'];
    }
    markaGetir();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> markaGetir() async {
    uyari.loadingShow(widget.sistemCevirileri['Veriler getiriliyor..'] ?? '');

    var formData = FormData.fromMap({
      "uId": user['uId'],
    });

    try {
      Response response = await Dio().post(
        Settings.apiUrl + "markalar/getir",
        data: formData,
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        uyari.loadingFade();
        markalar = response.data;
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
        if (markalar.length == 0) ...[
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
                        widget.sistemCevirileri["Hiç marka bulunamadı."] ?? '',
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
                for (var marka in markalar) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.size,
                            alignment: Alignment.topCenter,
                            child: MarkaDetay(
                              markaId: marka['m_id'],
                              markaAdi: marka['m_adi'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        width: MediaQuery.of(context).size.width / 2 - 30,
                        height: 100,
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
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.network(
                                Settings.fileManagerUrl + marka['m_logo'],
                                width: 100,
                                height: 40,
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
