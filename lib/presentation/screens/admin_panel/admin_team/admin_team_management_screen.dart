import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/admin_action/admin_add_newmember_action.dart';
import 'package:silverhome/domain/actions/admin_action/admin_team_action.dart';
import 'package:silverhome/domain/entities/landlorddata.dart';
import 'package:silverhome/presentation/models/admin_models/admin_team_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager_admin.dart';
import 'package:silverhome/tablayer/dsq_query.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/admin_panel/addnewmember_dialogbox.dart';
import 'package:silverhome/widget/admin_panel/team_table/team_header.dart';
import 'package:silverhome/widget/admin_panel/team_table/team_item.dart';
import 'package:silverhome/widget/alert_dialogbox.dart';
import 'package:silverhome/widget/message_dialogbox.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

import '../../../../widget/Landlord/customewidget.dart';

class AdminTeamManagementScreen extends StatefulWidget {
  @override
  _AdminTeamManagementScreenState createState() =>
      _AdminTeamManagementScreenState();
}

class _AdminTeamManagementScreenState extends State<AdminTeamManagementScreen> {
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
    apimanager("", 1, "Owner_ID", 1, 0);
  }

  updateState() async {
    _store.dispatch(UpdateAdminTeam_isIDSort(true));
    await updateSortingFeild(1);
    _store.dispatch(UpdateAdminTeam_IDSortAcsDes(1));
    _store.dispatch(UpdateAdminTeam_NameSortAcsDes(0));
    _store.dispatch(UpdateAdminTeam_EmailSortAcsDes(0));
    _store.dispatch(UpdateAdminTeam_PhoneSortAcsDes(0));
    _store.dispatch(UpdateAdminTeam_ActiveSortAcsDes(0));

    _store.dispatch(UpdateAdminTeam_pageNo(0));
    _store.dispatch(UpdateAdminTeam_totalpage(0));
    _store.dispatch(UpdateAdminTeam_totalRecord(0));
  }

  apimanager(String search, int pageNo, String SortField, int saquence,
      int ftime) async {
    LanloadListReqtokens reqtokens = new LanloadListReqtokens();
    reqtokens.roles = Weburl.Super_Admin_RoleID;
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

    _store.dispatch(UpdateAdminTeam_isloding(true));
    _store.dispatch(UpdateAdminTeam_datalist(<LandLordData>[]));
    _store.dispatch(UpdateAdminTeam_SearchText(search));

    await ApiManagerAdmin().getTeamMangList(context, filterjson, ftime);
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
      child: ConnectState<AdminTeamState>(
        map: (state) => state.adminTeamState,
        where: notIdentical,
        builder: (adminTeamState) {
          return Column(
            children: [
              Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (adminTeamState!.isloding &&
                            adminTeamState.AdminTeamSearchText == "")
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
                                        adminTeamState.AdminTeamSearchText,
                                    onChanged: (value) async {
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
                          ),
                        SizedBox(
                          width: 10,
                        ),
                        _addNewMamber(adminTeamState),
                      ],
                    ),
                    Row(
                      children: [_actionPopup(adminTeamState)],
                    ),
                  ],
                ),
              ),
              _tableview(adminTeamState),
            ],
          );
        },
      ),
    );
  }

  searchMethos(String txt) async {
    await updateState();
    _store.dispatch(UpdateAdminTeam_isloding(true));
    _store.dispatch(UpdateAdminTeam_datalist(<LandLordData>[]));

    timer = new Timer(Duration(seconds: 4), searchApi(txt));
  }

  searchApi(String txt) async {
    apimanager(txt, 1, "Owner_ID", 1, 0);
  }

  Widget _addNewMamber(AdminTeamState adminTeamState) {
    return InkWell(
      onTap: () async {
        await Prefs.setBool(PrefsName.admin_addTeam, true);

        _store.dispatch(UpdateAdminTM_AM_OwnerId(""));
        _store.dispatch(UpdateAdminTM_AM_Persionid(""));
        _store.dispatch(UpdateAdminTM_AM_firstname(""));
        _store.dispatch(UpdateAdminTM_AM_lastname(""));
        _store.dispatch(UpdateAdminTM_AM_email(""));
        _store.dispatch(UpdateAdminTM_AM_dialcode("+1"));
        _store.dispatch(UpdateAdminTM_AM_countrycode("CA"));
        _store.dispatch(UpdateAdminTM_AM_phone(""));

        _store.dispatch(UpdateAdminTM_AM_error_firstname(false));
        _store.dispatch(UpdateAdminTM_AM_error_lastname(false));
        _store.dispatch(UpdateAdminTM_AM_error_email(false));
        _store.dispatch(UpdateAdminTM_AM_error_phone(false));
        _store.dispatch(UpdateAdminTM_AM_error_Message(""));

        showDialog(
          context: context,
          barrierColor: Colors.black45,
          useSafeArea: true,
          barrierDismissible: false,
          builder: (BuildContext context1) {
            return AddNewMemberDialogBox(
              onPressedSave: () {
                Navigator.of(context1).pop();
                newmember_dailogShow();
              },
              onPressedClose: () {
                Navigator.of(context1).pop();
              },
            );
          },
        );
      },
      child: CustomeWidget.AddNewMember(),
    );
  }

  Widget _actionPopup(AdminTeamState adminTeamState) {
    return Container(
      height: 32,
      width: 30,
      child: PopupMenuButton(
        onSelected: (value) async {
          await ApiManagerAdmin().getTeamMangListExport(context);
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

  Widget _tableview(AdminTeamState adminTeamState) {
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
          TeamHeader(
            onPressedSortID: () {
              _store.dispatch(UpdateAdminTeam_isIDSort(true));
              updateOtherSortingValue(1, adminTeamState);
            },
            onPressedSortName: () {
              _store.dispatch(UpdateAdminTeam_isNameSort(true));
              updateOtherSortingValue(2, adminTeamState);
            },
            onPressedSortEmail: () {
              _store.dispatch(UpdateAdminTeam_isEmailSort(true));
              updateOtherSortingValue(3, adminTeamState);
            },
            onPressedSortPhoneno: () {
              _store.dispatch(UpdateAdminTeam_isPhoneSort(true));
              updateOtherSortingValue(4, adminTeamState);
            },
            onPressedSortActiveInactive: () {
              _store.dispatch(UpdateAdminTeam_isActiveSort(true));
              updateOtherSortingValue(5, adminTeamState);
            },
          ),
          tableItem(adminTeamState),
          if (adminTeamState.teamdatalist != null &&
              adminTeamState.teamdatalist.length > 0)
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
                      defultHeight:
                          Helper.PagingRecord(adminTeamState.totalRecord)
                                          .length *
                                      35 >
                                  250
                              ? 250
                              : Helper.PagingRecord(adminTeamState.totalRecord)
                                      .length *
                                  35,
                      textstyle: MyStyles.Medium(14, myColor.black),
                      hint: "Select page",
                      selectedItem: adminTeamState.pageNo.toString(),
                      items: Helper.PagingRecord(adminTeamState.totalRecord),
                      showSearchBox: false,
                      isFilteredOnline: true,
                      onChanged: (value) {
                        _store.dispatch(UpdateAdminTeam_pageNo(
                            int.parse(value.toString())));
                        paginationCall(
                            adminTeamState, int.parse(value.toString()));
                      },
                    ),
                  ),
                  /*Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_outlined,
                          color: adminTeamState.pageNo == 1
                              ? myColor.hintcolor
                              : myColor.black,
                        ),
                        onPressed: () {
                          if (adminTeamState.pageNo != 1) {
                            int pageno = adminTeamState.pageNo - 1;
                            _store.dispatch(UpdateAdminTeam_pageNo(pageno));
                            paginationCall(adminTeamState, pageno);
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
                          adminTeamState.pageNo.toString(),
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
                          adminTeamState.totalpage.toString(),
                          style: MyStyles.Medium(14, myColor.text_color),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: adminTeamState.pageNo == adminTeamState.totalpage
                              ? myColor.hintcolor
                              : myColor.black,
                        ),
                        onPressed: () {
                          if (adminTeamState.pageNo != adminTeamState.totalpage) {
                            int pageno = adminTeamState.pageNo + 1;
                            _store.dispatch(UpdateAdminTeam_pageNo(pageno));

                            paginationCall(adminTeamState, pageno);
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

  Widget tableItem(AdminTeamState adminTeamState) {
    return Row(
      children: [
        adminTeamState.isloding
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
            : adminTeamState.teamdatalist != null &&
                    adminTeamState.teamdatalist.length > 0
                ? Expanded(
                    child: TeamItem(
                      listdata1: adminTeamState.teamdatalist,
                      onPresseInActive: (LandLordData admindata, int pos) {
                        _dailogAdminActive(false, 1, admindata);
                      },
                      onPresseActive: (LandLordData admindata, int pos) {
                        _dailogAdminActive(true, 2, admindata);
                      },
                      onPresseEdit: (LandLordData admindata, int pos) async {
                        _store.dispatch(UpdateAdminTM_AM_OwnerId(
                            admindata.ownerId.toString()));
                        _store.dispatch(UpdateAdminTM_AM_Persionid(
                            admindata.id.toString()));
                        _store.dispatch(UpdateAdminTM_AM_firstname(
                            admindata.firstName.toString()));
                        _store.dispatch(UpdateAdminTM_AM_lastname(
                            admindata.lastName.toString()));
                        _store.dispatch(
                            UpdateAdminTM_AM_email(admindata.email.toString()));
                        _store.dispatch(UpdateAdminTM_AM_dialcode(
                            admindata.dialCode.toString()));
                        _store.dispatch(UpdateAdminTM_AM_countrycode(
                            admindata.countryCode.toString()));
                        _store.dispatch(UpdateAdminTM_AM_phone(
                            admindata.phoneNumber.toString()));

                        _store
                            .dispatch(UpdateAdminTM_AM_error_firstname(false));
                        _store.dispatch(UpdateAdminTM_AM_error_lastname(false));
                        _store.dispatch(UpdateAdminTM_AM_error_email(false));
                        _store.dispatch(UpdateAdminTM_AM_error_phone(false));

                        await Prefs.setBool(PrefsName.admin_addTeam, false);

                        showDialog(
                          context: context,
                          barrierColor: Colors.black45,
                          useSafeArea: true,
                          barrierDismissible: false,
                          builder: (BuildContext context1) {
                            return AddNewMemberDialogBox(
                              onPressedSave: () {
                                Navigator.of(context1).pop();
                                updateState();
                                apimanager("", 1, "Owner_ID", 1, 0);
                              },
                              onPressedClose: () {
                                Navigator.of(context1).pop();
                              },
                            );
                          },
                        );
                      },
                      onPresseDelete: (LandLordData admindata, int pos) {
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
                                DeleteTeamMember(admindata.ownerId.toString(),
                                    admindata.id.toString());
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

  void paginationCall(AdminTeamState adminTeamState, int pageno) {
    if (adminTeamState.isIDSort) {
      apimanager(adminTeamState.AdminTeamSearchText, pageno, "Owner_ID",
          adminTeamState.IDSortAcsDes, 1);
    }

    if (adminTeamState.isNameSort) {
      apimanager(adminTeamState.AdminTeamSearchText, pageno, "Landlord Name",
          adminTeamState.NameSortAcsDes, 1);
    }

    if (adminTeamState.isEmailSort) {
      apimanager(adminTeamState.AdminTeamSearchText, pageno, "Email",
          adminTeamState.EmailSortAcsDes, 1);
    }

    if (adminTeamState.isPhoneSort) {
      apimanager(adminTeamState.AdminTeamSearchText, pageno, "Phone Number",
          adminTeamState.PhoneSortAcsDes, 1);
    }
    if (adminTeamState.isActiveSort) {
      apimanager(adminTeamState.AdminTeamSearchText, pageno, "Active/Inactive",
          adminTeamState.ActiveSortAcsDes, 1);
    }
  }

  updateOtherSortingValue(int flag, AdminTeamState adminTeamState) {
    updateSortingFeild(flag);

    if (flag == 1) {
      _store.dispatch(UpdateAdminTeam_IDSortAcsDes(
          adminTeamState.IDSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminTeam_NameSortAcsDes(0));
      _store.dispatch(UpdateAdminTeam_EmailSortAcsDes(0));
      _store.dispatch(UpdateAdminTeam_PhoneSortAcsDes(0));
      _store.dispatch(UpdateAdminTeam_ActiveSortAcsDes(0));

      apimanager(
          "", 1, "Owner_ID", adminTeamState.IDSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 2) {
      _store.dispatch(UpdateAdminTeam_NameSortAcsDes(
          adminTeamState.NameSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminTeam_IDSortAcsDes(0));
      _store.dispatch(UpdateAdminTeam_EmailSortAcsDes(0));
      _store.dispatch(UpdateAdminTeam_PhoneSortAcsDes(0));
      _store.dispatch(UpdateAdminTeam_ActiveSortAcsDes(0));

      apimanager("", 1, "Landlord Name",
          adminTeamState.NameSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 3) {
      _store.dispatch(UpdateAdminTeam_EmailSortAcsDes(
          adminTeamState.EmailSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminTeam_IDSortAcsDes(0));
      _store.dispatch(UpdateAdminTeam_NameSortAcsDes(0));
      _store.dispatch(UpdateAdminTeam_PhoneSortAcsDes(0));
      _store.dispatch(UpdateAdminTeam_ActiveSortAcsDes(0));

      apimanager(
          "", 1, "Email", adminTeamState.EmailSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 4) {
      _store.dispatch(UpdateAdminTeam_PhoneSortAcsDes(
          adminTeamState.PhoneSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminTeam_IDSortAcsDes(0));
      _store.dispatch(UpdateAdminTeam_NameSortAcsDes(0));
      _store.dispatch(UpdateAdminTeam_EmailSortAcsDes(0));
      _store.dispatch(UpdateAdminTeam_ActiveSortAcsDes(0));

      apimanager("", 1, "Phone Number",
          adminTeamState.PhoneSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 5) {
      _store.dispatch(UpdateAdminTeam_ActiveSortAcsDes(
          adminTeamState.ActiveSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminTeam_IDSortAcsDes(0));
      _store.dispatch(UpdateAdminTeam_NameSortAcsDes(0));
      _store.dispatch(UpdateAdminTeam_EmailSortAcsDes(0));
      _store.dispatch(UpdateAdminTeam_PhoneSortAcsDes(0));

      apimanager("", 1, "Active/Inactive",
          adminTeamState.ActiveSortAcsDes == 1 ? 0 : 1, 0);
    }
  }

  updateSortingFeild(int flag) {
    if (flag != 1) {
      _store.dispatch(UpdateAdminTeam_isIDSort(false));
    }
    if (flag != 2) {
      _store.dispatch(UpdateAdminTeam_isNameSort(false));
    }
    if (flag != 3) {
      _store.dispatch(UpdateAdminTeam_isEmailSort(false));
    }
    if (flag != 4) {
      _store.dispatch(UpdateAdminTeam_isPhoneSort(false));
    }
    if (flag != 5) {
      _store.dispatch(UpdateAdminTeam_isActiveSort(false));
    }
  }

  newmember_dailogShow() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MessageDialogBox(
          buttontitle: GlobleString.admin_Member_OK,
          title: GlobleString.admin_Member_successfully,
          onPressed: () async {
            Navigator.of(context).pop();
            updateState();
            apimanager("", 1, "Owner_ID", 1, 0);
          },
        );
      },
    );
  }

  _dailogAdminActive(
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
              ? GlobleString.Admin_INActive_msg
              : GlobleString.Admin_Active_msg,
          positiveText: GlobleString.Admin_Active_yes,
          negativeText: GlobleString.Admin_Active_NO,
          onPressedYes: () async {
            Navigator.of(context1).pop();

            CommonID commonid = new CommonID();
            commonid.ID = landLordData.ownerId.toString();

            AdminsideIsActive update = new AdminsideIsActive();
            update.adminsideIsActive = status;

            ApiManagerAdmin().UpdateLandlordActive(context, commonid, update,
                (error, respoce) async {
              if (error) {
                updateState();
                apimanager("", 1, "Owner_ID", 1, 0);
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

  DeleteTeamMember(String ownerId, String Pid) {
    CommonID pid = new CommonID();
    pid.ID = Pid;

    CommonID uid = new CommonID();
    uid.ID = ownerId;

    ApiManagerAdmin().DeleteTeamManagement(context, pid, uid,
        (status, responce) async {
      if (status) {
        ToastUtils.showCustomToast(context, GlobleString.User_delete, true);
        await updateState();
        await apimanager("", 1, "Owner_ID", 1, 0);
      } else {
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
  }
}
