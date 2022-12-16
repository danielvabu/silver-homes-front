import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/funnelview_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/landlord_tenancy_activetenant_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/landlord_tenancy_applicant_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/landlord_tenancy_lead_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/landlord_tenancy_lease_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/landlordtenancyarchive_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/reference_check_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/varification_document_actions.dart';
import 'package:silverhome/domain/entities/filter_item.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/presentation/models/landlord_models/landlord_tenancy_applicant_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/landlord/filterview.dart';
import 'package:silverhome/widget/landlord/funnelview/funnelviewscreen.dart';
import 'package:silverhome/widget/landlord/lead_dialog/addnewlead_dialogbox.dart';
import 'package:silverhome/widget/landlord/propertydropdown.dart';
import 'package:silverhome/widget/landlord/tenancyapplicationtable/tenancy_application_header.dart';
import 'package:silverhome/widget/landlord/tenancyapplicationtable/tenancy_application_item.dart';
import 'package:silverhome/widget/search/searchboxview.dart';
import 'package:silverhome/widget/customer/toggle_switch.dart';

class LandlordTenancyApplicantScreen extends StatefulWidget {
  @override
  _LandlordTenancyApplicantScreenState createState() =>
      _LandlordTenancyApplicantScreenState();
}

class _LandlordTenancyApplicantScreenState
    extends State<LandlordTenancyApplicantScreen> {
  double height = 0, width = 0;

  late OverlayEntry overlayEntry;
  late OverlayEntry loader;

  final _store = getIt<AppStore>();

  @override
  void initState() {
    apimanager();
    super.initState();
  }

  void apimanager() async {
    await Prefs.init();

    if (Prefs.getBool(PrefsName.IsApplyFilterList))
      FilterApplyLeadCallApi();
    else
      ApplicantcallApi();
  }

  FilterApplyLeadCallApi() async {
    String json = await Prefs.getString(PrefsName.ApplyFilterJson);

    _store.dispatch(UpdateLLTAApplicantleadList(<TenancyApplication>[]));
    _store.dispatch(UpdateLLTAFilterApplicantleadList(<TenancyApplication>[]));

    var filter = jsonDecode(json);

    FilterData? filterData = FilterData.fromJson(filter);
    if (filterData.Reqtokens!.ApplicationStatus == null ||
        filterData.Reqtokens!.ApplicationStatus == "" ||
        filterData.Reqtokens!.ApplicationStatus!.contains("2")) {
      filterData.Reqtokens!.ApplicationStatus = "2";
      String filterjson = jsonEncode(filterData);
      _store.dispatch(UpdateLLTAApplicantisloding(true));
      await ApiManager().getCommonApplicantList(context, filterjson);
    }
  }

  ApplicantcallApi() async {
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

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: height - 150,
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: myColor.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: myColor.application_boreder, width: 1),
      ),
      child: ConnectState<LandLordTenancyApplicantState>(
          map: (state) => state.landLordTenancyApplicantState,
          where: notIdentical,
          builder: (LLTAApplicantState) {
            return Column(
              children: [
                Container(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          LLTAApplicantState!.selecttoggle == 0
                              ? SearchBoxView(
                                  callbackOnChanetext: (String text) {
                                    if (text.isNotEmpty) {
                                      List<TenancyApplication>
                                          filtereleadlitemsnew = List.empty();

                                      filtereleadlitemsnew = LLTAApplicantState
                                          .applicationlead
                                          .where((u) => (u.propertyName!
                                                  .toLowerCase()
                                                  .contains(
                                                      text.toLowerCase()) ||
                                              u.applicantName!
                                                  .toLowerCase()
                                                  .contains(
                                                      text.toLowerCase())))
                                          .toList();

                                      _store.dispatch(
                                          UpdateLLTAFilterApplicantleadList(
                                              filtereleadlitemsnew));
                                    } else {
                                      _store.dispatch(
                                          UpdateLLTAFilterApplicantleadList(
                                              LLTAApplicantState
                                                  .applicationlead));
                                    }

                                    RefreshstartTime();
                                  },
                                )
                              : PropertyDropdown(
                                  propertylist: LLTAApplicantState.propertylist,
                                  onSelectVal: (item) async {
                                    _store.dispatch(
                                        UpdateLLTAApplicantPropertyItem(item));
                                    _store.dispatch(
                                        UpdateLLVDapplicationPropertyItem(
                                            item));
                                    _store
                                        .dispatch(UpdateLLRCPropertyItem(item));
                                    _store.dispatch(
                                        UpdateLLTLleasePropertyItem(item));
                                    _store.dispatch(
                                        UpdateArchivePropertyItem(item));
                                    _store.dispatch(
                                        UpdateLLTALeadPropertyItem(item));
                                    _store.dispatch(
                                        UpdateLLActiveTenantPropertyItem(item));

                                    await finnleviewcallapi(
                                        item!.ID.toString());
                                  },
                                  propertyValue:
                                      LLTAApplicantState.propertyValue,
                                ),
                          SizedBox(
                            width: 10,
                          ),
                          _addNewLead(LLTAApplicantState),
                        ],
                      ),
                      Row(
                        children: [
                          if (Prefs.getBool(PrefsName.IsApplyFilterList) ||
                              Prefs.getBool(PrefsName.IsApplyFilterFunnel))
                            InkWell(
                              onTap: () {
                                ClearFilter(LLTAApplicantState);
                              },
                              child: Container(
                                height: 35,
                                padding: EdgeInsets.only(left: 25, right: 25),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(
                                      color: myColor.errorcolor, width: 1),
                                  color: myColor.white,
                                ),
                                child: Text(
                                  GlobleString.Filter_Clear,
                                  style:
                                      MyStyles.Medium(14, myColor.errorcolor),
                                ),
                              ),
                            ),
                          if (Prefs.getBool(PrefsName.IsApplyFilterList) ||
                              Prefs.getBool(PrefsName.IsApplyFilterFunnel))
                            SizedBox(
                              width: 30,
                            ),
                          _togglebutton(LLTAApplicantState),
                          SizedBox(
                            width: 10,
                          ),
                          _actionPopup(LLTAApplicantState)
                        ],
                      ),
                    ],
                  ),
                ),
                LLTAApplicantState.selecttoggle == 0
                    ? _tableview(LLTAApplicantState)
                    : _funnelview(LLTAApplicantState)
              ],
            );
          }),
    );
  }

  Widget _addNewLead(LandLordTenancyApplicantState LLTApplicationState) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.black45,
          useSafeArea: true,
          barrierDismissible: false,
          builder: (BuildContext context1) {
            return AddNewLeadDialogBox(
              onPressedSave: () async {
                Navigator.of(context1).pop();

                if (LLTApplicationState.selecttoggle == 0) {
                  _store.dispatch(UpdateLLTAApplicantisloding(true));
                  _store.dispatch(
                      UpdateLLTAApplicantleadList(<TenancyApplication>[]));
                  _store.dispatch(UpdateLLTAFilterApplicantleadList(
                      <TenancyApplication>[]));
                  await ApplicantcallApi();
                  _store.dispatch(UpdateLLTAApplicantisloding(false));
                } else {
                  if (LLTApplicationState.propertyValue != null) {
                    await finnleviewcallapi(
                        LLTApplicationState.propertyValue!.ID.toString());
                  }
                }
              },
              onPressedClose: () {
                Navigator.of(context1).pop();
              },
            );
          },
        );
      },
      child: CustomeWidget.AddNewLead(),
    );
  }

  Widget _togglebutton(LandLordTenancyApplicantState LLTApplicationState) {
    return Container(
      width: 203,
      decoration: BoxDecoration(
        border: Border.all(
          color: myColor.text_color,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ToggleSwitch(
        minWidth: 100.0,
        minHeight: 32.0,
        fontSize: 14.0,
        cornerRadius: 5,
        initialLabelIndex: LLTApplicationState.selecttoggle,
        activeBgColor: [myColor.text_color],
        activeFgColor: Colors.white,
        inactiveBgColor: Colors.white,
        inactiveFgColor: myColor.text_color,
        labels: [GlobleString.LL_ListView, GlobleString.LL_FunnelView],
        onToggle: (index) async {
          if (LLTApplicationState.selecttoggle != index) {
            if (index == 0) {
              await ApplicantcallApi();
            } else {
              if (LLTApplicationState.propertyValue != null) {
                await finnleviewcallapi(
                    LLTApplicationState.propertyValue!.ID.toString());
              }
            }

            await Prefs.setBool(PrefsName.IsApplyFilterFunnel, false);
            await Prefs.setBool(PrefsName.IsApplyFilterList, false);
            _store.dispatch(UpdateLLTAApplicantToggle(index));
          }
        },
        totalSwitches: 2,
      ),
    );
  }

  Widget _actionPopup(LandLordTenancyApplicantState LLTApplicationState) {
    return Container(
      height: 32,
      width: 30,
      child: PopupMenuButton(
        onSelected: (value) {
          if (value == 1) {
            if (LLTApplicationState.selecttoggle == 0) {
              _showFilterOverlayView(context, LLTApplicationState);
            } else {
              if (LLTApplicationState.propertyValue != null) {
                _showFilterOverlayView(context, LLTApplicationState);
              } else {
                ToastUtils.showCustomToast(
                    context, GlobleString.Blank_funnel, false);
              }
            }
          } else if (value == 2) {
            if (LLTApplicationState.selecttoggle == 0) {
              if (LLTApplicationState.filterapplicationlead != null &&
                  LLTApplicationState.filterapplicationlead.length > 0) {
                createTableDataCSVFile(LLTApplicationState);
              } else {
                ToastUtils.showCustomToast(
                    context, GlobleString.Blank_export, false);
              }
            } else {
              if (LLTApplicationState.propertyValue != null) {
                CustomeWidget.FunnelDataCSVFile(
                    context, LLTApplicationState.propertyValue!.ID.toString());
              } else {
                ToastUtils.showCustomToast(
                    context, GlobleString.Blank_funnel, false);
              }
            }
          } else if (value == 3) {
            if (LLTApplicationState.propertyValue != null) {
              loader = Helper.overlayLoader(context);
              Overlay.of(context)!.insert(loader);

              ApiManager().AllArchivePropertyWise(
                  context, LLTApplicationState.propertyValue!.ID.toString(),
                  (status, responce) async {
                if (status) {
                  await finnleviewcallapi(
                      LLTApplicationState.propertyValue!.ID.toString());
                  loader.remove();
                } else {
                  loader.remove();
                  ToastUtils.showCustomToast(
                      context, GlobleString.Error1, false);
                }
              });
            } else {
              ToastUtils.showCustomToast(
                  context, GlobleString.Blank_funnel, false);
            }
          }
        },
        child: Container(
          height: 40,
          width: 20,
          margin: EdgeInsets.only(right: 5),
          child: Icon(Icons.more_vert),
        ),
        itemBuilder: (context) {
          return LLTApplicationState.selecttoggle == 0
              ? [
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      GlobleString.Filter,
                      style: MyStyles.Medium(14, myColor.text_color),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text(
                      GlobleString.Export,
                      style: MyStyles.Medium(14, myColor.text_color),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ]
              : [
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      GlobleString.Filter,
                      style: MyStyles.Medium(14, myColor.text_color),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text(
                      GlobleString.Export,
                      style: MyStyles.Medium(14, myColor.text_color),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: Text(
                      GlobleString.AllArchive,
                      style: MyStyles.Medium(14, myColor.text_color),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ];
        },
      ),
    );
  }

  Widget _tableview(LandLordTenancyApplicantState LLTApplicationState) {
    return Container(
      width: width,
      height: height - 222,
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          //color: Hexcolor("#16C395"),
          border: Border.all(color: Colors.transparent, width: 1)),
      child: Column(
        children: [
          TenancyApplicationHeader(
            onPressedSortRating: () async {
              await updateOtherSortingValue(3);
              List<TenancyApplication> lalist =
                  LLTApplicationState.filterapplicationlead;
              if (!LLTApplicationState.isRatingSort) {
                lalist.sort((a, b) =>
                    b.rating.toString().compareTo(a.rating.toString()));
                _store.dispatch(UpdateLLTAApplicantisRatingSort(true));
              } else {
                lalist.sort((a, b) =>
                    a.rating.toString().compareTo(b.rating.toString()));
                _store.dispatch(UpdateLLTAApplicantisRatingSort(false));
              }
              _store.dispatch(UpdateLLTAFilterApplicantleadList(lalist));
            },
            onPressedSortName: () async {
              await updateOtherSortingValue(1);
              List<TenancyApplication> lalist =
                  LLTApplicationState.filterapplicationlead;
              if (!LLTApplicationState.isNameSort) {
                lalist.sort((a, b) => a.applicantName!
                    .toLowerCase()
                    .compareTo(b.applicantName!.toLowerCase()));
                _store.dispatch(UpdateLLTAApplicantisNameSort(true));
              } else {
                lalist.sort((a, b) => b.applicantName!
                    .toLowerCase()
                    .compareTo(a.applicantName!.toLowerCase()));
                _store.dispatch(UpdateLLTAApplicantisNameSort(false));
              }
              _store.dispatch(UpdateLLTAFilterApplicantleadList(lalist));
            },
            onPressedSortProperty: () async {
              await updateOtherSortingValue(2);
              List<TenancyApplication> lalist =
                  LLTApplicationState.filterapplicationlead;
              if (!LLTApplicationState.isPropertySort) {
                lalist.sort((a, b) => a.propertyName!
                    .toLowerCase()
                    .compareTo(b.propertyName!.toLowerCase()));
                _store.dispatch(UpdateLLTAApplicantisPropertySort(true));
              } else {
                lalist.sort((a, b) => b.propertyName!
                    .toLowerCase()
                    .compareTo(a.propertyName!.toLowerCase()));
                _store.dispatch(UpdateLLTAApplicantisPropertySort(false));
              }
              _store.dispatch(UpdateLLTAFilterApplicantleadList(lalist));
            },
            onPressedSortDateSent: () async {
              await updateOtherSortingValue(4);
              List<TenancyApplication> lalist =
                  LLTApplicationState.filterapplicationlead;
              if (!LLTApplicationState.isDateSentSort) {
                lalist.sort((a, b) => b.applicationSentDate!
                    .toLowerCase()
                    .compareTo(a.applicationSentDate!.toLowerCase()));
                _store.dispatch(UpdateLLTAApplicantisDateSentSort(true));
              } else {
                lalist.sort((a, b) => a.applicationSentDate!
                    .toLowerCase()
                    .compareTo(b.applicationSentDate!.toLowerCase()));
                _store.dispatch(UpdateLLTAApplicantisDateSentSort(false));
              }
              _store.dispatch(UpdateLLTAFilterApplicantleadList(lalist));
            },
            onPressedSortDateReceive: () async {
              await updateOtherSortingValue(5);
              List<TenancyApplication> lalist =
                  LLTApplicationState.filterapplicationlead;
              if (!LLTApplicationState.isDateReceiveSort) {
                lalist.sort((a, b) => b.applicationReceivedDate!
                    .toLowerCase()
                    .compareTo(a.applicationReceivedDate!.toLowerCase()));
                _store.dispatch(UpdateLLTAApplicantisDateReceiveSort(true));
              } else {
                lalist.sort((a, b) => a.applicationReceivedDate!
                    .toLowerCase()
                    .compareTo(b.applicationReceivedDate!.toLowerCase()));
                _store.dispatch(UpdateLLTAApplicantisDateReceiveSort(false));
              }
              _store.dispatch(UpdateLLTAFilterApplicantleadList(lalist));
            },
            onPressedSortAppStatus: () async {
              await updateOtherSortingValue(6);

              if (!LLTApplicationState.isAppStatusSort) {
                LLTApplicationState.filterapplicationlead.sort((a, b) => a
                    .applicationStatus!.EnumDetailID
                    .toString()
                    .compareTo(b.applicationStatus!.EnumDetailID.toString()));

                _store.dispatch(UpdateLLTAFilterApplicantleadList(
                    LLTApplicationState.filterapplicationlead));
                _store.dispatch(UpdateLLTAApplicantisAppStatusSort(true));
              } else {
                LLTApplicationState.filterapplicationlead.sort((a, b) => b
                    .applicationStatus!.EnumDetailID
                    .toString()
                    .compareTo(a.applicationStatus!.EnumDetailID.toString()));

                //lalist.reversed.toList();
                _store.dispatch(UpdateLLTAFilterApplicantleadList(
                    LLTApplicationState.filterapplicationlead));
                _store.dispatch(UpdateLLTAApplicantisAppStatusSort(false));
              }
            },
            onPressedAllCheckItem: (bool val) {
              List<TenancyApplication> leadlitemsnew =
                  LLTApplicationState.filterapplicationlead;

              for (int i = 0; i < leadlitemsnew.length; i++) {
                leadlitemsnew[i].ischeck = val;
              }

              _store.dispatch(UpdateLLTAApplicantisOneItemSelect(val));
              _store.dispatch(UpdateLLTAFilterApplicantleadList(leadlitemsnew));
            },
          ),
          _tableItem(LLTApplicationState),
        ],
      ),
    );
  }

  Widget _tableItem(LandLordTenancyApplicantState LLTApplicationState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LLTApplicationState.isloding
            ? Expanded(
                child: Container(
                  width: width,
                  height: height - 290,
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text(
                    "Please wait.....",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: MyStyles.Medium(18, myColor.Circle_main),
                  ),
                ),
              )
            : LLTApplicationState.filterapplicationlead != null &&
                    LLTApplicationState.filterapplicationlead.length > 0
                ? Expanded(
                    child: TenancyApplicationItem(
                      listdata1: LLTApplicationState.filterapplicationlead,
                      OnRefresh: () {},
                    ),
                  )
                : Container(
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.topCenter,
                    child: Text(
                      GlobleString.Blank_lead,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: MyStyles.Medium(14, myColor.tabel_msg),
                    ),
                  )
      ],
    );
  }

  Widget _funnelview(LandLordTenancyApplicantState LLTApplicationState) {
    return FunnelViewScreen(
      propertyValue: LLTApplicationState.propertyValue,
    );
  }

  ClearFilter(LandLordTenancyApplicantState LLTApplicationState) async {
    await Prefs.setBool(PrefsName.IsApplyFilterList, false);
    await Prefs.setBool(PrefsName.IsApplyFilterFunnel, false);

    if (LLTApplicationState.selecttoggle == 0) {
      ApplicantcallApi();
    } else {
      if (LLTApplicationState.propertyValue != null) {
        await finnleviewcallapi(
            LLTApplicationState.propertyValue!.ID.toString());
      }
    }

    _store
        .dispatch(UpdateLLTAApplicantToggle(LLTApplicationState.selecttoggle));
  }

  updateOtherSortingValue(int flag) {
    if (flag != 1) {
      _store.dispatch(UpdateLLTAApplicantisNameSort(false));
    }
    if (flag != 2) {
      _store.dispatch(UpdateLLTAApplicantisPropertySort(false));
    }
    if (flag != 3) {
      _store.dispatch(UpdateLLTAApplicantisRatingSort(false));
    }
    if (flag != 4) {
      _store.dispatch(UpdateLLTAApplicantisDateSentSort(false));
    }
    if (flag != 5) {
      _store.dispatch(UpdateLLTAApplicantisDateReceiveSort(false));
    }
    if (flag != 6) {
      _store.dispatch(UpdateLLTAApplicantisAppStatusSort(false));
    }

    RefreshstartTime();
  }

  RefreshstartTime() async {
    _store.dispatch(UpdateLLTAApplicantisloding(true));

    new Timer(Duration(milliseconds: 5), updateLoading);
  }

  updateLoading() {
    _store.dispatch(UpdateLLTAApplicantisloding(false));
  }

  _showFilterOverlayView(
      BuildContext context, LandLordTenancyApplicantState LLTApplicationState) {
    OverlayState overlayState = Overlay.of(context)!;
    overlayEntry = OverlayEntry(builder: (context) {
      return Container(
        color: myColor.Overviewcolor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: [
            new Expanded(
              child: Container(
                child: GestureDetector(
                  onTap: () {
                    overlayEntry.remove();
                  },
                ),
              ),
            ),
            Container(
              width: 400,
              child: FilterView(
                propertyValue: LLTApplicationState.propertyValue,
                isfunnelview: LLTApplicationState.selecttoggle == 1,
                onclose: () {
                  overlayEntry.remove();
                },
                onApply: (String json, bool isclear) async {
                  overlayEntry.remove();

                  if (LLTApplicationState.selecttoggle == 0) {
                    if (isclear) {
                      ApplicantcallApi();
                    } else {
                      FilterApplyLeadCallApi();
                    }
                  } else {
                    if (isclear) {
                      if (LLTApplicationState.propertyValue != null) {
                        await finnleviewcallapi(
                            LLTApplicationState.propertyValue!.ID.toString());
                      }
                    } else {
                      _store.dispatch(UpdateLLTAApplicantToggle(1));

                      _store.dispatch(
                          UpdateFunnelAllListData(<TenancyApplication>[]));

                      _store.dispatch(UpdateFunnelLeadCount(0));
                      _store.dispatch(
                          UpdateFunnelLeadList(<TenancyApplication>[]));

                      _store.dispatch(UpdateFunnelApplicantCount(0));
                      _store.dispatch(
                          UpdateFunnelApplicantList(<TenancyApplication>[]));

                      _store.dispatch(UpdateFunnelDocumentVarifyCount(0));
                      _store.dispatch(UpdateFunnelDocumentVarifyList(
                          <TenancyApplication>[]));

                      _store.dispatch(UpdateFunnelReferenceCheckCount(0));
                      _store.dispatch(
                          UpdateFunnelReferenceList(<TenancyApplication>[]));

                      _store.dispatch(UpdateFunnelLeaseCount(0));
                      _store.dispatch(
                          UpdateFunnelLeassentList(<TenancyApplication>[]));

                      _store.dispatch(UpdateFunnelActiveTenantCount(0));
                      _store.dispatch(
                          UpdateFunnelActiveTenantList(<TenancyApplication>[]));

                      await ApiManager().getPropertyWiseFunnel(context, json);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      );
    });
    overlayState.insert(overlayEntry);
  }

  createTableDataCSVFile(
      LandLordTenancyApplicantState LLTApplicationState) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String csv;
    List<List<dynamic>> csvList = [];

    List csvHeaderTitle = [];
    csvHeaderTitle.add("ID");
    csvHeaderTitle.add("Applicant Name");
    csvHeaderTitle.add("Property Name");
    csvHeaderTitle.add("Rating");
    csvHeaderTitle.add("Application Sent");
    csvHeaderTitle.add("Application Received");
    csvHeaderTitle.add("Application Status");

    csvList.add(csvHeaderTitle);

    for (var data in LLTApplicationState.filterapplicationlead.toSet()) {
      List row = [];
      row.add(data.id);
      row.add(data.applicantName);
      row.add(data.propertyName);
      row.add(data.rating.toString());
      row.add(data.applicationSentDate);
      row.add(data.applicationReceivedDate);
      row.add(data.applicationStatus != null
          ? data.applicationStatus!.displayValue.toString()
          : "");

      csvList.add(row);
    }

    csv = const ListToCsvConverter().convert(csvList);

    String filename = "LeadApplicant_" +
        DateFormat("ddMMyyyy_hhmmss").format(DateTime.now()).toString() +
        ".csv";

    // prepare
    final bytes = utf8.encode(csv);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = filename;

    html.document.body!.children.add(anchor);
    anchor.click();

    loader.remove();
  }

  finnleviewcallapi(String propertyid) async {
    await Prefs.setBool(PrefsName.IsApplyFilterFunnel, false);

    _store.dispatch(UpdateFunnelAllListData(<TenancyApplication>[]));

    _store.dispatch(UpdateFunnelLeadCount(0));
    _store.dispatch(UpdateFunnelLeadList(<TenancyApplication>[]));

    _store.dispatch(UpdateFunnelApplicantCount(0));
    _store.dispatch(UpdateFunnelApplicantList(<TenancyApplication>[]));

    _store.dispatch(UpdateFunnelDocumentVarifyCount(0));
    _store.dispatch(UpdateFunnelDocumentVarifyList(<TenancyApplication>[]));

    _store.dispatch(UpdateFunnelReferenceCheckCount(0));
    _store.dispatch(UpdateFunnelReferenceList(<TenancyApplication>[]));

    _store.dispatch(UpdateFunnelLeaseCount(0));
    _store.dispatch(UpdateFunnelLeassentList(<TenancyApplication>[]));

    _store.dispatch(UpdateFunnelActiveTenantCount(0));
    _store.dispatch(UpdateFunnelActiveTenantList(<TenancyApplication>[]));

    FilterReqtokens reqtokens = new FilterReqtokens();
    reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    reqtokens.IsArchived = "0";
    reqtokens.Prop_ID = propertyid;

    FilterData filterData = new FilterData();
    filterData.DSQID = Weburl.DSQ_CommonView;
    filterData.LoadLookupValues = true;
    filterData.LoadRecordInfo = true;
    filterData.Reqtokens = reqtokens;

    String filterjson = jsonEncode(filterData);

    await ApiManager().getPropertyWiseFunnel(context, filterjson);
  }
}
