import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/actions/landlord_action/landlord_tenancy_activetenant_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/landlord_tenancy_applicant_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/landlord_tenancy_lead_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/landlord_tenancy_lease_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/landlordapplication_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/landlordtenancyarchive_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/portal_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/reference_check_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/varification_document_actions.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/presentation/models/landlord_models/landlordapplication_state.dart';
import 'package:silverhome/presentation/screens/landlord/landlordApplication/landlord_leases_screen.dart';
import 'package:silverhome/presentation/screens/landlord/landlordApplication/landlord_reference_checks_screen.dart';
import 'package:silverhome/presentation/screens/landlord/landlordApplication/landlord_verification_document_screen.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/store.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';

import 'landlord_active_tenant_screen.dart';
import 'landlord_archived_leads_screen.dart';
import 'landlord_tenancy_applicant_screen.dart';
import 'landlord_tenancy_lead_screen.dart';

class LandlordApplicationScreen extends StatefulWidget {
  @override
  _LandlordApplicationScreenState createState() =>
      _LandlordApplicationScreenState();
}

class _LandlordApplicationScreenState extends State<LandlordApplicationScreen> {
  final _store = getIt<AppStore>();
  double ssheight = 0, sswidth = 0;

  @override
  void initState() {
    updateCount();
    apimanager();
    super.initState();
  }

  updateCount() {
    ApiManager().updateTenancyStatusCount(context);
  }

