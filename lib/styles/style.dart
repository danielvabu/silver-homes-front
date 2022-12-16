import 'package:flutter/material.dart';

class AppStyle {
  styleText(double size, var color, bool bold, {bool? bold2}) {
    return TextStyle(
      fontSize: size,
      color: color,
      height: 1,
      fontFamily: bold == true ? "ralewaiBold" : "ralewaiLight",
      fontWeight: bold2 == true
          ? FontWeight.bold
          : bold != true
              ? FontWeight.normal
              : FontWeight.bold,
    );
  }
}
