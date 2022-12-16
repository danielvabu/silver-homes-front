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
import 'package:silverhome/widget/landlord/referencechecktabel/reference_header.dart';
import 'package:silverhome/widget/landlord/referencechecktabel/reference_item.dart';
import 'package:silverhome/widget/search/searchboxview.dart';
import 'package:silverhome/widget/customer/toggle_switch.dart';

import '../../../models/landlord_models/referencecheck_state.dart';

class LandlordReferenceCheckScreen extends StatefulWidget {
  @override
  _LandlordReferenceCheckScreenState createState() => _LandlordReferenceCheckScreenState();
}

class _LandlordReferenceCheckScreenState extends State<LandlordReferenceCheckScreen> {
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
      FilterApplyReferenceCallApi();
    else
      referencecallApi();
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

  FilterApplyReferenceCallApi() async {
    String json = await Prefs.getString(PrefsName.ApplyFilterJson);

    _store.dispatch(UpdateLLRCReferenceCheckslist(<TenancyApplication>[]));
    _store.dispatch(UpdateLLRCfilterReferenceCheckslist(<TenancyApplication>[]));

    var filter = jsonDecode(json);

    FilterData? filterData = FilterData.fromJson(filter);
    if (filterData.Reqtokens!.ApplicationStatus == null ||
        filterData.Reqtokens!.ApplicationStatus == "" ||
        filterData.Reqtokens!.ApplicationStatus!.contains("4")) {
      filterData.Reqtokens!.ApplicationStatus = "4";

      String filterjson = jsonEncode(filterData);
      _store.dispatch(UpdateLLRCisloding(true));
      await ApiManager().getApplicantReferenceCheckList(context, filterjson);
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
      child: ConnectState<ReferenceCheckState>(
        map: (state) => state.referenceCheckState,
        where: notIdentical,
        builder: (referenceCheckState) {
          return Column(
            children: [
              Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        referenceCheckState!.selecttoggle == 0
                            ? SearchBoxView(
                                callbackOnChanetext: (String text) {
                                  if (text.isNotEmpty) {
                                    List<TenancyApplication> filterReferencelist = List.empty();

                                    filterReferencelist = referenceCheckState.ReferenceCheckslist.where((u) =>
                                        (u.propertyName!.toLowerCase().contains(text.toLowerCase()) ||
                                            u.applicantName!.toLowerCase().contains(text.toLowerCase()))).toList();

                                    _store.dispatch(UpdateLLRCfilterReferenceCheckslist(filterReferencelist));
                                  } else {
                                    _store.dispatch(UpdateLLRCfilterReferenceCheckslist(referenceCheckState.ReferenceCheckslist));
                                  }

                                  RefreshstartTime();
                                },
                              )
                            : PropertyDropdown(
                                onSelectVal: (item) async {
                                  _store.dispatch(UpdateLLRCPropertyItem(item));
                                  _store.dispatch(UpdateLLTLleasePropertyItem(item));
                                  _store.dispatch(UpdateArchivePropertyItem(item));
                                  _store.dispatch(UpdateLLTALeadPropertyItem(item));
                                  _store.dispatch(UpdateLLVDapplicationPropertyItem(item));

                                  _store.dispatch(UpdateLLTAApplicantPropertyItem(item));
                                  _store.dispatch(UpdateLLActiveTenantPropertyItem(item));

                                  await finnleviewcallapi(item!.ID.toString());
                                },
                                propertylist: referenceCheckState.propertylist,
                                propertyValue: referenceCheckState.propertyValue,
                              ),
                        SizedBox(
                          width: 10,
                        ),
                        _addNewLead(referenceCheckState),
                      ],
                    ),
                    Row(
                      children: [
                        if (Prefs.getBool(PrefsName.IsApplyFilterList) || Prefs.getBool(PrefsName.IsApplyFilterFunnel))
                          InkWell(
                            onTap: () {
                              ClearFilter(referenceCheckState);
                            },
                            child: Container(
                              height: 35,
                              padding: EdgeInsets.only(left: 25, right: 25),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                border: Border.all(color: myColor.errorcolor, width: 1),
                                color: myColor.white,
                              ),
                              child: Text(
                                GlobleString.Filter_Clear,
                                style: MyStyles.Medium(14, myColor.errorcolor),
                              ),
                            ),
                          ),
                        if (Prefs.getBool(PrefsName.IsApplyFilterList) || Prefs.getBool(PrefsName.IsApplyFilterFunnel))
                          SizedBox(
                            width: 30,
                          ),
                        _togglebutton(referenceCheckState),
                        SizedBox(
                          width: 10,
                        ),
                        _actionPopup(referenceCheckState)
                      ],
                    ),
                  ],
                ),
              ),
              referenceCheckState.selecttoggle == 0 ? _tableview(referenceCheckState) : _funnelview(referenceCheckState)
            ],
          );
        },
      ),
    );
  }

  Widget _addNewLead(ReferenceCheckState referenceCheckState) {
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

                if (referenceCheckState.selecttoggle == 0) {
                  /* await ApiManager().getTenancyApplicationList(
                      context, Prefs.getString(PrefsName.OwnerID));*/
                } else {
                  if (referenceCheckState.propertyValue != null) {
                    await finnleviewcallapi(referenceCheckState.propertyValue!.ID.toString());
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

  Widget _togglebutton(ReferenceCheckState referenceCheckState) {
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
        initialLabelIndex: referenceCheckState.selecttoggle,
        activeBgColor: [myColor.text_color],
        activeFgColor: Colors.white,
        inactiveBgColor: Colors.white,
        inactiveFgColor: myColor.text_color,
        labels: [GlobleString.LL_ListView, GlobleString.LL_FunnelView],
        onToggle: (index) async {
          if (referenceCheckState.selecttoggle != index) {
            if (index == 0) {
              referencecallApi();
            } else {
              if (referenceCheckState.propertyValue != null) {
                await finnleviewcallapi(referenceCheckState.propertyValue!.ID.toString());
              }
            }
            await Prefs.setBool(PrefsName.IsApplyFilterFunnel, false);
            await Prefs.setBool(PrefsName.IsApplyFilterList, false);
            _store.dispatch(UpdateLLRCToggle(index));
          }
        },
        totalSwitches: 2,
      ),
    );
  }

  Widget _actionPopup(ReferenceCheckState referenceCheckState) {
    return Container(
      height: 32,
      width: 30,
      child: PopupMenuButton(
        onSelected: (value) {
          if (value == 1) {
            if (referenceCheckState.selecttoggle == 0) {
              _showFilterOverlayView(context, referenceCheckState);
            } else {
              if (referenceCheckState.propertyValue != null) {
                _showFilterOverlayView(context, referenceCheckState);
              } else {
                ToastUtils.showCustomToast(context, GlobleString.Blank_funnel, false);
              }
            }
          } else if (value == 2) {
            if (referenceCheckState.selecttoggle == 0) {
              if (referenceCheckState.filterReferenceCheckslist != null && referenceCheckState.filterReferenceCheckslist.length > 0) {
                createTableDataCSVFile(referenceCheckState);
              } else {
                ToastUtils.showCustomToast(context, GlobleString.Blank_export, false);
              }
            } else {
              if (referenceCheckState.propertyValue != null) {
                CustomeWidget.FunnelDataCSVFile(context, referenceCheckState.propertyValue!.ID.toString());
              } else {
                ToastUtils.showCustomToast(context, GlobleString.Blank_funnel, false);
              }
            }
          } else if (value == 3) {
            if (referenceCheckState.propertyValue != null) {
              loader = Helper.overlayLoader(context);
              Overlay.of(context)!.insert(loader);

              ApiManager().AllArchivePropertyWise(context, referenceCheckState.propertyValue!.ID.toString(), (status, responce) async {
                if (status) {
                  await finnleviewcallapi(referenceCheckState.propertyValue!.ID.toString());
                  loader.remove();
                } else {
                  loader.remove();
                  ToastUtils.showCustomToast(context, GlobleString.Error1, false);
                }
              });
            } else {
              ToastUtils.showCustomToast(context, GlobleString.Blank_funnel, false);
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
          return referenceCheckState.selecttoggle == 0
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

  Widget _tableview(ReferenceCheckState referenceCheckState) {
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
          ReferenceHeader(
            onPressedSortName: () async {
              await updateOtherSortingValue(1);
              List<TenancyApplication> lalist = referenceCheckState.filterReferenceCheckslist;
              if (!referenceCheckState.isNameSort) {
                lalist.sort((a, b) => a.applicantName!.toLowerCase().compareTo(b.applicantName!.toLowerCase()));
                _store.dispatch(UpdateLLRCisNameSort(true));
              } else {
                lalist.sort((a, b) => b.applicantName!.toLowerCase().compareTo(a.applicantName!.toLowerCase()));
                _store.dispatch(UpdateLLRCisNameSort(false));
              }
              _store.dispatch(UpdateLLRCfilterReferenceCheckslist(lalist));
            },
            onPressedSortProperty: () async {
              await updateOtherSortingValue(2);
              List<TenancyApplication> lalist = referenceCheckState.filterReferenceCheckslist;

              if (!referenceCheckState.isPropertySort) {
                lalist.sort((a, b) => a.propertyName!.toLowerCase().compareTo(b.propertyName!.toLowerCase()));
                _store.dispatch(UpdateLLRCisPropertySort(true));
              } else {
                lalist.sort((a, b) => b.propertyName!.toLowerCase().compareTo(a.propertyName!.toLowerCase()));
                _store.dispatch(UpdateLLRCisPropertySort(false));
              }

              _store.dispatch(UpdateLLRCfilterReferenceCheckslist(lalist));
            },
            onPressedSortRating: () async {
              await updateOtherSortingValue(3);
              List<TenancyApplication> lalist = referenceCheckState.filterReferenceCheckslist;
              if (!referenceCheckState.isRatingSort) {
                lalist.sort((a, b) => b.rating.toString().compareTo(a.rating.toString()));
                _store.dispatch(UpdateLLRCisRatingSort(true));
              } else {
                lalist.sort((a, b) => a.rating.toString().compareTo(b.rating.toString()));
                _store.dispatch(UpdateLLRCisRatingSort(false));
              }
              _store.dispatch(UpdateLLRCfilterReferenceCheckslist(lalist));
            },
            onPressedSortReferences: () async {
              await updateOtherSortingValue(7);
              List<TenancyApplication> lalist = referenceCheckState.filterReferenceCheckslist;
              if (!referenceCheckState.isReferenceSort) {
                lalist.sort((a, b) => b.referencesCount.toString().compareTo(a.referencesCount.toString()));
                _store.dispatch(UpdateLLRCisReferenceSort(true));
              } else {
                lalist.sort((a, b) => a.referencesCount.toString().compareTo(b.referencesCount.toString()));
                _store.dispatch(UpdateLLRCisReferenceSort(false));
              }
              _store.dispatch(UpdateLLRCfilterReferenceCheckslist(lalist));
            },
            onPressedSortQuesSent: () async {
              await updateOtherSortingValue(4);
              List<TenancyApplication> lalist = referenceCheckState.filterReferenceCheckslist;
              if (!referenceCheckState.isDateSentSort) {
                lalist.sort((a, b) => b.questionnairesSentCount.toString().compareTo(a.questionnairesSentCount.toString()));
                _store.dispatch(UpdateLLRCisDateSentSort(true));
              } else {
                lalist.sort((a, b) => a.questionnairesSentCount.toString().compareTo(b.questionnairesSentCount.toString()));
                _store.dispatch(UpdateLLRCisDateSentSort(false));
              }
              _store.dispatch(UpdateLLRCfilterReferenceCheckslist(lalist));
            },
            onPressedSortQuesReceive: () async {
              await updateOtherSortingValue(5);
              List<TenancyApplication> lalist = referenceCheckState.filterReferenceCheckslist;
              if (!referenceCheckState.isDateReceiveSort) {
                lalist.sort((a, b) => b.questionnairesReceivedCount!.compareTo(a.questionnairesReceivedCount!));
                _store.dispatch(UpdateLLRCisDateReceiveSort(true));
              } else {
                lalist.sort((a, b) => a.questionnairesReceivedCount!.compareTo(b.questionnairesReceivedCount!));
                _store.dispatch(UpdateLLRCisDateReceiveSort(false));
              }
              _store.dispatch(UpdateLLRCfilterReferenceCheckslist(lalist));
            },
            onPressedSortAppStatus: () async {
              await updateOtherSortingValue(6);
              List<TenancyApplication> lalist = referenceCheckState.filterReferenceCheckslist;

              if (!referenceCheckState.isAppStatusSort) {
                lalist.sort((a, b) => a.applicationStatus!.EnumDetailID.compareTo(b.applicationStatus!.EnumDetailID));
                _store.dispatch(UpdateLLRCisAppStatusSort(true));
              } else {
                lalist.sort((a, b) => b.applicationStatus!.EnumDetailID.compareTo(a.applicationStatus!.EnumDetailID));
                //lalist.reversed.toList();
                _store.dispatch(UpdateLLRCisAppStatusSort(false));
              }

              _store.dispatch(UpdateLLRCfilterReferenceCheckslist(lalist));
            },
          ),
          tableItem(referenceCheckState),
        ],
      ),
    );
  }

  Widget tableItem(ReferenceCheckState refCheckState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        refCheckState.isloding
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
            : refCheckState.filterReferenceCheckslist != null && refCheckState.filterReferenceCheckslist.length > 0
                ? Expanded(
                    child: ReferenceItem(
                      OnRefresh: () {},
                      listdata1: refCheckState.filterReferenceCheckslist,
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

  Widget _funnelview(ReferenceCheckState referenceCheckState) {
    return FunnelViewScreen(
      propertyValue: referenceCheckState.propertyValue,
    );
  }

  ClearFilter(ReferenceCheckState referenceCheckState) async {
    await Prefs.setBool(PrefsName.IsApplyFilterList, false);
    await Prefs.setBool(PrefsName.IsApplyFilterFunnel, false);

    if (referenceCheckState.selecttoggle == 0) {
      referencecallApi();
    } else {
      if (referenceCheckState.propertyValue != null) {
        await finnleviewcallapi(referenceCheckState.propertyValue!.ID.toString());
      }
    }

    _store.dispatch(UpdateLLRCToggle(referenceCheckState.selecttoggle));
  }

  updateOtherSortingValue(int flag) {
    if (flag != 1) {
      _store.dispatch(UpdateLLRCisNameSort(false));
    }
    if (flag != 2) {
      _store.dispatch(UpdateLLRCisPropertySort(false));
    }
    if (flag != 3) {
      _store.dispatch(UpdateLLRCisRatingSort(false));
    }
    if (flag != 4) {
      _store.dispatch(UpdateLLRCisDateSentSort(false));
    }
    if (flag != 5) {
      _store.dispatch(UpdateLLRCisDateReceiveSort(false));
    }
    if (flag != 6) {
      _store.dispatch(UpdateLLRCisAppStatusSort(false));
    }
    if (flag != 7) {
      _store.dispatch(UpdateLLRCisReferenceSort(false));
    }

    RefreshstartTime();
  }

  RefreshstartTime() async {
    _store.dispatch(UpdateLLRCisloding(true));

    new Timer(Duration(milliseconds: 5), updateLoading);
  }

  updateLoading() {
    _store.dispatch(UpdateLLRCisloding(false));
  }

  _showFilterOverlayView(BuildContext context, ReferenceCheckState referenceCheckState) {
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
                propertyValue: referenceCheckState.propertyValue,
                isfunnelview: referenceCheckState.selecttoggle == 1,
                onclose: () {
                  overlayEntry.remove();
                },
                onApply: (String json, bool isclear) async {
                  overlayEntry.remove();
                  if (referenceCheckState.selecttoggle == 0) {
                    if (isclear) {
                      referencecallApi();
                    } else {
                      FilterApplyReferenceCallApi();
                    }
                  } else {
                    if (isclear) {
                      if (referenceCheckState.propertyValue != null) {
                        await finnleviewcallapi(referenceCheckState.propertyValue!.ID.toString());
                      }
                    } else {
                      _store.dispatch(UpdateLLRCToggle(1));

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

  createTableDataCSVFile(ReferenceCheckState referenceCheckState) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String csv;
    List<List<dynamic>> csvList = [];

    List csvHeaderTitle = [];
    csvHeaderTitle.add("ID");
    csvHeaderTitle.add("Applicant Name");
    csvHeaderTitle.add("Property Name");
    csvHeaderTitle.add("Rating");
    csvHeaderTitle.add("# of References");
    csvHeaderTitle.add("Questionnaires Sent");
    csvHeaderTitle.add("Questionnaires Received ");
    csvHeaderTitle.add("Application Status");

    csvList.add(csvHeaderTitle);

    for (var data in referenceCheckState.filterReferenceCheckslist.toSet()) {
      List row = [];
      row.add(data.id);
      row.add(data.applicantName);
      row.add(data.propertyName);
      row.add(data.rating.toString());
      row.add(data.referencesCount);
      row.add(data.questionnairesSentCount);
      row.add(data.questionnairesReceivedCount);
      row.add(data.applicationStatus != null ? data.applicationStatus!.displayValue.toString() : "");

      csvList.add(row);
    }

    csv = const ListToCsvConverter().convert(csvList);

    String filename = "ReferenceCheck_" + DateFormat("ddMMyyyy_hhmmss").format(DateTime.now()).toString() + ".csv";

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
