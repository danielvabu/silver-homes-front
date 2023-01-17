import 'dart:html' as html;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/animation/animated_wave.dart';
import 'package:silverhome/common/basic_page.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/reference_questionnaire_actions.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/presentation/models/landlord_models/reference_questionnaire_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/httpclient.dart';
import 'package:silverhome/tablayer/query_filter.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/tabclass.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/internet/_network_image_web.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/alert/message_dialogbox.dart';

class TenantProfileScreen extends BasePage {
  final String? applicationid;

  TenantProfileScreen({
    this.applicationid,
  });

  @override
  _TenantProfileScreenState createState() => _TenantProfileScreenState();
}

class _TenantProfileScreenState extends BaseState<TenantProfileScreen>
    with BasicPage {
  final _store = getIt<AppStore>();

  double height = 0, width = 0;

  bool isloading = true;

  late OverlayEntry loader;
  static List<SystemEnumDetails> lenghtoftenancy = [];

  @override
  void initState() {
    super.initState();
  }

  dailogShow() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MessageDialogBox(
          buttontitle: GlobleString.Button_OK,
          title: GlobleString.user_not_accessible,
          onPressed: () async {
            Navigator.of(context).pop();
            await Prefs.clear();
            Navigator.pushNamed(context, RouteNames.Login);
          },
        );
      },
    );
  }

  void updatemethod() {
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget rootWidget(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: isloading ? Colors.black12 : myColor.white,
      body: SafeArea(
        minimum: EdgeInsets.zero,
        child: SingleChildScrollView(
          child: Center(
            child: _initialview(),
          ),
        ),
      ),
    );
  }

  Widget onBottom(Widget child) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: child,
      ),
    );
  }

  Widget _initialview() {
    return Container(
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _headerView(),
        ],
      ),
    );
  }

  Widget _menu() {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              // bloc.documentBloc.changeDocumentMenuDrawer(false);
              // bloc.documentBloc.changeDocumentSubMenuDrawer(-1);
              // tenantView();
            },
            child: Container(
              width: 200,
              height: 60,
              color: 1 == 4
                  ? myColor.drawselectcolor
                  : Color.fromARGB(1, 224, 224, 224),
              padding: EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        GlobleString.NAV_AppFormp,
                        style: 1 == 4
                            ? MyStyles.SemiBold(16, myColor.Circle_main)
                            : MyStyles.Regular(16, myColor.Circle_main),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // bloc.documentBloc.changeDocumentMenuDrawer(false);
              // bloc.documentBloc.changeDocumentSubMenuDrawer(-1);
              // tenantView();
            },
            child: Container(
              width: 200,
              height: 60,
              color: 1 == 4
                  ? myColor.drawselectcolor
                  : Color.fromARGB(1, 224, 224, 224),
              padding: EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        GlobleString.NAV_Documentsp,
                        style: 1 == 4
                            ? MyStyles.SemiBold(16, myColor.Circle_main)
                            : MyStyles.Regular(16, myColor.Circle_main),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // bloc.documentBloc.changeDocumentMenuDrawer(false);
              // bloc.documentBloc.changeDocumentSubMenuDrawer(-1);
              // tenantView();
            },
            child: Container(
              width: 200,
              height: 60,
              color: 1 == 4
                  ? myColor.drawselectcolor
                  : Color.fromARGB(1, 224, 224, 224),
              padding: EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        GlobleString.NAV_Referencesp,
                        style: 1 == 4
                            ? MyStyles.SemiBold(16, myColor.Circle_main)
                            : MyStyles.Regular(16, myColor.Circle_main),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // bloc.documentBloc.changeDocumentMenuDrawer(false);
              // bloc.documentBloc.changeDocumentSubMenuDrawer(-1);
              // tenantView();
            },
            child: Container(
              width: 200,
              height: 60,
              color: 1 == 4
                  ? myColor.drawselectcolor
                  : Color.fromARGB(1, 224, 224, 224),
              padding: EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        GlobleString.NAV_onboardingDocumentsp,
                        style: 1 == 4
                            ? MyStyles.SemiBold(16, myColor.Circle_main)
                            : MyStyles.Regular(16, myColor.Circle_main),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // bloc.documentBloc.changeDocumentMenuDrawer(false);
              // bloc.documentBloc.changeDocumentSubMenuDrawer(-1);
              // tenantView();
            },
            child: Container(
              width: 200,
              height: 60,
              color: 1 == 4
                  ? myColor.drawselectcolor
                  : Color.fromARGB(1, 224, 224, 224),
              padding: EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        GlobleString.NAV_Disclamerp,
                        style: 1 == 4
                            ? MyStyles.SemiBold(16, myColor.Circle_main)
                            : MyStyles.Regular(16, myColor.Circle_main),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _content1() {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [button()],
      ),
    );
  }

  Widget button() {
    return MaterialButton(
      onPressed: () {},
      color: Color.fromARGB(1, 142, 149, 161),
      elevation: 0,
      padding: EdgeInsets.all(16),
      child: Text(
        "Application Form",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
      ),
      textColor: Color(0xffe96767),
      height: 80,
      minWidth: 200,
    );
  }

  Widget _headerView() {
    width = MediaQuery.of(context).size.width / 2;
    return Container(
      /*     height: height, */
      width: width,
      child: Column(
        children: [
          DefaultTabController(
              length: 5,
              child: TabBar(
                indicatorColor: myColor.email_color,
                unselectedLabelColor: myColor.gray,
                onTap: (value) {
                  // _changeDocumentList(value, bloc, context);
                },
                labelColor: myColor.email_color,
                tabs: [
                  Tab(
                    text: GlobleString.Tab_Document_property,
                    height: height * .05,
                  ),
                  Tab(
                    text: GlobleString.Tab_Document_tenants,
                    height: height * .05,
                  ),
                  Tab(
                    text: GlobleString.Tab_Document_onwers,
                    height: height * .05,
                  ),
                  Tab(
                    text: GlobleString.Tab_Document_vendors,
                    height: height * .05,
                  ),
                  Tab(
                    text: GlobleString.Tab_Document_other,
                    height: height * .05,
                  ),
                ],
              )),
          SizedBox(height: 30),
          Row(
            children: [
              Container(
                width: width,
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: myColor.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(children: [Text("data")]),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: [
              _menu(),
              SizedBox(width: 20),
              Container(
                width: width / 2,
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: myColor.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(children: [Text("data")]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
