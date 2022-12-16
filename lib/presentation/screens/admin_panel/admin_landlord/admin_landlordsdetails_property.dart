import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/actions/admin_action/admin_landlord_property_action.dart';
import 'package:silverhome/domain/actions/admin_action/admin_portal_action.dart';
import 'package:silverhome/domain/actions/admin_action/admin_property_details_actions.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/presentation/models/admin_models/admin_landlord_property_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/api_manager_admin.dart';
import 'package:silverhome/tablayer/dsq_query.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/adminPanel/import_property_dialog.dart';
import 'package:silverhome/widget/adminPanel/landlord_property/landlord_property_header.dart';
import 'package:silverhome/widget/adminPanel/landlord_property/landlord_property_item.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

class AdminLandlordsDetailsProperty extends StatefulWidget {
  @override
  _AdminLandlordsDetailsPropertyState createState() => _AdminLandlordsDetailsPropertyState();
}

class _AdminLandlordsDetailsPropertyState extends State<AdminLandlordsDetailsProperty> {
  double height = 0, width = 0;
  final _store = getIt<AppStore>();

  double drawer_width = 230;
  double header_height = 70;

  @override
  void initState() {
    initmethod();

    super.initState();
  }

  Future<void> initmethod() async {
    await Prefs.init();
    await updateState();
    apimanager("", 1, "PropertyName", 1, 0);
  }

  updateState() async {
    _store.dispatch(UpdateAdminLL_property_isPropNameSort(true));
    await updateSortingFeild(1);
    _store.dispatch(UpdateAdminLL_PropNameSortAcsDes(1));
    _store.dispatch(UpdateAdminLL_PropUnitSortAcsDes(0));
    _store.dispatch(UpdateAdminLL_PropCitySortAcsDes(0));
    _store.dispatch(UpdateAdminLL_PropCountrySortAcsDes(0));
    _store.dispatch(UpdateAdminLL_PropTypeSortAcsDes(0));
    _store.dispatch(UpdateAdminLL_PropVacancySortAcsDes(0));
    _store.dispatch(UpdateAdminLL_PropTenantNameSortAcsDes(0));
    _store.dispatch(UpdateAdminLL_PropStatusSortAcsDes(0));
    _store.dispatch(UpdateAdminLL_PropActInActSortAcsDes(0));

    _store.dispatch(UpdateAdminLL_Property_pageNo(0));
    _store.dispatch(UpdateAdminLL_Property_totalpage(0));
    _store.dispatch(UpdateAdminLL_Property_totalRecord(0));
  }

