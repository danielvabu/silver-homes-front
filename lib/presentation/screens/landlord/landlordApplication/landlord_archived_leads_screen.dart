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
import 'package:silverhome/presentation/models/landlord_models/landlordtenancyarchive_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/alert/alert_dialogbox.dart';
import 'package:silverhome/widget/landlord/archivedapplicationtabel/archivedappheader.dart';
import 'package:silverhome/widget/landlord/archivedapplicationtabel/archivedappitem.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/landlord/filterview.dart';
import 'package:silverhome/widget/landlord/funnelview/funnelviewscreen.dart';
import 'package:silverhome/widget/landlord/lead_dialog/addnewlead_dialogbox.dart';
import 'package:silverhome/widget/landlord/propertydropdown.dart';
import 'package:silverhome/widget/search/searchboxview.dart';
import 'package:silverhome/widget/customer/toggle_switch.dart';

class LandlordArchivedLeadsScreen extends StatefulWidget {
  @override
  _LandlordArchivedLeadsScreenState createState() => _LandlordArchivedLeadsScreenState();
}

class _LandlordArchivedLeadsScreenState extends State<LandlordArchivedLeadsScreen> {
  final _store = getIt<AppStore>();
  static TextEditingController textsearchvalue = TextEditingController();
  double height = 0, width = 0;
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
      archivecallApi();
  }

  archivecallApi() async {
    await Prefs.setBool(PrefsName.IsApplyFilterList, false);
    _store.dispatch(UpdateArchiveisloding(true));
    _store.dispatch(UpdateArchiveleadList(<TenancyApplication>[]));
    _store.dispatch(UpdateArchiveFilterArchiveleadlist(<TenancyApplication>[]));

    FilterReqtokens reqtokens = new FilterReqtokens();
    reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    reqtokens.IsArchived = "1";

    FilterData filterData = new FilterData();
    filterData.DSQID = Weburl.DSQ_CommonView;
    filterData.LoadLookupValues = true;
    filterData.LoadRecordInfo = true;
    filterData.Reqtokens = reqtokens;

    String filterjson = jsonEncode(filterData);
    await ApiManager().getTenancyArchiveList(context, filterjson);
  }

  FilterApplyLeaseCallApi() async {
    String json = await Prefs.getString(PrefsName.ApplyFilterJson);
    _store.dispatch(UpdateArchiveisloding(true));
    _store.dispatch(UpdateArchiveleadList(<TenancyApplication>[]));
    _store.dispatch(UpdateArchiveFilterArchiveleadlist(<TenancyApplication>[]));

    var filter = jsonDecode(json);

    FilterData? filterData = FilterData.fromJson(filter);
    filterData.Reqtokens!.IsArchived = "1";

    String filterjson = jsonEncode(filterData);
    await ApiManager().getTenancyArchiveList(context, filterjson);
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
      child: ConnectState<LandLordTenancyArchiveState>(
          map: (state) => state.landLordTenancyArchiveState,
          where: notIdentical,
          builder: (ArchiveState) {
            return Column(
              children: [
                Container(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (ArchiveState!.selecttoggle == 0)
                            SearchBoxView(
                              callbackOnChanetext: (String text) {
                                if (text.isNotEmpty) {
                                  List<TenancyApplication> filtereleadlitemsnew = List.empty();

                                  filtereleadlitemsnew = ArchiveState.archiveleadlist
                                      .where((u) => (u.propertyName!.toLowerCase().contains(text.toLowerCase()) ||
                                          u.applicantName!.toLowerCase().contains(text.toLowerCase())))
                                      .toList();

                                  _store.dispatch(UpdateArchiveFilterArchiveleadlist(filtereleadlitemsnew));
                                } else {
                                  _store.dispatch(UpdateArchiveFilterArchiveleadlist(ArchiveState.archiveleadlist));
                                }

                                RefreshstartTime();
                              },
                            )
                          else
                            PropertyDropdown(
                              onSelectVal: (item) async {
                                _store.dispatch(UpdateArchivePropertyItem(item));
                                _store.dispatch(UpdateLLTALeadPropertyItem(item));
                                _store.dispatch(UpdateLLVDapplicationPropertyItem(item));
                                _store.dispatch(UpdateLLRCPropertyItem(item));
                                _store.dispatch(UpdateLLTLleasePropertyItem(item));
                                _store.dispatch(UpdateLLTAApplicantPropertyItem(item));
                                _store.dispatch(UpdateLLActiveTenantPropertyItem(item));

                                await finnleviewcallapi(item!.ID.toString());
                              },
                              propertylist: ArchiveState.propertylist,
                              propertyValue: ArchiveState.propertyValue,
                            ),
                          SizedBox(
                            width: 10,
                          ),
                          _addNewLead(ArchiveState)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (Prefs.getBool(PrefsName.IsApplyFilterList) || Prefs.getBool(PrefsName.IsApplyFilterFunnel))
                            InkWell(
                              onTap: () {
                                ClearFilter(ArchiveState);
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
                          _togglebutton(ArchiveState),
                          SizedBox(
                            width: 10,
                          ),
                          _actionPopup(ArchiveState)
                        ],
                      ),
                    ],
                  ),
                ),
                ArchiveState.selecttoggle == 0 ? _tableview(ArchiveState) : _funnelview(ArchiveState)
              ],
            );
          }),
    );
  }

  Widget _addNewLead(LandLordTenancyArchiveState ArchiveState) {
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

                if (ArchiveState.selecttoggle == 0) {
                  /*await ApiManager().getTenancyApplicationList(
                      context, Prefs.getString(PrefsName.OwnerID));*/
                } else {
                  if (ArchiveState.propertyValue != null) {
                    await finnleviewcallapi(ArchiveState.propertyValue!.ID.toString());
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

  Widget _togglebutton(LandLordTenancyArchiveState ArchiveState) {
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
        initialLabelIndex: ArchiveState.selecttoggle,
        activeBgColor: [myColor.text_color],
        activeFgColor: Colors.white,
        inactiveBgColor: Colors.white,
        inactiveFgColor: myColor.text_color,
        labels: [GlobleString.LL_ListView, GlobleString.LL_FunnelView],
        onToggle: (index) async {
          if (ArchiveState.selecttoggle != index) {
            if (index == 0) {
              archivecallApi();
            } else {
              if (ArchiveState.propertyValue != null) {
                await finnleviewcallapi(ArchiveState.propertyValue!.ID.toString());
              }
            }
            await Prefs.setBool(PrefsName.IsApplyFilterFunnel, false);
            await Prefs.setBool(PrefsName.IsApplyFilterList, false);
            _store.dispatch(UpdateArchiveToggle(index));
          }
        },
        totalSwitches: 2,
      ),
    );
  }

  Widget _actionPopup(LandLordTenancyArchiveState ArchiveState) {
    return Container(
      height: 32,
      width: 30,
      child: PopupMenuButton(
          onSelected: (value) {
            if (value == 1) {
              if (ArchiveState.selecttoggle == 0) {
                _showFilterOverlayView(context, ArchiveState);
              } else {
                if (ArchiveState.propertyValue != null) {
                  _showFilterOverlayView(context, ArchiveState);
                } else {
                  ToastUtils.showCustomToast(context, GlobleString.Blank_funnel, false);
                }
              }
            } else if (value == 2) {
              if (ArchiveState.selecttoggle == 0) {
                if (ArchiveState.filterarchiveleadlist != null && ArchiveState.filterarchiveleadlist.length > 0) {
                  createTableDataCSVFile(ArchiveState);
                } else {
                  ToastUtils.showCustomToast(context, GlobleString.Blank_export, false);
                }
              } else {
                if (ArchiveState.propertyValue != null) {
                  CustomeWidget.FunnelDataCSVFile(context, ArchiveState.propertyValue!.ID.toString());
                } else {
                  ToastUtils.showCustomToast(context, GlobleString.Blank_funnel, false);
                }
              }
            } else if (value == 3) {
              if (ArchiveState.propertyValue != null) {
                loader = Helper.overlayLoader(context);
                Overlay.of(context)!.insert(loader);

                ApiManager().AllArchivePropertyWise(context, ArchiveState.propertyValue!.ID.toString(), (status, responce) async {
                  if (status) {
                    await finnleviewcallapi(ArchiveState.propertyValue!.ID.toString());
                    loader.remove();
                  } else {
                    loader.remove();
                    ToastUtils.showCustomToast(context, GlobleString.Error1, false);
                  }
                });
              } else {
                ToastUtils.showCustomToast(context, GlobleString.Blank_funnel, false);
              }
            } else if (value == 4) {
              dailogAllRestore();
            }
          },
          child: Container(
            height: 40,
            width: 20,
            margin: EdgeInsets.only(right: 5),
            child: Icon(Icons.more_vert),
          ),
          itemBuilder: (context) {
            return ArchiveState.selecttoggle == 0
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
                    PopupMenuItem(
                      value: 4,
                      child: Text(
                        GlobleString.AllRestore,
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
          }),
    );
  }

  Widget _tableview(LandLordTenancyArchiveState ArchiveState) {
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
          ArchivedAppHeader(
            onPressedSortRating: () async {
              await updateOtherSortingValue(3);
              List<TenancyApplication> lalist = ArchiveState.filterarchiveleadlist;
              if (!ArchiveState.isRatingSort) {
                lalist.sort((a, b) => b.rating.toString().compareTo(a.rating.toString()));
                _store.dispatch(UpdateArchiveisRatingSort(true));
              } else {
                lalist.sort((a, b) => a.rating.toString().compareTo(b.rating.toString()));
                _store.dispatch(UpdateArchiveisRatingSort(false));
              }
              _store.dispatch(UpdateArchiveFilterArchiveleadlist(lalist));
            },
            onPressedSortName: () async {
              await updateOtherSortingValue(1);
              List<TenancyApplication> lalist = ArchiveState.filterarchiveleadlist;
              if (!ArchiveState.isNameSort) {
                lalist.sort((a, b) => a.applicantName!.toLowerCase().compareTo(b.applicantName!.toLowerCase()));
                _store.dispatch(UpdateArchiveisNameSort(true));
              } else {
                lalist.sort((a, b) => b.applicantName!.toLowerCase().compareTo(a.applicantName!.toLowerCase()));
                _store.dispatch(UpdateArchiveisNameSort(false));
              }
              _store.dispatch(UpdateArchiveFilterArchiveleadlist(lalist));
            },
            onPressedSortProperty: () async {
              await updateOtherSortingValue(2);
              List<TenancyApplication> lalist = ArchiveState.filterarchiveleadlist;
              if (!ArchiveState.isPropertySort) {
                lalist.sort((a, b) => a.propertyName!.toLowerCase().compareTo(b.propertyName!.toLowerCase()));
                _store.dispatch(UpdateArchiveisPropertySort(true));
              } else {
                lalist.sort((a, b) => b.propertyName!.toLowerCase().compareTo(a.propertyName!.toLowerCase()));
                _store.dispatch(UpdateArchiveisPropertySort(false));
              }
              _store.dispatch(UpdateArchiveFilterArchiveleadlist(lalist));
            },
            onPressedSortSent: () async {
              await updateOtherSortingValue(4);
              List<TenancyApplication> lalist = ArchiveState.filterarchiveleadlist;
              if (!ArchiveState.isDateSentSort) {
                lalist.sort((a, b) => b.applicationSentDate!.toLowerCase().compareTo(a.applicationSentDate!.toLowerCase()));
                _store.dispatch(UpdateArchiveisDateSentSort(true));
              } else {
                lalist.sort((a, b) => a.applicationSentDate!.toLowerCase().compareTo(b.applicationSentDate!.toLowerCase()));
                _store.dispatch(UpdateArchiveisDateSentSort(false));
              }
              _store.dispatch(UpdateArchiveFilterArchiveleadlist(lalist));
            },
            onPressedSortReceive: () async {
              await updateOtherSortingValue(5);
              List<TenancyApplication> lalist = ArchiveState.filterarchiveleadlist;
              if (!ArchiveState.isDateReceiveSort) {
                lalist.sort((a, b) => b.applicationReceivedDate!.toLowerCase().compareTo(a.applicationReceivedDate!.toLowerCase()));
                _store.dispatch(UpdateArchiveisDateReceiveSort(true));
              } else {
                lalist.sort((a, b) => a.applicationReceivedDate!.toLowerCase().compareTo(b.applicationReceivedDate!.toLowerCase()));
                _store.dispatch(UpdateArchiveisDateReceiveSort(false));
              }
              _store.dispatch(UpdateArchiveFilterArchiveleadlist(lalist));
            },
            onPressedSortAppStatus: () async {
              await updateOtherSortingValue(6);
              List<TenancyApplication> lalist = ArchiveState.filterarchiveleadlist;

              if (!ArchiveState.isAppStatusSort) {
                lalist.sort((a, b) => a.applicationStatus!.EnumDetailID.compareTo(b.applicationStatus!.EnumDetailID));
                _store.dispatch(UpdateArchiveisAppStatusSort(true));
              } else {
                lalist.sort((a, b) => b.applicationStatus!.EnumDetailID.compareTo(a.applicationStatus!.EnumDetailID));

                //lalist.reversed.toList();
                _store.dispatch(UpdateArchiveisAppStatusSort(false));
              }

              _store.dispatch(UpdateArchiveFilterArchiveleadlist(lalist));
            },
          ),
          _tableItem(ArchiveState),
        ],
      ),
    );
  }

  Widget _tableItem(LandLordTenancyArchiveState ArchiveState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ArchiveState.isloding
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
            : ArchiveState.filterarchiveleadlist != null && ArchiveState.filterarchiveleadlist.length > 0
                ? Expanded(
                    child: ArchivedAppItem(
                      OnRefresh: () {},
                      listdata1: ArchiveState.filterarchiveleadlist,
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

  Widget _funnelview(LandLordTenancyArchiveState ArchiveState) {
    return FunnelViewScreen(
      propertyValue: ArchiveState.propertyValue,
    );
  }

  ClearFilter(LandLordTenancyArchiveState ArchiveState) async {
    await Prefs.setBool(PrefsName.IsApplyFilterList, false);
    await Prefs.setBool(PrefsName.IsApplyFilterFunnel, false);

    if (ArchiveState.selecttoggle == 0) {
      archivecallApi();
    } else {
      if (ArchiveState.propertyValue != null) {
        await finnleviewcallapi(ArchiveState.propertyValue!.ID.toString());
      }
    }

    _store.dispatch(UpdateArchiveToggle(ArchiveState.selecttoggle));
  }

  dailogAllRestore() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialogBox(
          title: GlobleString.ARC_Restore_title,
          positiveText: GlobleString.ARC_Restore_btn_yes,
          negativeText: GlobleString.ARC_Restore_btn_No,
          onPressedYes: () {
            Navigator.of(context1).pop();

            loader = Helper.overlayLoader(context);
            Overlay.of(context)!.insert(loader);

            ApiManager().AllArchiveRestore(context, Prefs.getString(PrefsName.OwnerID), (status, responce) async {
              if (status) {
                await archivecallApi();
                loader.remove();
              } else {
                loader.remove();
                ToastUtils.showCustomToast(context, GlobleString.Error1, false);
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

  updateOtherSortingValue(int flag) {
    if (flag != 1) {
      _store.dispatch(UpdateArchiveisNameSort(false));
    }
    if (flag != 2) {
      _store.dispatch(UpdateArchiveisPropertySort(false));
    }
    if (flag != 3) {
      _store.dispatch(UpdateArchiveisRatingSort(false));
    }
    if (flag != 4) {
      _store.dispatch(UpdateArchiveisDateSentSort(false));
    }
    if (flag != 5) {
      _store.dispatch(UpdateArchiveisDateReceiveSort(false));
    }
    if (flag != 6) {
      _store.dispatch(UpdateArchiveisAppStatusSort(false));
    }

    RefreshstartTime();
  }

  RefreshstartTime() async {
    _store.dispatch(UpdateArchiveisloding(true));

    new Timer(Duration(milliseconds: 5), updateLoading);
  }

  updateLoading() {
    _store.dispatch(UpdateArchiveisloding(false));
  }

  _showFilterOverlayView(BuildContext context, LandLordTenancyArchiveState ArchiveState) {
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
                propertyValue: ArchiveState.propertyValue,
                isfunnelview: ArchiveState.selecttoggle == 1,
                onclose: () {
                  overlayEntry.remove();
                },
                onApply: (String json, bool isclear) async {
                  overlayEntry.remove();
                  if (ArchiveState.selecttoggle == 0) {
                    if (isclear) {
                      archivecallApi();
                    } else {
                      FilterApplyLeaseCallApi();
                    }
                  } else {
                    if (isclear) {
                      if (ArchiveState.propertyValue != null) {
                        await finnleviewcallapi(ArchiveState.propertyValue!.ID.toString());
                      }
                    } else {
                      _store.dispatch(UpdateArchiveToggle(1));

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

  createTableDataCSVFile(LandLordTenancyArchiveState ArchiveState) async {
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

    for (var data in ArchiveState.filterarchiveleadlist.toSet()) {
      List row = [];
      row.add(data.id);
      row.add(data.applicantName);
      row.add(data.propertyName);
      row.add(data.rating.toString());
      row.add(data.applicationSentDate);
      row.add(data.applicationReceivedDate);
      row.add(data.applicationStatus != null ? data.applicationStatus!.displayValue.toString() : "");

      csvList.add(row);
    }

    csv = const ListToCsvConverter().convert(csvList);

    String filename = "ArchiveLeads_" + DateFormat("ddMMyyyy_hhmmss").format(DateTime.now()).toString() + ".csv";

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
