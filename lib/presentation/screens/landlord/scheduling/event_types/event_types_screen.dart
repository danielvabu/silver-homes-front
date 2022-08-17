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
import 'package:silverhome/domain/actions/actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypes_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypes_disclosure_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypes_feature_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypes_specification_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypes_summery_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypesform_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypeslist_actions.dart';
import 'package:silverhome/domain/entities/eventtypes_amenities.dart';
import 'package:silverhome/domain/entities/eventtypeslist.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/dsq_query.dart';
import 'package:silverhome/tablayer/query_filter.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/tabclass.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/alert_dialogbox.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/landlord/eventtypestable/eventtypes_header.dart';
import 'package:silverhome/widget/landlord/eventtypestable/eventtypes_item.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

import '../../../../models/landlord_models/eventtypes_list_state.dart';
import 'add_edit_eventtypes.dart';

class EventTypesScreen extends StatefulWidget {
  @override
  _EventTypesScreenState createState() => _EventTypesScreenState();
}

class _EventTypesScreenState extends State<EventTypesScreen> {
  double ssheight = 0, sswidth = 0;
  final _store = getIt<AppStore>();

  late OverlayEntry loader;
  late Timer? _timer = null;

  @override
  void initState() {
    //updateCount();
    init();
    super.initState();
  }

  //updateCount() {
  //  ApiManager().updateEventTypesStatusCount(context);
  //}

  void init() async {
    await Prefs.init();

    //ApiManager().updateEventTypesStatusCount(context);
    updateState();
    apimanager("", 1, "EventTypesName", 1, 0);
  }

  updateState() async {
    _store.dispatch(UpdateEventTypesListEventTypesSearchText(""));
    _store.dispatch(UpdateEventTypesListNameSort(true));
    await updateSortingFeild(1);
    _store.dispatch(UpdateEventTypesListNameSortAcsDes(1));
    _store.dispatch(UpdateEventTypesListUnitSortAcsDes(0));
    _store.dispatch(UpdateEventTypesListCitySortAcsDes(0));
    _store.dispatch(UpdateEventTypesListCountrySortAcsDes(0));
    _store.dispatch(UpdateEventTypesListEventTypesTypeSortAcsDes(0));
    _store.dispatch(UpdateEventTypesListVacancySortAcsDes(0));
    _store.dispatch(UpdateEventTypesListActiveSortAcsDes(0));
    _store.dispatch(UpdateEventTypesListPublishedSortAcsDes(0));
  }

  apimanager(String search, int pageNo, String SortField, int saquence,
      int ftime) async {
    EventTypesListReqtokens reqtokens = EventTypesListReqtokens();
    reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    reqtokens.Name = search != null ? search : "";

    Pager pager = Pager(pageNo: pageNo, noOfRecords: Helper.noofrecored);

    List<Sort> sortinglist = [];
    Sort sort = Sort();
    sort.fieldId = SortField;
    sort.sortSequence = saquence;
    sortinglist.add(sort);

    DSQQuery dsqQuery = DSQQuery();
    dsqQuery.dsqid = Weburl.DSQ_EventTypesOnBoardingList;
    dsqQuery.loadLookUpValues = true;
    dsqQuery.loadRecordInfo = true;
    dsqQuery.eventTypesListReqtokens = reqtokens;
    dsqQuery.pager = pager;
    dsqQuery.sort = sortinglist;

    String filterjson = jsonEncode(dsqQuery);

    Helper.Log("EventTypes", filterjson);
    _store.dispatch(UpdateEventTypesListIsloding(true));
    _store.dispatch(UpdateEventTypesList(<EventTypesDataList>[]));
    _store.dispatch(UpdateEventTypesListEventTypesSearchText(search));
    await ApiManager().getEventTypesOnboadingList(context, filterjson, ftime);
  }

  @override
  Widget build(BuildContext context) {
    ssheight = MediaQuery.of(context).size.height - 70;
    sswidth = MediaQuery.of(context).size.width - 230;

    return Container(
      height: ssheight,
      width: sswidth,
      color: myColor.bg_color1,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: ConnectState<EventTypesListState>(
              map: (state) => state.eventTypesListState,
              where: notIdentical,
              builder: (eventTypesListState) {
                return Column(
                  children: [
                    //_statusView(eventTypesListState!),
                    _centerView(eventTypesListState!),
                  ],
                );
              }),
        ),
      ),
    );
  }

