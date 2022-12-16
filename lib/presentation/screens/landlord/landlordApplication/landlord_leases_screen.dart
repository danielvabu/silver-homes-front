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
import 'package:silverhome/presentation/models/landlord_models/landlord_tenancy_lease_state.dart';
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
import 'package:silverhome/widget/landlord/leasestabel/leases_header.dart';
import 'package:silverhome/widget/landlord/leasestabel/leases_item.dart';
import 'package:silverhome/widget/landlord/propertydropdown.dart';
import 'package:silverhome/widget/search/searchboxview.dart';
import 'package:silverhome/widget/customer/toggle_switch.dart';

class LandlordLeasesScreen extends StatefulWidget {
  @override
  _LandlordLeasesScreenState createState() => _LandlordLeasesScreenState();
}

class _LandlordLeasesScreenState extends State<LandlordLeasesScreen> {
  List<ActiveLead> leadlitems = [];
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
      FilterApplyLeaseCallApi();
    else
      leasecallApi();
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

  FilterApplyLeaseCallApi() async {
    String json = await Prefs.getString(PrefsName.ApplyFilterJson);

    _store.dispatch(UpdateLLTLleaseleadlist(<TenancyApplication>[]));
    _store.dispatch(UpdateLLTLfilterleaseleadlist(<TenancyApplication>[]));

    var filter = jsonDecode(json);

    FilterData? filterData = FilterData.fromJson(filter);

    if (filterData.Reqtokens!.ApplicationStatus == null ||
        filterData.Reqtokens!.ApplicationStatus == "" ||
        filterData.Reqtokens!.ApplicationStatus!.contains("5")) {
      filterData.Reqtokens!.ApplicationStatus = "5";
      String filterjson = jsonEncode(filterData);
      _store.dispatch(UpdateLLTLleaseisloding(true));
      await ApiManager().getLeaseLeadList(context, filterjson);
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
      child: ConnectState<LandLordTenancyLeaseState>(
        map: (state) => state.landlordTenancyLeaseState,
        where: notIdentical,
        builder: (leaseState) {
          return Column(
            children: [
              Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        leaseState!.selecttoggle == 0
                            ? SearchBoxView(
                                callbackOnChanetext: (String text) {
                                  if (text.isNotEmpty) {
                                    List<TenancyApplication>
                                        filterleaseleadlist = List.empty();

                                    filterleaseleadlist = leaseState
                                        .leaseleadlist
                                        .where((u) => (u.propertyName!
                                                .toLowerCase()
                                                .contains(text.toLowerCase()) ||
                                            u.applicantName!
                                                .toLowerCase()
                                                .contains(text.toLowerCase())))
                                        .toList();

                                    _store.dispatch(
                                        UpdateLLTLfilterleaseleadlist(
                                            filterleaseleadlist));
                                  } else {
                                    _store.dispatch(
                                        UpdateLLTLfilterleaseleadlist(
                                            leaseState.leaseleadlist));
                                  }

                                  RefereshstartTime();
                                },
                              )
                            : PropertyDropdown(
                                onSelectVal: (item) async {
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
                                  _store.dispatch(
                                      UpdateLLActiveTenantPropertyItem(item));

                                  await finnleviewcallapi(item!.ID.toString());
                                },
                                propertylist: leaseState.propertylist,
                                propertyValue: leaseState.propertyValue,
                              ),
                        SizedBox(
                          width: 10,
                        ),
                        _addNewLead(leaseState),
                      ],
                    ),
                    Row(
                      children: [
                        if (Prefs.getBool(PrefsName.IsApplyFilterList) ||
                            Prefs.getBool(PrefsName.IsApplyFilterFunnel))
                          InkWell(
                            onTap: () {
                              ClearFilter(leaseState);
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
                        _togglebutton(leaseState),
                        SizedBox(
                          width: 10,
                        ),
                        _actionPopup(leaseState)
                      ],
                    ),
                  ],
                ),
              ),
              leaseState.selecttoggle == 0
                  ? _tableview(leaseState)
                  : _funnelview(leaseState)
            ],
          );
        },
      ),
    );
  }

  Widget _addNewLead(LandLordTenancyLeaseState leaseState) {
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

                if (leaseState.selecttoggle == 0) {
                  await leasecallApi();
                } else {
                  if (leaseState.propertyValue != null) {
                    await finnleviewcallapi(
                        leaseState.propertyValue!.ID.toString());
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

  Widget _togglebutton(LandLordTenancyLeaseState leaseState) {
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
        initialLabelIndex: leaseState.selecttoggle,
        activeBgColor: [myColor.text_color],
        activeFgColor: Colors.white,
        inactiveBgColor: Colors.white,
        inactiveFgColor: myColor.text_color,
        labels: [GlobleString.LL_ListView, GlobleString.LL_FunnelView],
        onToggle: (index) async {
          if (leaseState.selecttoggle != index) {
            if (index == 0) {
              leasecallApi();
            } else {
              if (leaseState.propertyValue != null) {
                await finnleviewcallapi(
                    leaseState.propertyValue!.ID.toString());
              }
            }
            await Prefs.setBool(PrefsName.IsApplyFilterFunnel, false);
            await Prefs.setBool(PrefsName.IsApplyFilterList, false);
            _store.dispatch(UpdateLLTLToggle(index));
          }
        },
        totalSwitches: 2,
      ),
    );
  }

  Widget _actionPopup(LandLordTenancyLeaseState leaseState) {
    return Container(
      height: 32,
      width: 30,
      child: PopupMenuButton(
        onSelected: (value) {
          if (value == 1) {
            if (leaseState.selecttoggle == 0) {
              _showFilterOverlayView(context, leaseState);
            } else {
              if (leaseState.propertyValue != null) {
                _showFilterOverlayView(context, leaseState);
              } else {
                ToastUtils.showCustomToast(
                    context, GlobleString.Blank_funnel, false);
              }
            }
          } else if (value == 2) {
            if (leaseState.selecttoggle == 0) {
              if (leaseState.filterleaseleadlist != null &&
                  leaseState.filterleaseleadlist.length > 0) {
                createTableDataCSVFile(leaseState);
              } else {
                ToastUtils.showCustomToast(
                    context, GlobleString.Blank_export, false);
              }
            } else {
              if (leaseState.propertyValue != null) {
                CustomeWidget.FunnelDataCSVFile(
                    context, leaseState.propertyValue!.ID.toString());
              } else {
                ToastUtils.showCustomToast(
                    context, GlobleString.Blank_funnel, false);
              }
            }
          } else if (value == 3) {
            if (leaseState.propertyValue != null) {
              loader = Helper.overlayLoader(context);
              Overlay.of(context)!.insert(loader);

              ApiManager().AllArchivePropertyWise(
                  context, leaseState.propertyValue!.ID.toString(),
                  (status, responce) async {
                if (status) {
                  await finnleviewcallapi(
                      leaseState.propertyValue!.ID.toString());
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
          return leaseState.selecttoggle == 0
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

  Widget _tableview(LandLordTenancyLeaseState leaseState) {
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
          LeasesHeader(
            onPressedSortName: () async {
              await updateOtherSortingValue(1);
              List<TenancyApplication> lalist = leaseState.filterleaseleadlist;
              if (!leaseState.isNameSort) {
                lalist.sort((a, b) => a.applicantName!
                    .toLowerCase()
                    .compareTo(b.applicantName!.toLowerCase()));
                _store.dispatch(UpdateLLTLisNameSort(true));
              } else {
                lalist.sort((a, b) => b.applicantName!
                    .toLowerCase()
                    .compareTo(a.applicantName!.toLowerCase()));
                _store.dispatch(UpdateLLTLisNameSort(false));
              }
              _store.dispatch(UpdateLLTLfilterleaseleadlist(lalist));
            },
            onPressedSortProperty: () async {
              await updateOtherSortingValue(2);
              List<TenancyApplication> lalist = leaseState.filterleaseleadlist;

              if (!leaseState.isPropertySort) {
                lalist.sort((a, b) => a.propertyName!
                    .toLowerCase()
                    .compareTo(b.propertyName!.toLowerCase()));
                _store.dispatch(UpdateLLTLisPropertySort(true));
              } else {
                lalist.sort((a, b) => b.propertyName!
                    .toLowerCase()
                    .compareTo(a.propertyName!.toLowerCase()));
                _store.dispatch(UpdateLLTLisPropertySort(false));
              }

              _store.dispatch(UpdateLLTLfilterleaseleadlist(lalist));
            },
            onPressedSortRating: () async {
              await updateOtherSortingValue(3);
              List<TenancyApplication> lalist = leaseState.filterleaseleadlist;
              if (!leaseState.isRatingSort) {
                lalist.sort((a, b) =>
                    b.rating.toString().compareTo(a.rating.toString()));
                _store.dispatch(UpdateLLTLisRatingSort(true));
              } else {
                lalist.sort((a, b) =>
                    a.rating.toString().compareTo(b.rating.toString()));
                _store.dispatch(UpdateLLTLisRatingSort(false));
              }
              _store.dispatch(UpdateLLTLfilterleaseleadlist(lalist));
            },
            onPressedSortSent: () async {
              await updateOtherSortingValue(4);
              List<TenancyApplication> lalist = leaseState.filterleaseleadlist;
              if (!leaseState.isDateSentSort) {
                lalist.sort((a, b) => b.agreementSentDate!
                    .toLowerCase()
                    .compareTo(a.agreementSentDate!.toLowerCase()));
                _store.dispatch(UpdateLLTLisDateSentSort(true));
              } else {
                lalist.sort((a, b) => a.agreementSentDate!
                    .toLowerCase()
                    .compareTo(b.agreementSentDate!.toLowerCase()));
                _store.dispatch(UpdateLLTLisDateSentSort(false));
              }
              _store.dispatch(UpdateLLTLfilterleaseleadlist(lalist));
            },
            onPressedSortReceive: () async {
              await updateOtherSortingValue(5);
              List<TenancyApplication> lalist = leaseState.filterleaseleadlist;
              if (!leaseState.isDateReceiveSort) {
                lalist.sort((a, b) => b.agreementReceivedDate!
                    .toLowerCase()
                    .compareTo(a.agreementReceivedDate!.toLowerCase()));
                _store.dispatch(UpdateLLTLisDateReceiveSort(true));
              } else {
                lalist.sort((a, b) => a.agreementReceivedDate!
                    .toLowerCase()
                    .compareTo(b.agreementReceivedDate!.toLowerCase()));
                _store.dispatch(UpdateLLTLisDateReceiveSort(false));
              }
              _store.dispatch(UpdateLLTLfilterleaseleadlist(lalist));
            },
            onPressedSortAppStatus: () async {
              await updateOtherSortingValue(6);
              List<TenancyApplication> lalist = leaseState.filterleaseleadlist;

              if (!leaseState.isAppStatusSort) {
                lalist.sort((a, b) => a.applicationStatus!.EnumDetailID
                    .compareTo(b.applicationStatus!.EnumDetailID));
                _store.dispatch(UpdateLLTLisAppStatusSort(true));
              } else {
                lalist.sort((a, b) => b.applicationStatus!.EnumDetailID
                    .compareTo(a.applicationStatus!.EnumDetailID));
                //lalist.reversed.toList();
                _store.dispatch(UpdateLLTLisAppStatusSort(false));
              }

              _store.dispatch(UpdateLLTLfilterleaseleadlist(lalist));
            },
            onPressedSortReviewStatus: () async {
              await updateOtherSortingValue(7);
              List<TenancyApplication> lalist = leaseState.filterleaseleadlist;

              if (!leaseState.isLeaseStatusSort) {
                lalist.sort((a, b) => a.leaseStatus == null
                    ? 0
                    : a.leaseStatus!.EnumDetailID.compareTo(
                        b.leaseStatus == null
                            ? 0
                            : b.leaseStatus!.EnumDetailID));
                _store.dispatch(UpdateLLTLisLeaseStatusSort(true));
              } else {
                lalist.sort((a, b) => b.leaseStatus == null
                    ? 0
                    : b.leaseStatus!.EnumDetailID.compareTo(
                        a.leaseStatus == null
                            ? 0
                            : a.leaseStatus!.EnumDetailID));
                //lalist.reversed.toList();
                _store.dispatch(UpdateLLTLisLeaseStatusSort(false));
              }

              _store.dispatch(UpdateLLTLfilterleaseleadlist(lalist));
            },
          ),
          tableItem(leaseState)
        ],
      ),
    );
  }

  Widget tableItem(LandLordTenancyLeaseState leaseState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        leaseState.isloding
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
            : leaseState.filterleaseleadlist != null &&
                    leaseState.filterleaseleadlist.length > 0
                ? Expanded(
                    child: LeasesItem(
                      listdata1: leaseState.filterleaseleadlist,
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

  Widget _funnelview(LandLordTenancyLeaseState leaseState) {
    return FunnelViewScreen(
      propertyValue: leaseState.propertyValue,
    );
  }

  ClearFilter(LandLordTenancyLeaseState leaseState) async {
    await Prefs.setBool(PrefsName.IsApplyFilterList, false);
    await Prefs.setBool(PrefsName.IsApplyFilterFunnel, false);

    if (leaseState.selecttoggle == 0) {
      leasecallApi();
    } else {
      if (leaseState.propertyValue != null) {
        await finnleviewcallapi(leaseState.propertyValue!.ID.toString());
      }
    }

    _store.dispatch(UpdateLLTLToggle(leaseState.selecttoggle));
  }

  _showFilterOverlayView(
      BuildContext context, LandLordTenancyLeaseState leaseState) {
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
                propertyValue: leaseState.propertyValue,
                isfunnelview: leaseState.selecttoggle == 1,
                onclose: () {
                  overlayEntry.remove();
                },
                onApply: (String json, bool isclear) async {
                  overlayEntry.remove();
                  if (leaseState.selecttoggle == 0) {
                    if (isclear) {
                      leasecallApi();
                    } else {
                      FilterApplyLeaseCallApi();
                    }
                  } else {
                    if (isclear) {
                      if (leaseState.propertyValue != null) {
                        await finnleviewcallapi(
                            leaseState.propertyValue!.ID.toString());
                      }
                    } else {
                      _store.dispatch(UpdateLLTLToggle(1));

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
      _store.dispatch(UpdateLLTLisNameSort(false));
    }
    if (flag != 2) {
      _store.dispatch(UpdateLLTLisPropertySort(false));
    }
    if (flag != 3) {
      _store.dispatch(UpdateLLTLisRatingSort(false));
    }
    if (flag != 4) {
      _store.dispatch(UpdateLLTLisDateSentSort(false));
    }
    if (flag != 5) {
      _store.dispatch(UpdateLLTLisDateReceiveSort(false));
    }
    if (flag != 6) {
      _store.dispatch(UpdateLLTLisAppStatusSort(false));
    }
    if (flag != 7) {
      _store.dispatch(UpdateLLTLisLeaseStatusSort(false));
    }

    RefereshstartTime();
  }

  RefereshstartTime() async {
    _store.dispatch(UpdateLLTLleaseisloding(true));

    new Timer(Duration(milliseconds: 5), updateLoading);
  }

  updateLoading() {
    _store.dispatch(UpdateLLTLleaseisloding(false));
  }

  createTableDataCSVFile(LandLordTenancyLeaseState leaseState) async {
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
    csvHeaderTitle.add("Lease Review Status");

    csvList.add(csvHeaderTitle);

    for (var data in leaseState.filterleaseleadlist.toSet()) {
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
      row.add(data.leaseStatus != null
          ? data.leaseStatus!.displayValue.toString()
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
