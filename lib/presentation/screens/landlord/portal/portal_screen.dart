import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:silverhome/bloc/bloc.dart';
import 'package:silverhome/common/basic_page.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/notification_type.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/actions.dart';
import 'package:silverhome/domain/actions/landlord_action/landlord_tenancy_activetenant_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/landlord_tenancy_applicant_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/landlord_tenancy_lead_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/landlord_tenancy_lease_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/landlordtenancyarchive_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/notification_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/propertylist_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/reference_check_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/varification_document_actions.dart';
import 'package:silverhome/domain/entities/filter_item.dart';
import 'package:silverhome/domain/entities/notificationdata.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/presentation/models/landlord_models/notification_state.dart';
import 'package:silverhome/presentation/models/landlord_models/portal_state.dart';
import 'package:silverhome/presentation/screens/landlord/chat/chat_page.dart';
import 'package:silverhome/presentation/screens/landlord/documents/files.dart';
import 'package:silverhome/presentation/screens/landlord/landlordApplication/landlord_application_screen.dart';
import 'package:silverhome/presentation/screens/landlord/maintenance/requests/maintenance_requests_screen.dart';
import 'package:silverhome/presentation/screens/landlord/maintenance/vendors/maintenance_vendors_screen.dart';
import 'package:silverhome/presentation/screens/landlord/profile/landlord_profilescreen.dart';
import 'package:silverhome/presentation/screens/landlord/property/add_edit_property.dart';
import 'package:silverhome/presentation/screens/landlord/property/property_screen_new.dart';
import 'package:silverhome/presentation/screens/landlord/scheduling/calendar/scheduling_calendar_screen.dart';
import 'package:silverhome/presentation/screens/landlord/scheduling/event_type_templates/add_edit_eventtypes_templates.dart';
import 'package:silverhome/presentation/screens/landlord/scheduling/event_type_templates/event_type_templates_screen.dart';
import 'package:silverhome/presentation/screens/landlord/scheduling/event_types/add_edit_eventtypes.dart';
import 'package:silverhome/presentation/screens/landlord/scheduling/event_types/event_types_screen.dart';
import 'package:silverhome/presentation/screens/landlord/tenancy_application_details/tenancy_application_screen.dart';
import 'package:silverhome/store/store.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/alert/alert_dialogbox.dart';
import 'package:silverhome/widget/basic_tenant/maintenace_dialogbox.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/landlord/preview_Lease_dialogbox.dart';
import 'package:silverhome/widget/landlord/preview_documents_dialogbox.dart';
import 'package:silverhome/widget/alert/message_dialogbox.dart';
import 'package:silverhome/widget/notification/notification_item.dart';

class PortalScreen extends BasePage {
  @override
  _PortalScreenState createState() => _PortalScreenState();
}

class _PortalScreenState extends BaseState<PortalScreen> with BasicPage {
  final _store = getIt<AppStore>();

