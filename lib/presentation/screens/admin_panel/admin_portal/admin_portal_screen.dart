import 'package:flutter/material.dart';
import 'package:silverhome/common/basic_page.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/actions/admin_action/admin_portal_action.dart';
import 'package:silverhome/domain/entities/active_lead.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/presentation/models/admin_models/admin_portal_state.dart';
import 'package:silverhome/presentation/screens/admin_panel/admin_dashbord/admin_dashbord_screen.dart';
import 'package:silverhome/presentation/screens/admin_panel/admin_landlord/admin_landloads_screen.dart';
import 'package:silverhome/presentation/screens/admin_panel/admin_landlord/admin_landlordsdetails_screen.dart';
import 'package:silverhome/presentation/screens/admin_panel/admin_landlord/admin_property_details.dart';
import 'package:silverhome/presentation/screens/admin_panel/admin_landlord/admin_tenancy_details.dart';
import 'package:silverhome/presentation/screens/admin_panel/admin_leadsTenant/admin_leadstenant_screen.dart';
import 'package:silverhome/presentation/screens/admin_panel/admin_setting/admin_setting_screen.dart';
import 'package:silverhome/presentation/screens/admin_panel/admin_team/admin_team_management_screen.dart';
import 'package:silverhome/store/store.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager_admin.dart';

class AdminPortalScreen extends BasePage {
  @override
  _AdminPortalScreenState createState() => _AdminPortalScreenState();
}

class _AdminPortalScreenState extends BaseState<AdminPortalScreen>
    with BasicPage {
  final _store = getIt<AppStore>();

  double height = 0, width = 0;
  double drawer_width = 0;
  double header_height = 0;
  List<ActiveLead> notificalist = [];

  @override
  void initState() {
    Prefs.init();
    _store.dispatch(UpdateAdminPortalPage(0, GlobleString.NAV_admin_Overview));
    super.initState();
  }

  @override
  Widget rootWidget(BuildContext context) {
    // TODO: implement rootWidget
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
      child: ConnectState<AdminPortalState>(
          map: (state) => state.adminPortalState,
          where: notIdentical,
          builder: (adminPortalState) {
            Helper.Log(">>", "Rendering Portal Screen");
            return Stack(
              children: [
                Row(
                  children: [
                    Container(
                      width: drawer_width,
                      height: MediaQuery.of(context).size.height,
                    ),
                    ContentCenterView(context, drawer_width, adminPortalState!),
                  ],
                ),
                DrawerMenu(context, adminPortalState),
              ],
            );
          }),
    );
  }

  Widget DrawerMenu(BuildContext context, AdminPortalState portalState) {
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
          Container(
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
                      _store.dispatch(UpdateAdminPortalPage(
                          0, GlobleString.NAV_admin_Overview));
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
                              "assets/images/ic_nav_dashboard.png",
                              width: 26,
                              height: 26,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                GlobleString.NAV_admin_Overview,
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
                      _store.dispatch(UpdateAdminPortalPage(
                          1, GlobleString.NAV_admin_Landlords));
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
                              "assets/images/ic_nav_admin_landlord.png",
                              width: 27,
                              height: 27,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                GlobleString.NAV_admin_Landlords,
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
                  InkWell(
                    onTap: () {
                      _store.dispatch(UpdateAdminPortalPage(
                          2, GlobleString.NAV_admin_LeadsTenants));
                    },
                    child: Container(
                      height: 60,
                      color: portalState.index == 2
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
                              "assets/images/ic_nav_admin_leadtenant.png",
                              width: 24,
                              height: 26,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                GlobleString.NAV_admin_LeadsTenants,
                                style: portalState.index == 2
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
                      _store.dispatch(UpdateAdminPortalPage(
                          3, GlobleString.NAV_admin_TeamManagement));
                    },
                    child: Container(
                      height: 60,
                      color: portalState.index == 3
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
                              "assets/images/ic_nav_admin_teammanage.png",
                              width: 32,
                              height: 26,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                GlobleString.NAV_admin_TeamManagement,
                                style: portalState.index == 3
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
                      _store.dispatch(UpdateAdminPortalPage(
                          4, GlobleString.NAV_admin_Settings));
                    },
                    child: Container(
                      height: 60,
                      color: portalState.index == 4
                          ? myColor.drawselectcolor
                          : myColor.white,
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 35,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.settings,
                              color: myColor.Circle_main,
                              size: 32,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                GlobleString.NAV_admin_Settings,
                                style: portalState.index == 4
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
      BuildContext context, double val, AdminPortalState portalState) {
    return Container(
      width: MediaQuery.of(context).size.width - val,
      child: Column(
        children: [
          Header(context, portalState),
          Container(
            height: 1,
            color: myColor.TA_Border,
          ),
          CenterView(context, portalState.index ?? 0, portalState),
        ],
      ),
    );
  }

  Widget Header(BuildContext context, AdminPortalState portalState) {
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
                  if (portalState.index == 0) {
                    await ApiManagerAdmin().getDashbordStatusCount(context);
                    await ApiManagerAdmin().getDashbordList(context);
                  }
                },
                child: Image.asset(
                  'assets/images/ic_header_refresh.png',
                  color: Colors.black,
                  width: 30,
                  height: 27,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 20),
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
              SizedBox(width: 20),
            ],
          )
        ],
      ),
    );
  }

  Widget CenterView(
      BuildContext context, int index, AdminPortalState portalState) {
    switch (index) {
      case 0:
        {
          return AdminDashBordScreen();
        }
      case 1:
        {
          if (portalState.subindex == 1 && portalState.index == 1) {
            return AdminLandlordsDetailsScreen();
          } else if (portalState.subindex == 2 && portalState.index == 1) {
            return AdminPropertyDetails();
          } else if (portalState.subindex == 3 && portalState.index == 1) {
            return AdminTenancyDetails();
          }

          return AdminLandlordsScreen();
        }
      case 2:
        {
          if (portalState.subindex == 1 && portalState.index == 2) {
            return AdminTenancyDetails();
          }

          return AdminLeadsTenantScreen();
        }
      case 3:
        {
          return AdminTeamManagementScreen();
        }
      case 4:
        {
          return AdminSettingScreen();
        }
      default:
        {
          return AdminDashBordScreen();
        }
    }
  }

  void MenuPopup(AdminPortalState portalState) {
    if (portalState.isMenuDialogshow) {
      Navigator.of(context).pop();
    } else {
      _store.dispatch(UpdateisMenuDialogshow(false));
      showDialog(
          context: context,
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Colors.black45,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async {
                _store.dispatch(UpdateisMenuDialogshow(false));
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
                            onTap: () {
                              Navigator.of(context).pop();
                              Prefs.clear();
                              navigateTo(context, RouteNames.Login);
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
          });
    }
  }
}
