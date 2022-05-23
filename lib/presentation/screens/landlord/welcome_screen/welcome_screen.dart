import 'dart:math';

import 'package:flutter/material.dart';
import 'package:silverhome/Animation/animated_wave.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/httpclient.dart';
import 'package:silverhome/tablayer/query_pojo.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    this.ID = "",
  });

  final String ID;

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String Username = "";
  String PersonID = "";
  String UID = "";

  late OverlayEntry loader;

  @override
  void initState() {
    apiManagerCall();
    super.initState();
  }

  apiManagerCall() async {
    await Prefs.init();

    await Prefs.clear();

    await Prefs.setString(PrefsName.WelcomeUserid, widget.ID.toString());

    //await Prefs.setString(PrefsName.WelcomeUserid, "09b6fa54-cfa8-4226-9715-00016a650e62");

    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    HttpClientCall().CallAPIToken(context, (error, respoce) async {
      if (error) {
        Helper.Log("Tokan", respoce);
        await Prefs.setString(PrefsName.userTokan, respoce);

        CheckUserData check = new CheckUserData();
        check.UserID = Prefs.getString(PrefsName.WelcomeUserid);

        ApiManager().UserDetails(context, check,
            (error, username1, email1, personid1, respoce) {
          if (error) {
            Username = username1;
            PersonID = personid1;
            UID = respoce;
            loader.remove();

            setState(() {});
          } else {
            loader.remove();
            ToastUtils.showCustomToast(context, respoce, false);
          }
        });
      } else {
        loader.remove();
        Helper.Log("respoce", respoce);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColor.Circle_main.withAlpha(60),
      body: SafeArea(
        child: Center(
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 370,
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: myColor.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Image.asset(
                            "assets/images/silverhome.png",
                            height: 80,
                            //width: 180,
                          ),
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              GlobleString.Welcome_title + " " + Username + "!",
                              textAlign: TextAlign.center,
                              style: MyStyles.Bold(20, myColor.black),
                            ),
                          ],
                        ),
                        // SizedBox(height: 20),
                        // Text(
                        //   GlobleString.Welcome_message,
                        //   textAlign: TextAlign.center,
                        //   style: MyStyles.Medium(20, myColor.black),
                        // ),
                        SizedBox(
                          height: 40,
                        ),
                        _loginbutton(),
                      ],
                    ),
                  ),
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

  Widget _loginbutton() {
    return InkWell(
      onTap: () {
        CheckUserData check = new CheckUserData();
        check.UserID = Prefs.getString(PrefsName.WelcomeUserid);

        UpdateUserData userData = new UpdateUserData();
        userData.IsActive = true;

        ApiManager().UpdateUserAccount(context, check, userData,
            (error, respoce) async {
          if (error) {
            Navigator.pushNamed(context, RouteNames.Login);
          } else {
            ToastUtils.showCustomToast(context, respoce, false);
          }
        });
      },
      child: Container(
        width: 150,
        height: 45,
        padding: EdgeInsets.only(left: 15, right: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: myColor.Circle_main,
        ),
        child: Text(
          GlobleString.Welcome_continue,
          style: MyStyles.Medium(16, myColor.white),
        ),
      ),
    );
  }
}
