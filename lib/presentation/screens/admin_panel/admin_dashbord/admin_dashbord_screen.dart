import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/presentation/models/admin_models/admin_dashbord_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager_admin.dart';
import 'package:silverhome/widget/admin_panel/newjoinee_table/newjoinee_header.dart';
import 'package:silverhome/widget/admin_panel/newjoinee_table/newjoinee_item.dart';
import 'package:silverhome/widget/admin_panel/todaytenantinvite_table/tenantinvite_header.dart';
import 'package:silverhome/widget/admin_panel/todaytenantinvite_table/tenantinvite_item.dart';

class AdminDashBordScreen extends StatefulWidget {
  @override
  _AdminDashBordScreenState createState() => _AdminDashBordScreenState();
}

class _AdminDashBordScreenState extends State<AdminDashBordScreen> {
  double height = 0, width = 0;
  final _store = getIt<AppStore>();

  @override
  void initState() {
    apiManager();
    super.initState();
  }

  apiManager() async {
    await ApiManagerAdmin().getDashbordStatusCount(context);
    //await ApiManagerAdmin().getDashbordList(context);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(20),
      color: myColor.white,
      child: ConnectState<AdminDashbordState>(
          map: (state) => state.adminDashbordState,
          where: notIdentical,
          builder: (adminDashbordState) {
            return Column(
              children: [
                _StatusCounter(adminDashbordState!),
                SizedBox(
                  height: 20,
                ),
                /*Container(
                  height: height - 140,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _todayNewJoinee(adminDashbordState),
                      SizedBox(
                        width: 20,
                      ),
                      _todayTenantInvitation(adminDashbordState)
                    ],
                  ),
                ),*/
              ],
            );
          }),
    );
  }

  Widget _StatusCounter(AdminDashbordState dashbordState) {
    return Container(
      height: 80,
      child: Row(
        children: [
          Expanded(
            child: Card(
              elevation: 5,
              shadowColor: myColor.fnl_shadow,
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    color: myColor.Circle_main,
                    child: Image.asset(
                      "assets/images/ic_nav_properties.png",
                      width: 35,
                      height: 35,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: myColor.main_light,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            GlobleString.ADB_TotalProperties,
                            style: MyStyles.Medium(14, myColor.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            dashbordState.totalProperty_cout.toString(),
                            style: MyStyles.SemiBold(18, myColor.white),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Card(
              elevation: 5,
              shadowColor: myColor.fnl_shadow,
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    color: myColor.Circle_main,
                    child: Image.asset(
                      "assets/images/ic_nav_tenants.png",
                      width: 35,
                      height: 35,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: myColor.main_light,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            GlobleString.ADB_TotalTenant,
                            style: MyStyles.Medium(14, myColor.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            dashbordState.totalTenant_cout.toString(),
                            style: MyStyles.SemiBold(18, myColor.white),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Card(
              elevation: 5,
              shadowColor: myColor.fnl_shadow,
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    color: myColor.Circle_main,
                    child: Image.asset(
                      "assets/images/ic_nav_admin_teammanage.png",
                      width: 35,
                      height: 35,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: myColor.main_light,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            GlobleString.ADB_TotalLandlords,
                            style: MyStyles.Medium(14, myColor.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            dashbordState.totalProperty_owner_cout.toString(),
                            style: MyStyles.SemiBold(18, myColor.white),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          /* SizedBox(
            width: 20,
          ),
          Expanded(
            child: Card(
              elevation: 5,
              shadowColor: myColor.fnl_shadow,
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    color: myColor.Circle_main,
                    child: Image.asset(
                      "assets/images/ic_nav_documents.png",
                      width: 35,
                      height: 35,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: myColor.main_light,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            GlobleString.ADB_TotalLeasedSigned,
                            style: MyStyles.Medium(14, myColor.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            dashbordState.totallease_signed_count.toString(),
                            style: MyStyles.SemiBold(18, myColor.white),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _todayNewJoinee(AdminDashbordState dashbordState) {
    return Flexible(
      flex: 2,
      child: Card(
        elevation: 5,
        shadowColor: myColor.fnl_shadow,
        child: Container(
          child: Column(
            children: [
              Container(
                width: width,
                height: 40,
                color: myColor.Circle_main,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  GlobleString.ADB_TodaysNewJoinee +
                      " - " +
                      new DateFormat("yyyy-MM-dd")
                          .format(DateTime.now())
                          .toString(),
                  style: MyStyles.Medium(16, myColor.white),
                ),
              ),
              NewJoineeHeader(),
              NewJoineeItem(
                listdata1: dashbordState.newJoineeOwnerList,
              )
              /*Container(
                height: height - 190,
                color: Colors.white,
                child: Column(
                  children: [

                  ],
                ),
              )*/
            ],
          ),
        ),
      ),
    );
  }

  Widget _todayTenantInvitation(AdminDashbordState dashbordState) {
    return Flexible(
      flex: 3,
      child: Card(
        elevation: 5,
        shadowColor: myColor.fnl_shadow,
        child: Container(
          child: Column(
            children: [
              Container(
                width: width,
                height: 40,
                color: myColor.Circle_main,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  GlobleString.ADB_TodayTenantInvitation +
                      " - " +
                      new DateFormat("yyyy-MM-dd")
                          .format(DateTime.now())
                          .toString(),
                  style: MyStyles.Medium(16, myColor.white),
                ),
              ),
              TenantInviteHeader(),
              TenantInviteItem(
                listdata1: dashbordState.todayTenantInviteList,
              )
              /* Container(
                height: height - 190,
                color: Colors.white,
                child: Column(
                  children: [

                  ],
                ),
              )*/
            ],
          ),
        ),
      ),
    );
  }
}