  void apimanager() async {
    await Prefs.init();

    await Prefs.setBool(PrefsName.IsApplyFilterList, false);
    await Prefs.setBool(PrefsName.IsApplyFilterFunnel, false);

    ApiManager().updateTenancyStatusCount(context);

    PropertyListInDropDown propertyListInDropDown =
        new PropertyListInDropDown();
    propertyListInDropDown.IsActive = "1";
    propertyListInDropDown.Owner_ID = Prefs.getString(PrefsName.OwnerID);

    ApiManager().PropertyListInDropDownApi(context, propertyListInDropDown,
        (mylitems, error) {
      List<PropertyData> propertylist = <PropertyData>[];
      if (error) {
        propertylist = mylitems;

        //Helper.Log("PropertyList",jsonEncode(propertylist));

        _store.dispatch(UpdateLLTALeadPropertyList(propertylist));
        _store.dispatch(UpdateLLTAApplicantPropertyList(propertylist));
        _store.dispatch(UpdateLLVDapplicationPropertyList(propertylist));
        _store.dispatch(UpdateLLRCPropertyList(propertylist));
        _store.dispatch(UpdateLLTLleasePropertyList(propertylist));
        _store.dispatch(UpdateArchivePropertyList(propertylist));
        _store.dispatch(UpdateLLActiveTenantPropertyList(propertylist));
      } else {
        _store.dispatch(UpdateLLTALeadPropertyList(propertylist));
        _store.dispatch(UpdateLLTAApplicantPropertyList(propertylist));
        _store.dispatch(UpdateLLVDapplicationPropertyList(propertylist));
        _store.dispatch(UpdateLLRCPropertyList(propertylist));
        _store.dispatch(UpdateLLTLleasePropertyList(propertylist));
        _store.dispatch(UpdateArchivePropertyList(propertylist));
        _store.dispatch(UpdateLLActiveTenantPropertyList(propertylist));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ssheight = MediaQuery.of(context).size.height - 70;
    sswidth = MediaQuery.of(context).size.width - 230;

    return Container(
      height: ssheight,
      width: sswidth,
      color: myColor.bg_color1,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: ConnectState<LandLordApplicationState>(
              map: (state) => state.landLordApplicationState,
              where: notIdentical,
              builder: (landLordApplicationState) {
                return Column(
                  children: [
                    _statusView(landLordApplicationState!),
                    _tabView(landLordApplicationState),
                    _centerView(landLordApplicationState.selecttab),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget _statusView(LandLordApplicationState landLordApplicationState) {
    return Container(
      child: Row(
        children: [
          CustomeWidget.TenantsStutas(
              landLordApplicationState.leads_cout.toString(),
              GlobleString.LL_status_Leads),
          CustomeWidget.TenantsStutas(
              landLordApplicationState.applications_count.toString(),
              GlobleString.LL_status_Applications),
          // CustomeWidget.TenantsStutas(
          //     landLordApplicationState.varfy_documents_count.toString(),
          //     GlobleString.LL_status_Documents),
          CustomeWidget.TenantsStutas(
              landLordApplicationState.references_check_count.toString(),
              GlobleString.LL_status_References),
          CustomeWidget.TenantsStutas(
              landLordApplicationState.leases_count.toString(),
              GlobleString.LL_status_Leases),
          CustomeWidget.TenantsStutas(
              landLordApplicationState.active_tenants_count.toString(),
              GlobleString.LL_status_Active_Tenants),
        ],
      ),
    );
  }

  Widget _tabView(LandLordApplicationState landLordApplicationState) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Stack(
        children: [
          Container(
            height: 1,
            margin: EdgeInsets.only(top: 37, right: 15),
            color: myColor.TA_tab_devide,
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    child: InkWell(
                      onTap: () async {
                        if (Prefs.getBool(PrefsName.IsApplyFilterFunnel)) {
                          await Prefs.setBool(
                              PrefsName.IsApplyFilterFunnel, false);
                        }
                        _store.dispatch(UpdateLLTALeadToggle(0));
                        _store.dispatch(UpdateLandlordApplicationTab(1));
                        _store.dispatch(UpdateTenantTabIndex(1));
                      },
                      child: CustomeWidget.TenantsTabWidget(
                          GlobleString.LL_TAB_Leads,
                          landLordApplicationState.selecttab,
                          1),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 45,
                    child: InkWell(
                      onTap: () async {
                        if (Prefs.getBool(PrefsName.IsApplyFilterFunnel)) {
                          await Prefs.setBool(
                              PrefsName.IsApplyFilterFunnel, false);
                        }

                        _store.dispatch(UpdateLLTAApplicantToggle(0));
                        _store.dispatch(UpdateLandlordApplicationTab(2));
                        _store.dispatch(UpdateTenantTabIndex(2));
                      },
                      child: CustomeWidget.TenantsTabWidget(
                          GlobleString.LL_TAB_Applicants,
                          landLordApplicationState.selecttab,
                          2),
                    ),
                  ),
                ),
                // Expanded(
                //   child: Container(
                //     height: 45,
                //     child: InkWell(
                //       onTap: () async {
                //         if (Prefs.getBool(PrefsName.IsApplyFilterFunnel)) {
                //           await Prefs.setBool(
                //               PrefsName.IsApplyFilterFunnel, false);
                //         }
                //         _store.dispatch(UpdateLLVDToggle(0));
                //         _store.dispatch(UpdateLandlordApplicationTab(3));
                //         _store.dispatch(UpdateTenantTabIndex(3));
                //       },
                //       child: CustomeWidget.TenantsTabWidget(
                //           GlobleString.LL_TAB_Verification_Documents,
                //           landLordApplicationState.selecttab,
                //           3),
                //     ),
                //   ),
                // ),
                Expanded(
                  child: Container(
                    height: 45,
                    child: InkWell(
                      onTap: () async {
                        if (Prefs.getBool(PrefsName.IsApplyFilterFunnel)) {
                          await Prefs.setBool(
                              PrefsName.IsApplyFilterFunnel, false);
                        }
                        _store.dispatch(UpdateLLRCToggle(0));
                        _store.dispatch(UpdateLandlordApplicationTab(4));
                        _store.dispatch(UpdateTenantTabIndex(4));
                      },
                      child: CustomeWidget.TenantsTabWidget(
                          GlobleString.LL_TAB_Reference_Checks,
                          landLordApplicationState.selecttab,
                          4),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 45,
                    child: InkWell(
                      onTap: () async {
                        if (Prefs.getBool(PrefsName.IsApplyFilterFunnel)) {
                          await Prefs.setBool(
                              PrefsName.IsApplyFilterFunnel, false);
                        }
                        _store.dispatch(UpdateLLTLToggle(0));
                        _store.dispatch(UpdateLandlordApplicationTab(5));
                        _store.dispatch(UpdateTenantTabIndex(5));
                      },
                      child: CustomeWidget.TenantsTabWidget(
                          GlobleString.LL_TAB_Leases,
                          landLordApplicationState.selecttab,
                          5),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 45,
                    child: InkWell(
                      onTap: () async {
                        if (Prefs.getBool(PrefsName.IsApplyFilterFunnel)) {
                          await Prefs.setBool(
                              PrefsName.IsApplyFilterFunnel, false);
                        }

                        _store.dispatch(UpdateLLActiveTenantToggle(0));
                        _store.dispatch(UpdateLandlordApplicationTab(6));
                        _store.dispatch(UpdateTenantTabIndex(6));
                      },
                      child: CustomeWidget.TenantsTabWidget(
                          GlobleString.LL_TAB_ActiveTenant,
                          landLordApplicationState.selecttab,
                          6),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 45,
                    child: InkWell(
                      onTap: () async {
                        if (Prefs.getBool(PrefsName.IsApplyFilterFunnel)) {
                          await Prefs.setBool(
                              PrefsName.IsApplyFilterFunnel, false);
                        }
                        _store.dispatch(UpdateArchiveToggle(0));
                        _store.dispatch(UpdateLandlordApplicationTab(7));
                        _store.dispatch(UpdateTenantTabIndex(7));
                      },
                      child: CustomeWidget.TenantsTabWidget(
                          GlobleString.LL_TAB_ArchivedLeads,
                          landLordApplicationState.selecttab,
                          7),
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
          return LandlordTenancyLeadScreen();
        }
      case 2:
        {
          //  return LandlordTenancyApplicantScreen();
          return LandlordVarificationDocumentScreen();
        }
      case 3:
        {
          return LandlordVarificationDocumentScreen();
        }
      case 4:
        {
          return LandlordReferenceCheckScreen();
        }
      case 5:
        {
          return LandlordLeasesScreen();
        }
      case 6:
        {
          return LandlordActiveTenantScreen();
        }
      case 7:
        {
          return LandlordArchivedLeadsScreen();
        }
      default:
        {
          return LandlordTenancyLeadScreen();
        }
    }
  }
}
