import 'package:flutter/material.dart';

class AppSettings {
  //Setting apps
  static const String appDisplayName = 'SilverHomes';
  static const String appSuffix = 'SilverHomes';
  static const bool debug = true;
  static String URL_ENDPOINT = debug ? "" : "";
  static const String version = '1.0.0';
  static const String build = '1';
  static const List<String> itemLanguage = ['English', 'Español'];
  static const statusCodeSuccess = 200;
  static const statusCodeError = 401;
}
