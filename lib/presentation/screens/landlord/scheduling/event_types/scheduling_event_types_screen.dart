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
import 'package:silverhome/domain/actions/event_types_action/add_event_types_action.dart';
import 'package:silverhome/domain/actions/event_types_action/landlord_event_types_action.dart';
import 'package:silverhome/domain/entities/event_typesdata.dart';
import 'package:silverhome/presentation/models/event_types/landlord_event_types_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/dsq_query.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/alert_dialogbox.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/landlord/maintenance_dialog/addEventTypes_dialogbox.dart';
import 'package:silverhome/widget/landlord/maintenance_event_types_table/event_typess_header.dart';
import 'package:silverhome/widget/landlord/maintenance_event_types_table/event_typess_item.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

class EventTypesScreen extends StatefulWidget {
  @override
  _landlordEventTypesState createState() => _landlordEventTypesState();
}

class _landlordEventTypesState extends State<EventTypesScreen> {
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
    _store.dispatch(UpdateLLEventTypes_status_TotalEventTypes(0));

    ApiManager().getEventTypesCount(context, Prefs.getString(PrefsName.OwnerID));
  }

  updateState() async {
    _store.dispatch(UpdateLLEventTypes_SearchText(""));
    _store.dispatch(UpdateLLEventTypes_isCompanyNameSort(false));
    await updateSortingFeild(1);
    _store.dispatch(UpdateLLEventTypes_CompanyNameSortAcsDes(0));
    _store.dispatch(UpdateLLEventTypes_CitySortAcsDes(0));
    _store.dispatch(UpdateLLEventTypes_ContactNameSortAcsDes(0));
    _store.dispatch(UpdateLLEventTypes_EmailSortAcsDes(0));
    _store.dispatch(UpdateLLEventTypes_PhoneSortAcsDes(0));
    _store.dispatch(UpdateLLEventTypes_CategorySortAcsDes(0));
    _store.dispatch(UpdateLLEventTypes_RatingSortAcsDes(0));
  }

  apimanager(String search, int pageNo, String SortField, int saquence,
      int ftime) async {
    EventTypesListReqtokens reqtokens = new EventTypesListReqtokens();
    reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    reqtokens.Name = search != null ? search : "";

    Pager pager = new Pager(pageNo: pageNo, noOfRecords: Helper.noofrecored);

    List<Sort> sortinglist = [];
    Sort sort = new Sort();
    sort.fieldId = SortField;
    sort.sortSequence = saquence;
    sortinglist.add(sort);

    DSQQuery dsqQuery = new DSQQuery();
    dsqQuery.dsqid = Weburl.DSQ_landlord_EventTypesList;
    dsqQuery.loadLookUpValues = true;
    dsqQuery.loadRecordInfo = false;
    dsqQuery.event_typesListReqtokens = reqtokens;
    dsqQuery.pager = pager;
    dsqQuery.sort = sortinglist;

    String filterjson = jsonEncode(dsqQuery);

    Helper.Log("Property", filterjson);
    _store.dispatch(UpdateLLEventTypes_isloding(true));
    _store.dispatch(UpdateLL_event_typesdatalist(<EventTypesData>[]));
    _store.dispatch(UpdateLLEventTypes_SearchText(search));
    await ApiManager().getEventTypesList(context, filterjson, ftime);
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
          child: ConnectState<landlordEventTypesState>(
            map: (state) => state.landlordEventTypesState,
            where: notIdentical,
            builder: (landlordEventTypesState) {
              return Column(
                children: [
                  _centerView(landlordEventTypesState!),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _centerView(landlordEventTypesState landlordEventTypesState) {
    return Container(
      width: width,
      height: height - 45,
      margin: const EdgeInsets.only(top: 15.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: myColor.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: myColor.application_boreder, width: 1),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (landlordEventTypesState.isloding &&
                        landlordEventTypesState.SearchText == "")
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
                                    landlordEventTypesState.SearchText,
                                onChanged: (value) async {
                                  if (_timer != null) {
                                    _timer!.cancel();
                                  }
                                  _timer = Timer.periodic(Duration(seconds: 2),
                                      (timer) {
                                    _store.dispatch(
                                        UpdateLLEventTypes_isloding(true));
                                    _store.dispatch(UpdateLL_event_typesdatalist(
                                        <EventTypesData>[]));
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
                                  contentPadding: const EdgeInsets.all(10.0),
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
                    _addNewRequest(landlordEventTypesState),
                  ],
                ),
                Row(
                  children: [_actionPopup(landlordEventTypesState)],
                ),
              ],
            ),
          ),
          _tableview(landlordEventTypesState)
        ],
      ),
    );
  }

  Widget _addNewRequest(landlordEventTypesState landlordEventTypesState) {
    return InkWell(
      onTap: () async {
        await clearEventTypesStateData();

        ApiManager().getCountryList(context, (status, responce, errorlist) {
          if (status) {
            _store.dispatch(UpdateADV_countrydatalist(errorlist));
            openDialodAddEventTypes();
          }
        });
      },
      child: CustomeWidget.AddNewButton(GlobleString.LMV_Add_New_EventTypes),
    );
  }

  clearEventTypesStateData() {
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

  updateEventTypesStateData(EventTypesData data) {
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
        ApiManager().getStateList(context, data.country!.ID.toString(),
            (status, responce, errorlist) {
          if (status) {
            _store.dispatch(UpdateADV_statedatalist(errorlist));

            ApiManager().getCityList(context, data.province!.ID.toString(),
                (status, responce, errorlist) {
              if (status) {
                loader.remove();
                _store.dispatch(UpdateADV_citydatalist(errorlist));
                openDialodAddEventTypes();
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

  openDialodAddEventTypes() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AddEventTypesDialogBox(
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

  Widget _actionPopup(landlordEventTypesState landlordEventTypesState) {
    return Container(
      height: 32,
      width: 30,
      child: PopupMenuButton(
        onSelected: (value) async {
          EventTypesListReqtokens reqtokens = new EventTypesListReqtokens();
          reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
          reqtokens.Name = landlordEventTypesState.SearchText != null
              ? landlordEventTypesState.SearchText
              : "";

          List<Sort> sortinglist = [];
          Sort sort = new Sort();
          if (landlordEventTypesState.SearchText != null &&
              landlordEventTypesState.SearchText.isNotEmpty) {
            sort.fieldId = "ID";
            sort.sortSequence = 0;
          } else {
            if (landlordEventTypesState.isCompanyNameSort) {
              sort.fieldId = "CompanyName";
              sort.sortSequence = landlordEventTypesState.CompanyNameSortAcsDes;
            } else if (landlordEventTypesState.isCitySort) {
              sort.fieldId = "City.CityName";
              sort.sortSequence = landlordEventTypesState.CitySortAcsDes;
            } else if (landlordEventTypesState.isContactNameSort) {
              sort.fieldId = "PersonID.FirstName";
              sort.sortSequence = landlordEventTypesState.ContactNameSortAcsDes;
            } else if (landlordEventTypesState.isEmaiSort) {
              sort.fieldId = "PersonID.Email";
              sort.sortSequence = landlordEventTypesState.EmailSortAcsDes;
            } else if (landlordEventTypesState.isPhoneSort) {
              sort.fieldId = "PersonID.MobileNumber";
              sort.sortSequence = landlordEventTypesState.PhoneSortAcsDes;
            } else if (landlordEventTypesState.isCategorySort) {
              sort.fieldId = "Category";
              sort.sortSequence = landlordEventTypesState.CategorySortAcsDes;
            } else if (landlordEventTypesState.isRatingSort) {
              sort.fieldId = "Rating";
              sort.sortSequence = landlordEventTypesState.RatingSortAcsDes;
            } else {
              sort.fieldId = "ID";
              sort.sortSequence = 0;
            }
          }

          sortinglist.add(sort);

          DSQQuery dsqQuery = new DSQQuery();
          dsqQuery.dsqid = Weburl.DSQ_landlord_EventTypesList;
          dsqQuery.loadLookUpValues = true;
          dsqQuery.loadRecordInfo = false;
          dsqQuery.event_typesListReqtokens = reqtokens;
          dsqQuery.sort = sortinglist;

          String filterjson = jsonEncode(dsqQuery);

          await ApiManager().getAllEventTypesListCSV(context, filterjson);
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

  Widget _tableview(landlordEventTypesState landlordEventTypesState) {
    return Container(
      width: width,
      height: height - 167,
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          //color: Hexcolor("#16C395"),
          border: Border.all(color: Colors.transparent, width: 1)),
      child: Column(
        children: [
          tableHeader(landlordEventTypesState),
          tableItem(landlordEventTypesState),
          if (landlordEventTypesState.event_typesdatalist != null &&
              landlordEventTypesState.event_typesdatalist.length > 0)
            tablefooter(landlordEventTypesState),
        ],
      ),
    );
  }

  Widget tableHeader(landlordEventTypesState landlordEventTypesState) {
    return EventTypessHeader(
      onPressedSortCompanyName: () {
        _store.dispatch(UpdateLLEventTypes_isCompanyNameSort(true));
        updateOtherSortingValue(1, landlordEventTypesState);
      },
      onPressedSortCity: () {
        _store.dispatch(UpdateLLEventTypes_isCitySort(true));
        updateOtherSortingValue(2, landlordEventTypesState);
      },
      onPressedSortContactName: () {
        _store.dispatch(UpdateLLEventTypes_isContactNameSort(true));
        updateOtherSortingValue(3, landlordEventTypesState);
      },
      onPressedSortEmail: () {
        _store.dispatch(UpdateLLEventTypes_isEmaiSort(true));
        updateOtherSortingValue(4, landlordEventTypesState);
      },
      onPressedSortPhone: () {
        _store.dispatch(UpdateLLEventTypes_isPhoneSort(true));
        updateOtherSortingValue(5, landlordEventTypesState);
      },
      onPressedSortCategory: () {
        _store.dispatch(UpdateLLEventTypes_isCategorySort(true));
        updateOtherSortingValue(6, landlordEventTypesState);
      },
      onPressedSortRating: () {
        _store.dispatch(UpdateLLEventTypes_isRatingSort(true));
        updateOtherSortingValue(7, landlordEventTypesState);
      },
    );
  }

  Widget tableItem(landlordEventTypesState landlordEventTypesState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        landlordEventTypesState.isloding
            ? Expanded(
                child: Container(
                  width: width,
                  height: height - 229,
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
            : landlordEventTypesState.event_typesdatalist != null &&
                    landlordEventTypesState.event_typesdatalist.length > 0
                ? Expanded(
                    child: EventTypessItem(
                      listdata1: landlordEventTypesState.event_typesdatalist,
                      onPressView: (EventTypesData data, int pos) async {
                        await clearEventTypesStateData();
                        await updateEventTypesStateData(data);
                      },
                      onPresseEdit: (EventTypesData data, int pos) async {
                        await clearEventTypesStateData();
                        await updateEventTypesStateData(data);
                      },
                      onPresseDuplicat: (EventTypesData data, int pos) {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black45,
                          useSafeArea: true,
                          barrierDismissible: false,
                          builder: (BuildContext context1) {
                            return AlertDialogBox(
                              title: GlobleString.event_types_dupliacate_title,
                              negativeText: GlobleString.event_types_dupliacate_NO,
                              positiveText: GlobleString.event_types_dupliacate_yes,
                              onPressedYes: () {
                                Navigator.of(context1).pop();
                                duplicateEventTypes(data, landlordEventTypesState);
                              },
                              onPressedNo: () {
                                Navigator.of(context1).pop();
                              },
                            );
                          },
                        );
                      },
                      onPresseArchive: (EventTypesData data, int pos) {},
                      onPresseDelete: (EventTypesData data, int pos) {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black45,
                          useSafeArea: true,
                          barrierDismissible: false,
                          builder: (BuildContext context1) {
                            return AlertDialogBox(
                              title: GlobleString.LMV_DL_EventTypes_Delete,
                              positiveText:
                                  GlobleString.LMV_DL_EventTypes_btn_Delete,
                              negativeText:
                                  GlobleString.LMV_DL_EventTypes_btn_Cancel,
                              onPressedYes: () {
                                Navigator.of(context1).pop();
                                deleteEventTypes(data, landlordEventTypesState);
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
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text(
                        GlobleString.event_types_data_not_found,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: MyStyles.Medium(18, myColor.tabel_msg),
                      ),
                    ),
                  )
      ],
    );
  }

  Widget tablefooter(landlordEventTypesState landlordEventTypesState) {
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
              defultHeight:
                  Helper.PagingRecord(landlordEventTypesState.totalRecord)
                                  .length *
                              35 >
                          350
                      ? 350
                      : Helper.PagingRecord(landlordEventTypesState.totalRecord)
                              .length *
                          35,
              selectedItem: landlordEventTypesState.pageNo.toString(),
              items: Helper.PagingRecord(landlordEventTypesState.totalRecord),
              showSearchBox: false,
              isFilteredOnline: true,
              onChanged: (value) {
                _store.dispatch(
                    UpdateLLEventTypes_pageNo(int.parse(value.toString())));
                paginationCall(
                    landlordEventTypesState, int.parse(value.toString()));
              },
            ),
          )
        ],
      ),
    );
  }

  paginationCall(landlordEventTypesState landlordEventTypesState, int pageno) {
    if (landlordEventTypesState.isCompanyNameSort) {
      apimanager(landlordEventTypesState.SearchText, pageno, "CompanyName",
          landlordEventTypesState.CompanyNameSortAcsDes, 1);
    } else if (landlordEventTypesState.isCitySort) {
      apimanager(landlordEventTypesState.SearchText, pageno, "City.CityName",
          landlordEventTypesState.CitySortAcsDes, 1);
    } else if (landlordEventTypesState.isContactNameSort) {
      apimanager(
          landlordEventTypesState.SearchText,
          pageno,
          "PersonID.FirstName",
          landlordEventTypesState.ContactNameSortAcsDes,
          1);
    } else if (landlordEventTypesState.isEmaiSort) {
      apimanager(landlordEventTypesState.SearchText, pageno, "PersonID.Email",
          landlordEventTypesState.EmailSortAcsDes, 1);
    } else if (landlordEventTypesState.isPhoneSort) {
      apimanager(landlordEventTypesState.SearchText, pageno,
          "PersonID.MobileNumber", landlordEventTypesState.PhoneSortAcsDes, 1);
    } else if (landlordEventTypesState.isCategorySort) {
      apimanager(landlordEventTypesState.SearchText, pageno, "Category",
          landlordEventTypesState.CategorySortAcsDes, 1);
    } else if (landlordEventTypesState.isRatingSort) {
      apimanager(landlordEventTypesState.SearchText, pageno, "Rating",
          landlordEventTypesState.RatingSortAcsDes, 1);
    } else {
      apimanager(landlordEventTypesState.SearchText, pageno, "ID", 0, 1);
    }
  }

  updateOtherSortingValue(
      int flag, landlordEventTypesState landlordEventTypesState) {
    updateSortingFeild(flag);

    if (flag == 1) {
      _store.dispatch(UpdateLLEventTypes_CompanyNameSortAcsDes(
          landlordEventTypesState.CompanyNameSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLEventTypes_CitySortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_ContactNameSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_EmailSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_PhoneSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_CategorySortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_RatingSortAcsDes(0));

      apimanager("", 1, "CompanyName",
          landlordEventTypesState.CompanyNameSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 2) {
      _store.dispatch(UpdateLLEventTypes_CitySortAcsDes(
          landlordEventTypesState.CitySortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLEventTypes_CompanyNameSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_ContactNameSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_EmailSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_PhoneSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_CategorySortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_RatingSortAcsDes(0));

      apimanager("", 1, "City.CityName",
          landlordEventTypesState.CitySortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 3) {
      _store.dispatch(UpdateLLEventTypes_ContactNameSortAcsDes(
          landlordEventTypesState.ContactNameSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLEventTypes_CompanyNameSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_CitySortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_EmailSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_PhoneSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_CategorySortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_RatingSortAcsDes(0));

      apimanager("", 1, "PersonID.FirstName",
          landlordEventTypesState.ContactNameSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 4) {
      _store.dispatch(UpdateLLEventTypes_EmailSortAcsDes(
          landlordEventTypesState.EmailSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLEventTypes_CompanyNameSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_CitySortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_ContactNameSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_PhoneSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_CategorySortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_RatingSortAcsDes(0));

      apimanager("", 1, "PersonID.Email",
          landlordEventTypesState.EmailSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 5) {
      _store.dispatch(UpdateLLEventTypes_PhoneSortAcsDes(
          landlordEventTypesState.PhoneSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLEventTypes_CompanyNameSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_CitySortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_ContactNameSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_EmailSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_CategorySortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_RatingSortAcsDes(0));

      apimanager("", 1, "PersonID.MobileNumber",
          landlordEventTypesState.PhoneSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 6) {
      _store.dispatch(UpdateLLEventTypes_CategorySortAcsDes(
          landlordEventTypesState.CategorySortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLEventTypes_CompanyNameSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_CitySortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_ContactNameSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_EmailSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_PhoneSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_RatingSortAcsDes(0));

      apimanager("", 1, "Category",
          landlordEventTypesState.CategorySortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 7) {
      _store.dispatch(UpdateLLEventTypes_RatingSortAcsDes(
          landlordEventTypesState.RatingSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateLLEventTypes_CompanyNameSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_CitySortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_ContactNameSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_EmailSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_PhoneSortAcsDes(0));
      _store.dispatch(UpdateLLEventTypes_CategorySortAcsDes(0));

      apimanager("", 1, "Rating",
          landlordEventTypesState.RatingSortAcsDes == 1 ? 0 : 1, 0);
    }
  }

  updateSortingFeild(int flag) {
    if (flag != 1) {
      _store.dispatch(UpdateLLEventTypes_isCompanyNameSort(false));
    }
    if (flag != 2) {
      _store.dispatch(UpdateLLEventTypes_isCitySort(false));
    }
    if (flag != 3) {
      _store.dispatch(UpdateLLEventTypes_isContactNameSort(false));
    }
    if (flag != 4) {
      _store.dispatch(UpdateLLEventTypes_isEmaiSort(false));
    }
    if (flag != 5) {
      _store.dispatch(UpdateLLEventTypes_isPhoneSort(false));
    }
    if (flag != 6) {
      _store.dispatch(UpdateLLEventTypes_isCategorySort(false));
    }
    if (flag != 7) {
      _store.dispatch(UpdateLLEventTypes_isRatingSort(false));
    }
  }

  duplicateEventTypes(
      EventTypesData event_typesData, landlordEventTypesState landlordEventTypesState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().duplicateEventTypesworkflow(context, event_typesData.id.toString(),
        (error, respoce) {
      if (error) {
        init();
        ToastUtils.showCustomToast(
            context, GlobleString.event_types_dupliacate_successfully, true);

        if (respoce != null && respoce.isNotEmpty) {
          ApiManager().getEventTypesDetails(context, respoce,
              (status, responce, event_typesData) async {
            if (status) {
              loader.remove();
              await clearEventTypesStateData();
              await updateEventTypesStateData(event_typesData);
            } else {
              loader.remove();
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

  deleteEventTypes(
      EventTypesData event_typesData, landlordEventTypesState landlordEventTypesState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    CommonID id = new CommonID(ID: event_typesData.id.toString());

    ApiManager().deleteEventTypesAPI(context, id, (error, respoce) async {
      if (error) {
        loader.remove();
        init();
        ToastUtils.showCustomToast(
            context, GlobleString.EventTypes_delete_successfully, true);
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
        Helper.Log("respoce", respoce);
      }
    });
  }
}
