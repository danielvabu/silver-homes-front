import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/navigation/route_names.dart';

class GlobalTimer {
  late Timer? _timer;
  late BuildContext? context = null;
  GlobalTimer() {
    _timer = Timer.periodic(Duration(minutes: 30), (timer) {
      _timer!.cancel();
      _logout();
    });
  }
  checkAndUpdateTimer(BuildContext context) {
    this.context = context;
    //print("timer reset");
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(minutes: 30), (timer) {
      _timer!.cancel();
      _logout();
    });
  }

  _logout() {
    if (context != null) {
      Prefs.clear();
      //navigateTo(context!, RouteNames.Login);
      Navigator.pushNamedAndRemoveUntil(
          context!, RouteNames.Login, (route) => false);
    }
  }
}
