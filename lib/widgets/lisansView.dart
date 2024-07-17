import 'package:flutter/material.dart';
import 'package:maxiruby/widgets/lisansView_tek.dart';
import 'package:time_machine/time_machine.dart';

class LisansView extends StatefulWidget {
  final DateTime tarih;
  const LisansView({Key? key, required this.tarih}) : super(key: key);

  @override
  _LisansViewState createState() => _LisansViewState();
}

class _LisansViewState extends State<LisansView> {
  DateTime suan = DateTime.now();

  int yil = 0;
  int ay = 0;
  int gun = 0;
  int saat = 0;

  bool yilColor = true;
  bool ayColor = true;
  bool gunColor = true;
  bool saatColor = true;

  @override
  void initState() {
    super.initState();

    LocalDate a = LocalDate.dateTime(suan);
    LocalDate b = LocalDate.dateTime(widget.tarih);
    Period diff = b.periodSince(a);

    yil = diff.years;
    ay = diff.months;
    gun = diff.days;
    saat = diff.hours;

    if (yil == 0) {
      yilColor = false;
    }
    if (yil == 0 && ay == 0) {
      ayColor = false;
    }
    if (yil == 0 && ay == 0 && gun == 0) {
      gunColor = false;
    }
    if (yil == 0 && ay == 0 && gun == 0 && saat == 0) {
      saatColor = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
            topLeft: Radius.circular(8.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Lisans Süresi",
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              children: [
                LisansViewTek(
                  value: yil,
                  title: "Yıl",
                  colorChange: yilColor,
                ),
                LisansViewTek(
                  value: ay,
                  title: "Ay",
                  colorChange: ayColor,
                ),
                LisansViewTek(
                  value: gun,
                  title: "Gün",
                  colorChange: gunColor,
                ),
                LisansViewTek(
                  value: saat,
                  title: "Saat",
                  colorChange: saatColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