  double height = 0, width = 0;
  double drawer_width = 0;
  double header_height = 0;
  static bool isNotifiDialogshow = false;
  late OverlayEntry loader;
  bool isFirstCharge = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    apimanager();
    super.initState();
  }

  apimanager() async {
    await Prefs.init();
    _store.dispatch(UpdateMantenaceExpand(false));
    ApiManager().NotificationCount(context);
  }

  @override
  createState() {}

  void initVars(Bloc bloc) {
    bloc.documentBloc.changeDocumentMenuDrawer(false);
  }

  @override
  Widget rootWidget(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    drawer_width = 230;
    header_height = 70;
    final bloc = Provider.of<Bloc>(context);
    if (isFirstCharge) {
      isFirstCharge = false;
      initVars(bloc);
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          key: _scaffoldKey,
          minimum: EdgeInsets.zero,
          child: Center(
            child: _initialview(context, bloc),
          ),
        ),
      ),
    );
  }

  Widget _initialview(BuildContext context, Bloc bloc) {
    return Container(
      width: width,
      height: height,
      child: ConnectState<PortalState>(
          map: (state) => state.portalState,
          where: notIdentical,
          builder: (portalState) {
            Helper.Log(">>", "Rendering Portal Screen");
            return Stack(
              children: [
                Row(
                  children: [
                    Container(
                      width: drawer_width,
                      height: MediaQuery.of(context).size.height,
                    ),
                    ContentCenterView(context, drawer_width, portalState!, bloc),
                  ],
                ),
                DrawerMenu(context, portalState, bloc),
              ],
            );
          }),
    );
  }

  cleanButtons() {
    _store.dispatch(UpdateLandlordApplication_Lead_Count(-1));
    _store.dispatch(UpdateLandlordApplications_count(-1));
    _store.dispatch(UpdateLandlordApplication_verification_documents_count(-1));
    _store.dispatch(UpdateLandlordApplication_references_check_count(-1));
    _store.dispatch(UpdateLandlordApplication_leases_count(-1));
    _store.dispatch(UpdateLandlordApplication_Active_Tenants_Count(-1));
    _store.dispatch(UpdateLLTALeadToggle(-1));
    _store.dispatch(UpdateLandlordApplicationTab(-1));
    _store.dispatch(UpdateTenantTabIndex(-1));

    _store.dispatch(UpdateLLTALeadPropertyItem(null));
    _store.dispatch(UpdateLLTAApplicantPropertyItem(null));
    _store.dispatch(UpdateLLVDapplicationPropertyItem(null));
    _store.dispatch(UpdateLLRCPropertyItem(null));
    _store.dispatch(UpdateLLTLleasePropertyItem(null));
    _store.dispatch(UpdateArchivePropertyItem(null));
    _store.dispatch(UpdateLLActiveTenantPropertyItem(null));
    _store.dispatch(UpdateMantenaceExpand(false));
    _store.dispatch(UpdateSchedulingExpand(false));

    _store.dispatch(UpdateLLTALeadPropertyItem(null));
    _store.dispatch(UpdateLLTAApplicantPropertyItem(null));
    _store.dispatch(UpdateLLVDapplicationPropertyItem(null));
    _store.dispatch(UpdateLLRCPropertyItem(null));
    _store.dispatch(UpdateLLTLleasePropertyItem(null));
    _store.dispatch(UpdateArchivePropertyItem(null));
    _store.dispatch(UpdateLLActiveTenantPropertyItem(null));
    _store.dispatch(UpdateMantenaceExpand(false));
    _store.dispatch(UpdateSchedulingExpand(false));
  }

  Widget DrawerMenu(BuildContext context, PortalState portalState, Bloc bloc) {
    return Container(
      width: drawer_width,
      height: MediaQuery.of(context).size.height,
      //color: Colors.white,
      decoration: const BoxDecoration(
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
            margin: EdgeInsets.only(left: 15),
            padding: EdgeInsets.all(5),
            child: InkWell(
              onTap: () async {},
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
                        bloc.documentBloc.changeDocumentMenuDrawer(false);
                        bloc.documentBloc.changeDocumentSubMenuDrawer(-1);
                        _store.dispatch(UpdatePropertyStatus_UnitsHeld(0));
                        _store.dispatch(UpdatePropertyStatus_UnitsRented(0));
                        _store.dispatch(UpdatePropertyStatus_VacantUnits(0));
                        _store.dispatch(UpdateMantenaceExpand(false));
                        _store.dispatch(UpdateSchedulingExpand(false));
                        _store.dispatch(UpdatePortalPage(1, GlobleString.NAV_Properties));
                      },
                      child: StreamBuilder(
                          stream: bloc.documentBloc.getDocumentSubMenuTransformer,
                          initialData: -1,
                          builder: (BuildContext context, AsyncSnapshot snapshotDocumentSubMenu) {
                            return Container(
                              height: 60,
                              padding: EdgeInsets.only(left: 15),
                              color: portalState.index == 1 &&
                                      (!snapshotDocumentSubMenu.hasData ||
                                          (snapshotDocumentSubMenu.hasData && snapshotDocumentSubMenu.data == -1))
                                  ? myColor.drawselectcolor
                                  : myColor.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 35,
                                    child: Image.asset(
                                      "assets/images/ic_nav_properties.png",
                                      width: 25,
                                      height: 26,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(
                                        GlobleString.NAV_Properties,
                                        style: portalState.index == 1 &&
                                                (!snapshotDocumentSubMenu.hasData ||
                                                    (snapshotDocumentSubMenu.hasData && snapshotDocumentSubMenu.data == -1))
                                            ? MyStyles.SemiBold(16, myColor.Circle_main)
                                            : MyStyles.Regular(16, myColor.Circle_main),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          })),
                  /*InkWell(
                    onTap: () {
                      _store.dispatch(
                          UpdatePortalPage(2, GlobleString.NAV_Finances));
                    },
                    child: Container(
                      height: 60,
                      color: portalState.index == 2
                          ? myColor.drawselectcolor
                          : myColor.white,
                      padding: EdgeInsets.only(left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 35,
                            child: Image.asset(
                              "assets/images/ic_nav_finance.png",
                              width: 34,
                              height: 28,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                GlobleString.NAV_Finances,
                                style: portalState.index == 2
                                    ? MyStyles.SemiBold(16, myColor.Circle_main)
                                    : MyStyles.Regular(16, myColor.Circle_main),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),*/
                  /*InkWell(
                    onTap: () {
                      _store.dispatch(
                          UpdatePortalPage(3, GlobleString.NAV_Documents));
                    },
                    child: Container(
                      height: 60,
                      color: portalState.index == 3
                          ? myColor.drawselectcolor
                          : myColor.white,
                      padding: EdgeInsets.only(left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 35,
                            child: Image.asset(
                              "assets/images/ic_nav_documents.png",
                              width: 19,
                              height: 26,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                GlobleString.NAV_Documents,
                                style: portalState.index == 3
                                    ? MyStyles.SemiBold(16, myColor.Circle_main)
                                    : MyStyles.Regular(16, myColor.Circle_main),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),*/
                  InkWell(
                    onTap: () {
                      bloc.documentBloc.changeDocumentMenuDrawer(false);
                      bloc.documentBloc.changeDocumentSubMenuDrawer(-1);
                      tenantView();
                    },
                    child: Container(
                      height: 60,
                      color: portalState.index == 4 ? myColor.drawselectcolor : myColor.white,
                      padding: EdgeInsets.only(left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 35,
                            child: Image.asset(
                              "assets/images/ic_nav_tenants.png",
                              width: 26,
                              height: 26,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                GlobleString.NAV_Tenants,
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
                  InkWell(
                    onTap: () {
                      bloc.documentBloc.changeDocumentMenuDrawer(false);
                      bloc.documentBloc.changeDocumentSubMenuDrawer(-1);
                      // _store.dispatch(
                      //     UpdatePortalPage(5, GlobleString.NAV_Maintenance));
                      // _store.dispatch(UpdateMantenaceRequest());
                      _store.dispatch(UpdateMantenaceExpand(!portalState.isMaintenanceExpand));
                    },
                    child: Container(
                      height: 60,
                      color: portalState.index == 5 ? myColor.drawselectcolor : myColor.white,
                      padding: EdgeInsets.only(left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 35,
                            child: Image.asset(
                              "assets/images/ic_nav_maintainance.png",
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      GlobleString.NAV_Maintenance,
                                      style: portalState.index == 5
                                          ? MyStyles.SemiBold(16, myColor.Circle_main)
                                          : MyStyles.Regular(16, myColor.Circle_main),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      portalState.isMaintenanceExpand ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down_sharp,
                                      size: 25,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  portalState.isMaintenanceExpand == true
                      ? Container(
                          height: 70,
                          color: portalState.index == 5 ? myColor.drawselectcolor2 : myColor.white,
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(width: 5),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 40),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      InkWell(
                                        onTap: () {
                                          _store.dispatch(UpdateSchedulingExpand(false));
                                          _store.dispatch(UpdateMantenaceRequest());
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                GlobleString.NAV_Maintenance_requests,
                                                style: portalState.index == 5 && portalState.subindex == 1
                                                    ? MyStyles.SemiBold(14, myColor.Circle_main)
                                                    : MyStyles.Regular(14, myColor.Circle_main),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      InkWell(
                                        onTap: () {
                                          _store.dispatch(UpdateSchedulingExpand(false));
                                          _store.dispatch(UpdateMantenaceVendor());
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                GlobleString.NAV_Maintenance_vendors,
                                                style: portalState.index == 5 && portalState.subindex == 2
                                                    ? MyStyles.SemiBold(14, myColor.Circle_main)
                                                    : MyStyles.Regular(14, myColor.Circle_main),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),

                  //Item Documents
                  StreamBuilder(
                      stream: bloc.documentBloc.getDocumentMenuTransformer,
                      initialData: false,
                      builder: (BuildContext context, AsyncSnapshot snapshotDocument) {
                        return StreamBuilder(
                            stream: bloc.documentBloc.getDocumentSubMenuTransformer,
                            initialData: -1,
                            builder: (BuildContext context, AsyncSnapshot snapshotDocumentSubMenu) {
                              return InkWell(
                                  onTap: () {
                                    if (snapshotDocument.hasData) {
                                      bloc.documentBloc.changeDocumentMenuDrawer(!snapshotDocument.data);
                                    }
                                  },
                                  child: Container(
                                      height: 60,
                                      color: snapshotDocumentSubMenu.data == 0 ||
                                              snapshotDocumentSubMenu.data == 1 ||
                                              snapshotDocumentSubMenu.data == 2
                                          ? myColor.drawselectcolor
                                          : myColor.white,
                                      padding: EdgeInsets.only(left: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 35,
                                            child: Image.asset(
                                              "assets/images/ic_nav_documents.png",
                                              width: 20,
                                              height: 20,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      GlobleString.NAV_Documents,
                                                      style: snapshotDocument.data == true
                                                          ? MyStyles.SemiBold(16, myColor.Circle_main)
                                                          : MyStyles.Regular(16, myColor.Circle_main),
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Icon(
                                                        snapshotDocument.data == true
                                                            ? Icons.keyboard_arrow_up
                                                            : Icons.keyboard_arrow_down_sharp,
                                                        size: 25,
                                                      ))
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      )));
                            });
                      }),
                  //SubItem Documents
                  StreamBuilder(
                    stream: bloc.documentBloc.getDocumentMenuTransformer,
                    initialData: false,
                    builder: (BuildContext context, AsyncSnapshot snapshotDocument) {
                      return snapshotDocument.data == true
                          ? StreamBuilder(
                              stream: bloc.documentBloc.getDocumentSubMenuTransformer,
                              initialData: -1,
                              builder: (BuildContext context, AsyncSnapshot snapshotDocumentSubMenu) {
                                return Container(
                                  height: 100,
                                  color: snapshotDocumentSubMenu.data == 0 ||
                                          snapshotDocumentSubMenu.data == 1 ||
                                          snapshotDocumentSubMenu.data == 2
                                      ? myColor.drawselectcolor2
                                      : myColor.white,
                                  padding: EdgeInsets.only(left: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 40),
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 10.0),
                                              InkWell(
                                                onTap: () {
                                                  _store.dispatch(UpdatePropertyStatus_UnitsHeld(-1));
                                                  _store.dispatch(UpdatePropertyStatus_UnitsRented(-1));
                                                  _store.dispatch(UpdatePropertyStatus_VacantUnits(-1));
                                                  _store.dispatch(UpdateMantenaceExpand(false));
                                                  _store.dispatch(UpdateSchedulingExpand(false));

                                                  _store.dispatch(UpdatePortalPage(1, GlobleString.Title_documents));
                                                  bloc.documentBloc.changeDocumentSubMenuDrawer(0);
                                                },
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        GlobleString.NAV_Files_string,
                                                        style: snapshotDocumentSubMenu.data == 0
                                                            ? MyStyles.SemiBold(14, myColor.Circle_main)
                                                            : MyStyles.Regular(14, myColor.Circle_main),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),
                                              InkWell(
                                                onTap: () {
                                                  _store.dispatch(UpdateSchedulingExpand(false));
                                                  bloc.documentBloc.changeDocumentSubMenuDrawer(1);
                                                },
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        GlobleString.NAV_Document_builder,
                                                        style: snapshotDocumentSubMenu.data == 1
                                                            ? MyStyles.SemiBold(14, myColor.Circle_main)
                                                            : MyStyles.Regular(14, myColor.Circle_main),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),
                                              InkWell(
                                                onTap: () {
                                                  bloc.documentBloc.changeDocumentSubMenuDrawer(2);
                                                },
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        GlobleString.NAV_Document_templates,
                                                        style: snapshotDocumentSubMenu.data == 2
                                                            ? MyStyles.SemiBold(14, myColor.Circle_main)
                                                            : MyStyles.Regular(14, myColor.Circle_main),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })
                          : Container();
                    },
                  ),
                  InkWell(
                    onTap: () {
                      bloc.documentBloc.changeDocumentMenuDrawer(false);
                      bloc.documentBloc.changeDocumentSubMenuDrawer(-1);
                      _store.dispatch(UpdateSchedulingExpand(!portalState.isSchedulingExpand));
                    },
                    child: Container(
                      height: 60,
                      color: portalState.index == 8 ? myColor.drawselectcolor : myColor.white,
                      padding: EdgeInsets.only(left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 35,
                            child: Image.asset(
                              "assets/images/ic_nav_scheduling.png",
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      GlobleString.NAV_Scheduling,
                                      style: portalState.index == 8
                                          ? MyStyles.SemiBold(16, myColor.Circle_main)
                                          : MyStyles.Regular(16, myColor.Circle_main),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      portalState.isSchedulingExpand ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down_sharp,
                                      size: 25,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  portalState.isSchedulingExpand == true
                      ? Container(
                          height: 100,
                          color: portalState.index == 8 ? myColor.drawselectcolor2 : myColor.white,
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 40),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10.0),
                                      InkWell(
                                        onTap: () {
                                          _store.dispatch(UpdateMantenaceExpand(false));
                                          _store.dispatch(UpdateSchedulingCalendar());
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                GlobleString.NAV_Scheduling_calendar,
                                                style: portalState.index == 8 && portalState.subindex == 1
                                                    ? MyStyles.SemiBold(14, myColor.Circle_main)
                                                    : MyStyles.Regular(14, myColor.Circle_main),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      InkWell(
                                        onTap: () {
                                          _store.dispatch(UpdateMantenaceExpand(false));
                                          _store.dispatch(UpdateSchedulingEventTypes());
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                GlobleString.NAV_Scheduling_event_types,
                                                style: portalState.index == 8 && portalState.subindex == 2
                                                    ? MyStyles.SemiBold(14, myColor.Circle_main)
                                                    : MyStyles.Regular(14, myColor.Circle_main),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      InkWell(
                                        onTap: () {
                                          _store.dispatch(UpdateMantenaceExpand(false));
                                          _store.dispatch(UpdateSchedulingEventTypeTemplates());
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                GlobleString.NAV_Scheduling_event_type_templates,
                                                style: portalState.index == 8 && portalState.subindex == 3
                                                    ? MyStyles.SemiBold(14, myColor.Circle_main)
                                                    : MyStyles.Regular(14, myColor.Circle_main),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),

                  /*InkWell(
                    onTap: () {
                      _store.dispatch(UpdatePortalPage(7, GlobleString.NAV_Tasks));
                    },
                    child: Container(
                      height: 60,
                      color: portalState.index == 7
                          ? myColor.drawselectcolor
                          : myColor.white,
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 35,
                            child: Image.asset(
                              "assets/images/ic_nav_tasks.png",
                              width: 26,
                              height: 25,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                GlobleString.NAV_Tasks,
                                style: portalState.index == 7
                                    ? MyStyles.SemiBold(16, myColor.Circle_main)
                                    : MyStyles.Regular(16, myColor.Circle_main),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Container(
            width: drawer_width,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Powered by Silver Homes',
                style: MyStyles.Regular(12, Colors.black12),
              ),
            ]),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  tenantView() {
    _store.dispatch(UpdateLandlordApplication_Lead_Count(0));
    _store.dispatch(UpdateLandlordApplications_count(0));
    _store.dispatch(UpdateLandlordApplication_verification_documents_count(0));
    _store.dispatch(UpdateLandlordApplication_references_check_count(0));
    _store.dispatch(UpdateLandlordApplication_leases_count(0));
    _store.dispatch(UpdateLandlordApplication_Active_Tenants_Count(0));

    List<PropertyData> propertylist = <PropertyData>[];

    _store.dispatch(UpdateLLTALeadPropertyList(propertylist));
    _store.dispatch(UpdateLLTAApplicantPropertyList(propertylist));
    _store.dispatch(UpdateLLVDapplicationPropertyList(propertylist));
    _store.dispatch(UpdateLLRCPropertyList(propertylist));
    _store.dispatch(UpdateLLTLleasePropertyList(propertylist));
    _store.dispatch(UpdateArchivePropertyList(propertylist));
    _store.dispatch(UpdateLLActiveTenantPropertyList(propertylist));

    _store.dispatch(UpdateLLTALeadToggle(0));
    _store.dispatch(UpdateLandlordApplicationTab(1));
    _store.dispatch(UpdateTenantTabIndex(1));

    _store.dispatch(UpdateLLTALeadPropertyItem(null));
    _store.dispatch(UpdateLLTAApplicantPropertyItem(null));
    _store.dispatch(UpdateLLVDapplicationPropertyItem(null));
    _store.dispatch(UpdateLLRCPropertyItem(null));
    _store.dispatch(UpdateLLTLleasePropertyItem(null));
    _store.dispatch(UpdateArchivePropertyItem(null));
    _store.dispatch(UpdateLLActiveTenantPropertyItem(null));
    _store.dispatch(UpdateMantenaceExpand(false));
    _store.dispatch(UpdateSchedulingExpand(false));
    _store.dispatch(UpdatePortalPage(4, GlobleString.NAV_Tenants));
  }

  Widget ContentCenterView(BuildContext context, double val, PortalState portalState, Bloc bloc) {
    return Container(
      width: MediaQuery.of(context).size.width - val,
      height: height,
      child: Column(
        children: [
          Header(context, portalState, bloc),
          Container(
            height: 1,
            color: myColor.TA_Border,
          ),
          portalState.isLoading
              ? Container(
                  width: MediaQuery.of(context).size.width - drawer_width,
                  height: MediaQuery.of(context).size.height - header_height,
                  child: Center(
                    child: Text('Please wait...'),
                  ),
                )
              : StreamBuilder(
                  stream: bloc.documentBloc.getDocumentSubMenuTransformer,
                  initialData: -1,
                  builder: (BuildContext context, AsyncSnapshot snapshotSubMenu) {
                    if (!snapshotSubMenu.hasData || snapshotSubMenu.data == -1) {
                      return CenterView(context, portalState.index, portalState);
                    } else if (snapshotSubMenu.data == 0) {
                      return FileDocuments();
                    } else if (snapshotSubMenu.data == 1) {
                      return Container(child: Text("Nueva pantalla 1 "));
                    } else if (snapshotSubMenu.data == 3) {
                      return ChatPage();
                    } else {
                      return CenterView(context, portalState.index, portalState);
                    }
                  },
                ),
        ],
      ),
    );
  }

  Widget Header(BuildContext context, PortalState portalState, Bloc bloc) {
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
                  margin: EdgeInsets.only(top: 15, bottom: 15, left: 30, right: 20),
                ),
                Container(
                    child: Text(
                  portalState.title,
                  style: MyStyles.Medium(25, myColor.text_color),
                ) /* StreamBuilder(
                        stream: bloc.documentBloc.getDocumentSubMenuTransformer,
                        initialData: -1,
                        builder: (BuildContext context,
                            AsyncSnapshot snapshotSubMenu) {
                          if (!snapshotSubMenu.hasData ||
                              snapshotSubMenu.data == -1) {
                            return Text(
                              portalState.title,
                              style: MyStyles.Medium(25, myColor.text_color),
                            );
                          } else {
                            return Text(GlobleString.Title_documents,
                                style: MyStyles.Medium(25, myColor.text_color));
                          }
                        }) */
                    )
              ],
            ),
          ),
          Row(
            children: [
              /*     InkWell(
                  onTap: () async {
                    _store.dispatch(UpdatePortalPageisLoading(true));
                    bloc.documentBloc.changeDocumentSubMenuDrawer(-1);
                    _store.dispatch(UpdatePropertyStatus_UnitsHeld(0));
                    _store.dispatch(UpdatePropertyStatus_UnitsRented(0));
                    _store.dispatch(UpdatePropertyStatus_VacantUnits(0));
                    _store.dispatch(UpdateLandlordApplication_Lead_Count(0));
                    _store.dispatch(UpdateLandlordApplications_count(0));
                    _store.dispatch(
                        UpdateLandlordApplication_references_check_count(0));
                    _store.dispatch(UpdateLandlordApplication_leases_count(0));
                    _store.dispatch(
                        UpdateLandlordApplication_Active_Tenants_Count(0));
                    bloc.documentBloc.changeDocumentSubMenuDrawer(3);
                    _store.dispatch(UpdatePortalPageisLoading(false));
                  },
                  child: Icon(
                    FontAwesomeIcons.envelope,
                    size: 37,
                  )), */
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () async {
                  apimanager();

                  _store.dispatch(UpdatePortalPageisLoading(true));

                  if (portalState.index == 1) {
                    _store.dispatch(UpdatePropertyStatus_UnitsHeld(0));
                    _store.dispatch(UpdatePropertyStatus_UnitsRented(0));
                    _store.dispatch(UpdatePropertyStatus_VacantUnits(0));

                    _store.dispatch(UpdatePortalPage(1, GlobleString.NAV_Properties));
                  } else if (portalState.index == 4) {
                    _store.dispatch(UpdateLandlordApplication_Lead_Count(0));
                    _store.dispatch(UpdateLandlordApplications_count(0));
                    _store.dispatch(UpdateLandlordApplication_verification_documents_count(0));
                    _store.dispatch(UpdateLandlordApplication_references_check_count(0));
                    _store.dispatch(UpdateLandlordApplication_leases_count(0));
                    _store.dispatch(UpdateLandlordApplication_Active_Tenants_Count(0));

                    _store.dispatch(UpdatePortalPage(4, GlobleString.NAV_Tenants));
                  } else if (portalState.index == 5) {
                    if (portalState.subindex == 1) {
                      _store.dispatch(UpdateMantenaceRequest());
                    } else {
                      _store.dispatch(UpdateMantenaceVendor());
                    }
                  }

                  new Timer(Duration(milliseconds: 3), () {
                    _store.dispatch(UpdatePortalPageisLoading(false));
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
                onTap: () {
                  OverlayEntry loader = Helper.overlayLoader(context);
                  Overlay.of(context)!.insert(loader);

                  ApiManager().getNotificationList(context, Prefs.getString(PrefsName.OwnerID), 1, (status, notificationlist, message) {
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
                        padding: EdgeInsets.only(left: 3, right: 3, top: 1, bottom: 1),
                        decoration: BoxDecoration(
                          border: Border.all(color: myColor.noti_count_border, width: 0.5),
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

  Widget CenterView(BuildContext context, int index, PortalState portalState) {
    switch (index) {
      case 0:
        {
          // DashboardScreen;
          return Container(
            width: MediaQuery.of(context).size.width - drawer_width,
            height: MediaQuery.of(context).size.height - header_height,
            child: Center(
              child: Text('Dashboard: Under Construction!!'),
            ),
          );
        }
      case 1:
        {
          // property
          //subindex 0 = property listing table screen
          //subindex 1 = Details
          //subindex 2 = Add / Edit Screeen

          if (portalState.subindex == 1 && portalState.index == 1) {
            return AddEditProperty();
          } else if (portalState.subindex == 2 && portalState.index == 1) {
            return PropertyScreenNew();
          }

          return PropertyScreenNew();
        }
      case 2:
        {
          // Finances
          return Container(
            width: MediaQuery.of(context).size.width - drawer_width,
            height: MediaQuery.of(context).size.height - header_height,
            child: Center(
              child: Text('Finances: Under Construction!!'),
            ),
          );
        }
      case 3:
        {
          // Document
          return Container(
            width: MediaQuery.of(context).size.width - drawer_width,
            height: MediaQuery.of(context).size.height - header_height,
            child: Center(
              child: Text('Document: Under Construction!!'),
            ),
          );
        }
      case 4:
        {
          // Tenancy Screening
          if (portalState.subindex == 1 && portalState.index == 4) {
            return TenancyApplicationScreen(
              listdata1: portalState.listdataviewlist,
              index: 0,
            );
          }
          return LandlordApplicationScreen();
        }
      case 5:
        {
          // maintenance
          //subindex 1 = Request
          //subindex 2 = Vendor

          if (portalState.subindex == 1 && portalState.index == 5) {
            return MaintenanceRequestsScreen();
          } else if (portalState.subindex == 2 && portalState.index == 5) {
            return MaintenanceVendorsScreen();
          }

          return MaintenanceRequestsScreen();
        }
      case 6:
        {
          // Tasks
          return Container(
            width: MediaQuery.of(context).size.width - drawer_width,
            height: MediaQuery.of(context).size.height - header_height,
            child: Center(
              child: Text('Tasks: Under Construction!!'),
            ),
          );
        }
      case 7:
        {
          // profile
          return LandlordProfileScreen();
        }
      case 8:
        {
          // Scheduling
          //subindex 1 = Calendar
          //subindex 2 = Event Types
          //subindex 21 = New Event Types
          //subindex 3 = Event Type Templates

          if (portalState.subindex == 1 && portalState.index == 8) {
            return SchedulingCalendarScreen();
          } else if (portalState.subindex == 2 && portalState.index == 8) {
            return EventTypesScreen();
          } else if (portalState.subindex == 21 && portalState.index == 8) {
            return AddEditEventTypes();
          } else if (portalState.subindex == 3 && portalState.index == 8) {
            return EventTypeTemplateScreen();
          } else if (portalState.subindex == 31 && portalState.index == 8) {
            return AddEditEventTypesTemplates();
          }
          return SchedulingCalendarScreen();
        }
      default:
        {
          //return DashboardScreen();
          return Container(
            width: MediaQuery.of(context).size.width - drawer_width,
            height: MediaQuery.of(context).size.height - header_height,
            child: Center(
              child: Text('Dashboard:  Under Construction!!'),
            ),
          );
        }
    }
  }

  void showDialogNotification(List<NotificationData> notificationlist, PortalState portalState) {
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
                              height: notificationState!.IsLoadmore ? (mheight - 51) : (mheight - 10),
                              width: 250,
                              child: ListView.builder(
                                key: UniqueKey(),
                                itemCount: notificationState.notificationlist.length,
                                itemBuilder: (BuildContext context, int index) {
                                  NotificationData notification = notificationState.notificationlist[index];

                                  if (notification.typeOfNotification !=
                                      NotificationType().getNotificationType(NotificationName.Tenant_Maintenance_Requests))
                                    return NotificationItem(
                                      itemdata: notification,
                                      onPressNotification: (notification1) {
                                        Navigator.of(context).pop();
                                        isNotifiDialogshow = false;

                                        _tapNotificationItem(notification1, portalState);
                                      },
                                    );
                                  else
                                    return Container();
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
                                    style: MyStyles.Medium(15, myColor.text_color),
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

  void MenuPopup(PortalState portalState) {
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
                              ApiManager().getUserProfile(context);
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
                                    style: MyStyles.Medium(16, myColor.text_color),
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
                                    style: MyStyles.Medium(16, myColor.text_color),
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

  void _tapNotificationItem(NotificationData notification, PortalState portalState) {
    if (notification.typeOfNotification == NotificationType().getNotificationType(NotificationName.Application_Received)) {
      openTenancyApplicationDetails(notification);
    } else if (notification.typeOfNotification == NotificationType().getNotificationType(NotificationName.Documents_Received)) {
      _dailogPreviewDoc(notification, portalState);
    } else if (notification.typeOfNotification == NotificationType().getNotificationType(NotificationName.Reference_Received)) {
      CustomeWidget.ReferencePreview(context, notification.applicationId.toString());
    } else if (notification.typeOfNotification == NotificationType().getNotificationType(NotificationName.Lease_Received)) {
      _dailogPreviewLease(notification, portalState);
    } else if (notification.typeOfNotification == NotificationType().getNotificationType(NotificationName.Owner_Maintenance_Requests)) {
      _dailogMaintenance(notification);
    } else if (notification.typeOfNotification ==
        NotificationType().getNotificationType(NotificationName.Owner_Maintenance_Change_Status)) {
      _dailogMaintenance(notification);
    } else if (notification.typeOfNotification ==
        NotificationType().getNotificationType(NotificationName.Owner_Maintenance_Change_Priority)) {
      _dailogMaintenance(notification);
    }

    _updateReadNotification(notification, portalState);
  }

  _dailogMaintenance(NotificationData notification) {
    CheckMaintenanceExitOrNotOwner_ID checkMaintenanceExitOrNot = new CheckMaintenanceExitOrNotOwner_ID();
    checkMaintenanceExitOrNot.ID = notification.MaintenanceID.toString();
    checkMaintenanceExitOrNot.Owner_ID = Prefs.getString(PrefsName.OwnerID);

    ApiManager().checkMaintenanceExit(context, checkMaintenanceExitOrNot, (status, responce) {
      if (status) {
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

  void _updateReadNotification(NotificationData notification, PortalState portalState) {
    CommonID commonID = new CommonID();
    commonID.ID = notification.id.toString();

    NotificationIsRead notificationIsRead = new NotificationIsRead();
    notificationIsRead.IsRead = "1";

    ApiManager().UpdateNotificationRead(context, commonID, notificationIsRead, (status, responce) {
      if (status) {
        _store.dispatch(UpdateNotificationCount(portalState.notificationCount - 1));
      } else {
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
  }

  void _taptoLoadMoreData(NotificationState notificationState) {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);
    ApiManager().getNotificationList(context, Prefs.getString(PrefsName.OwnerID), (notificationState.PageNo + 1),
        (status, notificationlist, message) {
      if (status) {
        loader.remove();

        if (notificationlist.length >= 10) {
          _store.dispatch(UpdateNotificationisIsLoadmore(true));
        } else {
          _store.dispatch(UpdateNotificationisIsLoadmore(false));
        }
        _store.dispatch(UpdateNotificationPageNo((notificationState.PageNo + 1)));

        List<NotificationData> dalalist = notificationState.notificationlist;
        dalalist.addAll(notificationlist);
        _store.dispatch(UpdateNotificationList(dalalist));
      } else {
        loader.remove();
      }
    });
  }

  void openTenancyApplicationDetails(NotificationData notification) {
    List<TenancyApplication> listdataviewlist = <TenancyApplication>[];

    TenancyApplication tenancyApplication = new TenancyApplication();
    tenancyApplication.id = notification.applicationId;
    tenancyApplication.applicantId = notification.applicantId;
    tenancyApplication.applicantName = notification.applicantName;

    listdataviewlist.add(tenancyApplication);

    _store.dispatch(UpdateTenancyDetails(listdataviewlist));
  }

  void _dailogPreviewDoc(NotificationData notification, PortalState portalState) {
    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PreviewDocumentsDialogBox(
          onPressedYes: () async {
            Navigator.of(context).pop();

            if (portalState.index == 4) {
              _store.dispatch(UpdateLLTALeadToggle(0));
              _store.dispatch(UpdateLLVDToggle(0));
              _store.dispatch(UpdateLLRCToggle(0));
              _store.dispatch(UpdateLLTLToggle(0));
              _store.dispatch(UpdateArchiveToggle(0));
              _store.dispatch(UpdateLLTAApplicantToggle(0));
              _store.dispatch(UpdateLLActiveTenantToggle(0));

              if (portalState.tenantTabIndex == 1) {
                leadcallApi();
              } else if (portalState.tenantTabIndex == 2) {
                applicantcallApi();
              } else if (portalState.tenantTabIndex == 3) {
                varificationDocCallApi();
              } else if (portalState.tenantTabIndex == 4) {
                referencecallApi();
              } else if (portalState.tenantTabIndex == 5) {
                leasecallApi();
              } else if (portalState.tenantTabIndex == 6) {
                activetenantcallApi();
              }
            }
          },
          onPressedNo: () {
            Navigator.of(context).pop();
          },
          Applicantid: notification.applicantId.toString(),
          ApplicantionId: notification.applicationId.toString(),
        );
      },
    );
  }

  leadcallApi() async {
    await Prefs.setBool(PrefsName.IsApplyFilterList, false);

    _store.dispatch(UpdateLLTALeadleadList(<TenancyApplication>[]));
    _store.dispatch(UpdateLLTLeadFilterleadList(<TenancyApplication>[]));

    FilterReqtokens reqtokens = new FilterReqtokens();
    reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    reqtokens.IsArchived = "0";
    reqtokens.ApplicationStatus = "1";

    FilterData filterData = new FilterData();
    filterData.DSQID = Weburl.DSQ_CommonView;
    filterData.LoadLookupValues = true;
    filterData.LoadRecordInfo = true;
    filterData.Reqtokens = reqtokens;

    String filterjson = jsonEncode(filterData);

    _store.dispatch(UpdateLLTALeadisloding(true));
    await ApiManager().getCommonLeadList(context, filterjson);
  }

  applicantcallApi() async {
    await Prefs.setBool(PrefsName.IsApplyFilterList, false);

    _store.dispatch(UpdateLLTAApplicantleadList(<TenancyApplication>[]));
    _store.dispatch(UpdateLLTAFilterApplicantleadList(<TenancyApplication>[]));

    FilterReqtokens reqtokens = new FilterReqtokens();
    reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    reqtokens.IsArchived = "0";
    reqtokens.ApplicationStatus = "2";

    FilterData filterData = new FilterData();
    filterData.DSQID = Weburl.DSQ_CommonView;
    filterData.LoadLookupValues = true;
    filterData.LoadRecordInfo = true;
    filterData.Reqtokens = reqtokens;

    String filterjson = jsonEncode(filterData);

    _store.dispatch(UpdateLLTAApplicantisloding(true));
    await ApiManager().getCommonApplicantList(context, filterjson);
  }

  varificationDocCallApi() async {
    await Prefs.setBool(PrefsName.IsApplyFilterList, false);

    _store.dispatch(UpdateLLVDvarificationdoclist(<TenancyApplication>[]));
    _store.dispatch(UpdateLLVDfiltervarificationdoclist(<TenancyApplication>[]));

    FilterReqtokens reqtokens = new FilterReqtokens();
    reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    reqtokens.IsArchived = "0";
    reqtokens.ApplicationStatus = "3";

    FilterData filterData = new FilterData();
    filterData.DSQID = Weburl.DSQ_CommonView;
    filterData.LoadLookupValues = true;
    filterData.LoadRecordInfo = true;
    filterData.Reqtokens = reqtokens;

    String filterjson = jsonEncode(filterData);
    _store.dispatch(UpdateLLVDapplicationisloding(true));
    await ApiManager().getVarificationDocumentList(context, filterjson);
  }

  referencecallApi() async {
    await Prefs.setBool(PrefsName.IsApplyFilterList, false);

    _store.dispatch(UpdateLLRCReferenceCheckslist(<TenancyApplication>[]));
    _store.dispatch(UpdateLLRCfilterReferenceCheckslist(<TenancyApplication>[]));

    FilterReqtokens reqtokens = new FilterReqtokens();
    reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    reqtokens.IsArchived = "0";
    reqtokens.ApplicationStatus = "4";

    FilterData filterData = new FilterData();
    filterData.DSQID = Weburl.DSQ_CommonView;
    filterData.LoadLookupValues = true;
    filterData.LoadRecordInfo = true;
    filterData.Reqtokens = reqtokens;

    String filterjson = jsonEncode(filterData);
    _store.dispatch(UpdateLLRCisloding(true));
    await ApiManager().getApplicantReferenceCheckList(context, filterjson);
  }

  leasecallApi() async {
    await Prefs.setBool(PrefsName.IsApplyFilterList, false);
    _store.dispatch(UpdateLLTLleaseisloding(true));
    _store.dispatch(UpdateLLTLleaseleadlist(<TenancyApplication>[]));
    _store.dispatch(UpdateLLTLfilterleaseleadlist(<TenancyApplication>[]));

    FilterReqtokens reqtokens = new FilterReqtokens();
    reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    reqtokens.IsArchived = "0";
    reqtokens.ApplicationStatus = "5";

    FilterData filterData = new FilterData();
    filterData.DSQID = Weburl.DSQ_CommonView;
    filterData.LoadLookupValues = true;
    filterData.LoadRecordInfo = true;
    filterData.Reqtokens = reqtokens;

    String filterjson = jsonEncode(filterData);

    await ApiManager().getLeaseLeadList(context, filterjson);
  }

  activetenantcallApi() async {
    await Prefs.setBool(PrefsName.IsApplyFilterList, false);
    _store.dispatch(UpdateLLTLleaseisloding(true));
    _store.dispatch(UpdateLLTLleaseleadlist(<TenancyApplication>[]));
    _store.dispatch(UpdateLLTLfilterleaseleadlist(<TenancyApplication>[]));

    FilterReqtokens reqtokens = new FilterReqtokens();
    reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    reqtokens.IsArchived = "0";
    reqtokens.ApplicationStatus = "6";

    FilterData filterData = new FilterData();
    filterData.DSQID = Weburl.DSQ_CommonView;
    filterData.LoadLookupValues = true;
    filterData.LoadRecordInfo = true;
    filterData.Reqtokens = reqtokens;

    String filterjson = jsonEncode(filterData);

    await ApiManager().getActiveTenantLeadList(context, filterjson);
  }

  void _dailogPreviewLease(NotificationData notification, PortalState portalState) {
    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PreviewLeaseDialogBox(
          onPressedYes: () async {
            _dailogSetActiveTenant(notification, portalState);
          },
          onPressedNo: () {
            Navigator.of(context).pop();
          },
          Applicantid: notification.applicantId.toString(),
          ApplicantionId: notification.applicationId.toString(),
        );
      },
    );
  }

  _dailogSetActiveTenant(NotificationData notification, PortalState portalState) async {
    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialogBox(
          title: GlobleString.activeTenant_msg,
          positiveText: GlobleString.activeTenant_yes,
          negativeText: GlobleString.activeTenant_NO,
          onPressedYes: () async {
            Navigator.of(context1).pop();
            CommonID commonID = new CommonID();
            commonID.ID = notification.applicationId.toString();

            ApiManager().getPropertyIdForApplication(context, commonID, (status, responce) async {
              if (status) {
                await ApiManager().CheckTenantActiveOrNot(context, responce, notification.applicantId.toString(), (status, responce) async {
                  if (status) {
                    ApiManager().updateTenancyStatusCount(context);

                    if (portalState.index == 4) {
                      _store.dispatch(UpdateLLTALeadToggle(0));
                      _store.dispatch(UpdateLLVDToggle(0));
                      _store.dispatch(UpdateLLRCToggle(0));
                      _store.dispatch(UpdateLLTLToggle(0));
                      _store.dispatch(UpdateArchiveToggle(0));
                      _store.dispatch(UpdateLLTAApplicantToggle(0));
                      _store.dispatch(UpdateLLActiveTenantToggle(0));

                      if (portalState.tenantTabIndex == 1) {
                        leadcallApi();
                      } else if (portalState.tenantTabIndex == 2) {
                        applicantcallApi();
                      } else if (portalState.tenantTabIndex == 3) {
                        varificationDocCallApi();
                      } else if (portalState.tenantTabIndex == 4) {
                        referencecallApi();
                      } else if (portalState.tenantTabIndex == 5) {
                        leasecallApi();
                      } else if (portalState.tenantTabIndex == 6) {
                        activetenantcallApi();
                      }
                    }
                  } else {
                    if (responce == "1") {
                      ToastUtils.showCustomToast(context, GlobleString.already_active_tenant, false);
                    } else {
                      ToastUtils.showCustomToast(context, responce, false);
                    }
                  }
                });
              }
            });
          },
          onPressedNo: () {
            Navigator.of(context1).pop();
          },
        );
      },
    );
  }
}
