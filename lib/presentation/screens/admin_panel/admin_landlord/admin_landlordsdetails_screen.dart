import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/actions/admin_action/admin_landlorddetails_actions.dart';
import 'package:silverhome/domain/actions/admin_action/admin_portal_action.dart';
import 'package:silverhome/presentation/models/admin_models/admin_landlorddetails_state.dart';
import 'package:silverhome/presentation/screens/admin_panel/admin_landlord/admin_landlordsdetails_account.dart';
import 'package:silverhome/presentation/screens/admin_panel/admin_landlord/admin_landlordsdetails_leadtenant.dart';
import 'package:silverhome/presentation/screens/admin_panel/admin_landlord/admin_landlordsdetails_property.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';

class AdminLandlordsDetailsScreen extends StatefulWidget {
  @override
  _AdminLandlordsDetailsScreenState createState() => _AdminLandlordsDetailsScreenState();
}

class _AdminLandlordsDetailsScreenState extends State<AdminLandlordsDetailsScreen> {
  double height = 0, width = 0;
  final _store = getIt<AppStore>();

  double drawer_width = 230;
  double header_height = 70;

  @override
  void initState() {
    Prefs.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: height,
      child: ConnectState<AdminLandlordDetailsState>(
          map: (state) => state.adminLandlordDetailsState,
          where: notIdentical,
          builder: (adminLandlordDetailsState) {
            return Column(
              children: [
                _backToLandlord(adminLandlordDetailsState!),
                Container(
                  height: height - 56,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: myColor.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: myColor.application_boreder, width: 1),
                  ),
                  child: Column(
                    children: [
                      _tabView(adminLandlordDetailsState),
                      _centerView(adminLandlordDetailsState.selecttab),
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }

  Widget _backToLandlord(AdminLandlordDetailsState adminLandlordDetailsState) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: 15, left: 10, bottom: 5),
      child: InkWell(
        onTap: () {
          if (Prefs.getBool(PrefsName.admin_tenant_Landlord_Back)) {
            _store.dispatch(UpdateAdminPortalPage(2, GlobleString.NAV_admin_LeadsTenants));
          } else {
            _store.dispatch(UpdateAdminPortalPage(1, GlobleString.NAV_admin_Landlords));
          }
        },
        child: Text(
          GlobleString.ALLD_Account_backto_Landlords,
          style: MyStyles.SemiBold(13, myColor.blue),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  Widget _tabView(AdminLandlordDetailsState adminLandlordDetailsState) {
    return Container(
      child: Stack(
        children: [
          Container(
            height: 1,
            margin: EdgeInsets.only(top: 37),
            color: myColor.TA_tab_devide,
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    child: InkWell(
                      onTap: () {
                        _store.dispatch(UpdateLandlordDetailsTab(1));
                      },
                      child: CustomeWidget.AdminTabWidget(GlobleString.ALLD_TAB_Account, adminLandlordDetailsState.selecttab, 1),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 40,
                    child: InkWell(
                      onTap: () {
                        _store.dispatch(UpdateLandlordDetailsTab(2));
                      },
                      child: CustomeWidget.AdminTabWidget(GlobleString.ALLD_TAB_Properties, adminLandlordDetailsState.selecttab, 2),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 40,
                    child: InkWell(
                      onTap: () {
                        _store.dispatch(UpdateLandlordDetailsTab(3));
                      },
                      child: CustomeWidget.AdminTabWidget(GlobleString.ALLD_TAB_Leads_Tenants, adminLandlordDetailsState.selecttab, 3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _centerView(int view) {
    switch (view) {
      case 1:
        {
          return AdminLandlordsDetailsAccount();
        }
      case 2:
        {
          return AdminLandlordsDetailsProperty();
        }
      case 3:
        {
          return AdminLandlordsDetailsLeadTenant();
        }

      default:
        {
          return AdminLandlordsDetailsAccount();
        }
    }
  }
}