/*  Widget _statusView(EventTypesListState eventTypesListState) {
    return Container(
      child: Row(
        children: [
          CustomeWidget.EventTypesStutas(
              eventTypesListState.status_UnitsHeld.toString(),
              GlobleString.PP_status_UnitsHeld),
          CustomeWidget.EventTypesStutas(
              eventTypesListState.status_UnitsRented.toString(),
              GlobleString.PP_status_UnitsRented),
          CustomeWidget.EventTypesStutas(
              eventTypesListState.status_VacantUnits.toString(),
              GlobleString.PP_status_VacantUnits),
          Expanded(child: Container()),
          Expanded(child: Container()),
        ],
      ),
    );
  }*/

  Widget _centerView(EventTypesListState eventTypesListState) {
    return Container(
      width: sswidth,
      height: ssheight - 45,
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
                    Row(
                      children: [
                        if (eventTypesListState.isloding &&
                            eventTypesListState.EventTypesSearchText == "")
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
                                    initialValue: eventTypesListState
                                        .EventTypesSearchText,
                                    onChanged: (value) async {
                                      if (_timer != null) {
                                        _timer!.cancel();
                                      }
                                      _timer = Timer.periodic(
                                          Duration(seconds: 2), (timer) {
                                        _store.dispatch(
                                            UpdateEventTypesListIsloding(true));
                                        _store.dispatch(UpdateEventTypesList(
                                            <EventTypesDataList>[]));
                                        apimanager(
                                            value, 1, "EventTypesName", 1, 0);
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
                      ],
                    ),
                    const SizedBox(width: 10.0),
                    _addNewLead(),
                  ],
                ),
                Row(
                  children: [_actionPopup(eventTypesListState)],
                ),
              ],
            ),
          ),
          _tableview(eventTypesListState)
        ],
      ),
    );
  }

  Widget _addNewLead() {
    return InkWell(
      onTap: () async {
        AddEditEventTypes.isValueUpdate = false;
        await Prefs.setBool(PrefsName.EventTypesActive, true);
        await Prefs.setBool(PrefsName.EventTypesEdit, false);
        await Prefs.setBool(PrefsName.EventTypesEditMode, false);
        await Prefs.setString(PrefsName.EventTypesID, "");
        await Prefs.setBool(PrefsName.EventTypesAgreeTC, false);

        await Prefs.setBool(PrefsName.EventTypesStep1, false);
        await Prefs.setBool(PrefsName.EventTypesStep2, false);
        await Prefs.setBool(PrefsName.EventTypesStep3, false);

        await clearaddeventtypesdetails();
        await cleareventtypesSummerydetails();

        List<SystemEnumDetails> restrictionlist = [];
        restrictionlist =
            QueryFilter().PlainValues(eSystemEnums().Restrictions);

        List<SystemEnumDetails> secondrestrictionlist = restrictionlist
            .map((item) => new SystemEnumDetails.clone(item))
            .toList();

        _store.dispatch(UpdateSummeryRestrictionlist(secondrestrictionlist));

        _store.dispatch(UpdateRestrictionlist(restrictionlist));

        _store.dispatch(UpdateEventTypesForm(1));
        _store.dispatch(UpdateEventTypesFormAddress(""));
        _store.dispatch(UpdateAddEditEventTypes());
      },
      child: CustomeWidget.AddEventTypes(),
    );
  }

  clearaddeventtypesdetails() {
    _store.dispatch(UpdateProperTytypeValue(null));
    _store.dispatch(UpdateEventTypesTypeOtherValue(""));
    _store.dispatch(UpdateDateofavailable(null));
    _store.dispatch(UpdateRentalSpaceValue(null));
    _store.dispatch(UpdateEventTypesName(""));
    _store.dispatch(UpdateEventTypesAddress(""));
    _store.dispatch(UpdateEventTypesDescription(""));
    _store.dispatch(UpdateSuiteunit(""));
    _store.dispatch(UpdateBuildingname(""));
    _store.dispatch(UpdateEventTypesCity(""));
    _store.dispatch(UpdateEventTypesCountryCode("CA"));
    _store.dispatch(UpdateEventTypesCountryName("Canada"));
    _store.dispatch(UpdateEventTypesProvince(""));
    _store.dispatch(UpdateEventTypesPostalcode(""));
    _store.dispatch(UpdateEventTypesRentAmount(""));
    _store.dispatch(UpdateRentPaymentFrequencyValue(null));
    _store.dispatch(UpdateLeaseTypeValue(null));
    _store.dispatch(UpdateMinimumLeasedurationValue(null));
    _store.dispatch(UpdateMinimumleasedurationNumber(""));

    _store.dispatch(UpdateEventTypesBedrooms(""));
    _store.dispatch(UpdateEventTypesBathrooms(""));
    _store.dispatch(UpdateEventTypesSizeinsquarefeet(""));
    _store.dispatch(UpdateEventTypesMaxoccupancy(""));
    _store.dispatch(UpdateFurnishingValue(null));
    _store.dispatch(UpdateParkingstalls(""));
    _store.dispatch(UpdateStorageAvailableValue(null));
    _store.dispatch(UpdateAgreeTCPP(false));
    _store.dispatch(UpdateEventTypesDrafting(1));
    _store.dispatch(UpdateEventTypesVacancy(false));

    _store.dispatch(UpdateErrorParkingstalls(false));
    _store.dispatch(UpdateErrorStorageavailable(false));
    _store.dispatch(UpdateErrorOther_Partial_Furniture(false));
    _store.dispatch(UpdateErrorFurnishing(false));
    _store.dispatch(UpdateErrorEventTypesMaxoccupancy(false));
    _store.dispatch(UpdateErrorEventTypesBathrooms(false));
    _store.dispatch(UpdateErrorEventTypesBedrooms(false));
    _store.dispatch(UpdateErrorEventTypesSizeinsquarefeet(false));
    _store.dispatch(UpdateErrorEventTypestype(false));
    _store.dispatch(UpdateErrorEventTypestypeOther(false));
    _store.dispatch(UpdateErrorEventTypesName(false));
    _store.dispatch(UpdateErrorEventTypesAddress(false));
    _store.dispatch(UpdateErrorRentpaymentFrequency(false));
    _store.dispatch(UpdateErrorRentAmount(false));
    _store.dispatch(UpdateErrorRentalspace(false));
    _store.dispatch(UpdateErrorDateofavailable(false));
    _store.dispatch(UpdateErrorMinimumleaseduration(false));
    _store.dispatch(UpdateErrorMinimumleasedurationnumber(false));
    _store.dispatch(UpdateErrorLeasetype(false));
    _store.dispatch(UpdateErrorPostalcode(false));
    _store.dispatch(UpdateErrorCity(false));
    _store.dispatch(UpdateErrorCountryName(false));
    _store.dispatch(UpdateErrorProvince(false));
    //_store.dispatch(UpdateEventTypesImageList(<EventTypesImageMediaInfo>[]));
  }

  cleareventtypesSummerydetails() {
    _store.dispatch(UpdateSummeryProperTytypeValue(null));
    _store.dispatch(UpdateSummeryEventTypesTypeOtherValue(""));
    _store.dispatch(UpdateSummeryDateofavailable(null));
    _store.dispatch(UpdateSummeryRentalSpaceValue(null));
    _store.dispatch(UpdateSummeryEventTypesName(""));
    _store.dispatch(UpdateSummeryEventTypesAddress(""));
    _store.dispatch(UpdateSummeryEventTypesDescription(""));
    _store.dispatch(UpdateSummerySuiteunit(""));
    _store.dispatch(UpdateSummeryBuildingname(""));
    _store.dispatch(UpdateSummeryEventTypesCity(""));
    _store.dispatch(UpdateSummeryEventTypesCountryCode("CA"));
    _store.dispatch(UpdateSummeryEventTypesCountryName("Canada"));
    _store.dispatch(UpdateSummeryEventTypesProvince(""));
    _store.dispatch(UpdateSummeryEventTypesPostalcode(""));
    _store.dispatch(UpdateSummeryEventTypesRentAmount(""));
    _store.dispatch(UpdateSummeryRentPaymentFrequencyValue(null));
    _store.dispatch(UpdateSummeryLeaseTypeValue(null));
    _store.dispatch(UpdateSummeryMinimumLeasedurationValue(null));
    _store.dispatch(UpdateSummeryMinimumleasedurationNumber(""));
    _store.dispatch(UpdateSummeryEventTypesImage(null));
    _store.dispatch(UpdateSummeryEventTypesUint8List(null));
    _store.dispatch(UpdateSummeryEventTypesBedrooms(""));
    _store.dispatch(UpdateSummeryEventTypesBathrooms(""));
    _store.dispatch(UpdateSummeryEventTypesSizeinsquarefeet(""));
    _store.dispatch(UpdateSummeryEventTypesMaxoccupancy(""));
    _store.dispatch(UpdateSummeryFurnishingValue(null));
    _store.dispatch(UpdateSummeryOtherPartialFurniture(""));
    _store.dispatch(UpdateSummeryParkingstalls(""));
    _store.dispatch(UpdateSummeryStorageAvailableValue(null));
    _store.dispatch(UpdateSummeryAgreeTCPP(false));
    _store.dispatch(UpdateSummeryEventTypesDrafting(1));
    _store.dispatch(UpdateSummeryEventTypesVacancy(false));
    //_store.dispatch(UpdateSummeryEventTypesImageList(<EventTypesImageMediaInfo>[]));
  }

  Widget _actionPopup(EventTypesListState eventtypesListState) {
    return Container(
      height: 32,
      width: 30,
      child: PopupMenuButton(
        onSelected: (value) async {
          EventTypesListReqtokens reqtokens = new EventTypesListReqtokens();
          reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
          reqtokens.Name = eventtypesListState.EventTypesSearchText != null
              ? eventtypesListState.EventTypesSearchText
              : "";

          List<Sort> sortinglist = [];
          Sort sort = new Sort();
          if (eventtypesListState.EventTypesSearchText != null &&
              eventtypesListState.EventTypesSearchText.isNotEmpty) {
            sort.fieldId = "ID";
            sort.sortSequence = 0;
          } else {
            if (eventtypesListState.isEventTypesNameSort) {
              sort.fieldId = "EventTypesName";
              sort.sortSequence = eventtypesListState.NameSortAcsDes;
            } else if (eventtypesListState.isEventTypesUnitSort) {
              sort.fieldId = "Suite_Unit";
              sort.sortSequence = eventtypesListState.UnitSortAcsDes;
            } else if (eventtypesListState.isCitySort) {
              sort.fieldId = "City";
              sort.sortSequence = eventtypesListState.CitySortAcsDes;
            } else if (eventtypesListState.isCountrySort) {
              sort.fieldId = "Country";
              sort.sortSequence = eventtypesListState.CountrySortAcsDes;
            } else if (eventtypesListState.isEventTypesTypeSort) {
              sort.fieldId = "EventTypes_Type";
              sort.sortSequence = eventtypesListState.EventTypesTypeSortAcsDes;
            } else if (eventtypesListState.isvacancySort) {
              sort.fieldId = "Vacancy";
              sort.sortSequence = eventtypesListState.VacancySortAcsDes;
            } else if (eventtypesListState.isActiveInactiveSort) {
              sort.fieldId = "IsActive";
              sort.sortSequence = eventtypesListState.ActiveSortAcsDes;
            } else if (eventtypesListState.isPublishedSort) {
              sort.fieldId = "IsPublished";
              sort.sortSequence = eventtypesListState.PublishedSortAcsDes;
            } else {
              sort.fieldId = "ID";
              sort.sortSequence = 0;
            }
          }

          sortinglist.add(sort);

          DSQQuery dsqQuery = new DSQQuery();
          dsqQuery.dsqid = Weburl.DSQ_EventTypesOnBoardingList;
          dsqQuery.loadLookUpValues = true;
          dsqQuery.loadRecordInfo = true;
          dsqQuery.eventTypesListReqtokens = reqtokens;
          dsqQuery.sort = sortinglist;

          String filterjson = jsonEncode(dsqQuery);

          await ApiManager()
              .getAllEventTypesOnboadingListCSV(context, filterjson);
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

  Widget _tableview(EventTypesListState eventtypesListState) {
    return Container(
      width: sswidth,
      height: ssheight - 167,
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          //color: Hexcolor("#16C395"),
          border: Border.all(color: Colors.transparent, width: 1)),
      child: Column(
        children: [
          EventTypesHeader(
            onPressedSortEventTypes: () async {
              _store.dispatch(UpdateEventTypesListNameSort(true));
              updateOtherSortingValue(1, eventtypesListState);
            },
            onPressedSortUnit: () async {
              _store.dispatch(UpdateEventTypesListUnitSort(true));
              updateOtherSortingValue(2, eventtypesListState);
            },
            onPressedSortCity: () async {
              _store.dispatch(UpdateEventTypesListCitySort(true));
              updateOtherSortingValue(3, eventtypesListState);
            },
            onPressedSortCountry: () async {
              _store.dispatch(UpdateEventTypesListCountrySort(true));
              updateOtherSortingValue(4, eventtypesListState);
            },
            onPressedSortEventTypesType: () async {
              _store.dispatch(UpdateEventTypesListEventTypesTypeSort(true));
              updateOtherSortingValue(5, eventtypesListState);
            },
            onPressedSortVacancy: () async {
              _store.dispatch(UpdateEventTypesListVacancySort(true));
              updateOtherSortingValue(6, eventtypesListState);
            },
            onPressedSortActiveInactive: () async {
              _store.dispatch(UpdateEventTypesListActiveInactiveSort(true));
              updateOtherSortingValue(7, eventtypesListState);
            },
            onPressedSortIsPublished: () async {
              _store.dispatch(UpdateEventTypesListisPublishedSort(true));
              updateOtherSortingValue(8, eventtypesListState);
            },
          ),
          tableItem(eventtypesListState),
          if (eventtypesListState.eventtypeslist != null &&
              eventtypesListState.eventtypeslist.length > 0)
            tablefooter(eventtypesListState)
        ],
      ),
    );
  }

  Widget tableItem(EventTypesListState eventtypesListState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        eventtypesListState.isloding
            ? Expanded(
                child: Container(
                  width: sswidth,
                  height: ssheight - 310,
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
            : eventtypesListState.eventtypeslist != null &&
                    eventtypesListState.eventtypeslist.length > 0
                ? Expanded(
                    child: EventTypesItem(
                      listdata1: eventtypesListState.eventtypeslist,
                      onPresseEdit: (EventTypesDataList eventtypesData) {
                        getEventTypesDetails(
                            eventtypesData, 2, eventtypesData.slots!);
                      },
                      onPresseDuplicat: (EventTypesDataList eventtypesData) {
                        ApiManager().DuplicatEventTypesGenerate(
                            context, eventtypesData.id!,
                            (status, responce) async {
                          if (status) {
                            _store.dispatch(UpdateEventTypesListIsloding(true));
                            _store.dispatch(
                                UpdateEventTypesList(<EventTypesDataList>[]));
                            apimanager("", 1, "EventTypesName", 1, 0);
                          } else {
                            ToastUtils.showCustomToast(
                                context, GlobleString.Error1, false);
                          }
                        });
                      },
                      onPressDetails: (EventTypesDataList eventtypesData) {
                        getEventTypesDetails(
                            eventtypesData, 1, eventtypesData.slots!);
                      },
                      onPressName: (EventTypesDataList eventtypesData) {
                        getEventTypesDetails(
                            eventtypesData, 1, eventtypesData.slots!);
                      },
                      onPresseInActive:
                          (EventTypesDataList eventtypesData, int pos) {
                        /*ApiManager().TenantAvailableInEventTypes(
                            context,
                            Prefs.getString(PrefsName.OwnerID),
                            eventtypesData.id!, (status, responce) {
                          if (status) {
                            if (responce == "1") {
                              showDialog(
                                context: context,
                                barrierColor: Colors.black45,
                                useSafeArea: true,
                                barrierDismissible: false,
                                builder: (BuildContext context1) {
                                  return AlertDialogBox(
                                    title: GlobleString.Prop_Inactive,
                                    positiveText: GlobleString.Prop_btn_yes,
                                    negativeText: GlobleString.Prop_btn_cancel,
                                    onPressedYes: () {
                                      Navigator.of(context1).pop();
                                      eventtypesActive_InAction_call(
                                          eventtypesListState,
                                          false,
                                          eventtypesData.id!);
                                    },
                                    onPressedNo: () {
                                      Navigator.of(context1).pop();
                                    },
                                  );
                                },
                              );
                            } else {
                              eventtypesActive_InAction_call(
                                  eventtypesListState,
                                  false,
                                  eventtypesData.id!);
                            }
                          } else {
                            eventtypesActive_InAction_call(
                                eventtypesListState, false, eventtypesData.id!);
                          }
                        });*/
                      },
                      onPresseActive:
                          (EventTypesDataList eventtypesData, int pos) {
                        //if (eventtypesData.propDrafting != 3) {
                        //  ToastUtils.showCustomToast(context,GlobleString.PS3_EventTypes_all_details, false);
                        //} else if (!eventtypesData.isAgreedTandC!) {
                        //  ToastUtils.showCustomToast(context,GlobleString.PS3_EventTypes_Disclosures, false);
                        //} else {
                        eventtypesActive_InAction_call(
                            eventtypesListState, true, eventtypesData.id!);
                        //}
                      },
                      onPresseIsPublish: (EventTypesDataList eventtypesData,
                          int pos, bool flag) {
                        if (!eventtypesData.ispublished!) {
                          ToastUtils.showCustomToast(
                              context,
                              'Publicar creo',
                              //GlobleString.PS3_EventTypes_Active_publish,
                              false);
                        } else {
                          showDialog(
                            context: context,
                            barrierColor: Colors.black45,
                            useSafeArea: true,
                            barrierDismissible: false,
                            builder: (BuildContext context1) {
                              return AlertDialogBox(
                                title: flag
                                    ? GlobleString.Prop_Publish
                                    : GlobleString.Prop_UnPublish,
                                positiveText: GlobleString.Prop_btn_yes,
                                negativeText: GlobleString.Prop_btn_cancel,
                                onPressedYes: () {
                                  Navigator.of(context1).pop();
                                  eventtypesIsPublished_call(
                                      eventtypesListState,
                                      flag,
                                      eventtypesData.id!);
                                },
                                onPressedNo: () {
                                  Navigator.of(context1).pop();
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                  )
                : Expanded(
                    child: Container(
                      width: sswidth,
                      height: ssheight - 310,
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text(
                        'blank npi',
                        //GlobleString.Blank_EventTypes,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: MyStyles.Medium(18, myColor.tabel_msg),
                      ),
                    ),
                  )
      ],
    );
  }

  Widget tablefooter(EventTypesListState eventtypesListState) {
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
                  Helper.PagingRecord(eventtypesListState.totalRecord).length *
                              35 >
                          350
                      ? 350
                      : Helper.PagingRecord(eventtypesListState.totalRecord)
                              .length *
                          35,
              selectedItem: eventtypesListState.pageNo.toString(),
              items: Helper.PagingRecord(eventtypesListState.totalRecord),
              showSearchBox: false,
              isFilteredOnline: true,
              onChanged: (value) {
                _store.dispatch(
                    UpdateEventTypesListPageNo(int.parse(value.toString())));
                paginationCall(
                    eventtypesListState, int.parse(value.toString()));
              },
            ),
          )
          /*Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: eventtypesListState.pageNo == 1
                        ? myColor.hintcolor
                        : myColor.black,
                  ),
                  onPressed: () {
                    if (eventtypesListState.pageNo != 1) {
                      int pageno = eventtypesListState.pageNo - 1;
                      _store.dispatch(UpdateEventTypesListPageNo(pageno));
                      paginationCall(eventtypesListState, pageno);
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
                    eventtypesListState.pageNo.toString(),
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
                    eventtypesListState.totalpage.toString(),
                    style: MyStyles.Medium(14, myColor.text_color),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: eventtypesListState.pageNo ==
                        eventtypesListState.totalpage
                        ? myColor.hintcolor
                        : myColor.black,
                  ),
                  onPressed: () {
                    if (eventtypesListState.pageNo !=
                        eventtypesListState.totalpage) {
                      int pageno = eventtypesListState.pageNo + 1;
                      _store.dispatch(UpdateEventTypesListPageNo(pageno));
                      paginationCall(eventtypesListState, pageno);
                    }
                  },
                )
              ],
            )*/
        ],
      ),
    );
  }

  void paginationCall(EventTypesListState eventtypesListState, int pageno) {
    if (eventtypesListState.isEventTypesNameSort) {
      apimanager(eventtypesListState.EventTypesSearchText, pageno,
          "EventTypesName", eventtypesListState.NameSortAcsDes, 1);
    }

    if (eventtypesListState.isEventTypesUnitSort) {
      apimanager(eventtypesListState.EventTypesSearchText, pageno, "Suite_Unit",
          eventtypesListState.UnitSortAcsDes, 1);
    }

    if (eventtypesListState.isCitySort) {
      apimanager(eventtypesListState.EventTypesSearchText, pageno, "City",
          eventtypesListState.CitySortAcsDes, 1);
    }

    if (eventtypesListState.isCountrySort) {
      apimanager(eventtypesListState.EventTypesSearchText, pageno, "Country",
          eventtypesListState.CountrySortAcsDes, 1);
    }

    if (eventtypesListState.isEventTypesTypeSort) {
      apimanager(eventtypesListState.EventTypesSearchText, pageno,
          "EventTypes_Type", eventtypesListState.EventTypesTypeSortAcsDes, 1);
    }

    if (eventtypesListState.isvacancySort) {
      apimanager(eventtypesListState.EventTypesSearchText, pageno, "Vacancy",
          eventtypesListState.VacancySortAcsDes, 1);
    }

    if (eventtypesListState.isActiveInactiveSort) {
      apimanager(eventtypesListState.EventTypesSearchText, pageno, "IsActive",
          eventtypesListState.ActiveSortAcsDes, 1);
    }

    if (eventtypesListState.isPublishedSort) {
      apimanager(eventtypesListState.EventTypesSearchText, pageno,
          "IsPublished", eventtypesListState.PublishedSortAcsDes, 1);
    }
  }

  updateOtherSortingValue(int flag, EventTypesListState eventtypesListState) {
    updateSortingFeild(flag);

    if (flag == 1) {
      _store.dispatch(UpdateEventTypesListNameSortAcsDes(
          eventtypesListState.NameSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateEventTypesListUnitSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListCitySortAcsDes(0));
      _store.dispatch(UpdateEventTypesListCountrySortAcsDes(0));
      _store.dispatch(UpdateEventTypesListEventTypesTypeSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListVacancySortAcsDes(0));
      _store.dispatch(UpdateEventTypesListActiveSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListPublishedSortAcsDes(0));

      apimanager("", 1, "EventTypesName",
          eventtypesListState.NameSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 2) {
      _store.dispatch(UpdateEventTypesListUnitSortAcsDes(
          eventtypesListState.UnitSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateEventTypesListNameSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListCitySortAcsDes(0));
      _store.dispatch(UpdateEventTypesListCountrySortAcsDes(0));
      _store.dispatch(UpdateEventTypesListEventTypesTypeSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListVacancySortAcsDes(0));
      _store.dispatch(UpdateEventTypesListActiveSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListPublishedSortAcsDes(0));

      apimanager("", 1, "Suite_Unit",
          eventtypesListState.UnitSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 3) {
      _store.dispatch(UpdateEventTypesListCitySortAcsDes(
          eventtypesListState.CitySortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateEventTypesListNameSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListUnitSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListCountrySortAcsDes(0));
      _store.dispatch(UpdateEventTypesListEventTypesTypeSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListVacancySortAcsDes(0));
      _store.dispatch(UpdateEventTypesListActiveSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListPublishedSortAcsDes(0));

      apimanager(
          "", 1, "City", eventtypesListState.CitySortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 4) {
      _store.dispatch(UpdateEventTypesListCountrySortAcsDes(
          eventtypesListState.CountrySortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateEventTypesListNameSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListUnitSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListCitySortAcsDes(0));
      _store.dispatch(UpdateEventTypesListEventTypesTypeSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListVacancySortAcsDes(0));
      _store.dispatch(UpdateEventTypesListActiveSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListPublishedSortAcsDes(0));

      apimanager("", 1, "Country",
          eventtypesListState.CountrySortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 5) {
      _store.dispatch(UpdateEventTypesListEventTypesTypeSortAcsDes(
          eventtypesListState.EventTypesTypeSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateEventTypesListNameSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListUnitSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListCitySortAcsDes(0));
      _store.dispatch(UpdateEventTypesListCountrySortAcsDes(0));
      _store.dispatch(UpdateEventTypesListVacancySortAcsDes(0));
      _store.dispatch(UpdateEventTypesListActiveSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListPublishedSortAcsDes(0));

      apimanager("", 1, "EventTypes_Type",
          eventtypesListState.EventTypesTypeSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 6) {
      _store.dispatch(UpdateEventTypesListVacancySortAcsDes(
          eventtypesListState.VacancySortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateEventTypesListNameSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListUnitSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListCitySortAcsDes(0));
      _store.dispatch(UpdateEventTypesListCountrySortAcsDes(0));
      _store.dispatch(UpdateEventTypesListEventTypesTypeSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListActiveSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListPublishedSortAcsDes(0));

      apimanager("", 1, "Vacancy",
          eventtypesListState.VacancySortAcsDes == 1 ? 0 : 1, 0);
    }

    if (flag == 7) {
      _store.dispatch(UpdateEventTypesListActiveSortAcsDes(
          eventtypesListState.ActiveSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateEventTypesListNameSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListUnitSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListCitySortAcsDes(0));
      _store.dispatch(UpdateEventTypesListCountrySortAcsDes(0));
      _store.dispatch(UpdateEventTypesListEventTypesTypeSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListVacancySortAcsDes(0));
      _store.dispatch(UpdateEventTypesListPublishedSortAcsDes(0));

      apimanager("", 1, "IsActive",
          eventtypesListState.ActiveSortAcsDes == 1 ? 0 : 1, 0);
    }

    if (flag == 8) {
      _store.dispatch(UpdateEventTypesListPublishedSortAcsDes(
          eventtypesListState.PublishedSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdateEventTypesListNameSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListUnitSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListCitySortAcsDes(0));
      _store.dispatch(UpdateEventTypesListCountrySortAcsDes(0));
      _store.dispatch(UpdateEventTypesListEventTypesTypeSortAcsDes(0));
      _store.dispatch(UpdateEventTypesListVacancySortAcsDes(0));
      _store.dispatch(UpdateEventTypesListActiveSortAcsDes(0));

      apimanager("", 1, "IsPublished",
          eventtypesListState.PublishedSortAcsDes == 1 ? 0 : 1, 0);
    }
  }

  updateSortingFeild(int flag) {
    if (flag != 1) {
      _store.dispatch(UpdateEventTypesListNameSort(false));
    }
    if (flag != 2) {
      _store.dispatch(UpdateEventTypesListUnitSort(false));
    }
    if (flag != 3) {
      _store.dispatch(UpdateEventTypesListCitySort(false));
    }
    if (flag != 4) {
      _store.dispatch(UpdateEventTypesListCountrySort(false));
    }
    if (flag != 5) {
      _store.dispatch(UpdateEventTypesListEventTypesTypeSort(false));
    }
    if (flag != 6) {
      _store.dispatch(UpdateEventTypesListVacancySort(false));
    }
    if (flag != 7) {
      _store.dispatch(UpdateEventTypesListActiveInactiveSort(false));
    }
    if (flag != 8) {
      _store.dispatch(UpdateEventTypesListisPublishedSort(false));
    }
  }

  eventtypesActive_InAction_call(EventTypesListState eventtypesListState,
      bool isAct, String eventtypesid) {
    EventTypesActive proactive = EventTypesActive();
    proactive.IsActive = isAct;
    proactive.IsPublished = false;

    EventTypesUpdate eventtypesUpdate = EventTypesUpdate();
    eventtypesUpdate.ID = eventtypesid;
    eventtypesUpdate.Owner_ID = Prefs.getString(PrefsName.OwnerID);

    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().UpdateEventTypesActive(context, eventtypesUpdate, proactive,
        (error, responce) async {
      if (error) {
        if (isAct) {
          ApiManager().ArchiveLeadRestoreInEventTypes(context, eventtypesid,
              (status, responce) async {
            if (status) {
              ToastUtils.showCustomToast(
                  context, GlobleString.Prop_activated_success, true);
              paginationCall(eventtypesListState, eventtypesListState.pageNo);
              loader.remove();
            } else {
              loader.remove();
              ToastUtils.showCustomToast(context, GlobleString.Error1, false);
            }
          });
        } else {
          ApiManager().ArchiveLeadInEventTypes(context, eventtypesid,
              (status, responce) async {
            if (status) {
              ToastUtils.showCustomToast(
                  context, GlobleString.Prop_deactivated_success, true);
              paginationCall(eventtypesListState, eventtypesListState.pageNo);
              loader.remove();
            } else {
              loader.remove();
              ToastUtils.showCustomToast(context, GlobleString.Error1, false);
            }
          });
        }
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
  }

  eventtypesIsPublished_call(EventTypesListState eventtypesListState,
      bool isAct, String eventtypesid) {
    EventTypesIsPublished proactive = EventTypesIsPublished();
    proactive.IsPublished = isAct;

    EventTypesUpdate eventtypesUpdate = new EventTypesUpdate();
    eventtypesUpdate.ID = eventtypesid;
    eventtypesUpdate.Owner_ID = Prefs.getString(PrefsName.OwnerID);

    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().UpdateEventTypesActive(context, eventtypesUpdate, proactive,
        (error, responce) async {
      if (error) {
        if (isAct) {
          ToastUtils.showCustomToast(
              context, GlobleString.Prop_published_success, true);
        } else {
          ToastUtils.showCustomToast(
              context, GlobleString.Prop_unpublished_success, true);
        }
        paginationCall(eventtypesListState, eventtypesListState.pageNo);
        loader.remove();
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
  }

  getEventTypesDetails(
      EventTypesDataList eventtypesData1, int flag, int PropDrafting) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String propId = eventtypesData1.id.toString();

    ApiManager().getEventTypesRestriction(context, propId,
        (status, responce, restrictionlist) {
      if (status) {
        _store.dispatch(UpdateRestrictionlist(List.from(restrictionlist)));

        List<SystemEnumDetails> secondList = restrictionlist
            .map((item) => new SystemEnumDetails.clone(item))
            .toList();

        _store.dispatch(UpdateSummeryRestrictionlist(secondList));
      } else {
        _store.dispatch(UpdateRestrictionlist([]));
        _store.dispatch(UpdateSummeryRestrictionlist([]));
      }
    });

    /*ApiManager().getEventTypesImagesDSQ(context, propId,
        (status, responce, EventTypesImageMediaInfolist) {
      if (status) {
        _store.dispatch(
            UpdateEventTypesImageList(List.from(EventTypesImageMediaInfolist)));
        _store.dispatch(UpdateSummeryEventTypesImageList(
            List.from(EventTypesImageMediaInfolist)));
      } else {
        _store.dispatch(UpdateEventTypesImageList([]));
        _store.dispatch(UpdateSummeryEventTypesImageList([]));
      }
    });*/

    /*ApiManager().getEventTypesAmanityUtility(context, propId, (status, responce, amenitieslist, utilitylist) async {
      if (status) {
        amenitieslist.sort((a, b) => a.id!.compareTo(b.id!));
        utilitylist.sort((a, b) => a.id!.compareTo(b.id!));

        _store
            .dispatch(UpdateEventTypesAmenitiesList(List.from(amenitieslist)));
        _store.dispatch(UpdateEventTypesUtilitiesList(List.from(utilitylist)));

        List<EventTypesAmenitiesUtility> secondAmenityList = amenitieslist
            .map((item) => new EventTypesAmenitiesUtility.clone(item))
            .toList();

        _store.dispatch(
            UpdateSummeryEventTypesAmenitiesList(List.from(secondAmenityList)));

        List<EventTypesAmenitiesUtility> secondUtilityList = utilitylist
            .map((item) => new EventTypesAmenitiesUtility.clone(item))
            .toList();

        _store.dispatch(
            UpdateSummeryEventTypesUtilitiesList(List.from(secondUtilityList)));
      } else {
        _store.dispatch(UpdateEventTypesAmenitiesList([]));
        _store.dispatch(UpdateEventTypesUtilitiesList([]));
        _store.dispatch(UpdateSummeryEventTypesAmenitiesList([]));
        _store.dispatch(UpdateSummeryEventTypesUtilitiesList([]));
        await ApiManager().getEventTypesFeaturelist(context);
      }
    });*/

    /*await ApiManager().getEventTypesDetails(context, propId,(status, responce, eventtypesData) async {
      if (status) {
        await ApiManager().bindEventTypesData(eventtypesData!);

        AddEditEventTypes.isValueUpdate = false;

        await Prefs.setBool(
            PrefsName.EventTypesActive, eventtypesData.isActive!);
        await Prefs.setBool(PrefsName.EventTypesEdit, true);
        await Prefs.setBool(PrefsName.EventTypesEditMode, true);
        await Prefs.setString(PrefsName.EventTypesID, eventtypesData.ID!);
        await Prefs.setBool(
            PrefsName.EventTypesAgreeTC, eventtypesData.isAgreedTandC!);
        // await Prefs.setBool(PrefsName.EventTypesAgreeTC, true);

        if (PropDrafting == 3) {
          await Prefs.setBool(PrefsName.EventTypesStep1, true);
          await Prefs.setBool(PrefsName.EventTypesStep2, true);
          await Prefs.setBool(PrefsName.EventTypesStep3, true);
        } else if (PropDrafting == 2) {
          await Prefs.setBool(PrefsName.EventTypesStep1, true);
          await Prefs.setBool(PrefsName.EventTypesStep2, true);
          await Prefs.setBool(PrefsName.EventTypesStep3, false);
        } else if (PropDrafting == 1) {
          await Prefs.setBool(PrefsName.EventTypesStep1, true);
          await Prefs.setBool(PrefsName.EventTypesStep2, false);
          await Prefs.setBool(PrefsName.EventTypesStep3, false);
        }

        if (flag == 2) {
          _store.dispatch(UpdateEventTypesForm(1));
        } else if (PropDrafting >= 1 && PropDrafting < 2) {
          _store.dispatch(UpdateEventTypesForm(2));
        } else if (PropDrafting >= 2 && PropDrafting < 3) {
          _store.dispatch(UpdateEventTypesForm(3));
        } else if (PropDrafting == 3 && !eventtypesData.isAgreedTandC!) {
          _store.dispatch(UpdateEventTypesForm(4));
        } else if (PropDrafting == 3 && flag == 1) {
          _store.dispatch(UpdateEventTypesForm(4));
        }

        _store.dispatch(UpdateAddEditEventTypes());

        loader.remove();
      } else {
        loader.remove();
      }
    }
    );*/
  }
}
