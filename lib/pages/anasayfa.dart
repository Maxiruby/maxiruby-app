import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maxiruby/pages/bottomBar.dart';
import 'package:maxiruby/pages/brands.dart';
import 'package:maxiruby/pages/profil.dart';
import 'package:maxiruby/pages/wallet.dart';
import 'package:maxiruby/services/functions.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:maxiruby/pages/bildirimUst.dart';
import 'package:maxiruby/services/Uyari.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:maxiruby/pages/anasayfaVeriler.dart';
import 'package:page_transition/page_transition.dart';

GetStorage box = GetStorage();
Uyari uyari = new Uyari();
AppFunctions appFunctions = new AppFunctions();

class Anasayfa extends StatefulWidget {
  final int index;
  const Anasayfa({Key? key, required this.index}) : super(key: key);

  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  String dil = Platform.localeName == 'tr_TR' ? 'tr' : 'en';
  Map<String, dynamic> sistemCevirileri = {};
  final _unfocusNode = FocusNode();

  int homeIndex = 0;
  String stateTitle = "";
  late Map<String, dynamic> user;

  @override
  void initState() {
    super.initState();
    user = box.read('user');
    ceviriGonder();
    homeIndex = widget.index;
  }

  Future ceviriGonder() async {
    uyari.loadingShow('');
    sistemCevirileri = await appFunctions.ceviri(dil);

    uyari.loadingFade();
    setState(() {
      if (widget.index == 0) {
        stateTitle = sistemCevirileri['Kampanyalar'] ?? '';
      } else if (widget.index == 1) {
        stateTitle = sistemCevirileri['Markalar'] ?? '';
      }
    });
  }

  Widget homeDesign(int index) {
    if (index == 0) {
      return AnasayfaVeriler(
        sistemCevirileri: sistemCevirileri,
      );
    } else if (index == 1) {
      return Brands(
        sistemCevirileri: sistemCevirileri,
      );
    } else if (index == 2) {
      return Wallet(
        sistemCevirileri: sistemCevirileri,
      );
    }

    return Text("");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.topToBottom, child: Profil()));
              },
              icon: Icon(
                FontAwesome5.user,
                size: 18,
                color: Color.fromARGB(188, 47, 47, 47),
              ),
            ),
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
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
                  stateTitle,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            actions: [
              BildirimUst(
                id: user['uId'],
                sistemCevirileri: sistemCevirileri,
              ),
            ],
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  Colors.white,
                  Colors.white60,
                  Colors.white38,
                  Colors.white24,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: homeDesign(homeIndex),
            ),
          ),
          bottomNavigationBar: Container(
            width: MediaQuery.of(context).size.width,
            height: 90,
            color: Color.fromARGB(255, 248, 248, 248),
            child: Column(
              children: [
                BottomBar(
                  user: user,
                  index: homeIndex,
                  sistemCevirileri: sistemCevirileri,
                  onPressed: (int returnIndex, String returnTitle) {
                    setState(() {
                      homeIndex = returnIndex;
                      stateTitle = returnTitle;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
