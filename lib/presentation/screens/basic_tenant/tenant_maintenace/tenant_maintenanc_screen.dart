import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/notification_type.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/basictenant_action/tenant_add_maintenance_action.dart';
import 'package:silverhome/domain/actions/basictenant_action/tenant_maintenance_action.dart';
import 'package:silverhome/domain/actions/basictenant_action/tenant_portal_action.dart';
import 'package:silverhome/domain/entities/maintenace_notification.dart';
import 'package:silverhome/domain/entities/maintenance_data.dart';
import 'package:silverhome/domain/entities/maintenance_details.dart';
import 'package:silverhome/presentation/models/basic_tenant/tenant_maintenance_state.dart';
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
import 'package:silverhome/widget/alert_dialogbox.dart';
import 'package:silverhome/widget/basic_tenant/addnewrequest_dialogbox.dart';
import 'package:silverhome/widget/basic_tenant/maintenace_dialogbox.dart';
import 'package:silverhome/widget/basic_tenant/tenant_maintenance/tenant_maintenance_header.dart';
import 'package:silverhome/widget/basic_tenant/tenant_maintenance/tenant_maintenance_item.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

class TenantMaintenancScreen extends StatefulWidget {
  @override
  _TenantMaintenancScreenState createState() => _TenantMaintenancScreenState();
}

class _TenantMaintenancScreenState extends State<TenantMaintenancScreen> {
  double height = 0, width = 0;

