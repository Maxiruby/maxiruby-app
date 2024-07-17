import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:maxiruby/services/Uyari.dart';
import 'package:maxiruby/services/setting.dart';
import 'package:path_provider/path_provider.dart';

Uyari uyari = new Uyari();
GetStorage box = GetStorage();

class Locations {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  late GlobalKey _textButtonKey;

  Future<GeoData> mecvutKonum(
      BuildContext context, Map<String, dynamic> sistemCevirileri) async {
    final hasPermission = await _handlePermission(context, sistemCevirileri);

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    box.write('konumEnlem', position.latitude);
    box.write('konumBoylam', position.longitude);

    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
        googleMapApiKey: "AIzaSyC5ngsiA3cFeHtwYmyyux4XzokdA9ObgRc");

    box.write('konum', {
      'adress': data.address,
      'city': data.city,
      'country': data.country,
      'countryCode': data.countryCode,
      'latitude': data.latitude,
      'longitude': data.longitude,
      'postalCode': data.postalCode,
      'state': data.state,
      'streetNumber': data.streetNumber,
    });

    return data;
  }

  Future<bool> _handlePermission(
      BuildContext context, Map<String, dynamic> sistemCevirileri) async {
    bool serviceEnabled;
    LocationPermission permission;

    permission = await _geolocatorPlatform.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await showCustomTrackingDialog(context, sistemCevirileri);
    }

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        uyari.warning(sistemCevirileri[
            'Size daha iyi hizmet verebilmemiz için konum izni vermelisiniz.' ??
                '']);

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      uyari.warning(sistemCevirileri[
              'Ayarlar > Maxiruby > Location bölümünden konum erişimine izin vermelisin.'] ??
          '');
      return false;
    }

    return true;
  }

  Future<void> showCustomTrackingDialog(
          BuildContext context, Map<String, dynamic> sistemCevirileri) async =>
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(sistemCevirileri['Konum izni gerekli'] ?? ''),
          content: Text(
            sistemCevirileri[
                    'Daha iyi hizmet verebilmek ve kolayca adresinizi girip size özel kampanyalardan yararlanabilmek için konumunuza ihtiyacımız var. Kampanyalarda size yakın mağazaları göstermek için kullanacağız. Kampanyalar dışında hiç bir yerde adres bilginiz kullanılmayacaktır!'] ??
                '',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(sistemCevirileri['Devam Et'] ?? ''),
            ),
          ],
        ),
      );
}
