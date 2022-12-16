import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/notification_type.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/maintenance_action/add_maintenance_action.dart';
import 'package:silverhome/domain/actions/maintenance_action/edit_maintenance_action.dart';
import 'package:silverhome/domain/actions/maintenance_action/landlord_maintenance_action.dart';
import 'package:silverhome/domain/entities/maintenace_notification.dart';
import 'package:silverhome/domain/entities/maintenance_data.dart';
import 'package:silverhome/domain/entities/maintenance_details.dart';
import 'package:silverhome/presentation/models/maintenance/landlord_maintenance_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/dsq_query.dart';
import 'package:silverhome/tablayer/query_filter.dart';
import 'package:silverhome/tablayer/tabclass.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/alert/alert_dialogbox.dart';
import 'package:silverhome/widget/basic_tenant/maintenace_dialogbox.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/landlord/maintenance_dialog/maintenace_addnewrequest_dialogbox.dart';
import 'package:silverhome/widget/landlord/maintenance_dialog/maintenace_edit_request.dart';
import 'package:silverhome/widget/landlord/maintenance_dialog/sharelink_dialogbox.dart';
import 'package:silverhome/widget/landlord/maintenance_request_table/requests_header.dart';
import 'package:silverhome/widget/landlord/maintenance_request_table/requests_item.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

class MaintenanceRequestsScreen extends StatefulWidget {
  @override
  _MaintenanceRequestsState createState() => _MaintenanceRequestsState();
}

class _MaintenanceRequestsState extends State<MaintenanceRequestsScreen> {
  double height = 0, width = 0;
  final _store = getIt<AppStore>();

  late OverlayEntry loader;
  late Timer? _timer = null;

  @override
  void initState() {
    updatecount();
    init();
    super.initState();
  }

  void updatecount() {
    _store.dispatch(UpdateLLMaintenance_status_New(0));
    _store.dispatch(UpdateLLMaintenance_status_Approved(0));
    _store.dispatch(UpdateLLMaintenance_status_WorkinProgress(0));
    _store.dispatch(UpdateLLMaintenance_status_Resolved(0));
    _store.dispatch(UpdateLLMaintenance_status_Paid(0));
    ApiManager().getMaintenaceCount(context, (status, responce) {});
  }

  void init() async {
    await Prefs.init();
    updateState();
    apimanager("", 1, "ID", 0, 0);
  }

  updateState() async {
    _store.dispatch(UpdateLLMaintenance_SearchText(""));
    _store.dispatch(UpdateLLMaintenance_isPropertyNameSort(false));
    await updateSortingFeild(1);
    _store.dispatch(UpdateLLMaintenance_PropertyNameSortAcsDes(0));
    _store.dispatch(UpdateLLMaintenance_RequestNameSortAcsDes(0));
    _store.dispatch(UpdateLLMaintenance_CategorySortAcsDes(0));
    _store.dispatch(UpdateLLMaintenance_PrioritySortAcsDes(0));
    _store.dispatch(UpdateLLMaintenance_DateCreatedSortAcsDes(0));
    _store.dispatch(UpdateLLMaintenance_CreatedBySortAcsDes(0));
    _store.dispatch(UpdateLLMaintenance_StatusSortAcsDes(0));
    _store.dispatch(UpdateLLMaintenance_EditRightsSortAcsDes(0));
  }