  late OverlayEntry loader;
  final _store = getIt<AppStore>();
  late Timer? _timer = null;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    await Prefs.init();
    updateState();
    apimanager("", 1, "ID", 0, 0);
  }

  updateState() async {
    _store.dispatch(UpdateTenantMaintenance_isRequestNameSort(false));
    await updateSortingFeild(1);
    _store.dispatch(UpdateTenantMaintenance_RequestNameSortAcsDes(0));
    _store.dispatch(UpdateTenantMaintenance_CategorySortAcsDes(0));
    _store.dispatch(UpdateTenantMaintenance_PrioritySortAcsDes(0));
    _store.dispatch(UpdateTenantMaintenance_DateCreatedSortAcsDes(0));
    _store.dispatch(UpdateTenantMaintenance_CreatedBySortAcsDes(0));
    _store.dispatch(UpdateTenantMaintenance_StatusSortAcsDes(0));
    _store.dispatch(UpdateTenantMaintenance_EditRightsSortAcsDes(0));
  }

  apimanager(String search, int pageNo, String SortField, int saquence,
      int ftime) async {
    TenantMaintenanceListReqtokens reqtokens =
        new TenantMaintenanceListReqtokens();
    reqtokens.Applicant_ID = Prefs.getString(PrefsName.BT_ApplicantID);
    reqtokens.Name = search != null ? search : "";

    Pager pager = new Pager(pageNo: pageNo, noOfRecords: Helper.noofrecored);

    List<Sort> sortinglist = [];
    Sort sort = new Sort();
    sort.fieldId = SortField;
    sort.sortSequence = saquence;
    sortinglist.add(sort);

    DSQQuery dsqQuery = new DSQQuery();
    dsqQuery.dsqid = Weburl.DSQ_landlord_MaintenanceList;
    dsqQuery.loadLookUpValues = true;
    dsqQuery.loadRecordInfo = false;
    dsqQuery.tenantMaintenanceListReqtokens = reqtokens;
    dsqQuery.pager = pager;
    dsqQuery.sort = sortinglist;

    String filterjson = jsonEncode(dsqQuery);

    Helper.Log("Property", filterjson);
    _store.dispatch(UpdateTenantMaintenance_isloding(true));
    _store.dispatch(UpdateTenant_maintenancedatalist(<MaintenanceData>[]));
    _store.dispatch(UpdateTenantMaintenance_SearchText(search));
    await ApiManager().getTenantMaintenaceList(context, filterjson, ftime);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: height - 20,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: myColor.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: myColor.application_boreder, width: 1),
      ),
      child: ConnectState<TenantMaintenanceState>(
        map: (state) => state.tenantMaintenanceState,
        where: notIdentical,
        builder: (tenantMaintenanceState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (tenantMaintenanceState!.isloding &&
                            tenantMaintenanceState.SearchText == "")
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
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    GlobleString.LL_Search,
                                    style:
                                        MyStyles.Medium(14, myColor.hintcolor),
                                  ),
                                ),
                                Padding(
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
                                new Expanded(
                                  child: TextFormField(
                                    initialValue:
                                        tenantMaintenanceState.SearchText,
                                    onChanged: (value) async {
                                      if (_timer != null) {
                                        _timer!.cancel();
                                      }
                                      _timer = new Timer.periodic(
                                          Duration(seconds: 2), (timer) {
                                        _store.dispatch(
                                            UpdateTenantMaintenance_isloding(
                                                true));
                                        _store.dispatch(
                                            UpdateTenant_maintenancedatalist(
                                                <MaintenanceData>[]));
                                        apimanager(value, 1, "ID", 0, 0);
                                        _timer!.cancel();
                                      });
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: MyStyles.Medium(
                                          14, myColor.hintcolor),
                                      contentPadding: EdgeInsets.all(10),
                                      isDense: true,
                                      hintText: GlobleString.LL_Search,
                                    ),
                                    style:
                                        MyStyles.Medium(14, myColor.text_color),
                                  ),
                                ),
                                Padding(
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
                        SizedBox(
                          width: 10,
                        ),
                        _addNewRequest(tenantMaintenanceState),
                      ],
                    ),
                    Row(
                      children: [_actionPopup(tenantMaintenanceState)],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                child: InkWell(
                  onTap: () {
                    _store.dispatch(UpdateTenantPortalPage(
                        0, GlobleString.NAV_tenant_LeaseDetails));
                  },
                  child: Text(
                    Prefs.getString(PrefsName.BT_PropName),
                    style: MyStyles.Medium(14, myColor.blue),
                  ),
                ),
              ),
              Container(
                child: Text(
                  Prefs.getString(PrefsName.BT_PropAddress),
                  style: MyStyles.Medium(14, myColor.text_color),
                ),
              ),
              _tableview(tenantMaintenanceState),
            ],
          );
        },
      ),
    );
  }

  Widget _addNewRequest(TenantMaintenanceState MaintenanceState) {
    return InkWell(
      onTap: () async {
        addnewRequetsDialog(MaintenanceState);
      },
      child: CustomeWidget.AddNewRequest(),
    );
  }

  Widget _actionPopup(TenantMaintenanceState MaintenanceState) {
    return Container(
      height: 32,
      width: 30,
      child: PopupMenuButton(
        onSelected: (value) async {
          /* if (MaintenanceState.maintenancedatalist != null &&
              MaintenanceState.maintenancedatalist.length > 0) {
            createTableDataCSVFile(MaintenanceState);
          } else {
            ToastUtils.showCustomToast(
                context, GlobleString.Blank_export_maintenace, false);
          }*/

          TenantMaintenanceListReqtokens reqtokens =
              new TenantMaintenanceListReqtokens();
          reqtokens.Applicant_ID = Prefs.getString(PrefsName.BT_ApplicantID);
          reqtokens.Name = MaintenanceState.SearchText != null
              ? MaintenanceState.SearchText
              : "";

          List<Sort> sortinglist = [];
          Sort sort = new Sort();
          if (MaintenanceState.SearchText != null &&
              MaintenanceState.SearchText.isNotEmpty) {
            sort.fieldId = "ID";
            sort.sortSequence = 0;
          } else {
            if (MaintenanceState.isRequestNameSort) {
              sort.fieldId = "RequestName";
              sort.sortSequence = MaintenanceState.RequestNameSortAcsDes;
            } else if (MaintenanceState.isCategorySort) {
              sort.fieldId = "Category";
              sort.sortSequence = MaintenanceState.CategorySortAcsDes;
            } else if (MaintenanceState.isPrioritySort) {
              sort.fieldId = "Priority";
              sort.sortSequence = MaintenanceState.PrioritySortAcsDes;
            } else if (MaintenanceState.isDateCreatedSort) {
              sort.fieldId = "Date_Created";
              sort.sortSequence = MaintenanceState.DateCreatedSortAcsDes;
            } else if (MaintenanceState.isCreatedBySort) {
              sort.fieldId = "CreatedBy";
              sort.sortSequence = MaintenanceState.CreatedBySortAcsDes;
            } else if (MaintenanceState.isStatusSort) {
              sort.fieldId = "Status";
              sort.sortSequence = MaintenanceState.StatusSortAcsDes;
            } else if (MaintenanceState.isEditRightsSort) {
              sort.fieldId = "IsLock";
              sort.sortSequence = MaintenanceState.EditRightsSortAcsDes;
            } else {
              sort.fieldId = "ID";
              sort.sortSequence = 0;
            }
          }
          sortinglist.add(sort);

          DSQQuery dsqQuery = new DSQQuery();
          dsqQuery.dsqid = Weburl.DSQ_landlord_MaintenanceList;
          dsqQuery.loadLookUpValues = true;
          dsqQuery.loadRecordInfo = false;
          dsqQuery.tenantMaintenanceListReqtokens = reqtokens;
          dsqQuery.sort = sortinglist;

          String filterjson = jsonEncode(dsqQuery);

          Helper.Log("Property", filterjson);
          await ApiManager().getTenantMaintenaceListCSV(context, filterjson);
        },
        child: Container(
          height: 40,
          width: 20,
          margin: EdgeInsets.only(right: 5),
          child: Icon(Icons.more_vert),
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

  Widget _tableview(TenantMaintenanceState MaintenanceState) {
    return Container(
      width: width,
      height: height - 136,
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          //color: Hexcolor("#16C395"),
          border: Border.all(color: Colors.transparent, width: 1)),
      child: Column(
        children: [
          tableHeader(MaintenanceState),
          tableItem(MaintenanceState),
          if (MaintenanceState.maintenancedatalist != null &&
              MaintenanceState.maintenancedatalist.length > 0)
            tablefooter(MaintenanceState)
        ],
      ),
    );
  }

  Widget tableHeader(TenantMaintenanceState maintenanceState) {
    return TenantMaintenanceHeader(
      onPressedSortRequestName: () {
        _store.dispatch(UpdateTenantMaintenance_isRequestNameSort(true));
        updateOtherSortingValue(1, maintenanceState);
      },
      onPressedSortCategory: () {
        _store.dispatch(UpdateTenantMaintenance_isCategorySort(true));
        updateOtherSortingValue(2, maintenanceState);
      },
      onPressedSortPriority: () {
        _store.dispatch(UpdateTenantMaintenance_isPrioritySort(true));
        updateOtherSortingValue(3, maintenanceState);
      },
      onPressedSortDateCreated: () {
        _store.dispatch(UpdateTenantMaintenance_isDateCreatedSort(true));
        updateOtherSortingValue(4, maintenanceState);
      },
      onPressedSortCreatedBy: () {
        _store.dispatch(UpdateTenantMaintenance_isCreatedBySort(true));
        updateOtherSortingValue(5, maintenanceState);
      },
      onPressedSortStatus: () {
        _store.dispatch(UpdateTenantMaintenance_isStatusSort(true));
        updateOtherSortingValue(6, maintenanceState);
      },
      onPressedSortEditRights: () {
        _store.dispatch(UpdateTenantMaintenance_isEditRightsSort(true));
        updateOtherSortingValue(7, maintenanceState);
      },
    );
  }

  Widget tableItem(TenantMaintenanceState MaintenanceState) {
    return Row(
      children: [
        MaintenanceState.isloding
            ? Expanded(
                child: Container(
                  width: width,
                  height: height - 218,
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
            : MaintenanceState.maintenancedatalist != null &&
                    MaintenanceState.maintenancedatalist.length > 0
                ? Expanded(
                    child: TenantMaintenanceItem(
                      listdata1: MaintenanceState.maintenancedatalist,
                      onPresseView: (MaintenanceData maintenanceData, int pos) {
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
                                await clearAddMaintenanceStateData();

                                ApiManager().maintenanceDetailsApiCallback(
                                    context, mid, 2,
                                    (status, responce, details) async {
                                  if (status) {
                                    loader.remove();
                                    EditRequetsDialog();
                                  } else {
                                    loader.remove();
                                    Helper.Log("respoce", responce);
                                  }
                                });
                              },
                              showEdit: maintenanceData.IsLock != null
                                  ? !maintenanceData.IsLock!
                                  : true,
                              mID: maintenanceData.ID,
                            );
                          },
                        );
                      },
                      onPresseEdit:
                          (MaintenanceData maintenanceData, int pos) async {
                        loader = Helper.overlayLoader(context);
                        Overlay.of(context)!.insert(loader);
                        await clearAddMaintenanceStateData();

                        ApiManager().maintenanceDetailsApiCallback(
                            context, maintenanceData.ID.toString(), 2,
                            (status, responce, details) async {
                          if (status) {
                            loader.remove();
                            EditRequetsDialog();
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
                      onPresseDuplicate:
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
                                    maintenanceData, MaintenanceState);
                              },
                              onPressedNo: () {
                                Navigator.of(context1).pop();
                              },
                            );
                          },
                        );
                      },
                      onPresseArchive:
                          (MaintenanceData maintenanceData, int pos) {},
                    ),
                  )
                : Expanded(
                    child: Container(
                      width: width,
                      height: height - 218,
                      margin: EdgeInsets.all(10),
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

  Widget tablefooter(TenantMaintenanceState MaintenanceState) {
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
            margin: EdgeInsets.only(left: 10, right: 20),
            alignment: Alignment.center,
            child: DropdownSearch<String>(
              mode: Mode.MENU,
              textstyle: MyStyles.Medium(14, myColor.black),
              hint: "Select page",
              defultHeight: Helper.PagingRecord(MaintenanceState.totalRecord)
                              .length *
                          35 >
                      250
                  ? 250
                  : Helper.PagingRecord(MaintenanceState.totalRecord).length *
                      35,
              selectedItem: MaintenanceState.pageNo.toString(),
              items: Helper.PagingRecord(MaintenanceState.totalRecord),
              showSearchBox: false,
              isFilteredOnline: true,
              onChanged: (value) {
                _store.dispatch(UpdateTenantMaintenance_pageNo(
                    int.parse(value.toString())));
                paginationCall(MaintenanceState, int.parse(value.toString()));
              },
            ),
          )
        ],
      ),
    );
  }

  createTableDataCSVFile(TenantMaintenanceState MaintenanceState) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String csv;
    List<List<dynamic>> csvList = [];

    List csvHeaderTitle = [];
    csvHeaderTitle.add("ID");
    csvHeaderTitle.add(GlobleString.Mant_RequestName);
    csvHeaderTitle.add(GlobleString.Mant_Category);
    csvHeaderTitle.add(GlobleString.Mant_Priority);
    csvHeaderTitle.add(GlobleString.Mant_DateCreated);
    csvHeaderTitle.add(GlobleString.Mant_CreatedBy);
    csvHeaderTitle.add(GlobleString.Mant_Status);
    csvHeaderTitle.add(GlobleString.Mant_EditRights);

    csvList.add(csvHeaderTitle);

    for (var data in MaintenanceState.maintenancedatalist.toSet()) {
      List row = [];
      row.add(data.ID);
      row.add(data.RequestName);
      row.add(data.Category != null ? data.Category!.displayValue : "");
      row.add(data.Priority != null ? data.Priority!.displayValue : "");
      row.add(data.Date_Created != null &&
              data.Date_Created != "0" &&
              data.Date_Created != ""
          ? new DateFormat("dd-MMM-yyyy")
              .format(DateTime.parse(data.Date_Created!))
              .toString()
          : "");
      row.add(data.Type_User == "1" ? data.OwnerName! : data.ApplicantName!);
      row.add(data.Status != null ? data.Status!.displayValue : "");
      row.add(data.IsLock != null ? data.IsLock : false);

      csvList.add(row);
    }

    csv = const ListToCsvConverter().convert(csvList);

    String filename = "Tenant_Maintenance_Request" +
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

  addnewRequetsDialog(TenantMaintenanceState MaintenanceState) async {
    clearAddMaintenanceStateData();

    List<SystemEnumDetails> MaintenanceStatuslist =
        await QueryFilter().PlainValues(eSystemEnums().Maintenance_Status);
    List<SystemEnumDetails> MaintenanceCategorylist =
        await QueryFilter().PlainValues(eSystemEnums().Maintenance_Category);

    for (int i = 0; i < MaintenanceStatuslist.length; i++) {
      SystemEnumDetails details = MaintenanceStatuslist[i];
      if (details.EnumDetailID == 1) {
        _store.dispatch(UpdateTMR_selectStatus(details));
      }
    }

    _store.dispatch(UpdateTMR_IsLock(true));
    _store.dispatch(UpdateTMR_mid(""));
    _store.dispatch(UpdateTMR_Type_User(2));
    _store.dispatch(UpdateTMR_MaintenanceCategorylist(MaintenanceCategorylist));

    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AddNewRequestDialogBox(
          onPressedSave: () {
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
    _store.dispatch(UpdateTMR_mid(""));
    _store.dispatch(UpdateTMR_Type_User(2));
    _store.dispatch(UpdateTMR_requestName(""));
    _store.dispatch(UpdateTMR_IsLock(false));
    _store.dispatch(UpdateTMR_priority(0));
    _store.dispatch(UpdateTMR_description(""));
    _store.dispatch(UpdateTMR_fileobjectlist([]));
    _store.dispatch(UpdateTMR_MaintenanceCategorylist([]));
    _store.dispatch(UpdateTMR_selectStatus(null));
    _store.dispatch(UpdateTMR_selectCategory(null));
  }

  EditRequetsDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AddNewRequestDialogBox(
          onPressedSave: () {
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

  paginationCall(TenantMaintenanceState MaintenanceState, int pageno) {
    if (MaintenanceState.isRequestNameSort) {
      apimanager(MaintenanceState.SearchText, pageno, "RequestName",
          MaintenanceState.RequestNameSortAcsDes, 1);
    } else if (MaintenanceState.isCategorySort) {
      apimanager(MaintenanceState.SearchText, pageno, "Category",
          MaintenanceState.CategorySortAcsDes, 1);
    } else if (MaintenanceState.isPrioritySort) {
      apimanager(MaintenanceState.SearchText, pageno, "Priority",
          MaintenanceState.PrioritySortAcsDes, 1);
    } else if (MaintenanceState.isDateCreatedSort) {
      apimanager(MaintenanceState.SearchText, pageno, "Date_Created",
          MaintenanceState.DateCreatedSortAcsDes, 1);
    } else if (MaintenanceState.isCreatedBySort) {
      //apimanager(MaintenanceState.SearchText, pageno, "Type_User",MaintenanceState.CreatedBySortAcsDes, 1);
      apimanager(MaintenanceState.SearchText, pageno, "CreatedBy",
          MaintenanceState.CreatedBySortAcsDes, 1);
    } else if (MaintenanceState.isStatusSort) {
      apimanager(MaintenanceState.SearchText, pageno, "Status",
          MaintenanceState.StatusSortAcsDes, 1);
    } else if (MaintenanceState.isEditRightsSort) {
      apimanager(MaintenanceState.SearchText, pageno, "IsLock",
          MaintenanceState.EditRightsSortAcsDes, 1);
    } else {
      apimanager(MaintenanceState.SearchText, pageno, "ID", 0, 1);
    }
  }

  updateOtherSortingValue(int flag, TenantMaintenanceState MaintenanceState) {
    updateSortingFeild(flag);

    if (flag == 1) {
      _store.dispatch(UpdateTenantMaintenance_RequestNameSortAcsDes(
          MaintenanceState.RequestNameSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateTenantMaintenance_CategorySortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_PrioritySortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_DateCreatedSortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_CreatedBySortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_StatusSortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_EditRightsSortAcsDes(0));

      apimanager("", 1, "RequestName",
          MaintenanceState.RequestNameSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 2) {
      _store.dispatch(UpdateTenantMaintenance_CategorySortAcsDes(
          MaintenanceState.CategorySortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateTenantMaintenance_RequestNameSortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_PrioritySortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_DateCreatedSortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_CreatedBySortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_StatusSortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_EditRightsSortAcsDes(0));

      apimanager("", 1, "Category",
          MaintenanceState.CategorySortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 3) {
      _store.dispatch(UpdateTenantMaintenance_PrioritySortAcsDes(
          MaintenanceState.PrioritySortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateTenantMaintenance_RequestNameSortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_CategorySortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_DateCreatedSortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_CreatedBySortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_StatusSortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_EditRightsSortAcsDes(0));

      apimanager("", 1, "Priority",
          MaintenanceState.PrioritySortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 4) {
      _store.dispatch(UpdateTenantMaintenance_DateCreatedSortAcsDes(
          MaintenanceState.DateCreatedSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateTenantMaintenance_RequestNameSortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_CategorySortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_PrioritySortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_CreatedBySortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_StatusSortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_EditRightsSortAcsDes(0));

      apimanager("", 1, "Date_Created",
          MaintenanceState.DateCreatedSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 5) {
      _store.dispatch(UpdateTenantMaintenance_CreatedBySortAcsDes(
          MaintenanceState.CreatedBySortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateTenantMaintenance_RequestNameSortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_CategorySortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_PrioritySortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_DateCreatedSortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_StatusSortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_EditRightsSortAcsDes(0));

      //apimanager("", 1, "Type_User",MaintenanceState.CreatedBySortAcsDes == 1 ? 0 : 1, 0);
      apimanager("", 1, "CreatedBy",
          MaintenanceState.CreatedBySortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 6) {
      _store.dispatch(UpdateTenantMaintenance_StatusSortAcsDes(
          MaintenanceState.StatusSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateTenantMaintenance_RequestNameSortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_CategorySortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_PrioritySortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_DateCreatedSortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_CreatedBySortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_EditRightsSortAcsDes(0));

      apimanager(
          "", 1, "Status", MaintenanceState.StatusSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 7) {
      _store.dispatch(UpdateTenantMaintenance_EditRightsSortAcsDes(
          MaintenanceState.EditRightsSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateTenantMaintenance_RequestNameSortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_CategorySortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_PrioritySortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_DateCreatedSortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_CreatedBySortAcsDes(0));
      _store.dispatch(UpdateTenantMaintenance_StatusSortAcsDes(0));

      apimanager("", 1, "IsLock",
          MaintenanceState.EditRightsSortAcsDes == 1 ? 0 : 1, 0);
    }
  }

  updateSortingFeild(int flag) {
    if (flag != 1) {
      _store.dispatch(UpdateTenantMaintenance_isRequestNameSort(false));
    }
    if (flag != 2) {
      _store.dispatch(UpdateTenantMaintenance_isCategorySort(false));
    }
    if (flag != 3) {
      _store.dispatch(UpdateTenantMaintenance_isPrioritySort(false));
    }
    if (flag != 4) {
      _store.dispatch(UpdateTenantMaintenance_isDateCreatedSort(false));
    }
    if (flag != 5) {
      _store.dispatch(UpdateTenantMaintenance_isCreatedBySort(false));
    }
    if (flag != 6) {
      _store.dispatch(UpdateTenantMaintenance_isStatusSort(false));
    }
    if (flag != 7) {
      _store.dispatch(UpdateTenantMaintenance_isEditRightsSort(false));
    }
  }

  duplicateMaintenance(MaintenanceData maintenanceData,
      TenantMaintenanceState MaintenanceState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().duplicateMaintenaceworkflow(
        context, maintenanceData.ID.toString(), "2", (error, respoce) async {
      if (error) {
        //loader.remove();
        init();
        ToastUtils.showCustomToast(
            context, GlobleString.maintenace_dupliacate_successfully, true);

        if (respoce != null && respoce.isNotEmpty) {
          await clearAddMaintenanceStateData();

          ApiManager().maintenanceDetailsApiCallback(context, respoce, 2,
              (status, responce, details) async {
            if (status) {
              //loader.remove();
              insertNotification_newRequest(details!);
              EditRequetsDialog();
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
    mn.propid = Prefs.getString(PrefsName.BT_PropID);
    mn.applicantId = Prefs.getString(PrefsName.BT_ApplicantID);
    mn.applicationId = Prefs.getString(PrefsName.BT_ApplicationId);
    mn.ownerId = Prefs.getString(PrefsName.BT_OwnerID);
    mn.notificationDate =
        new DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();
    mn.typeOfNotification = NotificationType()
        .getNotificationType(NotificationName.Owner_Maintenance_Requests);
    mn.isRead = false;

    notificationlist.add(mn);

    MaintenanceNotificationData mn2 = new MaintenanceNotificationData();
    mn2.applicantName = "";
    mn2.mid = maintenanceDetails.mID;
    mn2.propid = Prefs.getString(PrefsName.BT_PropID);
    mn2.applicantId = Prefs.getString(PrefsName.BT_ApplicantID);
    mn2.applicationId = Prefs.getString(PrefsName.BT_ApplicationId);
    mn2.ownerId = Prefs.getString(PrefsName.BT_OwnerID);
    mn2.notificationDate =
        new DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();
    mn2.typeOfNotification = NotificationType()
        .getNotificationType(NotificationName.Tenant_Maintenance_Requests);
    mn2.isRead = false;

    notificationlist.add(mn2);

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
}
