import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:maxiruby/services/setting.dart';

class Uyari {
  void warning(String text) async {
    EasyLoading.dismiss();
    EasyLoading.instance
      ..textColor = Colors.white
      ..indicatorColor = Colors.white
      ..backgroundColor = Settings.warning
      ..textStyle = TextStyle(fontWeight: FontWeight.w500, color: Colors.white)
      ..maskColor = Colors.transparent;
    EasyLoading.showInfo(text);
  }

  void danger(String text) async {
    EasyLoading.dismiss();
    EasyLoading.instance
      ..textColor = Colors.white
      ..indicatorColor = Colors.white
      ..backgroundColor = Settings.danger
      ..textStyle = TextStyle(fontWeight: FontWeight.w500, color: Colors.white)
      ..maskColor = Colors.transparent;
    EasyLoading.showError(text);
  }

  void success(String text) async {
    EasyLoading.dismiss();
    EasyLoading.instance
      ..textColor = Colors.white
      ..indicatorColor = Colors.white
      ..backgroundColor = Settings.success
      ..textStyle = TextStyle(fontWeight: FontWeight.w500, color: Colors.white)
      ..maskColor = Colors.transparent;
    EasyLoading.showSuccess(text);
  }

  void loadingShow(String text) {
    EasyLoading.dismiss();
    EasyLoading.instance
      ..textStyle = TextStyle(
          fontWeight: FontWeight.w500, color: Settings.primary, fontSize: 16)
      ..backgroundColor = Colors.transparent
      ..boxShadow = <BoxShadow>[
        BoxShadow(
          color: Colors.transparent,
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        )
      ]
      ..maskColor = Color.fromARGB(147, 255, 255, 255);
    EasyLoading.show(
      status: text,
      indicator: Container(
        width: 100,
        height: 100,
        child: SpinKitRing(lineWidth: 3, color: Settings.primary, size: 50.0),
      ),
    );
  }

  void loadingFade() {
    EasyLoading.dismiss();
  }

  AlertDialog confrim(
      BuildContext context,
      String text,
      String text2,
      void Function(String id) okPress,
      var id,
      String baslik,
      String confrimText,
      String cancelText) {
    return AlertDialog(
      icon: Icon(
        Icons.help,
        size: 35,
        color: Settings.primary,
      ),
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: Colors.white,
      title: Text(
        baslik,
        style: TextStyle(fontWeight: FontWeight.w600, color: Settings.primary),
      ),
      content: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
          ),
          // ignore: unnecessary_null_comparison
          if (text2 != null) ...[
            Text(
              text2,
              textAlign: TextAlign.center,
            ),
          ]
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Column(
            children: [
              Icon(FontAwesome5.times_circle, color: Settings.danger),
              Text(
                cancelText,
                style: TextStyle(
                    fontWeight: FontWeight.w800, color: Settings.danger),
              ),
            ],
          ),
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.focused))
                return Settings.danger.withAlpha(40);
              if (states.contains(MaterialState.hovered))
                return Settings.danger.withAlpha(40);
              if (states.contains(MaterialState.pressed))
                return Settings.danger.withAlpha(40);
              return null; // Defer to the widget's default.
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.all(11),
            ),
          ),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          child: Column(
            children: [
              Icon(FontAwesome5.check_circle, color: Settings.success),
              Text(
                confrimText,
                style: TextStyle(
                    fontWeight: FontWeight.w800, color: Settings.success),
              ),
            ],
          ),
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.focused))
                return Settings.success.withAlpha(40);
              if (states.contains(MaterialState.hovered))
                return Settings.success.withAlpha(40);
              if (states.contains(MaterialState.pressed))
                return Settings.success.withAlpha(40);
              return null; // Defer to the widget's default.
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.all(11),
            ),
          ),
          onPressed: () {
            Navigator.pop(context, true);
            okPress(id);
          },
        ),
      ],
    );
  }
}
