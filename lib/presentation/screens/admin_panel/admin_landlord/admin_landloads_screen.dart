import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/admin_action/admin_landlord_action.dart';
import 'package:silverhome/domain/actions/admin_action/admin_landlorddetails_actions.dart';
import 'package:silverhome/domain/actions/admin_action/admin_portal_action.dart';
import 'package:silverhome/domain/entities/landlorddata.dart';
import 'package:silverhome/presentation/models/admin_models/admin_landlord_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager_admin.dart';
import 'package:silverhome/tablayer/dsq_query.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/admin_panel/landlord_table/landord_header.dart';
import 'package:silverhome/widget/admin_panel/landlord_table/landord_item.dart';
import 'package:silverhome/widget/alert_dialogbox.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

class AdminLandlordsScreen extends StatefulWidget {
  @override
  _AdminLandlordsScreenState createState() => _AdminLandlordsScreenState();
}

class _AdminLandlordsScreenState extends State<AdminLandlordsScreen> {
  double height = 0, width = 0;

  final _store = getIt<AppStore>();

  @override
  void initState() {
    Prefs.init();

    updateState();
    apimanager("", 1, "Owner_ID", 1, 0);
    super.initState();
  }

  updateState() async {
    _store.dispatch(UpdateAdminLandlord_isIDSort(true));
    await updateSortingFeild(1);
    _store.dispatch(UpdateAdminLandlord_IDSortAcsDes(1));
    _store.dispatch(UpdateAdminLandlord_NameSortAcsDes(0));
    _store.dispatch(UpdateAdminLandlord_EmailSortAcsDes(0));
    _store.dispatch(UpdateAdminLandlord_PhoneSortAcsDes(0));
    _store.dispatch(UpdateAdminLandlord_PropertySortAcsDes(0));
    _store.dispatch(UpdateAdminLandlord_ActiveSortAcsDes(0));
  }

