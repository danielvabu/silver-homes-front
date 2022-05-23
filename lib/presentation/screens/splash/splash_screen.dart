import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:silverhome/Animation/animated_wave.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/navigation/route_names.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    prefsManager();
    super.initState();
    startTime();
  }

  prefsManager() async => Prefs.init();

  startTime() async => new Timer(Duration(seconds: 1), pageNavigate);

  pageNavigate() {
    if (Prefs.getBool(PrefsName.Is_login)) {
      Navigator.pushNamed(
          context,
          Prefs.getBool(PrefsName.Is_adminlogin)
              ? RouteNames.Admin_Portal
              : RouteNames.Portal);
    } else if (Prefs.getBool(PrefsName.BT_Is_login)) {
      Navigator.pushNamed(context,
          "/${Prefs.getString(PrefsName.BT_CustomerFeatureListingURL)}/${RouteNames.Basic_Tenant_Portal}");
    } else {
      String url = window.location.href.toString();

      String name = url.substring(url.indexOf("#/") + 2);

      if (name.isEmpty || name == null) {
        Navigator.of(context).pushReplacementNamed(RouteNames.Login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Stack(
          children: <Widget>[
            new Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 150),
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height - 150,
                    child: Image.asset(
                      "assets/images/silverhome_splash.png",
                      height: 280,
                      alignment: Alignment.center,
                      //width: 180,
                    ),
                  ),
                ],
              ),
            ),
            onBottom(
              AnimatedWave(
                height: 180,
                speed: 1.0,
              ),
            ),
            onBottom(
              AnimatedWave(
                height: 120,
                speed: 0.9,
                offset: pi,
              ),
            ),
            onBottom(
              AnimatedWave(
                height: 220,
                speed: 1.2,
                offset: pi / 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  onBottom(Widget child) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: child,
      ),
    );
  }
}
