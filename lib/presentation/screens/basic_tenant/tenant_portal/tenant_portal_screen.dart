import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silverhome/common/basic_page.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/notification_type.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/basictenant_action/tenant_portal_action.dart';
import 'package:silverhome/domain/actions/landlord_action/notification_actions.dart';
import 'package:silverhome/domain/entities/notificationdata.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/presentation/models/basic_tenant/tenant_portal_state.dart';
import 'package:silverhome/presentation/models/landlord_models/notification_state.dart';
import 'package:silverhome/presentation/screens/basic_tenant/tenant_lease_details/tenant_lease_details_screen.dart';
import 'package:silverhome/presentation/screens/basic_tenant/tenant_maintenace/tenant_maintenanc_screen.dart';
import 'package:silverhome/presentation/screens/basic_tenant/tenant_profile/tenant_profile_screen.dart';
import 'package:silverhome/store/store.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/internet/_network_image_web.dart';
import 'package:silverhome/widget/basic_tenant/maintenace_dialogbox.dart';
import 'package:silverhome/widget/alert/message_dialogbox.dart';
import 'package:silverhome/widget/notification/tenant_notification_item.dart';

class TenantPortalScreen extends BasePage {
  @override
  _TenantPortalScreenState createState() => _TenantPortalScreenState();
}

