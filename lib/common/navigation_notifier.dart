import 'package:flutter/cupertino.dart';

class NavigationNotifier extends ChangeNotifier {
  String backScreen = "";
  bool gotoBack = false;
  int stepper = 00;
  void change({required String back, required bool goBack, required int step}) {
    backScreen = back;
    gotoBack = goBack;
    stepper = step;
    notifyListeners();
  }
}