  apimanager(String search, int pageNo, String SortField, int saquence,
      int ftime) async {
    MaintenanceListReqtokens reqtokens = MaintenanceListReqtokens();
    reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    reqtokens.Name = search ?? "";

    Pager pager = Pager(pageNo: pageNo, noOfRecords: Helper.noofrecored);

    List<Sort> sortinglist = [];
    Sort sort = Sort();
    sort.fieldId = SortField;
    sort.sortSequence = saquence;
    sortinglist.add(sort);

    DSQQuery dsqQuery = DSQQuery();
    dsqQuery.dsqid = Weburl.DSQ_landlord_MaintenanceList;
    dsqQuery.loadLookUpValues = true;
    dsqQuery.loadRecordInfo = false;
    dsqQuery.maintenanceListReqtokens = reqtokens;
    dsqQuery.pager = pager;
    dsqQuery.sort = sortinglist;

    String filterjson = jsonEncode(dsqQuery);

    Helper.Log("Property", filterjson);
    _store.dispatch(UpdateLLMaintenance_isloding(true));
    _store.dispatch(UpdateLL_maintenancedatalist(<MaintenanceData>[]));
    _store.dispatch(UpdateLLMaintenance_SearchText(search));
    await ApiManager().getMaintenaceList(context, filterjson, ftime);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      color: myColor.bg_color1,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ConnectState<LandlordMaintenanceState>(
            map: (state) => state.landlordMaintenanceState,
            where: notIdentical,
            builder: (landlordMaintenanceState) {
              return Column(
                children: [
                  _statusView(landlordMaintenanceState!),
                  _centerView(landlordMaintenanceState),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _statusView(LandlordMaintenanceState landlordMaintenanceState) {
    return Container(
      child: Row(
        children: [
          CustomeWidget.PropertyStutas(
              landlordMaintenanceState.status_New.toString(),
              GlobleString.LMR_status_New),
          CustomeWidget.PropertyStutas(
              landlordMaintenanceState.status_Approved.toString(),
              GlobleString.LMR_status_Approved),
          CustomeWidget.PropertyStutas(
              landlordMaintenanceState.status_WorkinProgress.toString(),
              GlobleString.LMR_status_WorkinProgress),
          CustomeWidget.PropertyStutas(
              landlordMaintenanceState.status_Resolved.toString(),
              GlobleString.LMR_status_Resolved),
          CustomeWidget.PropertyStutas(
              landlordMaintenanceState.status_Paid.toString(),
              GlobleString.LMR_status_Paid),
        ],
      ),
    );
  }

  Widget _centerView(LandlordMaintenanceState landlordMaintenanceState) {
    return Container(
      width: width,
      height: height - 95,
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: myColor.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: myColor.application_boreder, width: 1),
      ),
      child: Column(
        children: [
          Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (landlordMaintenanceState.isloding &&
                        landlordMaintenanceState.SearchText == "")
                      Container(
                        width: 260,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: myColor.TA_Border,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                GlobleString.LL_Search,
                                style: MyStyles.Medium(14, myColor.hintcolor),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 8, right: 5),
                              child: Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        width: 260,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: myColor.TA_Border,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                initialValue:
                                    landlordMaintenanceState.SearchText,
                                onChanged: (value) async {
                                  if (_timer != null) {
                                    _timer!.cancel();
                                  }
                                  _timer = Timer.periodic(
                                      const Duration(seconds: 2), (timer) {
                                    _store.dispatch(
                                        UpdateLLMaintenance_isloding(true));
                                    _store.dispatch(
                                        UpdateLL_maintenancedatalist(
                                            <MaintenanceData>[]));
                                    updateState();
                                    apimanager(value, 1, "ID", 0, 0);
                                    _timer!.cancel();
                                  });
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle:
                                      MyStyles.Medium(14, myColor.hintcolor),
                                  contentPadding: const EdgeInsets.all(10),
                                  isDense: true,
                                  hintText: GlobleString.LL_Search,
                                ),
                                style: MyStyles.Medium(14, myColor.text_color),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 8, right: 5),
                              child: Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(width: 10.0),
                    _addNewRequest(),
                  ],
                ),
                Row(
                  children: [_actionPopup(landlordMaintenanceState)],
                ),
              ],
            ),
          ),
          _tableview(landlordMaintenanceState)
        ],
      ),
    );
  }

  Widget _addNewRequest() {
    return InkWell(
      onTap: () async {
        addnewRequets();
      },
      child: CustomeWidget.AddNewButton(GlobleString.LMR_Add_New_Request),
    );
  }

  Widget _actionPopup(LandlordMaintenanceState landlordMaintenanceState) {
    return Container(
      height: 32,
      width: 30,
      child: PopupMenuButton(
        onSelected: (value) async {
          MaintenanceListReqtokens reqtokens = MaintenanceListReqtokens();
          reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
          reqtokens.Name = landlordMaintenanceState.SearchText != null
              ? landlordMaintenanceState.SearchText
              : "";

          List<Sort> sortinglist = [];
          Sort sort = Sort();
          if (landlordMaintenanceState.SearchText != null &&
              landlordMaintenanceState.SearchText.isNotEmpty) {
            sort.fieldId = "ID";
            sort.sortSequence = 0;
          } else {
            if (landlordMaintenanceState.isPropertyNameSort) {
              sort.fieldId = "Prop_ID.PropertyName";
              sort.sortSequence =
                  landlordMaintenanceState.PropertyNameSortAcsDes;
            } else if (landlordMaintenanceState.isRequestNameSort) {
              sort.fieldId = "RequestName";
              sort.sortSequence =
                  landlordMaintenanceState.RequestNameSortAcsDes;
            } else if (landlordMaintenanceState.isCategorySort) {
              sort.fieldId = "Category";
              sort.sortSequence = landlordMaintenanceState.CategorySortAcsDes;
            } else if (landlordMaintenanceState.isPrioritySort) {
              sort.fieldId = "Priority";
              sort.sortSequence = landlordMaintenanceState.PrioritySortAcsDes;
            } else if (landlordMaintenanceState.isDateCreatedSort) {
              sort.fieldId = "Date_Created";
              sort.sortSequence =
                  landlordMaintenanceState.DateCreatedSortAcsDes;
            } else if (landlordMaintenanceState.isCreatedBySort) {
              sort.fieldId = "CreatedBy";
              sort.sortSequence = landlordMaintenanceState.CreatedBySortAcsDes;
            } else if (landlordMaintenanceState.isStatusSort) {
              sort.fieldId = "Status";
              sort.sortSequence = landlordMaintenanceState.StatusSortAcsDes;
            } else if (landlordMaintenanceState.isEditRightsSort) {
              sort.fieldId = "IsLock";
              sort.sortSequence = landlordMaintenanceState.EditRightsSortAcsDes;
            } else {
              sort.fieldId = "ID";
              sort.sortSequence = 0;
            }
          }
          sortinglist.add(sort);

          DSQQuery dsqQuery = DSQQuery();
          dsqQuery.dsqid = Weburl.DSQ_landlord_MaintenanceList;
          dsqQuery.loadLookUpValues = true;
          dsqQuery.loadRecordInfo = false;
          dsqQuery.maintenanceListReqtokens = reqtokens;
          dsqQuery.sort = sortinglist;

          String filterjson = jsonEncode(dsqQuery);

          Helper.Log("Property", filterjson);

          await ApiManager().getAllMaintenaceListExportCSV(context, filterjson);
        },
        child: Container(
          height: 40,
          width: 20,
          margin: const EdgeInsets.only(right: 5),
          child: const Icon(Icons.more_vert),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(
              "Export",
              style: MyStyles.Medium(14, myColor.text_color),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableview(LandlordMaintenanceState landlordMaintenanceState) {
    return Container(
      width: width,
      height: height - 167,
      margin: const EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          //color: Hexcolor("#16C395"),
          border: Border.all(color: Colors.transparent, width: 1)),
      child: Column(
        children: [
          tableHeader(landlordMaintenanceState),
          tableItem(landlordMaintenanceState),
          if (landlordMaintenanceState.maintenancedatalist != null &&
              landlordMaintenanceState.maintenancedatalist.length > 0)
            tablefooter(landlordMaintenanceState)
        ],
      ),
    );
  }

  Widget tableHeader(LandlordMaintenanceState landlordMaintenanceState) {
    return RequestsHeader(
      onPressedSortProperty: () {
        _store.dispatch(UpdateLLMaintenance_isPropertyNameSort(true));
        updateOtherSortingValue(1, landlordMaintenanceState);
      },
      onPressedSortRequestName: () {
        _store.dispatch(UpdateLLMaintenance_isRequestNameSort(true));
        updateOtherSortingValue(2, landlordMaintenanceState);
      },
      onPressedSortCategory: () {
        _store.dispatch(UpdateLLMaintenance_isCategorySort(true));
        updateOtherSortingValue(3, landlordMaintenanceState);
      },
      onPressedSortPriority: () {
        _store.dispatch(UpdateLLMaintenance_isPrioritySort(true));
        updateOtherSortingValue(4, landlordMaintenanceState);
      },
      onPressedSortDateCreated: () {
        _store.dispatch(UpdateLLMaintenance_isDateCreatedSort(true));
        updateOtherSortingValue(5, landlordMaintenanceState);
      },
      onPressedSortCreatedBy: () {
        _store.dispatch(UpdateLLMaintenance_isCreatedBySort(true));
        updateOtherSortingValue(6, landlordMaintenanceState);
      },
      onPressedSortStatus: () {
        _store.dispatch(UpdateLLMaintenance_isStatusSort(true));
        updateOtherSortingValue(7, landlordMaintenanceState);
      },
      onPressedSortLock: () {
        _store.dispatch(UpdateLLMaintenance_isEditRightsSort(true));
        updateOtherSortingValue(8, landlordMaintenanceState);
      },
    );
  }

  Widget tableItem(LandlordMaintenanceState landlordMaintenanceState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        landlordMaintenanceState.isloding
            ? Expanded(
                child: Container(
                  width: width,
                  height: height - 229,
                  margin: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text(
                    "Please wait.....",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: MyStyles.Medium(18, myColor.Circle_main),
                  ),
                ),
              )
            : landlordMaintenanceState.maintenancedatalist != null &&
                    landlordMaintenanceState.maintenancedatalist.length > 0
                ? Expanded(
                    child: RequestsItem(
                      listdata1: landlordMaintenanceState.maintenancedatalist,
                      onPressView: (MaintenanceData maintenanceData, int pos) {
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

                                loader = Helper.overlayLoader(context);
                                Overlay.of(context)!.insert(loader);
                                await clearEditMaintenanceStateData();

                                ApiManager().maintenanceDetailsApiCallback(
                                    context, mid, 1,
                                    (status, responce, details) async {
                                  if (status) {
                                    loader.remove();
                                    editRequest(details!);
                                  } else {
                                    loader.remove();
                                    Helper.Log("respoce", responce);
                                  }
                                });
                              },
                              showEdit: true,
                              mID: maintenanceData.ID,
                            );
                          },
                        );
                      },
                      onPressShare: (MaintenanceData maintenanceData, int pos) {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black45,
                          useSafeArea: true,
                          barrierDismissible: false,
                          builder: (BuildContext context1) {
                            return ShareLinkDialogBox(
                              mid: maintenanceData.ID.toString(),
                              onPressedNo: () {
                                Navigator.of(context1).pop();
                              },
                            );
                          },
                        );
                      },
                      onPresseEdit:
                          (MaintenanceData maintenanceData, int pos) async {
                        loader = Helper.overlayLoader(context);
                        Overlay.of(context)!.insert(loader);
                        await clearEditMaintenanceStateData();

                        ApiManager().maintenanceDetailsApiCallback(
                            context, maintenanceData.ID!, 1,
                            (status, responce, details) async {
                          if (status) {
                            loader.remove();
                            editRequest(details!);
                          } else {
                            loader.remove();
                            Helper.Log("respoce", responce);
                          }
                        });
                      },
                      onPresseExport:
                          (MaintenanceData maintenanceData, int pos) {
                        loader = Helper.overlayLoader(context);
                        Overlay.of(context)!.insert(loader);
                        ApiManager().maintenanceDetailsApiCallback(
                            context, maintenanceData.ID!, 0,
                            (status, responce, details) async {
                          if (status) {
                            await CustomeWidget.MaintenancePdfgenerate(
                                context, details!);
                            loader.remove();
                          } else {
                            loader.remove();
                            Helper.Log("respoce", responce);
                          }
                        });
                      },
                      onPresseDuplicat:
                          (MaintenanceData maintenanceData, int pos) {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black45,
                          useSafeArea: true,
                          barrierDismissible: false,
                          builder: (BuildContext context1) {
                            return AlertDialogBox(
                              title: GlobleString.maintenace_dupliacate_title,
                              negativeText:
                                  GlobleString.maintenace_dupliacate_NO,
                              positiveText:
                                  GlobleString.maintenace_dupliacate_yes,
                              onPressedYes: () {
                                Navigator.of(context1).pop();
                                duplicateMaintenance(
                                    maintenanceData, landlordMaintenanceState);
                              },
                              onPressedNo: () {
                                Navigator.of(context1).pop();
                              },
                            );
                          },
                        );
                      },
                      onPresseCallApi: () {
                        init();
                        //paginationCall(landlordMaintenanceState, landlordMaintenanceState.pageNo);
                      },
                      onPresseDelete:
                          (MaintenanceData maintenanceData, int pos) {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black45,
                          useSafeArea: true,
                          barrierDismissible: false,
                          builder: (BuildContext context1) {
                            return AlertDialogBox(
                              title: GlobleString.maintenace_delete_title,
                              negativeText: GlobleString.maintenace_delete_NO,
                              positiveText: GlobleString.maintenace_delete_yes,
                              onPressedYes: () {
                                Navigator.of(context1).pop();
                                deleteMaintenance(
                                    maintenanceData, landlordMaintenanceState);
                              },
                              onPressedNo: () {
                                Navigator.of(context1).pop();
                              },
                            );
                          },
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: Container(
                      width: width,
                      height: height - 229,
                      margin: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text(
                        GlobleString.maintenence_data_not_found,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: MyStyles.Medium(18, myColor.tabel_msg),
                      ),
                    ),
                  )
      ],
    );
  }

  Widget tablefooter(LandlordMaintenanceState landlordMaintenanceState) {
    return Container(
      height: 40,
      color: myColor.TA_table_header,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              "Page No.",
              style: MyStyles.Medium(14, myColor.text_color),
            ),
          ),
          Container(
            height: 30,
            width: 80,
            margin: const EdgeInsets.only(left: 10, right: 20),
            alignment: Alignment.center,
            child: DropdownSearch<String>(
              mode: Mode.MENU,
              textstyle: MyStyles.Medium(14, myColor.black),
              hint: "Select page",
              defultHeight: Helper.PagingRecord(
                                  landlordMaintenanceState.totalRecord)
                              .length *
                          35 >
                      250
                  ? 250
                  : Helper.PagingRecord(landlordMaintenanceState.totalRecord)
                          .length *
                      35,
              selectedItem: landlordMaintenanceState.pageNo.toString(),
              items: Helper.PagingRecord(landlordMaintenanceState.totalRecord),
              showSearchBox: false,
              isFilteredOnline: true,
              onChanged: (value) {
                _store.dispatch(
                    UpdateLLMaintenance_pageNo(int.parse(value.toString())));
                paginationCall(
                    landlordMaintenanceState, int.parse(value.toString()));
              },
            ),
          )
        ],
      ),
    );
  }

  addnewRequets() async {
    clearAddMaintenanceStateData();

    List<SystemEnumDetails> MaintenanceStatuslist =
        QueryFilter().PlainValues(eSystemEnums().Maintenance_Status);
    List<SystemEnumDetails> MaintenanceCategorylist =
        QueryFilter().PlainValues(eSystemEnums().Maintenance_Category);

    _store.dispatch(UpdateMAR_MaintenanceStatuslist(MaintenanceStatuslist));
    _store.dispatch(UpdateMAR_MaintenanceCategorylist(MaintenanceCategorylist));

    _store.dispatch(UpdateMER_PropertyDropDatalist([]));
    await ApiManager()
        .getPropertyMaintenanceList(context, Prefs.getString(PrefsName.OwnerID),
            (status, responce, errorlist) {
      if (status) {
        _store.dispatch(UpdateMAR_PropertyDropDatalist(errorlist));
      } else {
        _store.dispatch(UpdateMER_PropertyDropDatalist([]));
      }
    });

    ApiManager().getCountryList(context, (status, responce, errorlist) {
      if (status) {
        _store.dispatch(UpdateMAR_countrydatalist(errorlist));
      }
    });

    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return MaintenanceAddNewRequestDialogBox(
          onPressedSave: () async {
            Navigator.of(context1).pop();
            init();
          },
          onPressedClose: () {
            Navigator.of(context1).pop();
          },
        );
      },
    );
  }

  clearAddMaintenanceStateData() {
    _store.dispatch(UpdateMAR_requestName(""));
    _store.dispatch(UpdateMAR_priority(0));
    _store.dispatch(UpdateMAR_description(""));
    _store.dispatch(UpdateMAR_fileobjectlist([]));
    _store.dispatch(UpdateMAR_vendordatalist([]));
    _store.dispatch(UpdateMAR_MaintenanceStatuslist([]));
    _store.dispatch(UpdateMAR_MaintenanceCategorylist([]));
    _store.dispatch(UpdateMAR_PropertyDropDatalist([]));
    _store.dispatch(UpdateMAR_selectStatus(null));
    _store.dispatch(UpdateMAR_selectCategory(null));
    _store.dispatch(UpdateMAR_selectproperty(null));
    _store.dispatch(UpdateMAR_countrydatalist([]));
    _store.dispatch(UpdateMAR_statedatalist([]));
    _store.dispatch(UpdateMAR_citydatalist([]));
    _store.dispatch(UpdateMAR_selectedCity([]));
    _store.dispatch(UpdateMAR_mainvendordatalist([]));
    _store.dispatch(UpdateMAR_filterCategorylist([]));
    _store.dispatch(UpdateMAR_selectedCountry(null));
    _store.dispatch(UpdateMAR_selectedState(null));
  }

  clearEditMaintenanceStateData() {
    _store.dispatch(UpdateMER_mid(""));
    _store.dispatch(UpdateMER_Type_User(0));
    _store.dispatch(UpdateMER_Applicant_ID(""));
    _store.dispatch(UpdateMER_IsLock(false));
    _store.dispatch(UpdateMER_requestName(""));
    _store.dispatch(UpdateMER_priority(0));
    _store.dispatch(UpdateMER_description(""));
    _store.dispatch(UpdateMER_fileobjectlist([]));
    _store.dispatch(UpdateMER_vendordatalist([]));
    _store.dispatch(UpdateMER_MaintenanceStatuslist([]));
    _store.dispatch(UpdateMER_MaintenanceCategorylist([]));
    _store.dispatch(UpdateMER_PropertyDropDatalist([]));
    _store.dispatch(UpdateMER_selectStatus(null));
    _store.dispatch(UpdateMER_selectCategory(null));
    _store.dispatch(UpdateMER_selectproperty(null));
    _store.dispatch(UpdateMER_countrydatalist([]));
    _store.dispatch(UpdateMER_statedatalist([]));
    _store.dispatch(UpdateMER_citydatalist([]));
    _store.dispatch(UpdateMER_selectedCity([]));
    _store.dispatch(UpdateMER_mainvendordatalist([]));
    _store.dispatch(UpdateMER_filterCategorylist([]));
    _store.dispatch(UpdateMER_selectedCountry(null));
    _store.dispatch(UpdateMER_selectedState(null));
    _store.dispatch(UpdateMER_logActivitylist([]));
  }

  editRequest(MaintenanceDetails maintenanceDetails) async {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return MaintenanceEditRequestDialogBox(
          onPressedSave: () async {
            Navigator.of(context1).pop();
            init();
          },
          onPressedClose: () {
            Navigator.of(context1).pop();
          },
        );
      },
    );
  }

  paginationCall(
      LandlordMaintenanceState landlordMaintenanceState, int pageno) {
    if (landlordMaintenanceState.isPropertyNameSort) {
      apimanager(
          landlordMaintenanceState.SearchText,
          pageno,
          "Prop_ID.PropertyName",
          landlordMaintenanceState.PropertyNameSortAcsDes,
          1);
    } else if (landlordMaintenanceState.isRequestNameSort) {
      apimanager(landlordMaintenanceState.SearchText, pageno, "RequestName",
          landlordMaintenanceState.RequestNameSortAcsDes, 1);
    } else if (landlordMaintenanceState.isCategorySort) {
      apimanager(landlordMaintenanceState.SearchText, pageno, "Category",
          landlordMaintenanceState.CategorySortAcsDes, 1);
    } else if (landlordMaintenanceState.isPrioritySort) {
      apimanager(landlordMaintenanceState.SearchText, pageno, "Priority",
          landlordMaintenanceState.PrioritySortAcsDes, 1);
    } else if (landlordMaintenanceState.isDateCreatedSort) {
      apimanager(landlordMaintenanceState.SearchText, pageno, "Date_Created",
          landlordMaintenanceState.DateCreatedSortAcsDes, 1);
    } else if (landlordMaintenanceState.isCreatedBySort) {
      apimanager(landlordMaintenanceState.SearchText, pageno, "CreatedBy",
          landlordMaintenanceState.CreatedBySortAcsDes, 1);
    } else if (landlordMaintenanceState.isStatusSort) {
      apimanager(landlordMaintenanceState.SearchText, pageno, "Status",
          landlordMaintenanceState.StatusSortAcsDes, 1);
    } else if (landlordMaintenanceState.isEditRightsSort) {
      apimanager(landlordMaintenanceState.SearchText, pageno, "IsLock",
          landlordMaintenanceState.EditRightsSortAcsDes, 1);
    } else {
      apimanager(landlordMaintenanceState.SearchText, pageno, "ID", 0, 1);
    }
  }

  updateOtherSortingValue(
      int flag, LandlordMaintenanceState landlordMaintenanceState) {
    updateSortingFeild(flag);

    if (flag == 1) {
      _store.dispatch(UpdateLLMaintenance_PropertyNameSortAcsDes(
          landlordMaintenanceState.PropertyNameSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLMaintenance_RequestNameSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_CategorySortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_PrioritySortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_DateCreatedSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_CreatedBySortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_StatusSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_EditRightsSortAcsDes(0));

      apimanager("", 1, "Prop_ID.PropertyName",
          landlordMaintenanceState.PropertyNameSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 2) {
      _store.dispatch(UpdateLLMaintenance_RequestNameSortAcsDes(
          landlordMaintenanceState.RequestNameSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLMaintenance_PropertyNameSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_CategorySortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_PrioritySortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_DateCreatedSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_CreatedBySortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_StatusSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_EditRightsSortAcsDes(0));

      apimanager("", 1, "RequestName",
          landlordMaintenanceState.RequestNameSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 3) {
      _store.dispatch(UpdateLLMaintenance_CategorySortAcsDes(
          landlordMaintenanceState.CategorySortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLMaintenance_PropertyNameSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_RequestNameSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_PrioritySortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_DateCreatedSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_CreatedBySortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_StatusSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_EditRightsSortAcsDes(0));

      apimanager("", 1, "Category",
          landlordMaintenanceState.CategorySortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 4) {
      _store.dispatch(UpdateLLMaintenance_PrioritySortAcsDes(
          landlordMaintenanceState.PrioritySortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLMaintenance_PropertyNameSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_RequestNameSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_CategorySortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_DateCreatedSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_CreatedBySortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_StatusSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_EditRightsSortAcsDes(0));

      apimanager("", 1, "Priority",
          landlordMaintenanceState.PrioritySortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 5) {
      _store.dispatch(UpdateLLMaintenance_DateCreatedSortAcsDes(
          landlordMaintenanceState.DateCreatedSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLMaintenance_PropertyNameSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_RequestNameSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_CategorySortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_PrioritySortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_CreatedBySortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_StatusSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_EditRightsSortAcsDes(0));

      apimanager("", 1, "Date_Created",
          landlordMaintenanceState.DateCreatedSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 6) {
      _store.dispatch(UpdateLLMaintenance_CreatedBySortAcsDes(
          landlordMaintenanceState.CreatedBySortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLMaintenance_PropertyNameSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_RequestNameSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_CategorySortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_PrioritySortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_DateCreatedSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_StatusSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_EditRightsSortAcsDes(0));

      apimanager("", 1, "CreatedBy",
          landlordMaintenanceState.CreatedBySortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 7) {
      _store.dispatch(UpdateLLMaintenance_StatusSortAcsDes(
          landlordMaintenanceState.StatusSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLMaintenance_PropertyNameSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_RequestNameSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_CategorySortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_PrioritySortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_DateCreatedSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_CreatedBySortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_EditRightsSortAcsDes(0));

      apimanager("", 1, "Status",
          landlordMaintenanceState.StatusSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 8) {
      _store.dispatch(UpdateLLMaintenance_EditRightsSortAcsDes(
          landlordMaintenanceState.EditRightsSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLMaintenance_PropertyNameSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_RequestNameSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_CategorySortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_PrioritySortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_DateCreatedSortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_CreatedBySortAcsDes(0));
      _store.dispatch(UpdateLLMaintenance_StatusSortAcsDes(0));

      apimanager("", 1, "IsLock",
          landlordMaintenanceState.EditRightsSortAcsDes == 1 ? 0 : 1, 0);
    }
  }

  updateSortingFeild(int flag) {
    if (flag != 1) {
      _store.dispatch(UpdateLLMaintenance_isPropertyNameSort(false));
    }
    if (flag != 2) {
      _store.dispatch(UpdateLLMaintenance_isRequestNameSort(false));
    }
    if (flag != 3) {
      _store.dispatch(UpdateLLMaintenance_isCategorySort(false));
    }
    if (flag != 4) {
      _store.dispatch(UpdateLLMaintenance_isPrioritySort(false));
    }
    if (flag != 5) {
      _store.dispatch(UpdateLLMaintenance_isDateCreatedSort(false));
    }
    if (flag != 6) {
      _store.dispatch(UpdateLLMaintenance_isCreatedBySort(false));
    }
    if (flag != 7) {
      _store.dispatch(UpdateLLMaintenance_isStatusSort(false));
    }
    if (flag != 8) {
      _store.dispatch(UpdateLLMaintenance_isEditRightsSort(false));
    }
  }

  duplicateMaintenance(MaintenanceData maintenanceData,
      LandlordMaintenanceState llMaintenanceState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().duplicateMaintenaceworkflow(
        context, maintenanceData.ID.toString(), "1", (error, respoce) async {
      if (error) {
        init();
        ToastUtils.showCustomToast(
            context, GlobleString.maintenace_dupliacate_successfully, true);

        if (respoce != null && respoce.isNotEmpty) {
          await clearEditMaintenanceStateData();

          ApiManager().maintenanceDetailsApiCallback(context, respoce, 1,
              (status, responce, details) async {
            if (status) {
              insertNotification_newRequest(details!);
              editRequest(details);
            } else {
              loader.remove();
              Helper.Log("respoce", responce);
            }
          });
        } else {
          loader.remove();
        }
      } else {
        loader.remove();
        String errormsg1 =
            respoce.replaceAll("One or more errors occurred. (", "");
        String errormsg = errormsg1.replaceAll(")", "");
        ToastUtils.showCustomToast(context, errormsg, false);
      }
    });
  }

  insertNotification_newRequest(MaintenanceDetails maintenanceDetails) {
    List<MaintenanceNotificationData> notificationlist = [];

    MaintenanceNotificationData mn = new MaintenanceNotificationData();
    mn.applicantName = "";
    mn.mid = maintenanceDetails.mID;
    mn.propid = maintenanceDetails.Prop_ID;
    mn.applicantId = maintenanceDetails.Applicant_ID != null &&
            maintenanceDetails.Applicant_ID!.isNotEmpty
        ? maintenanceDetails.Applicant_ID
        : "";
    mn.applicationId = "";
    mn.ownerId = Prefs.getString(PrefsName.OwnerID);
    mn.notificationDate =
        new DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();
    mn.typeOfNotification = NotificationType()
        .getNotificationType(NotificationName.Owner_Maintenance_Requests);
    mn.isRead = false;

    notificationlist.add(mn);

    if (maintenanceDetails.Applicant_ID != null &&
        maintenanceDetails.Applicant_ID!.isNotEmpty) {
      MaintenanceNotificationData mn2 = new MaintenanceNotificationData();
      mn2.applicantName = "";
      mn2.mid = maintenanceDetails.mID;
      mn2.propid = maintenanceDetails.Prop_ID;
      mn2.applicantId = maintenanceDetails.Applicant_ID != null &&
              maintenanceDetails.Applicant_ID!.isNotEmpty
          ? maintenanceDetails.Applicant_ID
          : "";
      mn2.applicationId = "";
      mn2.ownerId = Prefs.getString(PrefsName.OwnerID);
      mn2.notificationDate = new DateFormat("yyyy-MM-dd HH:mm:ss")
          .format(DateTime.now())
          .toString();
      mn2.typeOfNotification = NotificationType()
          .getNotificationType(NotificationName.Tenant_Maintenance_Requests);
      mn2.isRead = false;

      notificationlist.add(mn2);
    }

    insertNotificationCall(notificationlist);
  }

  insertNotificationCall(List<MaintenanceNotificationData> notificationlist) {
    ApiManager().AddMaintenaceNotification(context, notificationlist,
        (error, responce) async {
      if (error) {
        loader.remove();
      } else {
        loader.remove();
      }
    });
  }

  deleteMaintenance(MaintenanceData maintenanceData,
      LandlordMaintenanceState llMaintenanceState) {
    ApiManager().deleteMaintenace(context, maintenanceData.ID!,
        (error, respoce) async {
      if (error) {
        init();
        ToastUtils.showCustomToast(
            context, GlobleString.maintenace_delete_successfully, true);
      } else {
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }
}