class _TenantPortalScreenState extends BaseState<TenantPortalScreen>
    with BasicPage {
  final _store = getIt<AppStore>();

  double height = 0, width = 0;
  double drawer_width = 0;
  double header_height = 0;

  static bool isNotifiDialogshow = false;
  late OverlayEntry loader;

  @override
  void initState() {
    Prefs.init();
    ApiManager().NotificationCountTenant(context);
    super.initState();
  }

  @override
  Widget rootWidget(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    drawer_width = 230;
    header_height = 70;

    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.zero,
        child: Center(
          child: _initialview(context),
        ),
      ),
    );
  }

  Widget _initialview(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ConnectState<TenantPortalState>(
          map: (state) => state.tenantPortalState,
          where: notIdentical,
          builder: (tenantPortalState) {
            Helper.Log(">>", "Rendering Portal Screen");
            return Stack(
              children: [
                Row(
                  children: [
                    Container(
                      width: drawer_width,
                      height: MediaQuery.of(context).size.height,
                    ),
                    ContentCenterView(
                        context, drawer_width, tenantPortalState!),
                  ],
                ),
                DrawerMenu(context, tenantPortalState),
              ],
            );
          }),
    );
  }

  Widget DrawerMenu(BuildContext context, TenantPortalState portalState) {
    return Container(
      width: drawer_width,
      height: MediaQuery.of(context).size.height,
      //color: Colors.white,
      decoration: new BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: myColor.TA_Border,
            blurRadius: 8.0,
            spreadRadius: 0.0,
            offset: Offset(
              1.0,
              0.0,
            ),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Prefs.getString(PrefsName.BT_CompanyLogoid) != null &&
                  Prefs.getString(PrefsName.BT_CompanyLogoid).isNotEmpty
              ? Container(
                  height: header_height,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.all(5),
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: new DecorationImage(
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        image: CustomNetworkImage(
                          Weburl.image_API +
                              Prefs.getString(PrefsName.BT_CompanyLogoid),
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
              : Container(
                  //width: drawer_width,
                  height: header_height,
                  alignment: Alignment.centerLeft,
                  color: myColor.white,
                  margin: EdgeInsets.only(left: 20),
                  padding: EdgeInsets.all(5),
                  child: InkWell(
                    onTap: () {},
                    child: Image.asset(
                      'assets/images/menu_logo.png',
                      width: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      _store.dispatch(UpdateTenantPortalPage(
                          0, GlobleString.NAV_tenant_LeaseDetails));
                    },
                    child: Container(
                      height: 60,
                      color: portalState.index == 0
                          ? myColor.drawselectcolor
                          : myColor.white,
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 35,
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/images/ic_nav_bt_leasedetails.png",
                              width: 26,
                              height: 26,
                              color: myColor.Circle_main,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                GlobleString.NAV_tenant_LeaseDetails,
                                style: portalState.index == 0
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
                      _store.dispatch(UpdateTenantPortalPage(
                          1, GlobleString.NAV_tenant_Maintenance));
                    },
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.only(left: 20),
                      color: portalState.index == 1
                          ? myColor.drawselectcolor
                          : myColor.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 35,
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/images/ic_nav_bt_maintenance.png",
                              width: 27,
                              height: 27,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                GlobleString.NAV_tenant_Maintenance,
                                style: portalState.index == 1
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
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget ContentCenterView(
      BuildContext context, double val, TenantPortalState portalState) {
    return Container(
      width: MediaQuery.of(context).size.width - val,
      child: Column(
        children: [
          Header(context, portalState),
          Container(
            height: 1,
            color: myColor.TA_Border,
          ),
          portalState.isLoading!
              ? Container(
                  width: MediaQuery.of(context).size.width - drawer_width,
                  height: MediaQuery.of(context).size.height - header_height,
                  child: Center(
                    child: Text('Please wait...'),
                  ),
                )
              : CenterView(context, portalState.index ?? 0, portalState),
        ],
      ),
    );
  }

  Widget Header(BuildContext context, TenantPortalState portalState) {
    return Container(
      width: MediaQuery.of(context).size.width - drawer_width,
      height: header_height - 2,
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 5,
                  //height: 40,
                  color: myColor.headertitle,
                  margin:
                      EdgeInsets.only(top: 15, bottom: 15, left: 30, right: 20),
                ),
                Container(
                  child: Text(
                    portalState.title,
                    style: MyStyles.Medium(25, myColor.text_color),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: () async {
                  await ApiManager().NotificationCountTenant(context);

                  _store.dispatch(UpdateTenantPortalPage_isLoading(true));

                  if (portalState.index == 0) {
                    _store.dispatch(UpdateTenantPortalPage(
                        0, GlobleString.NAV_tenant_LeaseDetails));
                  } else if (portalState.index == 1) {
                    _store.dispatch(UpdateTenantPortalPage(
                        1, GlobleString.NAV_tenant_Maintenance));
                  }

                  new Timer(Duration(milliseconds: 3), () {
                    _store.dispatch(UpdateTenantPortalPage_isLoading(false));
                  });
                },
                child: Image.asset(
                  'assets/images/ic_header_refresh.png',
                  color: Colors.black,
                  width: 30,
                  height: 27,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () async {
                  OverlayEntry loader = Helper.overlayLoader(context);
                  Overlay.of(context)!.insert(loader);

                  ApiManager().getTenantNotificationList(
                      context, Prefs.getString(PrefsName.BT_ApplicantID), 1,
                      (status, notificationlist, message) {
                    if (status) {
                      loader.remove();

                      if (notificationlist.length >= 10) {
                        _store.dispatch(UpdateNotificationisIsLoadmore(true));
                      } else {
                        _store.dispatch(UpdateNotificationisIsLoadmore(false));
                      }
                      _store.dispatch(UpdateNotificationPageNo(1));
                      _store.dispatch(UpdateNotificationList(notificationlist));

                      if (notificationlist.length > 0) {
                        showDialogNotification(notificationlist, portalState);
                      }
                    } else {
                      loader.remove();
                    }
                  });
                },
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/ic_header_bell.png',
                      color: Colors.black,
                      width: 25,
                      height: 26,
                      fit: BoxFit.contain,
                    ),
                    if (portalState.notificationCount > 0)
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        padding: EdgeInsets.only(
                            left: 3, right: 3, top: 1, bottom: 1),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: myColor.noti_count_border, width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: myColor.noti_count_fill,
                        ),
                        //alignment: Alignment.topRight,
                        child: Text(
                          portalState.notificationCount.toString(),
                          style: MyStyles.Medium(10, myColor.text_color),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  MenuPopup(portalState);
                },
                child: Image.asset(
                  'assets/images/ic_header_profile.png',
                  color: Colors.black,
                  width: 26,
                  height: 26,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          )
        ],
      ),
    );
  }

  void showDialogNotification(
      List<NotificationData> notificationlist, TenantPortalState portalState) {
    double mheight;

    if (notificationlist.length > 0 && notificationlist.length < 4) {
      mheight = (notificationlist.length * 65) as double;
    } else if (notificationlist.length > 0 && notificationlist.length < 10) {
      mheight = (notificationlist.length * 60) as double;
    } else {
      mheight = 500;
    }

    if (isNotifiDialogshow) {
      Navigator.of(context).pop();
      isNotifiDialogshow = false;
    } else {
      showDialog(
        context: context,
        useSafeArea: false,
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              isNotifiDialogshow = false;
              return true;
            },
            child: Material(
              type: MaterialType.transparency,
              child: Align(
                alignment: Alignment(1.0, -1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8.0,
                        spreadRadius: 1,
                        offset: Offset(
                          0.0,
                          2.0,
                        ),
                      ),
                    ],
                  ),
                  height: mheight,
                  width: 250,
                  margin: EdgeInsets.only(top: 60, right: 40),
                  padding: EdgeInsets.all(5),
                  child: ConnectState<NotificationState>(
                      map: (state) => state.notificationState,
                      where: notIdentical,
                      builder: (notificationState) {
                        return Column(
                          children: [
                            Container(
                              height: notificationState!.IsLoadmore
                                  ? (mheight - 51)
                                  : (mheight - 10),
                              width: 250,
                              child: ListView.builder(
                                key: UniqueKey(),
                                itemCount:
                                    notificationState.notificationlist.length,
                                itemBuilder: (BuildContext context, int index) {
                                  NotificationData notification =
                                      notificationState.notificationlist[index];

                                  return TenantNotificationItem(
                                    itemdata: notification,
                                    onPressNotification: () {
                                      Navigator.of(context).pop();
                                      isNotifiDialogshow = false;

                                      _tapNotificationItem(
                                          notification, portalState);
                                    },
                                  );
                                },
                              ),
                            ),
                            if (notificationState.IsLoadmore)
                              Divider(
                                height: 1,
                                color: myColor.text_color,
                              ),
                            if (notificationState.IsLoadmore)
                              InkWell(
                                onTap: () {
                                  _taptoLoadMoreData(notificationState);
                                },
                                child: Container(
                                  height: 40,
                                  width: 250,
                                  color: myColor.white,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Load more data",
                                    style:
                                        MyStyles.Medium(15, myColor.text_color),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                          ],
                        );
                      }),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  void _tapNotificationItem(
      NotificationData notification, TenantPortalState portalState) {
    if (notification.typeOfNotification ==
            NotificationType().getNotificationType(
                NotificationName.Tenant_Maintenance_Requests) ||
        notification.typeOfNotification ==
            NotificationType().getNotificationType(
                NotificationName.Tenant_Maintenance_Change_Status) ||
        notification.typeOfNotification ==
            NotificationType().getNotificationType(
                NotificationName.Tenant_Maintenance_Change_Priority)) {
      CheckMaintenanceExitOrNot checkMaintenanceExitOrNot =
          new CheckMaintenanceExitOrNot();
      checkMaintenanceExitOrNot.ID = notification.MaintenanceID.toString();
      checkMaintenanceExitOrNot.Applicant_ID =
          notification.applicantId.toString();

      ApiManager().checkMaintenanceExit(context, checkMaintenanceExitOrNot,
          (status, responce) {
        if (status) {
          _dailogMaintenance(notification);
        } else {
          showDialog(
            context: context,
            barrierColor: Colors.black45,
            useSafeArea: true,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return MessageDialogBox(
                buttontitle: GlobleString.maintenance_request_not_found_ok,
                title: GlobleString.maintenance_request_not_found_title,
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              );
            },
          );
        }
      });
    }

    _updateReadNotification(notification, portalState);
  }

  _dailogMaintenance(NotificationData notification) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return MaintenanceRequestDialogBox(
          onPressedClose: () {
            Navigator.of(context1).pop();
          },
          onPressedEdit: (String mid) async {
            Navigator.of(context1).pop();
          },
          showEdit: false,
          mID: notification.MaintenanceID.toString(),
        );
      },
    );
  }

  void _taptoLoadMoreData(NotificationState notificationState) {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);
    ApiManager().getTenantNotificationList(
        context,
        Prefs.getString(PrefsName.BT_ApplicantID),
        (notificationState.PageNo + 1), (status, notificationlist, message) {
      if (status) {
        loader.remove();

        if (notificationlist.length >= 10) {
          _store.dispatch(UpdateNotificationisIsLoadmore(true));
        } else {
          _store.dispatch(UpdateNotificationisIsLoadmore(false));
        }
        _store
            .dispatch(UpdateNotificationPageNo((notificationState.PageNo + 1)));

        List<NotificationData> dalalist = notificationState.notificationlist;
        dalalist.addAll(notificationlist);
        _store.dispatch(UpdateNotificationList(dalalist));
      } else {
        loader.remove();
      }
    });
  }

  void _updateReadNotification(
      NotificationData notification, TenantPortalState portalState) {
    CommonID commonID = new CommonID();
    commonID.ID = notification.id.toString();

    NotificationIsRead notificationIsRead = new NotificationIsRead();
    notificationIsRead.IsRead = "1";

    ApiManager().UpdateNotificationRead(context, commonID, notificationIsRead,
        (status, responce) {
      if (status) {
        _store.dispatch(UpdateTenantPortalPage_notificationCount(
            portalState.notificationCount - 1));
      } else {
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
  }

  void MenuPopup(TenantPortalState portalState) {
    if (portalState.isMenuDialogshow) {
      Navigator.of(context).pop();
    } else {
      _store.dispatch(UpdateTenantisMenuDialogshow(false));
      showDialog(
        context: context,
        useSafeArea: false,
        barrierDismissible: true,
        barrierColor: Colors.black45,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              _store.dispatch(UpdateTenantisMenuDialogshow(false));
              return true;
            },
            child: Align(
              alignment: Alignment(1.0, -1.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2.0,
                    ),
                  ],
                ),
                height: 90,
                width: 120,
                margin: EdgeInsets.only(top: 50, right: 40),
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();

                            ProfileView();
                          },
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          child: Container(
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/ic_header_profile.png',
                                  color: Colors.black,
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  GlobleString.Menu_Profile,
                                  style:
                                      MyStyles.Medium(16, myColor.text_color),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            Navigator.of(context).pop();
                            String companyname = await Prefs.getString(
                                PrefsName.BT_CustomerFeatureListingURL);
                            await Prefs.clear();

                            Navigator.of(context).pushReplacementNamed("/" +
                                companyname +
                                "/" +
                                RouteNames.Basic_Tenant_Login);
                          },
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          child: Container(
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/ic_logout.png',
                                  color: Colors.black,
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  GlobleString.Menu_Logout,
                                  style:
                                      MyStyles.Medium(16, myColor.text_color),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Widget CenterView(
      BuildContext context, int index, TenantPortalState portalState) {
    switch (index) {
      case 0:
        {
          return TenantLeaseDetailsScreen();
        }
      case 1:
        {
          return TenantMaintenancScreen();
        }
      case 3:
        {
          return TenantProfileScreen();
        }
      default:
        {
          return TenantLeaseDetailsScreen();
        }
    }
  }

  ProfileView() {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().getTenantDetailsDSQCall(
        context, Prefs.getString(PrefsName.BT_UserID), (error, respoce2) {
      if (error) {
        loader.remove();
        _store.dispatch(UpdateTenantPortalPage(3, GlobleString.NAV_Profile));
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, respoce2, false);
      }
    });
  }
}
