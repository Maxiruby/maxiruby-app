import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:path_provider/path_provider.dart';

class AppFunctions {
  tarih_format(String date, bool time) {
    DateTime dateValue = DateTime.parse(date).toLocal();
    String date1 = time == true
        ? DateFormat("dd.MM.yyyy HH:mm").format(dateValue)
        : DateFormat("dd.MM.yyyy").format(dateValue);

    return date1;
  }

  tarih_format2(String date, bool time) {
    DateTime dateValue = DateFormat("yyyy-MM-dd").parseUTC(date).toLocal();
    String date1 = time == true
        ? DateFormat("dd.MM.yyyy HH:mm").format(dateValue)
        : DateFormat("dd.MM.yyyy").format(dateValue);

    return date1;
  }

  tarih_format3(String date, bool time) {
    DateTime dateValue =
        DateFormat("yyyy-MM-dd HH:mm:ss").parseUTC(date).toLocal();
    String date1 = time == true
        ? DateFormat("dd.MM.yyyy HH:mm").format(dateValue)
        : DateFormat("dd.MM.yyyy").format(dateValue);

    return date1;
  }

  bool get isTablet {
    final firstView = WidgetsBinding.instance.platformDispatcher.views.first;
    final logicalShortestSide =
        firstView.physicalSize.shortestSide / firstView.devicePixelRatio;
    return logicalShortestSide > 600;
  }

  Future<Map<String, dynamic>> ceviri(String dil) async {
    Map<String, dynamic> yCeviriler = {};

    var formData = FormData.fromMap({
      'dil': dil,
    });

    try {
      Response response = await Dio().post(
        Settings.apiUrl + "ceviriler",
        data: formData,
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        yCeviriler = response.data;
      } else {
        return {};
      }
    } on DioError catch (e) {
      return {};
    }

    return yCeviriler;
  }
}
