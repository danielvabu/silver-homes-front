import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/animation/animated_wave.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/actions/customer/customer_portal_action.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/presentation/models/customer/customer_portal_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/httpclient.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/_network_image_web.dart';
import 'package:silverhome/widget/message_dialogbox.dart';

import 'customer_property_details_page.dart';
import 'customer_property_list_page.dart';

class CustomerFeaturedlistPage extends StatefulWidget {
  const CustomerFeaturedlistPage({
    //this.LID = "metrocorere",
    this.LID,
  });

  final String? LID;

  @override
  _CustomerFeaturedlistPageState createState() =>
      _CustomerFeaturedlistPageState();
}

class _CustomerFeaturedlistPageState extends State<CustomerFeaturedlistPage> {
  double height = 0, width = 0;
  final _store = getIt<AppStore>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late OverlayEntry loader;
  bool isloading = true;
  bool isError = false;
  bool isNoDatafound = false;

  @override
  void initState() {
    apimanager();
    super.initState();
  }

  void apimanager() async {
    await Prefs.init();

    //Helper.Log("LID", widget.LID!);

    HttpClientCall().CallAPIToken(context, (error, respoce) async {
      if (error) {
        Helper.Log("Takan", respoce);

        await Prefs.setString(PrefsName.userTokan, respoce);

        if (widget.LID != null && widget.LID != "") {
          ApiManager().userDetailsDSQCall(context, widget.LID.toString(),
              (error1, respoce2) async {
            Helper.Log("error", error1.toString());
            Helper.Log("respoce2", respoce2);

            if (error1) {
              await Prefs.setString(PrefsName.Customer_OwnerID, respoce2);

              await ApiManager().getFeatuePropertyList(context, respoce2,
                  (status, responce3) {
                if (status) {
                  updatemethod();
                } else {
                  if (responce3 == "1") {
                    nodatafound();
                  } else {
                    updateError();
                  }
                }
              });
            } else {
              if (respoce2 == "1") {
                InActiveDialog();
              } else if (respoce2 == "2") {
                AdminInActiveDialog();
              } else {
                updateError();
                //ToastUtils.showCustomToast(context, respoce2, false);
              }
            }
          });
        } else {
          updateError();
        }
      } else {
        Helper.Log("respoce", respoce);
      }
    });
  }

  void updatemethod() {
    setState(() {
      isloading = false;
      isError = false;
      isNoDatafound = false;
    });
  }

  void updateError() {
    setState(() {
      isloading = false;
      isError = true;
      isNoDatafound = false;
    });
  }

  void nodatafound() {
    setState(() {
      isloading = false;
      isError = false;
      isNoDatafound = true;
    });
  }

  AdminInActiveDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return MessageDialogBox(
          buttontitle: GlobleString.user_inactive_admin_OK,
          title: GlobleString.user_inactive_admin,
          onPressed: () async {
            Navigator.of(context).pop();
            await Prefs.clear();
          },
        );
      },
    );
  }

  InActiveDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return MessageDialogBox(
          buttontitle: GlobleString.user_inactive_admin_OK,
          title: GlobleString.Welcome_Mail_dailog_Success2,
          onPressed: () async {
            Navigator.of(context).pop();
            await Prefs.clear();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        navigateTo(context, RouteNames.Login);
        return false;
      },
      child: Scaffold(
        backgroundColor: isloading || isError ? Colors.black12 : myColor.white,
        body: SafeArea(
          key: _scaffoldKey,
          minimum: EdgeInsets.zero,
          child: Center(
            child: isloading
                ? Stack(
                    children: <Widget>[
                      new Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /* Container(
                              margin: EdgeInsets.only(bottom: 150),
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height - 150,
                              child: Image.asset(
                                "assets/images/silverhome_splash.png",
                                height: 280,
                                alignment: Alignment.center,
                                //width: 180,
                              ),
                            ),*/
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
                  )
                : isError
                    ? _errorPage(context)
                    : _initialview(context),
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

  Widget _errorPage(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.black12,
      alignment: Alignment.center,
      child: Container(
          width: width / 2,
          height: 300,
          alignment: Alignment.center,
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: myColor.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
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
              Text(
                "Sorry, the page you are looking for is currently unavailable. Please contact us for guidance.",
                textAlign: TextAlign.center,
                style: MyStyles.Bold(20, myColor.black),
              ),
              SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Helper.launchURL(Weburl.silverhomes_contact_mail);
                },
                child: Text(
                  Weburl.silverhomes_contact_url,
                  textAlign: TextAlign.center,
                  style: MyStyles.Medium(20, myColor.email_color),
                ),
              ),
            ],
          )),
    );
  }

  Widget _initialview(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ConnectState<CustomerPortalState>(
        map: (state) => state.customerPortalState,
        where: notIdentical,
        builder: (cusPortalState) {
          if (isNoDatafound) {
            return _nodatafoundpage(cusPortalState!);
          } else {
            return Column(
              children: [
                headerView(cusPortalState!),
                centerView(cusPortalState, cusPortalState.index),
                footerView(cusPortalState),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _nodatafoundpage(CustomerPortalState cusPortalState) {
    return Container(
      width: width,
      height: height,
      color: Colors.black12,
      alignment: Alignment.center,
      child: Container(
        width: width / 2,
        height: 300,
        alignment: Alignment.center,
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: myColor.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            cusPortalState.Companynamelogo != null &&
                    cusPortalState.Companynamelogo!.id != null
                ? Container(
                    width: 380,
                    height: 100,
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: new DecorationImage(
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        image: CustomNetworkImage(
                          Weburl.image_API +
                              cusPortalState.Companynamelogo!.id.toString(),
                          scale: 1.5,
                          headers: {
                            'Authorization': 'bearer ' +
                                Prefs.getString(PrefsName.userTokan),
                            'ApplicationCode': Weburl.API_CODE,
                          },
                        ),
                      ),
                    ),
                  )
                : Image.asset(
                    "assets/images/silverhome.png",
                    width: 380,
                    height: 100,
                    alignment: Alignment.center,
                  ),
            SizedBox(height: 15),
            Text(
              "Sorry, No properties are available at the moment,",
              textAlign: TextAlign.center,
              style: MyStyles.Bold(20, myColor.black),
            ),
            SizedBox(height: 5),
            Text(
              "Please contact us for more details",
              textAlign: TextAlign.center,
              style: MyStyles.Bold(20, myColor.black),
            ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () {
                String mail = "mailto:" + cusPortalState.landlordemail;
                Helper.launchURL(mail);
              },
              child: Text(
                cusPortalState.landlordemail,
                textAlign: TextAlign.center,
                style: MyStyles.Medium(20, myColor.email_color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget headerView(CustomerPortalState cusPortalState) {
    return Container(
      width: width,
      height: 100,
      decoration: new BoxDecoration(
        color: myColor.CM_Header,
        //borderRadius: BorderRadius.all(Radius.circular(0)),
        border: Border.all(color: myColor.CM_Header_Border, width: 1),
      ),
      padding: EdgeInsets.only(left: 100, right: 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                cusPortalState.Companynamelogo != null &&
                        cusPortalState.Companynamelogo!.id != null
                    ? InkWell(
                        onTap: () async {
                          Helper.urlload(cusPortalState.homepagelink);
                        },
                        child: Container(
                          width: 250,
                          height: 80,
                          margin: EdgeInsets.only(left: 5),
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: new DecorationImage(
                              fit: BoxFit.contain,
                              alignment: Alignment.centerLeft,
                              image: CustomNetworkImage(
                                Weburl.image_API +
                                    cusPortalState.Companynamelogo!.id
                                        .toString(),
                                scale: 1.5,
                                headers: {
                                  'Authorization': 'bearer ' +
                                      Prefs.getString(PrefsName.userTokan),
                                  'ApplicationCode': Weburl.API_CODE,
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                    : Image.asset(
                        "assets/images/silverhome.png",
                        width: 250,
                        height: 50,
                        alignment: Alignment.centerLeft,
                      ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    Helper.urlload(cusPortalState.homepagelink);
                  },
                  onHover: (value) {
                    final Size txtSize = Helper.textSize(GlobleString.CSM_Home,
                        MyStyles.SemiBold(16, myColor.black));

                    _store.dispatch(
                        UpdateCustomerPortal_ishover_heder_home(value));
                    _store.dispatch(
                        UpdateCustomerPortal_tw_header_home(txtSize.width));
                  },
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        GlobleString.CSM_Home,
                        style: MyStyles.SemiBold(16, myColor.black),
                      ),
                      SizedBox(height: 2),
                      Visibility(
                        maintainAnimation: true,
                        maintainState: true,
                        maintainSize: true,
                        visible: cusPortalState.ishover_heder_home,
                        child: Container(
                          height: 1,
                          width: cusPortalState.tw_header_home,
                          color: myColor.second_color,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                InkWell(
                  onTap: () {
                    _store.dispatch(UpdateCustomerPortal_pageindex(0));
                  },
                  onHover: (value) {
                    final Size txtSize = Helper.textSize(
                        GlobleString.CSM_Listings,
                        MyStyles.SemiBold(16, myColor.black));

                    _store.dispatch(
                        UpdateCustomerPortal_ishover_heder_listing(value));
                    _store.dispatch(
                        UpdateCustomerPortal_tw_header_listing(txtSize.width));
                  },
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        GlobleString.CSM_Listings,
                        style: MyStyles.SemiBold(16, myColor.black),
                      ),
                      SizedBox(height: 2),
                      Visibility(
                        maintainAnimation: true,
                        maintainState: true,
                        maintainSize: true,
                        visible: cusPortalState.ishover_heder_listing,
                        child: Container(
                          height: 1,
                          width: cusPortalState.tw_header_listing,
                          color: myColor.second_color,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget centerView(CustomerPortalState cusPortalState, int index) {
    switch (index) {
      case 0:
        {
          return CustomerPropertyListPage();
        }
      case 1:
        {
          return CustomerPropertyDetailsPage(
              LID: Prefs.getString(PrefsName.Customer_OwnerID));
        }
      default:
        {
          return CustomerPropertyListPage();
        }
    }
  }

  Widget footerView(CustomerPortalState cusPortalState) {
    return Container(
      width: width,
      height: 70,
      decoration: new BoxDecoration(
        color: myColor.CM_Header,
        //borderRadius: BorderRadius.all(Radius.circular(0)),
        border: Border.all(color: myColor.CM_Header_Border, width: 1),
      ),
      padding: EdgeInsets.only(left: 100, right: 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Helper.urlload(cusPortalState.homepagelink);
                },
                onHover: (value) {
                  final Size txtSize = Helper.textSize(GlobleString.CSM_Home,
                      MyStyles.SemiBold(16, myColor.black));

                  _store.dispatch(
                      UpdateCustomerPortal_ishover_footer_home(value));
                  _store.dispatch(
                      UpdateCustomerPortal_tw_footer_home(txtSize.width));
                },
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      GlobleString.CSM_Home,
                      style: MyStyles.SemiBold(16, myColor.black),
                    ),
                    SizedBox(height: 2),
                    Visibility(
                      maintainAnimation: true,
                      maintainState: true,
                      maintainSize: true,
                      visible: cusPortalState.ishover_footer_home,
                      child: Container(
                        height: 1,
                        width: cusPortalState.tw_footer_home,
                        color: myColor.second_color,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 50,
              ),
              InkWell(
                onTap: () {
                  _store.dispatch(UpdateCustomerPortal_pageindex(0));
                },
                onHover: (value) {
                  final Size txtSize = Helper.textSize(
                      GlobleString.CSM_Listings,
                      MyStyles.SemiBold(16, myColor.black));

                  _store.dispatch(
                      UpdateCustomerPortal_ishover_footer_listing(value));
                  _store.dispatch(
                      UpdateCustomerPortal_tw_footer_listing(txtSize.width));
                },
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      GlobleString.CSM_Listings,
                      style: MyStyles.SemiBold(16, myColor.black),
                    ),
                    SizedBox(height: 2),
                    Visibility(
                      maintainAnimation: true,
                      maintainState: true,
                      maintainSize: true,
                      visible: cusPortalState.ishover_footer_listing,
                      child: Container(
                        height: 1,
                        width: cusPortalState.tw_footer_listing,
                        color: myColor.second_color,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Text(
                  GlobleString.CSM_PoweredBy,
                  style: MyStyles.SemiBold(14, myColor.CM_footer_powerby),
                  textAlign: TextAlign.end,
                ),
              ),
              InkWell(
                onTap: () {
                  Helper.urlload("www.silverhomes.ai");
                },
                child: Text(
                  GlobleString.CSM_silverhomes,
                  style: MyStyles.SemiBold(14, myColor.CM_footer_link),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
