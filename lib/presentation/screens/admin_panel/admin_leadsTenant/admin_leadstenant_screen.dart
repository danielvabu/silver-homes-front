import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/actions/admin_action/admin_landlord_leads_action.dart';
import 'package:silverhome/domain/actions/admin_action/admin_landlorddetails_actions.dart';
import 'package:silverhome/domain/actions/admin_action/admin_portal_action.dart';
import 'package:silverhome/domain/entities/leadtenantdata.dart';
import 'package:silverhome/presentation/models/admin_models/admin_landlord_leads_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager_admin.dart';
import 'package:silverhome/tablayer/dsq_query.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/admin_panel/leadtenant_table/leadtenant_header.dart';
import 'package:silverhome/widget/admin_panel/leadtenant_table/leadtenant_item.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

class AdminLeadsTenantScreen extends StatefulWidget {
  @override
  _AdminLeadsTenantScreenState createState() => _AdminLeadsTenantScreenState();
}

class _AdminLeadsTenantScreenState extends State<AdminLeadsTenantScreen> {
  double height = 0, width = 0;
  final _store = getIt<AppStore>();

  Timer? timer;

  @override
  void initState() {
    initmethod();
    super.initState();
  }

  initmethod() async {
    await Prefs.init();
    await updateState();
    apimanager("", 1, "ID", 1, 0);
  }

  updateState() async {
    _store.dispatch(UpdateAdminLL_isLeadIDSort(true));
    await updateSortingFeild(1);
    _store.dispatch(UpdateAdminLL_LeadIDSortAcsDes(1));
    _store.dispatch(UpdateAdminLL_LeadApplicantSortAcsDes(0));
    _store.dispatch(UpdateAdminLL_LeadEmailSortAcsDes(0));
    _store.dispatch(UpdateAdminLL_LeadPhoneNoSortAcsDes(0));
    _store.dispatch(UpdateAdminLL_LeadRatingSortAcsDes(1));
    _store.dispatch(UpdateAdminLL_LeadStatusSortAcsDes(0));
    _store.dispatch(UpdateAdminLL_LeadLLnameSortAcsDes(0));
    _store.dispatch(UpdateAdminLL_LeadPropertyNameSortAcsDes(0));

    _store.dispatch(UpdateAdminLL_Leads_pageNo(0));
    _store.dispatch(UpdateAdminLL_Leads_totalpage(0));
    _store.dispatch(UpdateAdminLL_Leads_totalRecord(0));
  }

