import 'package:flutter/material.dart';

abstract final class Settings {
  /// Completely invisible.
  static const Color primary = Color.fromARGB(255, 219, 213, 18);
  static const Color success = Color(0xFF28c76f);
  static const Color info = Color(0xFF00cfe8);
  static const Color warning = Color(0xFFff9f43);
  static const Color danger = Color(0xFFea5455);

  static const String apiUrl = 'https://www.maxi.rvyazilim.net/api/';
  static const String fileManagerUrl =
      'https://www.maxi.rvyazilim.net/uploads/';
}
