import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:maxiruby/widgets/button.dart';
import 'package:maxiruby/widgets/select.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

GetStorage box = GetStorage();
Uyari uyari = new Uyari();
Locations locations = new Locations();

class Wallet extends StatefulWidget {
  final Map<String, dynamic> sistemCevirileri;

  const Wallet({Key? key, required this.sistemCevirileri}) : super(key: key);

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  String dil = Platform.localeName == 'tr_TR' ? 'tr' : 'en';

  late Map<String, dynamic> user;
  double veriYokOpacity = 0;
  String konum = '';
  String konumUyari = '';
  List kampanyalar = [];
  Map<String, dynamic> toplamRakam = {};
  double digerRakam = 0;
  int PageDurum = 0;

  List<ChartData> chartData = [
    ChartData('', 100, Color.fromARGB(255, 241, 241, 241))
  ];
  List<Color> renkler = [
    Settings.primary,
    Settings.success,
    Settings.danger,
    Settings.warning,
    Settings.info,
  ];
  Map<String, Color> yeniRenkler = {};

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
      "tip": PageDurum
    });

    try {
      Response response = await Dio().post(
        Settings.apiUrl + "cuzdan/getir",
        data: formData,
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        uyari.loadingFade();
        chartData = [];
        toplamRakam = {};
        digerRakam = 0;
        kampanyalar = response.data['kampanyalar'];

        digerRakam =
            double.parse(response.data['digerRakam'].toStringAsFixed(2));

        if (response.data['toplamRakam'].toString() != '[]') {
          toplamRakam = response.data['toplamRakam'];
          var c = 0;
          for (var deger in response.data['toplamRakam'].entries) {
            chartData.add(ChartData(deger.key,
                double.parse(deger.value.toStringAsFixed(2)), renkler[c]));

            final yRenk = <String, Color>{deger.key: renkler[c]};
            yeniRenkler.addEntries(yRenk.entries);
            c++;
          }
        }
        chartData.add(ChartData(
            '', digerRakam, const Color.fromARGB(255, 208, 208, 208)));

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

  void walletIslem(int durum) {
    setState(() {
      PageDurum = durum;
      kampanyaGetir();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /*
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: () => walletIslem(0),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    decoration: BoxDecoration(
                      color: PageDurum == 0
                          ? Settings.primary
                          : Color.fromARGB(255, 250, 250, 250),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                        topLeft: Radius.circular(8.0),
                      ),
                      border: Border.all(
                        width: 1,
                        color: Color.fromARGB(255, 240, 240, 240),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(7, 7, 7, 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.sistemCevirileri['Tutar İnd.'] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Icon(
                            FontAwesome5.coins,
                            size: 20,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: () => walletIslem(1),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    decoration: BoxDecoration(
                      color: PageDurum == 1
                          ? Settings.primary
                          : Color.fromARGB(255, 250, 250, 250),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                        topLeft: Radius.circular(8.0),
                      ),
                      border: Border.all(
                        width: 1,
                        color: Color.fromARGB(255, 240, 240, 240),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(7, 7, 7, 7),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.sistemCevirileri['Yüzde İnd.'] ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Icon(
                              FontAwesome5.percentage,
                              size: 20,
                              color: Colors.black,
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        */
        Expanded(
          child: ListView(
            children: [
              SfCircularChart(annotations: <CircularChartAnnotation>[
                CircularChartAnnotation(
                  widget: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var deger in toplamRakam.entries) ...[
                          Text(
                            deger.key + ' ' + deger.value.toStringAsFixed(2),
                            style: TextStyle(
                              color: yeniRenkler[deger.key],
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                )
              ], series: <CircularSeries>[
                DoughnutSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  pointColorMapper: (ChartData data, _) => data.color,
                  innerRadius: '80%',
                  // Explode the segments on tap
                  explode: false,
                )
              ]),
              kampanyalar.length == 0
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
                            widget.sistemCevirileri[
                                    "Hiç kampanya bulunamadı."] ??
                                '',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: kampanyalar.map((veri) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 15),
                          child: GestureDetector(
                            onTap: () {
                              showBarModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) => IndirimDetay(
                                  uId: user['uId'],
                                  userUlke: user['ulkeId'],
                                  kampanya: veri,
                                  sistemCevirileri: widget.sistemCevirileri,
                                ),
                              ).whenComplete(() {});
                            },
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
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          (veri['sembol'] ?? '%') +
                                              ' ' +
                                              veri['k_deger']
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: veri['sembol'] == null
                                                ? Settings.danger
                                                : Colors.black,
                                          ),
                                        ),
                                        Text(
                                          widget.sistemCevirileri['İndirim'] ??
                                              '',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Image.network(
                                      Settings.fileManagerUrl + veri['m_logo'],
                                      width: 90,
                                      height: 25,
                                      fit: BoxFit.contain,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Settings.primary,
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(8.0),
                                              bottomLeft: Radius.circular(8.0),
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
                                            padding: const EdgeInsets.fromLTRB(
                                                7, 3, 7, 3),
                                            child: Column(
                                              children: [
                                                if (veri['kullanim'] == 0) ...[
                                                  Text(
                                                    widget.sistemCevirileri[
                                                            'Son'] ??
                                                        '',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                  Text(
                                                    veri['diff'],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ] else ...[
                                                  Icon(
                                                    FontAwesome5.check_circle,
                                                    size: 15,
                                                    color: Colors.white,
                                                  ),
                                                  Text(
                                                    widget.sistemCevirileri[
                                                            'Kullanılmış'] ??
                                                        '',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ]
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
