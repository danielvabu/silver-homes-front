import 'package:flutter/material.dart';

import 'fontname.dart';

class MyStyles {
  static TextStyle ExtraBold(double fontsize, Color color) {
    return TextStyle(
        color: color,
        fontFamily: FontName.avenirnext,
        fontWeight: FontWeight.w800,
        fontSize: fontsize);
  }

  static TextStyle Bold(double fontsize, Color color) {
    return TextStyle(
        color: color,
        fontFamily: FontName.avenirnext,
        fontWeight: FontWeight.w700,
        fontSize: fontsize);
  }

  static TextStyle SemiBold(double fontsize, Color color) {
    return TextStyle(
        fontFamily: FontName.avenirnext,
        color: color,
        fontWeight: FontWeight.w600,
        fontSize: fontsize);
  }

  static TextStyle Medium(double fontsize, Color color) {
    return TextStyle(
        fontFamily: FontName.avenirnext,
        color: color,
        fontWeight: FontWeight.w500,
        fontSize: fontsize);
  }

  static TextStyle Regular(double fontsize, Color color) {
    return TextStyle(
        fontFamily: FontName.avenirnext,
        color: color,
        fontWeight: FontWeight.w400,
        fontSize: fontsize);
  }

  static TextStyle Light(double fontsize, Color color) {
    return TextStyle(
        fontFamily: FontName.avenirnext,
        color: color,
        fontWeight: FontWeight.w300,
        fontSize: fontsize);
  }
}
