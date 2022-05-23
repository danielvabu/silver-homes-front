import 'package:flutter/material.dart';

import 'mystyles.dart';

final ThemeData defaultTheme = _buildDefaultTheme();
final Color primaryColor = Color(0xff000080);
final Color secondaryColor = Color(0xffD3D3D3);
final Color buttonColor1 = Color(0xff010B32);
final Color buttonColor2 = Color(0xffFFFFFF);
final Color buttonColor3 = Color(0xff4B74FF);
final Color buttonColor4 = Color(0xffA7A7A7);
final Color buttonColor5 = Color(0xff364069);
final Color buttonColor6 = Color(0xff364069);
final Color buttonColor7 = Color(0xffEDEDED);
final Color copyColor1 = Color(0xff000000);
final Color errorColor1 = Color(0xffBA1515);

ThemeData _buildDefaultTheme() {
  return ThemeData.light().copyWith(
    primaryColor: Color(0xff010b32),
    primaryColorDark: Color(0xff010b32),
    textTheme: defaultTextTheme,
  );
}

TextStyle headline1 = MyStyles.SemiBold(32, copyColor1);

TextStyle headline6 = MyStyles.SemiBold(16, copyColor1);

TextTheme defaultTextTheme = TextTheme(
    headline1: MyStyles.SemiBold(32, copyColor1),
    headline2: MyStyles.Medium(24, copyColor1),
    headline3: MyStyles.Medium(20, copyColor1),
    headline4: MyStyles.Medium(20, copyColor1),
    headline5: MyStyles.Bold(16, copyColor1),
    headline6: MyStyles.SemiBold(16, copyColor1),
    subtitle1: MyStyles.Medium(16, copyColor1),
    subtitle2: MyStyles.Medium(14, copyColor1),
    bodyText1: MyStyles.Medium(16, copyColor1),
    bodyText2: MyStyles.Regular(16, copyColor1),
    caption: MyStyles.Medium(12, copyColor1));
