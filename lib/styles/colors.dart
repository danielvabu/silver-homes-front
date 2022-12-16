import 'package:cocemfe/redux/settingApp/store.dart';
import 'package:flutter/material.dart';

class AppColors {
  static Color info = Color(0xffF68D2E);
  static Color greyButton = Color(0xffD9D9D9);
  static Color greyColor = Color(0xff0177C8);
  static Color mainColor = Color(0xff0177C8);
  static Color main2Color = Color(0xff004a51);
  static Color textfield = Color(0xFFD9D9D9);
  static Color fontColor = Colors.white;
  static Color boxColor = Color(0xff34495e);
  static Color raisedButtonColor = Color(0xff0177C8);
  static Color bgPrimaryColor = Color(0xffFFF059);

  static Color boxAlternativeColor = Color(0xff34495e);

  static Color textColor = ReduxHome.store.state.postsState.changeContrast == true ? Colors.black : Color(0xff5555555);
}