  void apimanager(String search, int pageNo, String SortField, int saquence, int ftime) async {
    PropertyListReqtokens reqtokens = new PropertyListReqtokens();
    reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    reqtokens.Name = search != null ? search : "";

    Pager pager = new Pager(pageNo: pageNo, noOfRecords: Helper.noofrecored);

    List<Sort> sortinglist = [];
    Sort sort = new Sort();
    sort.fieldId = SortField;
    sort.sortSequence = saquence;
    sortinglist.add(sort);

    DSQQuery dsqQuery = new DSQQuery();
    dsqQuery.dsqid = Weburl.Admin_Landlord_propertyList_New;
    dsqQuery.loadLookUpValues = true;
    dsqQuery.loadRecordInfo = true;
    dsqQuery.propertyListReqtokens = reqtokens;
    dsqQuery.pager = pager;
    dsqQuery.sort = sortinglist;

    String filterjson = jsonEncode(dsqQuery);

    Helper.Log("Property", filterjson);
    _store.dispatch(UpdateAdminLL_Property_isloding(true));
    _store.dispatch(UpdateAdminLL_PropertyDatalist(<PropertyData>[]));
    _store.dispatch(UpdateAdminLL_LandlordPropertySearchText(search));
    await ApiManagerAdmin().getLandlordPropertyList(context, filterjson, ftime);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Container(
      width: width - drawer_width,
      height: height - 198,
      margin: EdgeInsets.only(top: 10),
      child: ConnectState<AdminLandlordPropertyState>(
          map: (state) => state.adminLandlordPropertyState,
          where: notIdentical,
          builder: (adminLLPropertyState) {
            return Column(
              children: [
                Container(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (adminLLPropertyState!.isloding && adminLLPropertyState.LandlordPropertySearchText == "")
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
                                      style: MyStyles.Medium(14, myColor.hintcolor),
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
                                      initialValue: adminLLPropertyState.LandlordPropertySearchText,
                                      onChanged: (value) async {
                                        searchMethos(value);
                                      },
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: MyStyles.Medium(14, myColor.hintcolor),
                                        contentPadding: EdgeInsets.all(10),
                                        isDense: true,
                                        hintText: GlobleString.LL_Search,
                                      ),
                                      style: MyStyles.Medium(14, myColor.text_color),
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
                        children: [_actionPopup(adminLLPropertyState)],
                      ),
                    ],
                  ),
                ),
                _tableview(adminLLPropertyState),
              ],
            );
          }),
    );
  }

  searchMethos(String txt) async {
    await updateState();
    _store.dispatch(UpdateAdminLL_Property_isloding(true));
    _store.dispatch(UpdateAdminLL_PropertyDatalist(<PropertyData>[]));

    new Timer(Duration(seconds: 4), searchApi(txt));
  }

  searchApi(String txt) async {
    apimanager(txt, 1, "PropertyName", 1, 0);
  }

  Widget _actionPopup(AdminLandlordPropertyState adminLLPropertyState) {
    return Container(
      height: 32,
      width: 30,
      child: PopupMenuButton(
        onSelected: (value) async {
          if (value == 1) {
            await ApiManagerAdmin().getLandlordPropertyListExportCSV(context, Prefs.getString(PrefsName.OwnerID));
          } else {
            ImportDialog();
          }
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
              GlobleString.Export,
              style: MyStyles.Medium(14, myColor.text_color),
              textAlign: TextAlign.start,
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Text(
              GlobleString.Import,
              style: MyStyles.Medium(14, myColor.text_color),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  void ImportDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return ImportPropertyDialogBox(
          onPressedYes: () async {
            Navigator.of(context1).pop();

            await updateState();
            apimanager("", 1, "PropertyName", 1, 0);
          },
          onPressedNo: () {
            Navigator.of(context1).pop();
          },
        );
      },
    );
  }

  Widget _tableview(AdminLandlordPropertyState adminLLPropertyState) {
    return Container(
      width: width,
      height: height - 248,
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          //color: Hexcolor("#16C395"),
          border: Border.all(color: Colors.transparent, width: 1)),
      child: Column(
        children: [
          LandLordPropertyHeader(
            onPressedSortProperty: () {
              _store.dispatch(UpdateAdminLL_property_isPropNameSort(true));
              updateOtherSortingValue(1, adminLLPropertyState);
            },
            onPressedSortUnit: () {
              _store.dispatch(UpdateAdminLL_property_isPropUnitSort(true));
              updateOtherSortingValue(2, adminLLPropertyState);
            },
            onPressedSortCity: () {
              _store.dispatch(UpdateAdminLL_property_isPropCitySort(true));
              updateOtherSortingValue(3, adminLLPropertyState);
            },
            onPressedSortCountry: () {
              _store.dispatch(UpdateAdminLL_property_isPropCountrySort(true));
              updateOtherSortingValue(4, adminLLPropertyState);
            },
            onPressedSortPropertyType: () {
              _store.dispatch(UpdateAdminLL_property_isPropTypeSort(true));
              updateOtherSortingValue(5, adminLLPropertyState);
            },
            onPressedSortVacancy: () {
              _store.dispatch(UpdateAdminLL_property_isPropVacancySort(true));
              updateOtherSortingValue(6, adminLLPropertyState);
            },
            onPressedSortTenantName: () {
              _store.dispatch(UpdateAdminLL_property_isPropTenantNameSort(true));
              updateOtherSortingValue(7, adminLLPropertyState);
            },
            onPressedSortActiveInactive: () {
              _store.dispatch(UpdateAdminLL_property_isPropActInActSort(true));
              updateOtherSortingValue(8, adminLLPropertyState);
            },
          ),
          tableItem(adminLLPropertyState),
          if (adminLLPropertyState.PropertyDatalist != null && adminLLPropertyState.PropertyDatalist.length > 0)
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
                      textstyle: MyStyles.Medium(14, myColor.black),
                      hint: "Select page",
                      defultHeight: Helper.PagingRecord(adminLLPropertyState.totalRecord).length * 35 > 350
                          ? 350
                          : Helper.PagingRecord(adminLLPropertyState.totalRecord).length * 35,
                      selectedItem: adminLLPropertyState.pageNo.toString(),
                      items: Helper.PagingRecord(adminLLPropertyState.totalRecord),
                      showSearchBox: false,
                      isFilteredOnline: true,
                      onChanged: (value) {
                        _store.dispatch(UpdateAdminLL_Property_pageNo(int.parse(value.toString())));
                        paginationCall(adminLLPropertyState, int.parse(value.toString()));
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
                            color: adminLLPropertyState.pageNo == 1
                                ? myColor.hintcolor
                                : myColor.black,
                          ),
                          onPressed: () {
                            if (adminLLPropertyState.pageNo != 1) {
                              int pageno = adminLLPropertyState.pageNo - 1;
                              _store.dispatch(UpdateAdminLL_Property_pageNo(pageno));
                              paginationCall(adminLLPropertyState, pageno);
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
                            adminLLPropertyState.pageNo.toString(),
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
                            adminLLPropertyState.totalpage.toString(),
                            style: MyStyles.Medium(14, myColor.text_color),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: adminLLPropertyState.pageNo ==
                                adminLLPropertyState.totalpage
                                ? myColor.hintcolor
                                : myColor.black,
                          ),
                          onPressed: () {
                            if (adminLLPropertyState.pageNo !=
                                adminLLPropertyState.totalpage) {
                              int pageno = adminLLPropertyState.pageNo + 1;
                              _store.dispatch(UpdateAdminLL_Property_pageNo(pageno));
                              paginationCall(adminLLPropertyState, pageno);
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

  Widget tableItem(AdminLandlordPropertyState adminLLPropertyState) {
    return Row(
      children: [
        adminLLPropertyState.isloding
            ? Expanded(
                child: Container(
                  width: width,
                  height: height - 310,
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
            : adminLLPropertyState.PropertyDatalist != null && adminLLPropertyState.PropertyDatalist.length > 0
                ? Expanded(
                    child: LandLordPropertyItem(
                      listdata1: adminLLPropertyState.PropertyDatalist,
                      onPressName: (PropertyData propertyData) {
                        getPropertyDetails(propertyData);
                      },
                      onPressDetails: (PropertyData propertyData) async {
                        getPropertyDetails(propertyData);
                      },
                      onPressTenantDetails: (PropertyData propertyData) {
                        if (propertyData.ApplicantID != null && propertyData.ApplicantID != "") {
                          tenantDetailsAPI(propertyData.ApplicantID.toString());
                        }
                      },
                    ),
                  )
                : Expanded(
                    child: Container(
                      width: width,
                      height: height - 310,
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

  void paginationCall(AdminLandlordPropertyState adminLLPropertyState, int pageno) {
    if (adminLLPropertyState.isPropNameSort) {
      apimanager(adminLLPropertyState.LandlordPropertySearchText, pageno, "PropertyName", adminLLPropertyState.PropNameSortAcsDes, 1);
    }

    if (adminLLPropertyState.isPropUnitSort) {
      apimanager(adminLLPropertyState.LandlordPropertySearchText, pageno, "Suite_Unit", adminLLPropertyState.PropUnitSortAcsDes, 1);
    }

    if (adminLLPropertyState.isPropCitySort) {
      apimanager(adminLLPropertyState.LandlordPropertySearchText, pageno, "City", adminLLPropertyState.PropCitySortAcsDes, 1);
    }

    if (adminLLPropertyState.isPropCountrySort) {
      apimanager(adminLLPropertyState.LandlordPropertySearchText, pageno, "Country", adminLLPropertyState.PropCountrySortAcsDes, 1);
    }

    if (adminLLPropertyState.isPropTypeSort) {
      apimanager(adminLLPropertyState.LandlordPropertySearchText, pageno, "Property_Type", adminLLPropertyState.PropTypeSortAcsDes, 1);
    }

    if (adminLLPropertyState.isPropVacancySort) {
      apimanager(adminLLPropertyState.LandlordPropertySearchText, pageno, "Vacancy", adminLLPropertyState.PropVacancySortAcsDes, 1);
    }

    if (adminLLPropertyState.isPropVacancySort) {
      apimanager(adminLLPropertyState.LandlordPropertySearchText, pageno, "TenantName", adminLLPropertyState.PropTenantNameSortAcsDes, 1);
    }

    if (adminLLPropertyState.isPropActInActSort) {
      apimanager(adminLLPropertyState.LandlordPropertySearchText, pageno, "IsActive", adminLLPropertyState.PropActInActSortAcsDes, 1);
    }
  }

  updateOtherSortingValue(int flag, AdminLandlordPropertyState adminLLPropertyState) {
    updateSortingFeild(flag);

    if (flag == 1) {
      _store.dispatch(UpdateAdminLL_PropNameSortAcsDes(adminLLPropertyState.PropNameSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLL_PropUnitSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropCitySortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropCountrySortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropTypeSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropVacancySortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropStatusSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropTenantNameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropActInActSortAcsDes(0));

      apimanager("", 1, "PropertyName", adminLLPropertyState.PropNameSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 2) {
      _store.dispatch(UpdateAdminLL_PropUnitSortAcsDes(adminLLPropertyState.PropUnitSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLL_PropNameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropCitySortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropCountrySortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropTypeSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropVacancySortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropStatusSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropTenantNameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropActInActSortAcsDes(0));

      apimanager("", 1, "Suite_Unit", adminLLPropertyState.PropUnitSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 3) {
      _store.dispatch(UpdateAdminLL_PropCitySortAcsDes(adminLLPropertyState.PropCitySortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLL_PropNameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropUnitSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropCountrySortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropTypeSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropVacancySortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropStatusSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropTenantNameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropActInActSortAcsDes(0));

      apimanager("", 1, "City", adminLLPropertyState.PropCitySortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 4) {
      _store.dispatch(UpdateAdminLL_PropCountrySortAcsDes(adminLLPropertyState.PropCountrySortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLL_PropNameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropUnitSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropCitySortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropTypeSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropVacancySortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropStatusSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropTenantNameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropActInActSortAcsDes(0));

      apimanager("", 1, "Country", adminLLPropertyState.PropCountrySortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 5) {
      _store.dispatch(UpdateAdminLL_PropTypeSortAcsDes(adminLLPropertyState.PropTypeSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLL_PropNameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropUnitSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropCitySortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropCountrySortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropVacancySortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropStatusSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropTenantNameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropActInActSortAcsDes(0));

      apimanager("", 1, "Property_Type", adminLLPropertyState.PropTypeSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 6) {
      _store.dispatch(UpdateAdminLL_PropVacancySortAcsDes(adminLLPropertyState.PropVacancySortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLL_PropNameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropUnitSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropCitySortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropCountrySortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropTypeSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropStatusSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropTenantNameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropActInActSortAcsDes(0));

      apimanager("", 1, "Vacancy", adminLLPropertyState.PropVacancySortAcsDes == 1 ? 0 : 1, 0);
    }
    if (flag == 7) {
      _store.dispatch(UpdateAdminLL_PropTenantNameSortAcsDes(adminLLPropertyState.PropTenantNameSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLL_PropNameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropUnitSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropCitySortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropCountrySortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropTypeSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropVacancySortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropActInActSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropStatusSortAcsDes(0));

      apimanager("", 1, "TenantName", adminLLPropertyState.PropTenantNameSortAcsDes == 1 ? 0 : 1, 0);
    }

    if (flag == 8) {
      _store.dispatch(UpdateAdminLL_PropActInActSortAcsDes(adminLLPropertyState.PropActInActSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateAdminLL_PropNameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropUnitSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropCitySortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropCountrySortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropTypeSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropVacancySortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropTenantNameSortAcsDes(0));
      _store.dispatch(UpdateAdminLL_PropStatusSortAcsDes(0));

      apimanager("", 1, "IsActive", adminLLPropertyState.PropActInActSortAcsDes == 1 ? 0 : 1, 0);
    }
  }

  updateSortingFeild(int flag) {
    if (flag != 1) {
      _store.dispatch(UpdateAdminLL_property_isPropNameSort(false));
    }
    if (flag != 2) {
      _store.dispatch(UpdateAdminLL_property_isPropUnitSort(false));
    }
    if (flag != 3) {
      _store.dispatch(UpdateAdminLL_property_isPropCitySort(false));
    }
    if (flag != 4) {
      _store.dispatch(UpdateAdminLL_property_isPropCountrySort(false));
    }
    if (flag != 5) {
      _store.dispatch(UpdateAdminLL_property_isPropTypeSort(false));
    }
    if (flag != 6) {
      _store.dispatch(UpdateAdminLL_property_isPropVacancySort(false));
    }
    if (flag != 7) {
      _store.dispatch(UpdateAdminLL_property_isPropTenantNameSort(false));
    }
    if (flag != 8) {
      _store.dispatch(UpdateAdminLL_property_isPropActInActSort(false));
    }
  }

  getPropertyDetails(PropertyData propertyData) async {
    ApiManager().getPropertyRestriction(context, propertyData.ID!, (status, responce, restrictionlist) {
      if (status) {
        _store.dispatch(UpdateAdminSummeryRestrictionlist(restrictionlist));
      } else {
        _store.dispatch(UpdateAdminSummeryRestrictionlist([]));
      }
    });

    ApiManager().getPropertyAmanityUtility(context, propertyData.ID!, (status, responce, amenitieslist, utilitylist) {
      if (status) {
        amenitieslist.sort((a, b) => a.id!.compareTo(b.id!));
        utilitylist.sort((a, b) => a.id!.compareTo(b.id!));

        _store.dispatch(UpdateAdminSummeryPropertyAmenitiesList(amenitieslist));
        _store.dispatch(UpdateAdminSummeryPropertyUtilitiesList(utilitylist));
      } else {
        _store.dispatch(UpdateAdminSummeryPropertyAmenitiesList([]));
        _store.dispatch(UpdateAdminSummeryPropertyUtilitiesList([]));
      }
    });

    ApiManager().getPropertyImagesDSQ(context, propertyData.ID!, (status, responce, PropertyImageMediaInfolist) {
      if (status) {
        _store.dispatch(UpdateAdminSummeryPropertyImageList(PropertyImageMediaInfolist));
      } else {
        _store.dispatch(UpdateAdminSummeryPropertyImageList([]));
      }
    });

    await ApiManager().getPropertyDetails(context, propertyData.ID!, (status, responce, propertyData) async {
      if (status) {
        await bindPropertyData(propertyData!);
        Prefs.setBool(PrefsName.admin_PropertyBack, true);
        Prefs.setBool(PrefsName.admin_Landlord_PropertyBack, false);
        _store.dispatch(UpdateAdminPortalLandlordPropertyDetails(GlobleString.NAV_admin_Landlords));
      } else {}
    });

    /*  ApiManagerAdmin().getLandlordPropertyDetails(context, propertyData,
        (status, responce) async {
      if (status) {

      } else {}
    });*/
  }

  bindPropertyData(PropertyData propertyData) {
    //DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(propertyData.dateAvailable);

    DateTime tempDate = DateTime.parse(propertyData.dateAvailable!);

    /*Summery*/

    _store.dispatch(UpdateAdminSummeryProperTytypeValue(propertyData.propertyType));
    _store.dispatch(UpdateAdminSummeryPropertyTypeOtherValue(propertyData.otherPropertyType!));
    _store.dispatch(UpdateAdminSummeryDateofavailable(tempDate));
    _store.dispatch(UpdateAdminSummeryRentalSpaceValue(propertyData.rentalSpace));
    _store.dispatch(UpdateAdminSummeryPropertyName(propertyData.propertyName!));
    _store.dispatch(UpdateAdminSummeryPropertyAddress(propertyData.propertyAddress!));
    _store.dispatch(UpdateAdminSummeryPropertyDescription(propertyData.propertyDescription!));
    _store.dispatch(UpdateAdminSummerySuiteunit(propertyData.suiteUnit!));
    _store.dispatch(UpdateAdminSummeryBuildingname(propertyData.buildingName!));
    _store.dispatch(UpdateAdminSummeryPropertyCity(propertyData.city!));
    _store.dispatch(UpdateAdminSummeryPropertyCountryCode(propertyData.countryCode!));
    _store.dispatch(UpdateAdminSummeryPropertyCountryName(propertyData.country!));
    _store.dispatch(UpdateAdminSummeryPropertyProvince(propertyData.province!));
    _store.dispatch(UpdateAdminSummeryPropertyPostalcode(propertyData.postalCode!));
    _store.dispatch(UpdateAdminSummeryPropertyRentAmount(propertyData.rentAmount!));
    _store.dispatch(UpdateAdminSummeryRentPaymentFrequencyValue(propertyData.rentPaymentFrequency));
    _store.dispatch(UpdateAdminSummeryLeaseTypeValue(propertyData.leaseType));
    _store.dispatch(UpdateAdminSummeryMinimumLeasedurationValue(propertyData.minLeaseDuration));
    _store.dispatch(UpdateAdminSummeryMinimumleasedurationNumber(propertyData.minLeaseNumber.toString()));
    _store.dispatch(UpdateAdminSummeryPropertyImage(propertyData.propertyImage));
    _store.dispatch(UpdateAdminSummeryPropertyUint8List(null));
    _store.dispatch(UpdateAdminSummeryPropertyBedrooms(propertyData.bedrooms.toString()));
    _store.dispatch(UpdateAdminSummeryPropertyBathrooms(propertyData.bathrooms.toString()));
    _store.dispatch(UpdateAdminSummeryPropertySizeinsquarefeet(propertyData.size.toString()));
    _store.dispatch(UpdateAdminSummeryPropertyMaxoccupancy(propertyData.maxOccupancy!));
    _store.dispatch(UpdateAdminSummeryFurnishingValue(propertyData.furnishing));
    _store.dispatch(UpdateAdminSummeryOtherPartialFurniture(propertyData.otherPartialFurniture.toString()));
    _store.dispatch(UpdateAdminSummeryParkingstalls(propertyData.parkingStalls!));
    _store.dispatch(UpdateAdminSummeryStorageAvailableValue(propertyData.storageAvailable));
    _store.dispatch(UpdateAdminSummeryAgreeTCPP(propertyData.isAgreedTandC!));
    _store.dispatch(UpdateAdminSummeryPropertyDrafting(propertyData.PropDrafting!));
    _store.dispatch(UpdateAdminSummeryPropertyVacancy(propertyData.Vacancy!));
  }

  tenantDetailsAPI(String applicantId) async {
    ApiManagerAdmin().getLandlordTenancyDetails(context, applicantId, (status, responce) {
      if (status) {
        Prefs.setBool(PrefsName.Is_adminLandlord_lead, false);
        Prefs.setBool(PrefsName.Is_adminLandlord_Property, true);
        _store.dispatch(UpdateAdminPortalLandlordTenancyDetails(GlobleString.NAV_admin_Landlords));
      } else {
        Helper.Log("respoce", responce);
      }
    });
  }
}
