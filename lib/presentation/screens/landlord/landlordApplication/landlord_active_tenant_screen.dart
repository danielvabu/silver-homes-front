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
import 'package:silverhome/domain/entities/active_lead.dart';
import 'package:silverhome/domain/entities/filter_item.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/presentation/models/landlord_models/landlord_tenancy_activetenant_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/landlord/activetenant_tabel/activetenant_header.dart';
import 'package:silverhome/widget/landlord/activetenant_tabel/activetenant_item.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/landlord/filterview.dart';
import 'package:silverhome/widget/landlord/funnelview/funnelviewscreen.dart';
import 'package:silverhome/widget/landlord/lead_dialog/addnewlead_dialogbox.dart';
import 'package:silverhome/widget/landlord/propertydropdown.dart';
import 'package:silverhome/widget/searchboxview.dart';
import 'package:silverhome/widget/toggle_switch.dart';

class LandlordActiveTenantScreen extends StatefulWidget {
  @override
  _LandlordActiveTenantScreenState createState() =>
      _LandlordActiveTenantScreenState();
}

class _LandlordActiveTenantScreenState
    extends State<LandlordActiveTenantScreen> {
  List<ActiveLead> leadlitems = [];
  double height = 0, width = 0;
  static TextEditingController textsearchvalue = TextEditingController();
  final _store = getIt<AppStore>();
  late OverlayEntry overlayEntry;
  late OverlayEntry loader;

  @override
  void initState() {
    apimanager();
    super.initState();
  }

  void apimanager() async {
    await Prefs.init();

    if (Prefs.getBool(PrefsName.IsApplyFilterList))
      filterApplyactivetenantCallApi();
    else
      activetenantcallApi();
  }

  activetenantcallApi() async {
    await Prefs.setBool(PrefsName.IsApplyFilterList, false);
    _store.dispatch(UpdateLLActiveTenantisloding(true));
    _store.dispatch(UpdateLLActiveTenantleadlist(<TenancyApplication>[]));
    _store.dispatch(UpdateLLActiveTenantfilterleadlist(<TenancyApplication>[]));

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

  filterApplyactivetenantCallApi() async {
    String json = await Prefs.getString(PrefsName.ApplyFilterJson);
    _store.dispatch(UpdateLLActiveTenantleadlist(<TenancyApplication>[]));
    _store.dispatch(UpdateLLActiveTenantfilterleadlist(<TenancyApplication>[]));

    var filter = jsonDecode(json);

    FilterData? filterData = FilterData.fromJson(filter);

    if (filterData.Reqtokens!.ApplicationStatus == null ||
        filterData.Reqtokens!.ApplicationStatus == "" ||
        filterData.Reqtokens!.ApplicationStatus!.contains("6")) {
      filterData.Reqtokens!.ApplicationStatus = "6";
      String filterjson = jsonEncode(filterData);
      _store.dispatch(UpdateLLActiveTenantisloding(true));
      await ApiManager().getActiveTenantLeadList(context, filterjson);
    }
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
      child: ConnectState<LandLordActiveTenantState>(
        map: (state) => state.landLordActiveTenantState,
        where: notIdentical,
        builder: (activeTenantState) {
          return Column(
            children: [
              Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        activeTenantState!.selecttoggle == 0
                            ? SearchBoxView(
                                callbackOnChanetext: (String text) {
                                  if (text.isNotEmpty) {
                                    List<TenancyApplication>
                                        filterleaseleadlist = List.empty();

                                    filterleaseleadlist = activeTenantState
                                        .activetenantleadlist
                                        .where((u) => (u.propertyName!
                                                .toLowerCase()
                                                .contains(text.toLowerCase()) ||
                                            u.applicantName!
                                                .toLowerCase()
                                                .contains(text.toLowerCase())))
                                        .toList();

                                    _store.dispatch(
                                        UpdateLLActiveTenantfilterleadlist(
                                            filterleaseleadlist));
                                  } else {
                                    _store.dispatch(
                                        UpdateLLActiveTenantfilterleadlist(
                                            activeTenantState
                                                .activetenantleadlist));
                                  }

                                  RefereshstartTime();
                                },
                              )
                            : PropertyDropdown(
                                onSelectVal: (item) async {
                                  _store.dispatch(
                                      UpdateLLActiveTenantPropertyItem(item));
                                  _store.dispatch(
                                      UpdateLLTLleasePropertyItem(item));
                                  _store.dispatch(
                                      UpdateArchivePropertyItem(item));
                                  _store.dispatch(
                                      UpdateLLTALeadPropertyItem(item));
                                  _store.dispatch(
                                      UpdateLLVDapplicationPropertyItem(item));
                                  _store.dispatch(UpdateLLRCPropertyItem(item));
                                  _store.dispatch(
                                      UpdateLLTAApplicantPropertyItem(item));

                                  await finnleviewcallapi(item!.ID.toString());
                                },
                                propertylist: activeTenantState.propertylist,
                                propertyValue: activeTenantState.propertyValue,
                              ),
                        SizedBox(
                          width: 10,
                        ),
                        _addNewLead(activeTenantState),
                      ],
                    ),
                    Row(
                      children: [
                        if (Prefs.getBool(PrefsName.IsApplyFilterList) ||
                            Prefs.getBool(PrefsName.IsApplyFilterFunnel))
                          InkWell(
                            onTap: () {
                              ClearFilter(activeTenantState);
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
                                style: MyStyles.Medium(14, myColor.errorcolor),
                              ),
                            ),
                          ),
                        if (Prefs.getBool(PrefsName.IsApplyFilterList) ||
                            Prefs.getBool(PrefsName.IsApplyFilterFunnel))
                          SizedBox(width: 30),
                        _togglebutton(activeTenantState),
                        SizedBox(width: 10),
                        _actionPopup(activeTenantState)
                      ],
                    ),
                  ],
                ),
              ),
              activeTenantState.selecttoggle == 0
                  ? _tableview(activeTenantState)
                  : _funnelview(activeTenantState)
            ],
          );
        },
      ),
    );
  }

  Widget _addNewLead(LandLordActiveTenantState activeTenantState) {
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

                if (activeTenantState.selecttoggle == 0) {
                  await activetenantcallApi();
                } else {
                  if (activeTenantState.propertyValue != null) {
                    await finnleviewcallapi(
                        activeTenantState.propertyValue!.ID.toString());
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

  Widget _togglebutton(LandLordActiveTenantState activeTenantState) {
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
        initialLabelIndex: activeTenantState.selecttoggle,
        activeBgColor: [myColor.text_color],
        activeFgColor: Colors.white,
        inactiveBgColor: Colors.white,
        inactiveFgColor: myColor.text_color,
        labels: [GlobleString.LL_ListView, GlobleString.LL_FunnelView],
        onToggle: (index) async {
          if (activeTenantState.selecttoggle != index) {
            if (index == 0) {
              activetenantcallApi();
            } else {
              if (activeTenantState.propertyValue != null) {
                await finnleviewcallapi(
                    activeTenantState.propertyValue!.ID.toString());
              }
            }
            await Prefs.setBool(PrefsName.IsApplyFilterFunnel, false);
            await Prefs.setBool(PrefsName.IsApplyFilterList, false);
            _store.dispatch(UpdateLLActiveTenantToggle(index));
          }
        },
        totalSwitches: 2,
      ),
    );
  }

  Widget _actionPopup(LandLordActiveTenantState activeTenantState) {
    return Container(
      height: 32,
      width: 30,
      child: PopupMenuButton(
        onSelected: (value) {
          if (value == 1) {
            if (activeTenantState.selecttoggle == 0) {
              _showFilterOverlayView(context, activeTenantState);
            } else {
              if (activeTenantState.propertyValue != null) {
                _showFilterOverlayView(context, activeTenantState);
              } else {
                ToastUtils.showCustomToast(
                    context, GlobleString.Blank_funnel, false);
              }
            }
          } else if (value == 2) {
            if (activeTenantState.selecttoggle == 0) {
              if (activeTenantState.filteractivetenantleadlist != null &&
                  activeTenantState.filteractivetenantleadlist.length > 0) {
                createTableDataCSVFile(activeTenantState);
              } else {
                ToastUtils.showCustomToast(
                    context, GlobleString.Blank_export, false);
              }
            } else {
              if (activeTenantState.propertyValue != null) {
                CustomeWidget.FunnelDataCSVFile(
                    context, activeTenantState.propertyValue!.ID.toString());
              } else {
                ToastUtils.showCustomToast(
                    context, GlobleString.Blank_funnel, false);
              }
            }
          } else if (value == 3) {
            if (activeTenantState.propertyValue != null) {
              loader = Helper.overlayLoader(context);
              Overlay.of(context)!.insert(loader);

              ApiManager().AllArchivePropertyWise(
                  context, activeTenantState.propertyValue!.ID.toString(),
                  (status, responce) async {
                if (status) {
                  await finnleviewcallapi(
                      activeTenantState.propertyValue!.ID.toString());
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
          return activeTenantState.selecttoggle == 0
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

  Widget _tableview(LandLordActiveTenantState activeTenantState) {
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
          ActiveTenantHeader(
            onPressedSortName: () async {
              await updateOtherSortingValue(1);
              List<TenancyApplication> lalist =
                  activeTenantState.filteractivetenantleadlist;
              if (!activeTenantState.isNameSort) {
                lalist.sort((a, b) => a.applicantName!
                    .toLowerCase()
                    .compareTo(b.applicantName!.toLowerCase()));
                _store.dispatch(UpdateLLActiveTenantisNameSort(true));
              } else {
                lalist.sort((a, b) => b.applicantName!
                    .toLowerCase()
                    .compareTo(a.applicantName!.toLowerCase()));
                _store.dispatch(UpdateLLActiveTenantisNameSort(false));
              }
              _store.dispatch(UpdateLLActiveTenantfilterleadlist(lalist));
            },
            onPressedSortProperty: () async {
              await updateOtherSortingValue(2);
              List<TenancyApplication> lalist =
                  activeTenantState.filteractivetenantleadlist;

              if (!activeTenantState.isPropertySort) {
                lalist.sort((a, b) => a.propertyName!
                    .toLowerCase()
                    .compareTo(b.propertyName!.toLowerCase()));
                _store.dispatch(UpdateLLActiveTenantisPropertySort(true));
              } else {
                lalist.sort((a, b) => b.propertyName!
                    .toLowerCase()
                    .compareTo(a.propertyName!.toLowerCase()));
                _store.dispatch(UpdateLLActiveTenantisPropertySort(false));
              }

              _store.dispatch(UpdateLLActiveTenantfilterleadlist(lalist));
            },
            onPressedSortRating: () async {
              await updateOtherSortingValue(3);
              List<TenancyApplication> lalist =
                  activeTenantState.filteractivetenantleadlist;
              if (!activeTenantState.isRatingSort) {
                lalist.sort((a, b) =>
                    b.rating.toString().compareTo(a.rating.toString()));
                _store.dispatch(UpdateLLActiveTenantisRatingSort(true));
              } else {
                lalist.sort((a, b) =>
                    a.rating.toString().compareTo(b.rating.toString()));
                _store.dispatch(UpdateLLActiveTenantisRatingSort(false));
              }
              _store.dispatch(UpdateLLActiveTenantfilterleadlist(lalist));
            },
            onPressedSortLeaseStartDate: () async {
              await updateOtherSortingValue(4);
              List<TenancyApplication> lalist =
                  activeTenantState.filteractivetenantleadlist;
              if (!activeTenantState.isLeasStartDateSort) {
                lalist.sort((a, b) => b.agreementSentDate!
                    .toLowerCase()
                    .compareTo(a.agreementSentDate!.toLowerCase()));
                _store.dispatch(UpdateLLActiveTenantisLeasStartDateSort(true));
              } else {
                lalist.sort((a, b) => a.agreementSentDate!
                    .toLowerCase()
                    .compareTo(b.agreementSentDate!.toLowerCase()));
                _store.dispatch(UpdateLLActiveTenantisLeasStartDateSort(false));
              }
              _store.dispatch(UpdateLLActiveTenantfilterleadlist(lalist));
            },
            onPressedSortLeaseDuration: () async {
              await updateOtherSortingValue(5);
              List<TenancyApplication> lalist =
                  activeTenantState.filteractivetenantleadlist;
              if (!activeTenantState.isLeaseDurationSort) {
                lalist.sort((a, b) => b.agreementReceivedDate!
                    .toLowerCase()
                    .compareTo(a.agreementReceivedDate!.toLowerCase()));
                _store.dispatch(UpdateLLActiveTenantisLeaseDurationSort(true));
              } else {
                lalist.sort((a, b) => a.agreementReceivedDate!
                    .toLowerCase()
                    .compareTo(b.agreementReceivedDate!.toLowerCase()));
                _store.dispatch(UpdateLLActiveTenantisLeaseDurationSort(false));
              }
              _store.dispatch(UpdateLLActiveTenantfilterleadlist(lalist));
            },
            onPressedSortAppStatus: () async {
              await updateOtherSortingValue(6);
              List<TenancyApplication> lalist =
                  activeTenantState.filteractivetenantleadlist;

              if (!activeTenantState.isAppStatusSort) {
                lalist.sort((a, b) => a.applicationStatus!.EnumDetailID
                    .compareTo(b.applicationStatus!.EnumDetailID));
                _store.dispatch(UpdateLLActiveTenantisAppStatusSort(true));
              } else {
                lalist.sort((a, b) => b.applicationStatus!.EnumDetailID
                    .compareTo(a.applicationStatus!.EnumDetailID));
                //lalist.reversed.toList();
                _store.dispatch(UpdateLLActiveTenantisAppStatusSort(false));
              }

              _store.dispatch(UpdateLLActiveTenantfilterleadlist(lalist));
            },
          ),
          tableItem(activeTenantState)
        ],
      ),
    );
  }

  Widget tableItem(LandLordActiveTenantState activeTenantState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        activeTenantState.isloding
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
            : activeTenantState.filteractivetenantleadlist != null &&
                    activeTenantState.filteractivetenantleadlist.length > 0
                ? Expanded(
                    child: ActiveTenantItem(
                      OnRefresh: () {},
                      listdata1: activeTenantState.filteractivetenantleadlist,
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

  Widget _funnelview(LandLordActiveTenantState activeTenantState) {
    return FunnelViewScreen(
      propertyValue: activeTenantState.propertyValue,
    );
  }

  ClearFilter(LandLordActiveTenantState activeTenantState) async {
    await Prefs.setBool(PrefsName.IsApplyFilterList, false);
    await Prefs.setBool(PrefsName.IsApplyFilterFunnel, false);

    if (activeTenantState.selecttoggle == 0) {
      activetenantcallApi();
    } else {
      if (activeTenantState.propertyValue != null) {
        await finnleviewcallapi(activeTenantState.propertyValue!.ID.toString());
      }
    }

    _store.dispatch(UpdateLLActiveTenantToggle(activeTenantState.selecttoggle));
  }

  _showFilterOverlayView(
      BuildContext context, LandLordActiveTenantState activeTenantState) {
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
                propertyValue: activeTenantState.propertyValue,
                isfunnelview: activeTenantState.selecttoggle == 1,
                onclose: () {
                  overlayEntry.remove();
                },
                onApply: (String json, bool isclear) async {
                  overlayEntry.remove();
                  if (activeTenantState.selecttoggle == 0) {
                    if (isclear) {
                      activetenantcallApi();
                    } else {
                      filterApplyactivetenantCallApi();
                    }
                  } else {
                    if (isclear) {
                      if (activeTenantState.propertyValue != null) {
                        await finnleviewcallapi(
                            activeTenantState.propertyValue!.ID.toString());
                      }
                    } else {
                      _store.dispatch(UpdateLLActiveTenantToggle(1));

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

  updateOtherSortingValue(int flag) {
    if (flag != 1) {
      _store.dispatch(UpdateLLActiveTenantisNameSort(false));
    }
    if (flag != 2) {
      _store.dispatch(UpdateLLActiveTenantisPropertySort(false));
    }
    if (flag != 3) {
      _store.dispatch(UpdateLLActiveTenantisRatingSort(false));
    }
    if (flag != 4) {
      _store.dispatch(UpdateLLActiveTenantisLeasStartDateSort(false));
    }
    if (flag != 5) {
      _store.dispatch(UpdateLLActiveTenantisLeaseDurationSort(false));
    }
    if (flag != 6) {
      _store.dispatch(UpdateLLActiveTenantisAppStatusSort(false));
    }

    RefereshstartTime();
  }

  RefereshstartTime() async {
    _store.dispatch(UpdateLLActiveTenantisloding(true));

    new Timer(Duration(milliseconds: 5), updateLoading);
  }

  updateLoading() {
    _store.dispatch(UpdateLLActiveTenantisloding(false));
  }

  createTableDataCSVFile(LandLordActiveTenantState activeTenantState) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String csv;
    List<List<dynamic>> csvList = [];

    List csvHeaderTitle = [];
    csvHeaderTitle.add("ID");
    csvHeaderTitle.add("Applicant Name");
    csvHeaderTitle.add("Property Name");
    csvHeaderTitle.add("Rating");
    csvHeaderTitle.add("Agreement Sent");
    csvHeaderTitle.add("Agreement Received");
    csvHeaderTitle.add("Application Status");

    csvList.add(csvHeaderTitle);

    for (var data in activeTenantState.filteractivetenantleadlist.toSet()) {
      List row = [];
      row.add(data.id);
      row.add(data.applicantName);
      row.add(data.propertyName);
      row.add(data.rating.toString());
      row.add(data.agreementSentDate);
      row.add(data.agreementReceivedDate);
      row.add(data.applicationStatus != null
          ? data.applicationStatus!.displayValue.toString()
          : "");

      csvList.add(row);
    }

    csv = const ListToCsvConverter().convert(csvList);

    String filename = "LeaseLead_" +
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
