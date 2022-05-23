import 'dart:math';

import 'package:flutter/material.dart';
import 'package:silverhome/Animation/animated_wave.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/actions/admin_action/admin_setting_action.dart';
import 'package:silverhome/presentation/models/admin_models/admin_setting_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager_admin.dart';
import 'package:silverhome/tablayer/httpclient.dart';

class UnderMaintenanceScreen extends StatefulWidget {
  @override
  _UnderMaintenanceScreenState createState() => _UnderMaintenanceScreenState();
}

class _UnderMaintenanceScreenState extends State<UnderMaintenanceScreen> {
  double height = 0, width = 0;

  final _store = getIt<AppStore>();
  late OverlayEntry loader;

  @override
  void initState() {
    apiManager();
    super.initState();
  }

  apiManager() async {
    await Prefs.init();
    _store.dispatch(UpdateAdminSettingisLoading(false));

    HttpClientCall().CallAPIToken(context, (error, respoce) async {
      if (error) {
        Helper.Log("responce", respoce);
        await Prefs.setString(PrefsName.userTokan, respoce);

        await ApiManagerAdmin().UnderMaintenanceDetails(context);
      } else {
        Helper.Log("respoce", respoce);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ConnectState<AdminSettingState>(
                  map: (state) => state.adminSettingState,
                  where: notIdentical,
                  builder: (adminSettingState) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: width / 2,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: myColor.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxHeight: 80,
                                      minHeight: 80,
                                      maxWidth: 380,
                                      minWidth: 380),
                                  child: Image.asset(
                                    "assets/images/silverhome.png",
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              Container(
                                child: Text(
                                  adminSettingState!.title,
                                  textAlign: TextAlign.center,
                                  style: MyStyles.Medium(35, myColor.black),
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                child: Text(
                                  adminSettingState.instruction,
                                  textAlign: TextAlign.center,
                                  style: MyStyles.Medium(13, myColor.black),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }),
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