  apimanager(String search, int pageNo, String SortField, int saquence,
      int ftime) async {
    LanloadListReqtokens reqtokens = new LanloadListReqtokens();
    reqtokens.roles = Weburl.RoleID;
    reqtokens.Name = search != null ? search : "";

    Pager pager = new Pager(pageNo: pageNo, noOfRecords: Helper.noofrecored);

    List<Sort> sortinglist = [];
    Sort sort = new Sort();
    sort.fieldId = SortField;
    sort.sortSequence = saquence;
    sortinglist.add(sort);

    DSQQuery dsqQuery = new DSQQuery();
    dsqQuery.dsqid = Weburl.Admin_LandlordList;
    dsqQuery.loadLookUpValues = true;
    dsqQuery.landlordlistrequest = reqtokens;
    dsqQuery.pager = pager;
    dsqQuery.sort = sortinglist;

    String filterjson = jsonEncode(dsqQuery);

    _store.dispatch(UpdateAdminLandlord_isloding(true));
    _store.dispatch(UpdateAdminLandlord_datalist(<LandLordData>[]));
    _store.dispatch(UpdateAdminLandlord_LandlordSearchText(search));
    await ApiManagerAdmin().getLandlordList(context, filterjson, ftime);
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
      child: ConnectState<AdminLandlordState>(
        map: (state) => state.adminLandlordState,
        where: notIdentical,
        builder: (adminLandlordState) {
          return Column(
            children: [
              Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (adminLandlordState!.isloding &&
                            adminLandlordState.LandlordSearchText == "")
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
                                    initialValue:
                                        adminLandlordState.LandlordSearchText,
                                    onChanged: (value) async {
                                      _store.dispatch(
                                          UpdateAdminLandlord_isloding(true));
                                      _store.dispatch(
                                          UpdateAdminLandlord_datalist(
                                              <LandLordData>[]));
                                      apimanager(value, 1, "Owner_ID", 1, 0);
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
                      children: [_actionPopup(adminLandlordState)],
                    ),
                  ],
                ),
              ),
              _tableview(adminLandlordState),
            ],
          );
        },
      ),
    );
  }

  Widget _actionPopup(AdminLandlordState adminLandlordState) {
    return Container(
      height: 32,
      width: 30,
      child: PopupMenuButton(
        onSelected: (value) async {
          await ApiManagerAdmin().getLandlordListExportCSV(context);
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
              GlobleString.Filter,
              style: MyStyles.Medium(14, myColor.text_color),
              textAlign: TextAlign.start,
            ),
          ),*/
          PopupMenuItem(
            value: 2,
            child: Text(
              GlobleString.Export,
              style: MyStyles.Medium(14, myColor.text_color),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableview(AdminLandlordState adminLandlordState) {
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
          LandLordHeader(
            onPressedSortID: () {
              _store.dispatch(UpdateAdminLandlord_isIDSort(true));
              updateOtherSortingValue(1, adminLandlordState);
            },
            onPressedSortName: () {
              _store.dispatch(UpdateAdminLandlord_isNameSort(true));
              updateOtherSortingValue(2, adminLandlordState);
            },
            onPressedSortEmail: () {
              _store.dispatch(UpdateAdminLandlord_isEmailSort(true));
              updateOtherSortingValue(3, adminLandlordState);
            },
            onPressedSortPhoneno: () {
              _store.dispatch(UpdateAdminLandlord_isPhoneSort(true));
              updateOtherSortingValue(4, adminLandlordState);
            },
            onPressedSortofProperty: () {
              _store.dispatch(UpdateAdminLandlord_isPropertySort(true));
              updateOtherSortingValue(5, adminLandlordState);
            },
            onPressedSortActiveInactive: () {
              _store.dispatch(UpdateAdminLandlord_isActiveSort(true));
              updateOtherSortingValue(6, adminLandlordState);
            },
          ),
          tableItem(adminLandlordState),
          if (adminLandlordState.landlorddatalist != null &&
              adminLandlordState.landlorddatalist.length > 0)
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
                                          adminLandlordState.totalRecord)
                                      .length *
                                  35 >
                              250
                          ? 250
                          : Helper.PagingRecord(adminLandlordState.totalRecord)
                                  .length *
                              35,
                      textstyle: MyStyles.Medium(14, myColor.black),
                      hint: "Select page",
                      selectedItem: adminLandlordState.pageNo.toString(),
                      items:
                          Helper.PagingRecord(adminLandlordState.totalRecord),
                      showSearchBox: false,
                      isFilteredOnline: true,
                      onChanged: (value) {
                        _store.dispatch(UpdateAdminLandlord_pageNo(
                            int.parse(value.toString())));
                        paginationCall(
                            adminLandlordState, int.parse(value.toString()));
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
                            color: adminLandlordState.pageNo == 1
                                ? myColor.hintcolor
                                : myColor.black,
                          ),
                          onPressed: () {
                            if (adminLandlordState.pageNo != 1) {
                              int pageno = adminLandlordState.pageNo - 1;
                              _store.dispatch(UpdateAdminLandlord_pageNo(pageno));
                              paginationCall(adminLandlordState, pageno);
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
                            adminLandlordState.pageNo.toString(),
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
                            adminLandlordState.totalpage.toString(),
                            style: MyStyles.Medium(14, myColor.text_color),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: adminLandlordState.pageNo ==
                                adminLandlordState.totalpage
                                ? myColor.hintcolor
                                : myColor.black,
                          ),
                          onPressed: () {
                            if (adminLandlordState.pageNo !=
                                adminLandlordState.totalpage) {
                              int pageno = adminLandlordState.pageNo + 1;
                              _store.dispatch(UpdateAdminLandlord_pageNo(pageno));

                              paginationCall(adminLandlordState, pageno);
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

  Widget tableItem(AdminLandlordState adminLandlordState) {
    return Row(
      children: [
        adminLandlordState.isloding
            ? Expanded(
                child: Container(
                  width: width,
                  height: height - 174,
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
            : adminLandlordState.landlorddatalist != null &&
                    adminLandlordState.landlorddatalist.length > 0
                ? Expanded(
                    child: LandlordItem(
                      listdata1: adminLandlordState.landlorddatalist,
                      onPresseInActive: (LandLordData landLordData, int pos) {
                        _dailogAdminActivelandlord(false, 1, landLordData);
                      },
                      onPresseActive: (LandLordData landLordData, int pos) {
                        _dailogAdminActivelandlord(true, 2, landLordData);
                      },
                      onPresseViewAccount:
                          (LandLordData landLordData, int pos) async {
                        await Prefs.setBool(
                            PrefsName.admin_tenant_Landlord_Back, false);
                        await Prefs.setString(
                            PrefsName.OwnerID, landLordData.ownerId.toString());
                        _store.dispatch(UpdateLandlordDetailsTab(1));
                        _store.dispatch(UpdateAdminPortalLandlordDetails(
                            GlobleString.NAV_admin_Landlords));
                      },
                      onPresseName: (LandLordData landLordData, int pos) async {
                        await Prefs.setString(
                            PrefsName.OwnerID, landLordData.ownerId.toString());
                        await Prefs.setBool(
                            PrefsName.admin_tenant_Landlord_Back, false);
                        _store.dispatch(UpdateLandlordDetailsTab(1));
                        _store.dispatch(UpdateAdminPortalLandlordDetails(
                            GlobleString.NAV_admin_Landlords));
                      },
                      onPresseDeleteAccount:
                          (LandLordData landLordData, int pos) {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black45,
                          useSafeArea: true,
                          barrierDismissible: false,
                          builder: (BuildContext context1) {
                            return AlertDialogBox(
                              title: GlobleString.Admin_Delete_title,
                              negativeText: GlobleString.Admin_Delete_NO,
                              positiveText: GlobleString.Admin_Delete_yes,
                              onPressedYes: () {
                                Navigator.of(context1).pop();
                                deleteLandlordData(
                                    landLordData.ownerId.toString());
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
                      height: height - 174,
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

  void paginationCall(AdminLandlordState adminLandlordState, int pageno) {
    if (adminLandlordState.isIDSort) {
      apimanager(adminLandlordState.LandlordSearchText, pageno, "Owner_ID",
          adminLandlordState.IDSortAcsDes, 1);
    }

    if (adminLandlordState.isNameSort) {
      apimanager(adminLandlordState.LandlordSearchText, pageno, "Landlord Name",
          adminLandlordState.NameSortAcsDes, 1);
    }

    if (adminLandlordState.isEmailSort) {
      apimanager(adminLandlordState.LandlordSearchText, pageno, "Email",
          adminLandlordState.EmailSortAcsDes, 1);
    }

    if (adminLandlordState.isPhoneSort) {
      apimanager(adminLandlordState.LandlordSearchText, pageno, "Phone Number",
          adminLandlordState.PhoneSortAcsDes, 1);
    }

    if (adminLandlordState.isPropertySort) {
      apimanager(adminLandlordState.LandlordSearchText, pageno,
          "# of Properties", adminLandlordState.PropertySortAcsDes, 1);
    }

    if (adminLandlordState.isActiveSort) {
      apimanager(adminLandlordState.LandlordSearchText, pageno,
          "Active/Inactive", adminLandlordState.ActiveSortAcsDes, 1);
    }
  }

  updateOtherSortingValue(int flag, AdminLandlordState adminLandlordState) {
    updateSortingFeild(flag);

    if (flag == 1) {
      _store.dispatch(UpdateAdminLandlord_IDSortAcsDes(
          adminLandlordState.IDSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLandlord_NameSortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_EmailSortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_PhoneSortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_PropertySortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_ActiveSortAcsDes(0));

      apimanager(
          "", 1, "Owner_ID", adminLandlordState.IDSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 2) {
      _store.dispatch(UpdateAdminLandlord_NameSortAcsDes(
          adminLandlordState.NameSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLandlord_IDSortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_EmailSortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_PhoneSortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_PropertySortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_ActiveSortAcsDes(0));

      apimanager("", 1, "Landlord Name",
          adminLandlordState.NameSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 3) {
      _store.dispatch(UpdateAdminLandlord_EmailSortAcsDes(
          adminLandlordState.EmailSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLandlord_IDSortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_NameSortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_PhoneSortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_PropertySortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_ActiveSortAcsDes(0));

      apimanager(
          "", 1, "Email", adminLandlordState.EmailSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 4) {
      _store.dispatch(UpdateAdminLandlord_PhoneSortAcsDes(
          adminLandlordState.PhoneSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLandlord_IDSortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_NameSortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_EmailSortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_PropertySortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_ActiveSortAcsDes(0));

      apimanager("", 1, "Phone Number",
          adminLandlordState.PhoneSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 5) {
      _store.dispatch(UpdateAdminLandlord_PropertySortAcsDes(
          adminLandlordState.PropertySortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLandlord_IDSortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_NameSortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_EmailSortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_PhoneSortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_ActiveSortAcsDes(0));

      apimanager("", 1, "# of Properties",
          adminLandlordState.PropertySortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 6) {
      _store.dispatch(UpdateAdminLandlord_ActiveSortAcsDes(
          adminLandlordState.ActiveSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLandlord_IDSortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_NameSortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_EmailSortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_PhoneSortAcsDes(0));
      _store.dispatch(UpdateAdminLandlord_PropertySortAcsDes(0));

      apimanager("", 1, "Active/Inactive",
          adminLandlordState.ActiveSortAcsDes == 1 ? 0 : 1, 0);
    }
  }

  updateSortingFeild(int flag) {
    if (flag != 1) {
      _store.dispatch(UpdateAdminLandlord_isIDSort(false));
    }
    if (flag != 2) {
      _store.dispatch(UpdateAdminLandlord_isNameSort(false));
    }
    if (flag != 3) {
      _store.dispatch(UpdateAdminLandlord_isEmailSort(false));
    }
    if (flag != 4) {
      _store.dispatch(UpdateAdminLandlord_isPhoneSort(false));
    }
    if (flag != 5) {
      _store.dispatch(UpdateAdminLandlord_isPropertySort(false));
    }
    if (flag != 6) {
      _store.dispatch(UpdateAdminLandlord_isActiveSort(false));
    }
  }

  _dailogAdminActivelandlord(
    bool status,
    int flag,
    LandLordData landLordData,
  ) async {
    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialogBox(
          title: flag == 1
              ? GlobleString.AdminINActiveLandlord_msg
              : GlobleString.AdminActiveLandlord_msg,
          positiveText: GlobleString.AdminActiveLandlord_yes,
          negativeText: GlobleString.AdminActiveLandlord_NO,
          onPressedYes: () async {
            Navigator.of(context1).pop();

            CommonID commonid = new CommonID();
            commonid.ID = landLordData.ownerId.toString();

            AdminsideIsActive update = new AdminsideIsActive();
            update.adminsideIsActive = status;

            ApiManagerAdmin().UpdateLandlordActive(context, commonid, update,
                (error, respoce) async {
              if (error) {
                await updateState();
                await apimanager("", 1, "Owner_ID", 1, 0);
              } else {
                ToastUtils.showCustomToast(context, respoce, false);
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

  deleteLandlordData(String userid) {
    ApiManagerAdmin().deleteLandlordData(context, userid,
        (error, respoce) async {
      if (error) {
        ToastUtils.showCustomToast(context, GlobleString.User_delete, true);
        await updateState();
        await apimanager("", 1, "Owner_ID", 1, 0);
      } else {
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }
}
