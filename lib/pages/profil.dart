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
import 'package:maxiruby/pages/changeNumber.dart';
import 'package:maxiruby/pages/changePassword.dart';
import 'package:maxiruby/pages/indirimDetay.dart';
import 'package:maxiruby/pages/kisiselBilgilerim.dart';
import 'package:maxiruby/pages/sozlesmeler.dart';
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

class Profil extends StatefulWidget {
  const Profil({
    Key? key,
  }) : super(key: key);

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String dil = Platform.localeName == 'tr_TR' ? 'tr' : 'en';
  Map<String, dynamic> sistemCevirileri = {};

  final _unfocusNode = FocusNode();
  final ImagePicker picker = ImagePicker();

  late Map<String, dynamic> user;
  List veriler = [];
  String harfler = '';

  @override
  void initState() {
    super.initState();
    user = box.read('user');
    if (user['resim'] == null) {
      var bol = user['adsoyad'].split(' ');
      if (bol.length > 1) {
        harfler = bol[0].substring(0, 1) + bol[1].substring(0, 1);
      } else {
        harfler = bol[0].substring(0, 1);
      }
    }

    ceviriGonder();
  }

  Future ceviriGonder() async {
    uyari.loadingShow('');
    sistemCevirileri = await function.ceviri(dil);

    setState(() {});
    uyari.loadingFade();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    if (img != null) {
      setState(() {
        resimGuncelle(img);
      });
    }
  }

  Future<void> resimGuncelle(XFile? resim) async {
    uyari.loadingShow(sistemCevirileri['Yükleniyor..'] ?? '');
    var mime = lookupMimeType(resim!.path)!.split("/");
    var formData = FormData.fromMap({
      "uId": user['uId'],
      "resim": await MultipartFile.fromFile(resim!.path,
          contentType: MediaType(mime[0], mime[1])),
    });

    try {
      Response response = await Dio().post(
        Settings.apiUrl + "security/resimGuncelle",
        data: formData,
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        uyari.loadingFade();

        user['resim'] = response.data['resim'];

        box.write('user', user);
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

  Future<void> hesapSil(String id) async {
    uyari.loadingShow(sistemCevirileri['Lütfen bekleyin..'] ?? '');

    var formData = FormData.fromMap({
      "uId": user['uId'],
    });

    try {
      Response response = await Dio().post(
        Settings.apiUrl + "security/remove",
        data: formData,
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        uyari.loadingFade();

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        box.write('user', "");

        prefs.setBool('giris', false);
        prefs.setString('u_username', "");
        prefs.setString('u_password', "");

        Navigator.pushNamed(context, '/');
      } else {
        uyari.danger(response.data['error']);
        return;
      }
    } on DioError catch (e) {
      uyari.danger(sistemCevirileri['Sunucu Hatası!'] ?? '');
      return;
    }
  }

  //show popup dialog
  void resimSec() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(sistemCevirileri['Lütfen bir resim seçin'] ?? ''),
            content: Container(
              height: MediaQuery.of(context).size.height / 5,
              child: Column(
                children: [
                  Button(
                      backgroundColor: Settings.primary,
                      textColor: Colors.black,
                      text: sistemCevirileri['Fotoğraf Seç'] ?? '',
                      onPress: () {
                        Navigator.pop(context);
                        getImage(ImageSource.gallery);
                      },
                      loading: false,
                      icon: FontAwesome5.images),
                  Button(
                      backgroundColor: Settings.primary,
                      textColor: Colors.black,
                      text: sistemCevirileri['Fotoğraf Çek'] ?? '',
                      onPress: () {
                        Navigator.pop(context);
                        getImage(ImageSource.camera);
                      },
                      loading: false,
                      icon: FontAwesome5.camera)
                ],
              ),
            ),
          );
        });
  }

  Future<void> cikisYap() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    box.write('user', "");

    prefs.setBool('giris', false);
    prefs.setString('u_username', "");
    prefs.setString('u_password', "");

    Navigator.pushNamed(context, '/');
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
                user['adsoyad'],
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: resimSec,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                          color: Color.fromARGB(255, 250, 250, 250),
                          border: Border.all(
                            width: 1,
                            color: Color.fromARGB(255, 240, 240, 240),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: user['resim'] == null
                                  ? Text(
                                      harfler,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 35,
                                      ),
                                    )
                                  : Image.network(
                                      Settings.fileManagerUrl + user['resim'],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Positioned(
                              bottom: 3,
                              left: 40,
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Settings.primary,
                                ),
                                child: Icon(
                                  FontAwesome5.edit,
                                  size: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        user['adsoyad'] + '\n' + user['telefon'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 17),
                      ),
                    ),
                    Text(
                      (sistemCevirileri['Referans Kodu'] ?? '') +
                          ': ' +
                          (user['referansKodu'] ?? ''),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    userSekil(() {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: KisiselBilgilerim()));
                    }, sistemCevirileri['Kişisel Bilgilerim'] ?? '',
                        FontAwesome5.user_cog, 0),
                    userSekil(() {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: ChangeNumber()));
                    }, sistemCevirileri['Numara Değiştir'] ?? '',
                        FontAwesome5.phone_square, 0),
                    userSekil(() {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: Sozlesmeler()));
                    }, sistemCevirileri['Sözleşmeler'] ?? '',
                        FontAwesome5.file_signature, 0),
                    userSekil(() {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: ChangePassword()));
                    }, sistemCevirileri['Şifre Değiştir'] ?? '',
                        FontAwesome5.lock_open, 0),
                    userSekil(() {
                      _confrim(context, 1);
                    }, sistemCevirileri['Hesabımı Sil'] ?? '',
                        FontAwesome5.trash_alt, 0),
                    userSekil(cikisYap, sistemCevirileri['Çıkış Yap'] ?? '',
                        FontAwesome5.sign_out_alt, 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget userSekil(
      void Function()? onTab, String baslik, IconData icon, int cikis) {
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
          leading: Icon(icon,
              color: cikis == 1
                  ? Settings.danger
                  : Color.fromARGB(255, 79, 79, 79)),
          title: Text(
            baslik,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: cikis == 1
                  ? Settings.danger
                  : Color.fromARGB(255, 79, 79, 79),
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

  Future<void> _confrim(BuildContext context, int id) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return uyari.confrim(
            context,
            sistemCevirileri['Hesap ve bağlı tüm veriler silinecek!'] ?? '',
            sistemCevirileri[
                    'Veri güvenliği açısından silmemenizi öneriyoruz.'] ??
                '',
            hesapSil,
            id.toString(),
            sistemCevirileri['Emin misiniz?'] ?? '',
            sistemCevirileri['Evet'] ?? '',
            sistemCevirileri['Hayır'] ?? '');
      },
    );
  }
}
