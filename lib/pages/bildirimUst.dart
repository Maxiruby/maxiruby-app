import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:maxiruby/pages/bildirim.dart';
import 'package:maxiruby/services/Uyari.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:badges/badges.dart' as badges;
import 'package:page_transition/page_transition.dart';

Uyari uyari = new Uyari();

class BildirimUst extends StatefulWidget {
  final int id;
  final Map<String, dynamic> sistemCevirileri;
  const BildirimUst(
      {Key? key, required this.id, required this.sistemCevirileri})
      : super(key: key);

  @override
  _BildirimUstState createState() => _BildirimUstState();
}

class _BildirimUstState extends State<BildirimUst> {
  int _bildirimBadgeCount = 0;
  bool _bildirimBadgeShow = false;
  Color bildirimBadgeColor = Settings.primary;

  @override
  void initState() {
    super.initState();

    bildirimCount();
  }

  Future<void> bildirimCount() async {
    uyari.loadingShow(widget.sistemCevirileri['Veriler getiriliyor..'] ?? '');

    var formData = FormData.fromMap({
      "uId": widget.id,
    });

    try {
      Response response = await Dio().post(
        Settings.apiUrl + "bildirim/say",
        data: formData,
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        uyari.loadingFade();

        setState(() {
          if (int.parse(response.data) != 0) {
            _bildirimBadgeCount = int.parse(response.data);
            _bildirimBadgeShow = true;
          }
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
    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: -5, end: 5),
      showBadge: _bildirimBadgeShow,
      badgeStyle: badges.BadgeStyle(
        badgeColor: bildirimBadgeColor,
      ),
      badgeContent: Padding(
        padding: const EdgeInsets.all(1),
        child: Text(
          _bildirimBadgeCount.toString(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      child: IconButton(
        icon: Icon(
          Icons.notifications_active_rounded,
          size: 23,
          color: Color.fromARGB(188, 47, 47, 47),
        ),
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.topToBottom, child: Bildirim()));
        },
      ),
    );
  }
}
