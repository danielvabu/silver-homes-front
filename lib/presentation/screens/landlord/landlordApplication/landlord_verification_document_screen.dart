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
import 'package:silverhome/presentation/models/landlord_models/varification_document_state.dart';
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
import 'package:silverhome/widget/landlord/varifydocumenttabel/varify_document_header.dart';
import 'package:silverhome/widget/landlord/varifydocumenttabel/varify_document_item.dart';
import 'package:silverhome/widget/searchboxview.dart';
import 'package:silverhome/widget/toggle_switch.dart';

class LandlordVarificationDocumentScreen extends StatefulWidget {
  @override
  _LandlordVarificationDocumentScreenState createState() =>
      _LandlordVarificationDocumentScreenState();
}

class _LandlordVarificationDocumentScreenState
    extends State<LandlordVarificationDocumentScreen> {
  double height = 0, width = 0;
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
      FilterApplyvarificationDocCallApi();
    else
      varificationDocCallApi();
  }

  varificationDocCallApi() async {
    await Prefs.setBool(PrefsName.IsApplyFilterList, false);

    _store.dispatch(UpdateLLVDvarificationdoclist(<TenancyApplication>[]));
    _store
        .dispatch(UpdateLLVDfiltervarificationdoclist(<TenancyApplication>[]));

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

  FilterApplyvarificationDocCallApi() async {
    String json = await Prefs.getString(PrefsName.ApplyFilterJson);

    _store.dispatch(UpdateLLVDvarificationdoclist(<TenancyApplication>[]));
    _store
        .dispatch(UpdateLLVDfiltervarificationdoclist(<TenancyApplication>[]));

    var filter = jsonDecode(json);

    FilterData? filterData = FilterData.fromJson(filter);
    if (filterData.Reqtokens!.ApplicationStatus == null ||
        filterData.Reqtokens!.ApplicationStatus == "" ||
        filterData.Reqtokens!.ApplicationStatus!.contains("3")) {
      filterData.Reqtokens!.ApplicationStatus = "3";
      String filterjson = jsonEncode(filterData);
      _store.dispatch(UpdateLLVDapplicationisloding(true));
      await ApiManager().getVarificationDocumentList(context, filterjson);
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
      child: ConnectState<VarificationDocumentState>(
        map: (state) => state.varificationDocumentState,
        where: notIdentical,
        builder: (varificationDocumentState) {
          return Column(
            children: [
              Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        varificationDocumentState!.selecttoggle == 0
                            ? SearchBoxView(
                                callbackOnChanetext: (String text) {
                                  if (text.isNotEmpty) {
                                    List<TenancyApplication>
                                        filtervarificationdoclist =
                                        List.empty();

                                    filtervarificationdoclist =
                                        varificationDocumentState
                                            .varificationdoclist
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
                                        UpdateLLVDfiltervarificationdoclist(
                                            filtervarificationdoclist));
                                  } else {
                                    _store.dispatch(
                                        UpdateLLVDfiltervarificationdoclist(
                                            varificationDocumentState
                                                .varificationdoclist));
                                  }

                                  RefreshstartTime();
                                },
                              )
                            : PropertyDropdown(
                                onSelectVal: (item) async {
                                  _store.dispatch(
                                      UpdateLLVDapplicationPropertyItem(item));
                                  _store.dispatch(UpdateLLRCPropertyItem(item));
                                  _store.dispatch(
                                      UpdateLLTLleasePropertyItem(item));
                                  _store.dispatch(
                                      UpdateArchivePropertyItem(item));
                                  _store.dispatch(
                                      UpdateLLTALeadPropertyItem(item));
                                  _store.dispatch(
                                      UpdateLLTAApplicantPropertyItem(item));
                                  _store.dispatch(
                                      UpdateLLActiveTenantPropertyItem(item));

                                  await finnleviewcallapi(item!.ID.toString());
                                },
                                propertylist:
                                    varificationDocumentState.propertylist,
                                propertyValue:
                                    varificationDocumentState.propertyValue,
                              ),
                        SizedBox(
                          width: 10,
                        ),
                        _addNewLead(varificationDocumentState),
                      ],
                    ),
                    Row(
                      children: [
                        if (Prefs.getBool(PrefsName.IsApplyFilterList) ||
                            Prefs.getBool(PrefsName.IsApplyFilterFunnel))
                          InkWell(
                            onTap: () {
                              ClearFilter(varificationDocumentState);
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
                          SizedBox(
                            width: 30,
                          ),
                        _togglebutton(varificationDocumentState),
                        SizedBox(
                          width: 10,
                        ),
                        _actionPopup(varificationDocumentState)
                      ],
                    ),
                  ],
                ),
              ),
              varificationDocumentState.selecttoggle == 0
                  ? _tableview(varificationDocumentState)
                  : _funnelview(varificationDocumentState)
            ],
          );
        },
      ),
    );
  }

  Widget _addNewLead(VarificationDocumentState VDState) {
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

                if (VDState.selecttoggle == 0) {
                  /*await ApiManager().getTenancyApplicationList(
                      context, Prefs.getString(PrefsName.OwnerID));*/
                } else {
                  if (VDState.propertyValue != null) {
                    await finnleviewcallapi(
                        VDState.propertyValue!.ID.toString());
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

  Widget _togglebutton(VarificationDocumentState varificationDocumentState) {
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
        initialLabelIndex: varificationDocumentState.selecttoggle,
        activeBgColor: [myColor.text_color],
        activeFgColor: Colors.white,
        inactiveBgColor: Colors.white,
        inactiveFgColor: myColor.text_color,
        labels: [GlobleString.LL_ListView, GlobleString.LL_FunnelView],
        onToggle: (index) async {
          if (varificationDocumentState.selecttoggle != index) {
            if (index == 0) {
              varificationDocCallApi();
            } else {
              if (varificationDocumentState.propertyValue != null) {
                await finnleviewcallapi(
                    varificationDocumentState.propertyValue!.ID.toString());
              }
            }
            await Prefs.setBool(PrefsName.IsApplyFilterFunnel, false);
            await Prefs.setBool(PrefsName.IsApplyFilterList, false);
            _store.dispatch(UpdateLLVDToggle(index));
          }
        },
        totalSwitches: 2,
      ),
    );
  }

  Widget _actionPopup(VarificationDocumentState varificationDocumentState) {
    return Container(
      height: 32,
      width: 30,
      child: PopupMenuButton(
        onSelected: (value) {
          if (value == 1) {
            if (varificationDocumentState.selecttoggle == 0) {
              _showFilterOverlayView(context, varificationDocumentState);
            } else {
              if (varificationDocumentState.propertyValue != null) {
                _showFilterOverlayView(context, varificationDocumentState);
              } else {
                ToastUtils.showCustomToast(
                    context, GlobleString.Blank_funnel, false);
              }
            }
          } else if (value == 2) {
            if (varificationDocumentState.selecttoggle == 0) {
              if (varificationDocumentState.filtervarificationdoclist != null &&
                  varificationDocumentState.filtervarificationdoclist.length >
                      0) {
                createTableDataCSVFile(varificationDocumentState);
              } else {
                ToastUtils.showCustomToast(
                    context, GlobleString.Blank_export, false);
              }
            } else {
              if (varificationDocumentState.propertyValue != null) {
                CustomeWidget.FunnelDataCSVFile(context,
                    varificationDocumentState.propertyValue!.ID.toString());
              } else {
                ToastUtils.showCustomToast(
                    context, GlobleString.Blank_funnel, false);
              }
            }
          } else if (value == 3) {
            if (varificationDocumentState.propertyValue != null) {
              loader = Helper.overlayLoader(context);
              Overlay.of(context)!.insert(loader);

              ApiManager().AllArchivePropertyWise(context,
                  varificationDocumentState.propertyValue!.ID.toString(),
                  (status, responce) async {
                if (status) {
                  await finnleviewcallapi(
                      varificationDocumentState.propertyValue!.ID.toString());
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
          return varificationDocumentState.selecttoggle == 0
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

  Widget _tableview(VarificationDocumentState varificationDocumentState) {
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
          VarifyDocumentHeader(
            onPressedSortName: () async {
              await updateOtherSortingValue(1);
              List<TenancyApplication> lalist =
                  varificationDocumentState.filtervarificationdoclist;
              if (!varificationDocumentState.isNameSort) {
                lalist.sort((a, b) => a.applicantName!
                    .toLowerCase()
                    .compareTo(b.applicantName!.toLowerCase()));
                _store.dispatch(UpdateLLVDisNameSort(true));
              } else {
                lalist.sort((a, b) => b.applicantName!
                    .toLowerCase()
                    .compareTo(a.applicantName!.toLowerCase()));
                _store.dispatch(UpdateLLVDisNameSort(false));
              }
              _store.dispatch(UpdateLLVDfiltervarificationdoclist(lalist));
            },
            onPressedSortProperty: () async {
              await updateOtherSortingValue(2);
              List<TenancyApplication> lalist =
                  varificationDocumentState.filtervarificationdoclist;

              if (!varificationDocumentState.isPropertySort) {
                lalist.sort((a, b) => a.propertyName!
                    .toLowerCase()
                    .compareTo(b.propertyName!.toLowerCase()));
                _store.dispatch(UpdateLLVDisPropertySort(true));
              } else {
                lalist.sort((a, b) => b.propertyName!
                    .toLowerCase()
                    .compareTo(a.propertyName!.toLowerCase()));
                _store.dispatch(UpdateLLVDisPropertySort(false));
              }

              _store.dispatch(UpdateLLVDfiltervarificationdoclist(lalist));
            },
            onPressedSortRating: () async {
              await updateOtherSortingValue(3);
              List<TenancyApplication> lalist =
                  varificationDocumentState.filtervarificationdoclist;
              if (!varificationDocumentState.isRatingSort) {
                lalist.sort((a, b) =>
                    b.rating.toString().compareTo(a.rating.toString()));
                _store.dispatch(UpdateLLVDisRatingSort(true));
              } else {
                lalist.sort((a, b) =>
                    a.rating.toString().compareTo(b.rating.toString()));
                _store.dispatch(UpdateLLVDisRatingSort(false));
              }
              _store.dispatch(UpdateLLVDfiltervarificationdoclist(lalist));
            },
            onPressedSortDateSent: () async {
              await updateOtherSortingValue(4);
              List<TenancyApplication> lalist =
                  varificationDocumentState.filtervarificationdoclist;
              if (!varificationDocumentState.isDateSentSort) {
                lalist.sort((a, b) => b.docRequestSentDate!
                    .toLowerCase()
                    .compareTo(a.docRequestSentDate!.toLowerCase()));
                _store.dispatch(UpdateLLVDisDateSentSort(true));
              } else {
                lalist.sort((a, b) => a.docRequestSentDate!
                    .toLowerCase()
                    .compareTo(b.docRequestSentDate!.toLowerCase()));
                _store.dispatch(UpdateLLVDisDateSentSort(false));
              }
              _store.dispatch(UpdateLLVDfiltervarificationdoclist(lalist));
            },
            onPressedSortDateReceive: () async {
              await updateOtherSortingValue(5);
              List<TenancyApplication> lalist =
                  varificationDocumentState.filtervarificationdoclist;
              if (!varificationDocumentState.isDateReceiveSort) {
                lalist.sort((a, b) => b.docReceivedDate!
                    .toLowerCase()
                    .compareTo(a.docReceivedDate!.toLowerCase()));
                _store.dispatch(UpdateLLVDisDateReceiveSort(true));
              } else {
                lalist.sort((a, b) => a.docReceivedDate!
                    .toLowerCase()
                    .compareTo(b.docReceivedDate!.toLowerCase()));
                _store.dispatch(UpdateLLVDisDateReceiveSort(false));
              }
              _store.dispatch(UpdateLLVDfiltervarificationdoclist(lalist));
            },
            onPressedSortAppStatus: () async {
              await updateOtherSortingValue(6);
              List<TenancyApplication> lalist =
                  varificationDocumentState.filtervarificationdoclist;

              if (!varificationDocumentState.isAppStatusSort) {
                lalist.sort((a, b) => a.applicationStatus!.EnumDetailID
                    .compareTo(b.applicationStatus!.EnumDetailID));
                _store.dispatch(UpdateLLVDisAppStatusSort(true));
              } else {
                lalist.sort((a, b) => b.applicationStatus!.EnumDetailID
                    .compareTo(a.applicationStatus!.EnumDetailID));
                //lalist.reversed.toList();
                _store.dispatch(UpdateLLVDisAppStatusSort(false));
              }

              _store.dispatch(UpdateLLVDfiltervarificationdoclist(lalist));
            },
            onPressedSortReviewStatus: () async {
              await updateOtherSortingValue(7);
              List<TenancyApplication> lalist =
                  varificationDocumentState.filtervarificationdoclist;

              if (!varificationDocumentState.isDocStatusSort) {
                lalist.sort((a, b) => a.docReviewStatus == null
                    ? 0
                    : a.docReviewStatus!.EnumDetailID.compareTo(
                        b.docReviewStatus == null
                            ? 0
                            : b.docReviewStatus!.EnumDetailID));
                _store.dispatch(UpdateLLVDisDocStatusSort(true));
              } else {
                lalist.sort((a, b) => b.docReviewStatus == null
                    ? 0
                    : b.docReviewStatus!.EnumDetailID.compareTo(
                        a.docReviewStatus == null
                            ? 0
                            : a.docReviewStatus!.EnumDetailID));
                //lalist.reversed.toList();
                _store.dispatch(UpdateLLVDisDocStatusSort(false));
              }

              _store.dispatch(UpdateLLVDfiltervarificationdoclist(lalist));
            },
          ),
          tableItem(varificationDocumentState),
        ],
      ),
    );
  }

  Widget tableItem(VarificationDocumentState varDocState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        varDocState.isloding
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
            : varDocState.filtervarificationdoclist != null &&
                    varDocState.filtervarificationdoclist.length > 0
                ? Expanded(
                    child: VarifyDocumentItem(
                      OnRefresh: () {},
                      listdata1: varDocState.filtervarificationdoclist,
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

  Widget _funnelview(VarificationDocumentState varificationDocumentState) {
    return FunnelViewScreen(
      propertyValue: varificationDocumentState.propertyValue,
    );
  }

  ClearFilter(VarificationDocumentState varificationDocumentState) async {
    await Prefs.setBool(PrefsName.IsApplyFilterList, false);
    await Prefs.setBool(PrefsName.IsApplyFilterFunnel, false);

    if (varificationDocumentState.selecttoggle == 0) {
      varificationDocCallApi();
    } else {
      if (varificationDocumentState.propertyValue != null) {
        await finnleviewcallapi(
            varificationDocumentState.propertyValue!.ID.toString());
      }
    }

    _store.dispatch(UpdateLLVDToggle(varificationDocumentState.selecttoggle));
  }

  updateOtherSortingValue(int flag) {
    if (flag != 1) {
      _store.dispatch(UpdateLLVDisNameSort(false));
    }
    if (flag != 2) {
      _store.dispatch(UpdateLLVDisPropertySort(false));
    }
    if (flag != 3) {
      _store.dispatch(UpdateLLVDisRatingSort(false));
    }
    if (flag != 4) {
      _store.dispatch(UpdateLLVDisDateSentSort(false));
    }
    if (flag != 5) {
      _store.dispatch(UpdateLLVDisDateReceiveSort(false));
    }
    if (flag != 6) {
      _store.dispatch(UpdateLLVDisAppStatusSort(false));
    }
    if (flag != 7) {
      _store.dispatch(UpdateLLVDisDocStatusSort(false));
    }

    RefreshstartTime();
  }

  RefreshstartTime() async {
    _store.dispatch(UpdateLLVDapplicationisloding(true));

    new Timer(Duration(milliseconds: 5), updateLoading);
  }

  updateLoading() {
    _store.dispatch(UpdateLLVDapplicationisloding(false));
  }

  createTableDataCSVFile(
      VarificationDocumentState varificationDocumentState) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String csv;
    List<List<dynamic>> csvList = [];

    List csvHeaderTitle = [];
    csvHeaderTitle.add("ID");
    csvHeaderTitle.add("Applicant Name");
    csvHeaderTitle.add("Property Name");
    csvHeaderTitle.add("Rating");
    csvHeaderTitle.add("DocumentS Request Sent");
    csvHeaderTitle.add("Documents Received");
    csvHeaderTitle.add("Application Status");
    csvHeaderTitle.add("Documents Review Status");

    csvList.add(csvHeaderTitle);

    for (var data
        in varificationDocumentState.filtervarificationdoclist.toSet()) {
      List row = [];
      row.add(data.id);
      row.add(data.applicantName);
      row.add(data.propertyName);
      row.add(data.rating.toString());
      row.add(data.docRequestSentDate);
      row.add(data.docReceivedDate);
      row.add(data.applicationStatus != null
          ? data.applicationStatus!.displayValue.toString()
          : "");
      row.add(data.docReviewStatus != null
          ? data.docReviewStatus!.displayValue.toString()
          : "");

      csvList.add(row);
    }

    csv = const ListToCsvConverter().convert(csvList);

    String filename = "VarificationDocument_" +
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

  _showFilterOverlayView(BuildContext context,
      VarificationDocumentState varificationDocumentState) {
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
                propertyValue: varificationDocumentState.propertyValue,
                isfunnelview: varificationDocumentState.selecttoggle == 1,
                onclose: () {
                  overlayEntry.remove();
                },
                onApply: (String json, bool isclear) async {
                  overlayEntry.remove();

                  if (varificationDocumentState.selecttoggle == 0) {
                    if (isclear) {
                      varificationDocCallApi();
                    } else {
                      FilterApplyvarificationDocCallApi();
                    }
                  } else {
                    if (isclear) {
                      if (varificationDocumentState.propertyValue != null) {
                        await finnleviewcallapi(varificationDocumentState
                            .propertyValue!.ID
                            .toString());
                      }
                    } else {
                      _store.dispatch(UpdateLLVDToggle(1));
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