  apimanager(String search, int pageNo, String SortField, int saquence,
      int ftime) async {
    LeadsTenantListReqtokens reqtokens = new LeadsTenantListReqtokens();
    reqtokens.ApplicationReceived = "1";
    reqtokens.Name = search != null ? search : "";

    Pager pager = new Pager(pageNo: pageNo, noOfRecords: Helper.noofrecored);

    List<Sort> sortinglist = [];
    Sort sort = new Sort();
    sort.fieldId = SortField;
    sort.sortSequence = saquence;
    sortinglist.add(sort);

    DSQQuery dsqQuery = new DSQQuery();
    dsqQuery.dsqid = Weburl.Admin_Landlord_LeadsList;
    dsqQuery.loadLookUpValues = true;
    dsqQuery.leadsTenantListReqtokens = reqtokens;
    dsqQuery.pager = pager;
    dsqQuery.sort = sortinglist;

    String filterjson = jsonEncode(dsqQuery);

    _store.dispatch(UpdateAdminLL_leadstenantSearchText(search));
    _store.dispatch(UpdateAdminLL_Leads_isloding(true));
    _store.dispatch(UpdateAdminLL_leadstenantDatalist(<LeadTenantData>[]));

    await ApiManagerAdmin().getLeadsTenantList(context, filterjson, ftime);
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
      child: ConnectState<AdminLandlordLeadsState>(
        map: (state) => state.adminLandlordLeadsState,
        where: notIdentical,
        builder: (adminLandlordLeadsState) {
          return Column(
            children: [
              Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (adminLandlordLeadsState!.isloding &&
                            adminLandlordLeadsState.leadstenantSearchText == "")
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
                                Expanded(
                                  child: TextFormField(
                                    initialValue: adminLandlordLeadsState
                                        .leadstenantSearchText,
                                    onChanged: (value) {
                                      if (timer != null) timer!.cancel();

                                      searchMethos(value);
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
                          )
                      ],
                    ),
                    Row(
                      children: [_actionPopup(adminLandlordLeadsState)],
                    ),
                  ],
                ),
              ),
              _tableview(adminLandlordLeadsState),
            ],
          );
        },
      ),
    );
  }

  searchMethos(String txt) async {
    await updateState();
    _store.dispatch(UpdateAdminLL_Leads_isloding(true));
    _store.dispatch(UpdateAdminLL_leadstenantDatalist(<LeadTenantData>[]));

    timer = new Timer(Duration(seconds: 2), searchApi(txt));
  }

  searchApi(String txt) async {
    apimanager(txt, 1, "ID", 1, 0);
  }

  Widget _actionPopup(AdminLandlordLeadsState adminLandlordLeadsState) {
    return Container(
      height: 32,
      width: 30,
      child: PopupMenuButton(
        onSelected: (value) async {
          await ApiManagerAdmin().getLeadsTenantListExportCSV(context);
        },
        child: Container(
          height: 40,
          width: 20,
          margin: EdgeInsets.only(right: 5),
          child: Icon(Icons.more_vert),
        ),
        itemBuilder: (context) => [
          /* PopupMenuItem(
            value: 1,
            child: Text(
              "Filter",
              style: MyStyles.Medium(14, myColor.text_color),
              textAlign: TextAlign.start,
            ),
          ),*/
          PopupMenuItem(
            value: 2,
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

  Widget _tableview(AdminLandlordLeadsState adminLandlordLeadsState) {
    return Container(
      width: width,
      height: height - 92,
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          //color: Hexcolor("#16C395"),
          border: Border.all(color: Colors.transparent, width: 1)),
      child: Column(
        children: [
          LeadTenantHeader(
            onPressedSortID: () {
              _store.dispatch(UpdateAdminLL_isLeadIDSort(true));
              updateOtherSortingValue(1, adminLandlordLeadsState);
            },
            onPressedSortName: () {
              _store.dispatch(UpdateAdminLL_isLeadApplicantSort(true));
              updateOtherSortingValue(2, adminLandlordLeadsState);
            },
            onPressedSortEmail: () {
              _store.dispatch(UpdateAdminLL_isLeadEmailSort(true));
              updateOtherSortingValue(3, adminLandlordLeadsState);
            },
            onPressedSortPhoneno: () {
              _store.dispatch(UpdateAdminLL_isLeadPhoneNoSort(true));
              updateOtherSortingValue(4, adminLandlordLeadsState);
            },
            onPressedSortRating: () {
              _store.dispatch(UpdateAdminLL_isLeadRatingSort(true));
              updateOtherSortingValue(5, adminLandlordLeadsState);
            },
            onPressedSortlandlordname: () {
              _store.dispatch(UpdateAdminLL_isLeadLLnameSort(true));
              updateOtherSortingValue(6, adminLandlordLeadsState);
            },
            onPressedSortProperty: () {
              _store.dispatch(UpdateAdminLL_isLeadPropertyNameSort(true));
              updateOtherSortingValue(7, adminLandlordLeadsState);
            },
            onPressedSortStatus: () {
              _store.dispatch(UpdateAdminLL_isLeadStatusSort(true));
              updateOtherSortingValue(8, adminLandlordLeadsState);
            },
          ),
          tableItem(adminLandlordLeadsState),
          if (adminLandlordLeadsState.leadstenantDatalist != null &&
              adminLandlordLeadsState.leadstenantDatalist.length > 0)
            Container(
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
                      defultHeight: Helper.PagingRecord(
                                          adminLandlordLeadsState.totalRecord)
                                      .length *
                                  35 >
                              350
                          ? 350
                          : Helper.PagingRecord(
                                      adminLandlordLeadsState.totalRecord)
                                  .length *
                              35,
                      textstyle: MyStyles.Medium(14, myColor.black),
                      hint: "Select page",
                      selectedItem: adminLandlordLeadsState.pageNo.toString(),
                      items: Helper.PagingRecord(
                          adminLandlordLeadsState.totalRecord),
                      showSearchBox: false,
                      isFilteredOnline: true,
                      onChanged: (value) {
                        _store.dispatch(UpdateAdminLL_Leads_pageNo(
                            int.parse(value.toString())));
                        paginationCall(adminLandlordLeadsState,
                            int.parse(value.toString()));
                      },
                    ),
                  ),
                  /* Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_outlined,
                          color: adminLandlordLeadsState.pageNo == 1
                              ? myColor.hintcolor
                              : myColor.black,
                        ),
                        onPressed: () {
                          if (adminLandlordLeadsState.pageNo != 1) {
                            int pageno = adminLandlordLeadsState.pageNo - 1;
                            _store.dispatch(UpdateAdminLL_Leads_pageNo(pageno));
                            paginationCall(adminLandlordLeadsState, pageno);
                          }
                        },
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          "Showing",
                          style: MyStyles.Medium(14, myColor.text_color),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          adminLandlordLeadsState.pageNo.toString(),
                          style: MyStyles.Medium(14, myColor.text_color),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          "to",
                          style: MyStyles.Medium(14, myColor.text_color),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          adminLandlordLeadsState.totalpage.toString(),
                          style: MyStyles.Medium(14, myColor.text_color),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: adminLandlordLeadsState.pageNo ==
                              adminLandlordLeadsState.totalpage
                              ? myColor.hintcolor
                              : myColor.black,
                        ),
                        onPressed: () {
                          if (adminLandlordLeadsState.pageNo !=
                              adminLandlordLeadsState.totalpage) {
                            int pageno = adminLandlordLeadsState.pageNo + 1;
                            _store.dispatch(UpdateAdminLL_Leads_pageNo(pageno));
                            paginationCall(adminLandlordLeadsState, pageno);
                          }
                        },
                      )
                    ],
                  ),*/
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget tableItem(AdminLandlordLeadsState adminLandlordLeadsState) {
    return Row(
      children: [
        adminLandlordLeadsState.isloding
            ? Expanded(
                child: Container(
                  width: width,
                  height: height - 276,
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
            : adminLandlordLeadsState.leadstenantDatalist != null &&
                    adminLandlordLeadsState.leadstenantDatalist.length > 0
                ? Expanded(
                    child: LeadTenantItem(
                      listdata1: adminLandlordLeadsState.leadstenantDatalist,
                      onPressDetails: (LeadTenantData data) {
                        tenantDetailsAPI(data);
                      },
                      onPressPropertyDetails: (LeadTenantData data) {
                        getPropertyDetails(data.Prop_ID.toString());
                      },
                      onPresseViewLandlordAccount: (LeadTenantData data) async {
                        await Prefs.setBool(
                            PrefsName.admin_tenant_Landlord_Back, true);
                        await Prefs.setString(
                            PrefsName.OwnerID, data.ownerId.toString());
                        _store.dispatch(UpdateLandlordDetailsTab(1));
                        _store.dispatch(UpdateAdminPortalLandlordDetails(
                            GlobleString.NAV_admin_Landlords));
                      },
                    ),
                  )
                : Expanded(
                    child: Container(
                      width: width,
                      height: height - 276,
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text(
                        GlobleString.Blank_Landloadview,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: MyStyles.Medium(18, myColor.tabel_msg),
                      ),
                    ),
                  )
      ],
    );
  }

  paginationCall(AdminLandlordLeadsState adminLandlordLeadsState, int pageno) {
    if (adminLandlordLeadsState.isLeadIDSort) {
      apimanager(adminLandlordLeadsState.leadstenantSearchText, pageno, "ID",
          adminLandlordLeadsState.LeadIDSortAcsDes, 1);
    }

    if (adminLandlordLeadsState.isLeadApplicantSort) {
      apimanager(adminLandlordLeadsState.leadstenantSearchText, pageno,
          "Applicant Name", adminLandlordLeadsState.LeadApplicantSortAcsDes, 1);
    }

    if (adminLandlordLeadsState.isLeadEmailSort) {
      apimanager(adminLandlordLeadsState.leadstenantSearchText, pageno, "Email",
          adminLandlordLeadsState.LeadEmailSortAcsDes, 1);
    }

    if (adminLandlordLeadsState.isLeadPhoneNoSort) {
      apimanager(adminLandlordLeadsState.leadstenantSearchText, pageno,
          "MobileNumber", adminLandlordLeadsState.LeadPhoneNoSortAcsDes, 1);
    }

    if (adminLandlordLeadsState.isLeadRatingSort) {
      apimanager(adminLandlordLeadsState.leadstenantSearchText, pageno,
          "Rating", adminLandlordLeadsState.LeadRatingSortAcsDes, 1);
    }

    if (adminLandlordLeadsState.isLeadLLnameSort) {
      apimanager(adminLandlordLeadsState.leadstenantSearchText, pageno,
          "Landlord Name", adminLandlordLeadsState.LeadLLnameSortAcsDes, 1);
    }

    if (adminLandlordLeadsState.isLeadPropertyNameSort) {
      apimanager(
          adminLandlordLeadsState.leadstenantSearchText,
          pageno,
          "Property Name",
          adminLandlordLeadsState.LeadPropertyNameSortAcsDes,
          1);
    }
    if (adminLandlordLeadsState.isLeadStatusSort) {
      apimanager(adminLandlordLeadsState.leadstenantSearchText, pageno,
          "ApplicationStatus", adminLandlordLeadsState.LeadStatusSortAcsDes, 1);
    }
  }

  updateOtherSortingValue(
      int flag, AdminLandlordLeadsState adminLandlordLeadsState) {
    updateSortingFeild(flag);

    if (flag == 1) {
      _store.dispatch(UpdateAdminLL_LeadIDSortAcsDes(
          adminLandlordLeadsState.LeadIDSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLL_LeadApplicantSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadEmailSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadPhoneNoSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadRatingSortAcsDes(1));
      _store.dispatch(UpdateAdminLL_LeadLLnameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadPropertyNameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadStatusSortAcsDes(0));

      apimanager("", 1, "ID",
          adminLandlordLeadsState.LeadIDSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 2) {
      _store.dispatch(UpdateAdminLL_LeadApplicantSortAcsDes(
          adminLandlordLeadsState.LeadApplicantSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLL_LeadIDSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadEmailSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadPhoneNoSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadRatingSortAcsDes(1));
      _store.dispatch(UpdateAdminLL_LeadLLnameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadPropertyNameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadStatusSortAcsDes(0));

      apimanager("", 1, "Applicant Name",
          adminLandlordLeadsState.LeadApplicantSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 3) {
      _store.dispatch(UpdateAdminLL_LeadEmailSortAcsDes(
          adminLandlordLeadsState.LeadEmailSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLL_LeadIDSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadApplicantSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadPhoneNoSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadRatingSortAcsDes(1));
      _store.dispatch(UpdateAdminLL_LeadLLnameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadPropertyNameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadStatusSortAcsDes(0));

      apimanager("", 1, "Email",
          adminLandlordLeadsState.LeadEmailSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 4) {
      _store.dispatch(UpdateAdminLL_LeadPhoneNoSortAcsDes(
          adminLandlordLeadsState.LeadPhoneNoSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLL_LeadIDSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadApplicantSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadEmailSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadRatingSortAcsDes(1));
      _store.dispatch(UpdateAdminLL_LeadLLnameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadPropertyNameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadStatusSortAcsDes(0));

      apimanager("", 1, "MobileNumber",
          adminLandlordLeadsState.LeadPhoneNoSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 5) {
      _store.dispatch(UpdateAdminLL_LeadRatingSortAcsDes(
          adminLandlordLeadsState.LeadRatingSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLL_LeadIDSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadApplicantSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadEmailSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadPhoneNoSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadLLnameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadPropertyNameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadStatusSortAcsDes(0));

      apimanager("", 1, "Rating",
          adminLandlordLeadsState.LeadRatingSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 6) {
      _store.dispatch(UpdateAdminLL_LeadLLnameSortAcsDes(
          adminLandlordLeadsState.LeadLLnameSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLL_LeadIDSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadApplicantSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadEmailSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadPhoneNoSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadRatingSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadPropertyNameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadStatusSortAcsDes(0));

      apimanager("", 1, "Landlord Name",
          adminLandlordLeadsState.LeadLLnameSortAcsDes == 1 ? 0 : 1, 0);
    }
    if (flag == 7) {
      _store.dispatch(UpdateAdminLL_LeadPropertyNameSortAcsDes(
          adminLandlordLeadsState.LeadPropertyNameSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLL_LeadIDSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadApplicantSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadEmailSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadPhoneNoSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadRatingSortAcsDes(1));
      _store.dispatch(UpdateAdminLL_LeadLLnameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadStatusSortAcsDes(0));

      apimanager("", 1, "Property Name",
          adminLandlordLeadsState.LeadPropertyNameSortAcsDes == 1 ? 0 : 1, 0);
    }
    if (flag == 8) {
      _store.dispatch(UpdateAdminLL_LeadStatusSortAcsDes(
          adminLandlordLeadsState.LeadStatusSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLL_LeadIDSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadApplicantSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadEmailSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadPhoneNoSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadRatingSortAcsDes(1));
      _store.dispatch(UpdateAdminLL_LeadLLnameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_LeadPropertyNameSortAcsDes(0));

      apimanager("", 1, "ApplicationStatus",
          adminLandlordLeadsState.LeadStatusSortAcsDes == 1 ? 0 : 1, 0);
    }
  }

  updateSortingFeild(int flag) {
    if (flag != 1) {
      _store.dispatch(UpdateAdminLL_isLeadIDSort(false));
    }
    if (flag != 2) {
      _store.dispatch(UpdateAdminLL_isLeadApplicantSort(false));
    }
    if (flag != 3) {
      _store.dispatch(UpdateAdminLL_isLeadEmailSort(false));
    }
    if (flag != 4) {
      _store.dispatch(UpdateAdminLL_isLeadPhoneNoSort(false));
    }
    if (flag != 5) {
      _store.dispatch(UpdateAdminLL_isLeadRatingSort(false));
    }
    if (flag != 6) {
      _store.dispatch(UpdateAdminLL_isLeadLLnameSort(false));
    }
    if (flag != 7) {
      _store.dispatch(UpdateAdminLL_isLeadPropertyNameSort(false));
    }
    if (flag != 8) {
      _store.dispatch(UpdateAdminLL_isLeadStatusSort(false));
    }
  }

  tenantDetailsAPI(LeadTenantData model) async {
    ApiManagerAdmin().getLandlordTenancyDetails(
        context, model.applicantId.toString(), (status, responce) {
      if (status) {
        Prefs.setBool(PrefsName.Is_adminLandlord_lead, false);
        Prefs.setBool(PrefsName.Is_adminLandlord_Property, false);
        _store.dispatch(UpdateAdminPortalLeadTenancyDetails(
            GlobleString.NAV_admin_LeadsTenants));
      } else {
        Helper.Log("respoce", responce);
      }
    });
  }

  getPropertyDetails(String propertyid) {
    ApiManagerAdmin().getPropertyDetailsByID(context, propertyid,
        (status, responce) async {
      if (status) {
        Prefs.setBool(PrefsName.admin_PropertyBack, false);
        Prefs.setBool(PrefsName.admin_Landlord_PropertyBack, false);
        _store.dispatch(UpdateAdminPortalLandlordPropertyDetails(
            GlobleString.NAV_admin_Landlords));
      } else {}
    });
  }
}
