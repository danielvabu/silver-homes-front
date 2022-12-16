import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/vendor_action/add_vendor_action.dart';
import 'package:silverhome/domain/actions/vendor_action/landlord_vendor_action.dart';
import 'package:silverhome/domain/entities/vendordata.dart';
import 'package:silverhome/presentation/models/vendor/landlord_vendor_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/dsq_query.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/alert/alert_dialogbox.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/landlord/maintenance_dialog/addVendor_dialogbox.dart';
import 'package:silverhome/widget/landlord/maintenance_vendor_table/vendors_header.dart';
import 'package:silverhome/widget/landlord/maintenance_vendor_table/vendors_item.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

class MaintenanceVendorsScreen extends StatefulWidget {
  @override
  _MaintenanceVendorsState createState() => _MaintenanceVendorsState();
}

class _MaintenanceVendorsState extends State<MaintenanceVendorsScreen> {
  double height = 0, width = 0;
  final _store = getIt<AppStore>();

  late OverlayEntry loader;
  late Timer? _timer = null;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    await Prefs.init();
    updatecount();
    updateState();
    apimanager("", 1, "ID", 0, 0);
  }

  void updatecount() {
    _store.dispatch(UpdateLLVendor_status_TotalVendor(0));

    ApiManager().getVendorCount(context, Prefs.getString(PrefsName.OwnerID));
  }

  updateState() async {
    _store.dispatch(UpdateLLVendor_SearchText(""));
    _store.dispatch(UpdateLLVendor_isCompanyNameSort(false));
    await updateSortingFeild(1);
    _store.dispatch(UpdateLLVendor_CompanyNameSortAcsDes(0));
    _store.dispatch(UpdateLLVendor_CitySortAcsDes(0));
    _store.dispatch(UpdateLLVendor_ContactNameSortAcsDes(0));
    _store.dispatch(UpdateLLVendor_EmailSortAcsDes(0));
    _store.dispatch(UpdateLLVendor_PhoneSortAcsDes(0));
    _store.dispatch(UpdateLLVendor_CategorySortAcsDes(0));
    _store.dispatch(UpdateLLVendor_RatingSortAcsDes(0));
  }

  apimanager(String search, int pageNo, String SortField, int saquence, int ftime) async {
    VendorListReqtokens reqtokens = new VendorListReqtokens();
    reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    reqtokens.Name = search != null ? search : "";

    Pager pager = new Pager(pageNo: pageNo, noOfRecords: Helper.noofrecored);

    List<Sort> sortinglist = [];
    Sort sort = new Sort();
    sort.fieldId = SortField;
    sort.sortSequence = saquence;
    sortinglist.add(sort);

    DSQQuery dsqQuery = new DSQQuery();
    dsqQuery.dsqid = Weburl.DSQ_landlord_VendorList;
    dsqQuery.loadLookUpValues = true;
    dsqQuery.loadRecordInfo = false;
    dsqQuery.vendorListReqtokens = reqtokens;
    dsqQuery.pager = pager;
    dsqQuery.sort = sortinglist;

    String filterjson = jsonEncode(dsqQuery);

    Helper.Log("Property", filterjson);
    _store.dispatch(UpdateLLVendor_isloding(true));
    _store.dispatch(UpdateLL_vendordatalist(<VendorData>[]));
    _store.dispatch(UpdateLLVendor_SearchText(search));
    await ApiManager().getVendorList(context, filterjson, ftime);
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
          padding: EdgeInsets.all(15),
          child: ConnectState<LandlordVendorState>(
            map: (state) => state.landlordVendorState,
            where: notIdentical,
            builder: (landlordVendorState) {
              return Column(
                children: [
                  _statusView(landlordVendorState),
                  _centerView(landlordVendorState!),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _statusView(LandlordVendorState? landlordVendorState) {
    return Container(
      child: Row(
        children: [
          CustomeWidget.PropertyStutas(landlordVendorState!.status_TotalVendor.toString(), GlobleString.LMV_status_TotalVendors),
          Expanded(child: Container()),
          Expanded(child: Container()),
          Expanded(child: Container()),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  Widget _centerView(LandlordVendorState landlordVendorState) {
    return Container(
      width: width,
      height: height - 95,
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.all(10),
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
                    if (landlordVendorState.isloding && landlordVendorState.SearchText == "")
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
                                initialValue: landlordVendorState.SearchText,
                                onChanged: (value) async {
                                  if (_timer != null) {
                                    _timer!.cancel();
                                  }
                                  _timer = Timer.periodic(Duration(milliseconds: 400), (timer) {
                                    _store.dispatch(UpdateLLVendor_isloding(true));
                                    _store.dispatch(UpdateLL_vendordatalist(<VendorData>[]));
                                    updateState();
                                    apimanager(value, 1, "ID", 0, 0);
                                    _timer!.cancel();
                                  });
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: MyStyles.Medium(14, myColor.hintcolor),
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
                    const SizedBox(width: 10),
                    _addNewRequest(landlordVendorState),
                  ],
                ),
                Row(
                  children: [_actionPopup(landlordVendorState)],
                ),
              ],
            ),
          ),
          _tableview(landlordVendorState)
        ],
      ),
    );
  }

  Widget _addNewRequest(LandlordVendorState landlordVendorState) {
    return InkWell(
      onTap: () async {
        await clearVendorStateData();
        ApiManager().getCountryList(context, (status, responce, errorlist) {
          if (status) {
            _store.dispatch(UpdateADV_countrydatalist(errorlist));
            openDialodAddVendor(false);
          }
        });
      },
      child: CustomeWidget.AddNewButton(GlobleString.LMV_Add_New_Vendor),
    );
  }

  clearVendorStateData() {
    _store.dispatch(UpdateADV_vid(0));
    _store.dispatch(UpdateADV_personid(0));
    _store.dispatch(UpdateADV_countrydatalist([]));
    _store.dispatch(UpdateADV_statedatalist([]));
    _store.dispatch(UpdateADV_citydatalist([]));
    _store.dispatch(UpdateADV_companyname(""));
    _store.dispatch(UpdateADV_cfirstname(""));
    _store.dispatch(UpdateADV_clastname(""));
    _store.dispatch(UpdateADV_cemail(""));
    _store.dispatch(UpdateADV_cdialcode("+91"));
    _store.dispatch(UpdateADV_ccountrycode("CA"));
    _store.dispatch(UpdateADV_cphone(""));
    _store.dispatch(UpdateADV_address(""));
    _store.dispatch(UpdateADV_suit(""));
    _store.dispatch(UpdateADV_postalcode(""));
    _store.dispatch(UpdateADV_selectCategory(null));
    _store.dispatch(UpdateADV_selectedCountry(null));
    _store.dispatch(UpdateADV_selectedState(null));
    _store.dispatch(UpdateADV_selectedCity(null));
    _store.dispatch(UpdateADV_Note(""));
    _store.dispatch(UpdateADV_rating(0));
  }

  updateVendorStateData(VendorData data, bool ranking) {
    _store.dispatch(UpdateADV_vid(data.id!));
    _store.dispatch(UpdateADV_personid(data.PersonID!));
    _store.dispatch(UpdateADV_countrydatalist([]));
    _store.dispatch(UpdateADV_statedatalist([]));
    _store.dispatch(UpdateADV_citydatalist([]));
    _store.dispatch(UpdateADV_companyname(data.companyName!));
    _store.dispatch(UpdateADV_cfirstname(data.firstName!));
    _store.dispatch(UpdateADV_clastname(data.lastName!));
    _store.dispatch(UpdateADV_cemail(data.email!));
    _store.dispatch(UpdateADV_cdialcode(data.Dial_Code!));
    _store.dispatch(UpdateADV_ccountrycode(data.Country_Code!));
    _store.dispatch(UpdateADV_cphone(data.mobileNumber!));
    _store.dispatch(UpdateADV_address(data.address!));
    _store.dispatch(UpdateADV_suit(data.suite!));
    _store.dispatch(UpdateADV_postalcode(data.PostalCode!));
    _store.dispatch(UpdateADV_selectCategory(data.category));
    _store.dispatch(UpdateADV_selectedCountry(data.country));
    _store.dispatch(UpdateADV_selectedState(data.province));
    _store.dispatch(UpdateADV_selectedCity(data.city));
    _store.dispatch(UpdateADV_Note(data.Note!));
    _store.dispatch(UpdateADV_rating(data.rating!));

    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().getCountryList(context, (status, responce, errorlist) {
      if (status) {
        _store.dispatch(UpdateADV_countrydatalist(errorlist));
        ApiManager().getStateList(context, data.country!.ID.toString(), (status, responce, errorlist) {
          if (status) {
            _store.dispatch(UpdateADV_statedatalist(errorlist));

            ApiManager().getCityList(context, data.province!.ID.toString(), (status, responce, errorlist) {
              if (status) {
                loader.remove();
                _store.dispatch(UpdateADV_citydatalist(errorlist));
                openDialodAddVendor(ranking);
              } else {
                loader.remove();
              }
            });
          } else {
            loader.remove();
          }
        });
      } else {
        loader.remove();
      }
    });
  }

  openDialodAddVendor(bool ranking) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: ranking,
      builder: (BuildContext context1) {
        return AddVendorDialogBox(
          rankingPress: ranking,
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

  Widget _actionPopup(LandlordVendorState landlordVendorState) {
    return Container(
      height: 32,
      width: 30,
      child: PopupMenuButton(
        onSelected: (value) async {
          VendorListReqtokens reqtokens = VendorListReqtokens();
          reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
          reqtokens.Name = landlordVendorState.SearchText != null ? landlordVendorState.SearchText : "";

          List<Sort> sortinglist = [];
          Sort sort = new Sort();
          if (landlordVendorState.SearchText != null && landlordVendorState.SearchText.isNotEmpty) {
            sort.fieldId = "ID";
            sort.sortSequence = 0;
          } else {
            if (landlordVendorState.isCompanyNameSort) {
              sort.fieldId = "CompanyName";
              sort.sortSequence = landlordVendorState.CompanyNameSortAcsDes;
            } else if (landlordVendorState.isCitySort) {
              sort.fieldId = "City.CityName";
              sort.sortSequence = landlordVendorState.CitySortAcsDes;
            } else if (landlordVendorState.isContactNameSort) {
              sort.fieldId = "PersonID.FirstName";
              sort.sortSequence = landlordVendorState.ContactNameSortAcsDes;
            } else if (landlordVendorState.isEmaiSort) {
              sort.fieldId = "PersonID.Email";
              sort.sortSequence = landlordVendorState.EmailSortAcsDes;
            } else if (landlordVendorState.isPhoneSort) {
              sort.fieldId = "PersonID.MobileNumber";
              sort.sortSequence = landlordVendorState.PhoneSortAcsDes;
            } else if (landlordVendorState.isCategorySort) {
              sort.fieldId = "Category";
              sort.sortSequence = landlordVendorState.CategorySortAcsDes;
            } else if (landlordVendorState.isRatingSort) {
              sort.fieldId = "Rating";
              sort.sortSequence = landlordVendorState.RatingSortAcsDes;
            } else {
              sort.fieldId = "ID";
              sort.sortSequence = 0;
            }
          }

          sortinglist.add(sort);

          DSQQuery dsqQuery = new DSQQuery();
          dsqQuery.dsqid = Weburl.DSQ_landlord_VendorList;
          dsqQuery.loadLookUpValues = true;
          dsqQuery.loadRecordInfo = false;
          dsqQuery.vendorListReqtokens = reqtokens;
          dsqQuery.sort = sortinglist;

          String filterjson = jsonEncode(dsqQuery);

          await ApiManager().getAllVendorListCSV(context, filterjson);
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

  Widget _tableview(LandlordVendorState landlordVendorState) {
    return Container(
      width: width,
      height: height - 167,
      margin: const EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      decoration:
          BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(3)), border: Border.all(color: Colors.transparent, width: 1)),
      child: Column(
        children: [
          tableHeader(landlordVendorState),
          tableItem(landlordVendorState),
          if (landlordVendorState.vendordatalist != null && landlordVendorState.vendordatalist.length > 0) tablefooter(landlordVendorState),
        ],
      ),
    );
  }

  Widget tableHeader(LandlordVendorState landlordVendorState) {
    return VendorsHeader(
      onPressedSortCompanyName: () {
        _store.dispatch(UpdateLLVendor_isCompanyNameSort(true));
        updateOtherSortingValue(1, landlordVendorState);
      },
      onPressedSortCity: () {
        _store.dispatch(UpdateLLVendor_isCitySort(true));
        updateOtherSortingValue(2, landlordVendorState);
      },
      onPressedSortContactName: () {
        _store.dispatch(UpdateLLVendor_isContactNameSort(true));
        updateOtherSortingValue(3, landlordVendorState);
      },
      onPressedSortEmail: () {
        _store.dispatch(UpdateLLVendor_isEmaiSort(true));
        updateOtherSortingValue(4, landlordVendorState);
      },
      onPressedSortPhone: () {
        _store.dispatch(UpdateLLVendor_isPhoneSort(true));
        updateOtherSortingValue(5, landlordVendorState);
      },
      onPressedSortCategory: () {
        _store.dispatch(UpdateLLVendor_isCategorySort(true));
        updateOtherSortingValue(6, landlordVendorState);
      },
      onPressedSortRating: () {
        _store.dispatch(UpdateLLVendor_isRatingSort(true));
        updateOtherSortingValue(7, landlordVendorState);
      },
    );
  }

  Widget tableItem(LandlordVendorState landlordVendorState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        landlordVendorState.isloding
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
            : landlordVendorState.vendordatalist != null && landlordVendorState.vendordatalist.length > 0
                ? Expanded(
                    child: VendorsItem(
                      listdata1: landlordVendorState.vendordatalist,
                      onPressView: (VendorData data, int pos) async {
                        await clearVendorStateData();
                        await updateVendorStateData(data, false);
                      },
                      onPresseEdit: (VendorData data, int pos) async {
                        await clearVendorStateData();
                        await updateVendorStateData(data, false);
                      },
                      onPresseRankingEdit: (VendorData data, int pos) async {
                        await clearVendorStateData();
                        await updateVendorStateData(data, true);
                      },
                      onPresseDuplicat: (VendorData data, int pos) {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black45,
                          useSafeArea: true,
                          barrierDismissible: false,
                          builder: (BuildContext context1) {
                            return AlertDialogBox(
                              title: GlobleString.vendor_dupliacate_title,
                              negativeText: GlobleString.vendor_dupliacate_NO,
                              positiveText: GlobleString.vendor_dupliacate_yes,
                              onPressedYes: () {
                                Navigator.of(context1).pop();
                                duplicateVendor(data, landlordVendorState);
                              },
                              onPressedNo: () {
                                Navigator.of(context1).pop();
                              },
                            );
                          },
                        );
                      },
                      onPresseArchive: (VendorData data, int pos) {},
                      onPresseDelete: (VendorData data, int pos) {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black45,
                          useSafeArea: true,
                          barrierDismissible: false,
                          builder: (BuildContext context1) {
                            return AlertDialogBox(
                              title: GlobleString.LMV_DL_Vendor_Delete,
                              positiveText: GlobleString.LMV_DL_Vendor_btn_Delete,
                              negativeText: GlobleString.LMV_DL_Vendor_btn_Cancel,
                              onPressedYes: () {
                                Navigator.of(context1).pop();
                                deleteVendor(data, landlordVendorState);
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
                        GlobleString.vendor_data_not_found,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: MyStyles.Medium(18, myColor.tabel_msg),
                      ),
                    ),
                  )
      ],
    );
  }

  Widget tablefooter(LandlordVendorState landlordVendorState) {
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
              defultHeight: Helper.PagingRecord(landlordVendorState.totalRecord).length * 35 > 350
                  ? 350
                  : Helper.PagingRecord(landlordVendorState.totalRecord).length * 35,
              selectedItem: landlordVendorState.pageNo.toString(),
              items: Helper.PagingRecord(landlordVendorState.totalRecord),
              showSearchBox: false,
              isFilteredOnline: true,
              onChanged: (value) {
                _store.dispatch(UpdateLLVendor_pageNo(int.parse(value.toString())));
                paginationCall(landlordVendorState, int.parse(value.toString()));
              },
            ),
          )
        ],
      ),
    );
  }

  paginationCall(LandlordVendorState landlordVendorState, int pageno) {
    if (landlordVendorState.isCompanyNameSort) {
      apimanager(landlordVendorState.SearchText, pageno, "CompanyName", landlordVendorState.CompanyNameSortAcsDes, 1);
    } else if (landlordVendorState.isCitySort) {
      apimanager(landlordVendorState.SearchText, pageno, "City.CityName", landlordVendorState.CitySortAcsDes, 1);
    } else if (landlordVendorState.isContactNameSort) {
      apimanager(landlordVendorState.SearchText, pageno, "PersonID.FirstName", landlordVendorState.ContactNameSortAcsDes, 1);
    } else if (landlordVendorState.isEmaiSort) {
      apimanager(landlordVendorState.SearchText, pageno, "PersonID.Email", landlordVendorState.EmailSortAcsDes, 1);
    } else if (landlordVendorState.isPhoneSort) {
      apimanager(landlordVendorState.SearchText, pageno, "PersonID.MobileNumber", landlordVendorState.PhoneSortAcsDes, 1);
    } else if (landlordVendorState.isCategorySort) {
      apimanager(landlordVendorState.SearchText, pageno, "Category", landlordVendorState.CategorySortAcsDes, 1);
    } else if (landlordVendorState.isRatingSort) {
      apimanager(landlordVendorState.SearchText, pageno, "Rating", landlordVendorState.RatingSortAcsDes, 1);
    } else {
      apimanager(landlordVendorState.SearchText, pageno, "ID", 0, 1);
    }
  }

  updateOtherSortingValue(int flag, LandlordVendorState landlordVendorState) {
    updateSortingFeild(flag);

    if (flag == 1) {
      _store.dispatch(UpdateLLVendor_CompanyNameSortAcsDes(landlordVendorState.CompanyNameSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLVendor_CitySortAcsDes(0));
      _store.dispatch(UpdateLLVendor_ContactNameSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_EmailSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_PhoneSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_CategorySortAcsDes(0));
      _store.dispatch(UpdateLLVendor_RatingSortAcsDes(0));

      apimanager("", 1, "CompanyName", landlordVendorState.CompanyNameSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 2) {
      _store.dispatch(UpdateLLVendor_CitySortAcsDes(landlordVendorState.CitySortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLVendor_CompanyNameSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_ContactNameSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_EmailSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_PhoneSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_CategorySortAcsDes(0));
      _store.dispatch(UpdateLLVendor_RatingSortAcsDes(0));

      apimanager("", 1, "City.CityName", landlordVendorState.CitySortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 3) {
      _store.dispatch(UpdateLLVendor_ContactNameSortAcsDes(landlordVendorState.ContactNameSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLVendor_CompanyNameSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_CitySortAcsDes(0));
      _store.dispatch(UpdateLLVendor_EmailSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_PhoneSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_CategorySortAcsDes(0));
      _store.dispatch(UpdateLLVendor_RatingSortAcsDes(0));

      apimanager("", 1, "PersonID.FirstName", landlordVendorState.ContactNameSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 4) {
      _store.dispatch(UpdateLLVendor_EmailSortAcsDes(landlordVendorState.EmailSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLVendor_CompanyNameSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_CitySortAcsDes(0));
      _store.dispatch(UpdateLLVendor_ContactNameSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_PhoneSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_CategorySortAcsDes(0));
      _store.dispatch(UpdateLLVendor_RatingSortAcsDes(0));

      apimanager("", 1, "PersonID.Email", landlordVendorState.EmailSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 5) {
      _store.dispatch(UpdateLLVendor_PhoneSortAcsDes(landlordVendorState.PhoneSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLVendor_CompanyNameSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_CitySortAcsDes(0));
      _store.dispatch(UpdateLLVendor_ContactNameSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_EmailSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_CategorySortAcsDes(0));
      _store.dispatch(UpdateLLVendor_RatingSortAcsDes(0));

      apimanager("", 1, "PersonID.MobileNumber", landlordVendorState.PhoneSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 6) {
      _store.dispatch(UpdateLLVendor_CategorySortAcsDes(landlordVendorState.CategorySortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLVendor_CompanyNameSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_CitySortAcsDes(0));
      _store.dispatch(UpdateLLVendor_ContactNameSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_EmailSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_PhoneSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_RatingSortAcsDes(0));

      apimanager("", 1, "Category", landlordVendorState.CategorySortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 7) {
      _store.dispatch(UpdateLLVendor_RatingSortAcsDes(landlordVendorState.RatingSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLVendor_CompanyNameSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_CitySortAcsDes(0));
      _store.dispatch(UpdateLLVendor_ContactNameSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_EmailSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_PhoneSortAcsDes(0));
      _store.dispatch(UpdateLLVendor_CategorySortAcsDes(0));

      apimanager("", 1, "Rating", landlordVendorState.RatingSortAcsDes == 1 ? 0 : 1, 0);
    }
  }

  updateSortingFeild(int flag) {
    if (flag != 1) {
      _store.dispatch(UpdateLLVendor_isCompanyNameSort(false));
    }
    if (flag != 2) {
      _store.dispatch(UpdateLLVendor_isCitySort(false));
    }
    if (flag != 3) {
      _store.dispatch(UpdateLLVendor_isContactNameSort(false));
    }
    if (flag != 4) {
      _store.dispatch(UpdateLLVendor_isEmaiSort(false));
    }
    if (flag != 5) {
      _store.dispatch(UpdateLLVendor_isPhoneSort(false));
    }
    if (flag != 6) {
      _store.dispatch(UpdateLLVendor_isCategorySort(false));
    }
    if (flag != 7) {
      _store.dispatch(UpdateLLVendor_isRatingSort(false));
    }
  }

  duplicateVendor(VendorData vendorData, LandlordVendorState landlordVendorState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().duplicateVendorworkflow(context, vendorData.id.toString(), (error, respoce) {
      if (error) {
        init();
        ToastUtils.showCustomToast(context, GlobleString.vendor_dupliacate_successfully, true);

        if (respoce != null && respoce.isNotEmpty) {
          ApiManager().getVendorDetails(context, respoce, (status, responce, vendorData) async {
            if (status) {
              loader.remove();
              await clearVendorStateData();
              await updateVendorStateData(vendorData, false);
            } else {
              loader.remove();
            }
          });
        } else {
          loader.remove();
        }
      } else {
        loader.remove();
        String errormsg1 = respoce.replaceAll("One or more errors occurred. (", "");
        String errormsg = errormsg1.replaceAll(")", "");
        ToastUtils.showCustomToast(context, errormsg, false);
      }
    });
  }

  deleteVendor(VendorData vendorData, LandlordVendorState landlordVendorState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    CommonID id = new CommonID(ID: vendorData.id.toString());

    ApiManager().deleteVendorAPI(context, id, (error, respoce) async {
      if (error) {
        loader.remove();
        init();
        ToastUtils.showCustomToast(context, GlobleString.Vendor_delete_successfully, true);
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
        Helper.Log("respoce", respoce);
      }
    });
  }
}
