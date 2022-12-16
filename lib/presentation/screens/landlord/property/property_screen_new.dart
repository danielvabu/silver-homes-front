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
import 'package:silverhome/domain/actions/landlord_action/property_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/property_disclosure_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/property_feature_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/property_specification_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/property_summery_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/propertyform_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/propertylist_actions.dart';
import 'package:silverhome/domain/entities/property_amenities.dart';
import 'package:silverhome/domain/entities/propertylist.dart';
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
import 'package:silverhome/widget/alert/alert_dialogbox.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/landlord/propertytable/property_header.dart';
import 'package:silverhome/widget/landlord/propertytable/property_item.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

import '../../../models/landlord_models/property_list_state.dart';
import 'add_edit_property.dart';

class PropertyScreenNew extends StatefulWidget {
  @override
  _PropertyScreenNewState createState() => _PropertyScreenNewState();
}

class _PropertyScreenNewState extends State<PropertyScreenNew> {
  double ssheight = 0, sswidth = 0;
  final _store = getIt<AppStore>();

  late OverlayEntry loader;
  late Timer? _timer = null;

  @override
  void initState() {
    updateCount();
    init();
    super.initState();
  }

  updateCount() {
    ApiManager().updatePropertyStatusCount(context);
  }

  void init() async {
    await Prefs.init();

    ApiManager().updatePropertyStatusCount(context);
    updateState();
    apimanager("", 1, "PropertyName", 1, 0);
  }

  updateState() async {
    _store.dispatch(UpdatePropertyListPropertySearchText(""));
    _store.dispatch(UpdatePropertyListNameSort(true));
    await updateSortingFeild(1);
    _store.dispatch(UpdatePropertyListNameSortAcsDes(1));
    _store.dispatch(UpdatePropertyListUnitSortAcsDes(0));
    _store.dispatch(UpdatePropertyListCitySortAcsDes(0));
    _store.dispatch(UpdatePropertyListCountrySortAcsDes(0));
    _store.dispatch(UpdatePropertyListPropertyTypeSortAcsDes(0));
    _store.dispatch(UpdatePropertyListVacancySortAcsDes(0));
    _store.dispatch(UpdatePropertyListActiveSortAcsDes(0));
    _store.dispatch(UpdatePropertyListPublishedSortAcsDes(0));
  }

  apimanager(String search, int pageNo, String SortField, int saquence, int ftime) async {
    PropertyListReqtokens reqtokens = PropertyListReqtokens();
    reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    reqtokens.Name = search != null ? search : "";

    Pager pager = Pager(pageNo: pageNo, noOfRecords: Helper.noofrecored);

    List<Sort> sortinglist = [];
    Sort sort = Sort();
    sort.fieldId = SortField;
    sort.sortSequence = saquence;
    sortinglist.add(sort);

    DSQQuery dsqQuery = DSQQuery();
    dsqQuery.dsqid = Weburl.DSQ_PropertyOnBoardingList;
    dsqQuery.loadLookUpValues = true;
    dsqQuery.loadRecordInfo = true;
    dsqQuery.propertyListReqtokens = reqtokens;
    dsqQuery.pager = pager;
    dsqQuery.sort = sortinglist;

    String filterjson = jsonEncode(dsqQuery);

    Helper.Log("Property", filterjson);
    _store.dispatch(UpdatePropertyListIsloding(true));
    _store.dispatch(UpdatePropertyList(<PropertyDataList>[]));
    _store.dispatch(UpdatePropertyListPropertySearchText(search));
    await ApiManager().getPropertyOnboadingList(context, filterjson, ftime);
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
          child: ConnectState<PropertyListState>(
              map: (state) => state.propertyListState,
              where: notIdentical,
              builder: (propertyListState) {
                return Column(
                  children: [
                    _statusView(propertyListState!),
                    _centerView(propertyListState),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget _statusView(PropertyListState propertyListState) {
    return Container(
      child: Row(
        children: [
          CustomeWidget.PropertyStutas(propertyListState.status_UnitsHeld.toString(), GlobleString.PP_status_UnitsHeld),
          CustomeWidget.PropertyStutas(propertyListState.status_UnitsRented.toString(), GlobleString.PP_status_UnitsRented),
          CustomeWidget.PropertyStutas(propertyListState.status_VacantUnits.toString(), GlobleString.PP_status_VacantUnits),
          Expanded(child: Container()),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  Widget _centerView(PropertyListState propertyListState) {
    return Container(
      width: sswidth,
      height: ssheight - 95,
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
                        if (propertyListState.isloding && propertyListState.PropertySearchText == "")
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
                                    initialValue: propertyListState.PropertySearchText,
                                    onChanged: (value) async {
                                      if (_timer != null) {
                                        _timer!.cancel();
                                      }
                                      _timer = new Timer.periodic(Duration(seconds: 2), (timer) {
                                        _store.dispatch(UpdatePropertyListIsloding(true));
                                        _store.dispatch(UpdatePropertyList(<PropertyDataList>[]));
                                        apimanager(value, 1, "PropertyName", 1, 0);
                                        _timer!.cancel();
                                      });
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
                    SizedBox(
                      width: 10,
                    ),
                    _addNewLead(),
                  ],
                ),
                Row(
                  children: [_actionPopup(propertyListState)],
                ),
              ],
            ),
          ),
          _tableview(propertyListState)
        ],
      ),
    );
  }

  Widget _addNewLead() {
    return InkWell(
      onTap: () async {
        AddEditProperty.isValueUpdate = false;
        await Prefs.setBool(PrefsName.PropertyActive, true);
        await Prefs.setBool(PrefsName.PropertyEdit, false);
        await Prefs.setBool(PrefsName.PropertyEditMode, false);
        await Prefs.setString(PrefsName.PropertyID, "");
        await Prefs.setBool(PrefsName.PropertyAgreeTC, false);

        await Prefs.setBool(PrefsName.PropertyStep1, false);
        await Prefs.setBool(PrefsName.PropertyStep2, false);
        await Prefs.setBool(PrefsName.PropertyStep3, false);

        await clearaddpropertydetails();
        await clearpropertySummerydetails();

        List<SystemEnumDetails> restrictionlist = [];
        restrictionlist = QueryFilter().PlainValues(eSystemEnums().Restrictions);

        List<SystemEnumDetails> secondrestrictionlist = restrictionlist.map((item) => new SystemEnumDetails.clone(item)).toList();

        _store.dispatch(UpdateSummeryRestrictionlist(secondrestrictionlist));

        _store.dispatch(UpdateRestrictionlist(restrictionlist));

        _store.dispatch(UpdatePropertyForm(1));
        _store.dispatch(UpdatePropertyFormAddress(""));
        _store.dispatch(UpdateAddEditProperty());
      },
      child: CustomeWidget.AddNewProperty(),
    );
  }

  clearaddpropertydetails() {
    _store.dispatch(UpdateProperTytypeValue(null));
    _store.dispatch(UpdatePropertyTypeOtherValue(""));
    _store.dispatch(UpdateDateofavailable(null));
    _store.dispatch(UpdateRentalSpaceValue(null));
    _store.dispatch(UpdatePropertyName(""));
    _store.dispatch(UpdatePropertyAddress(""));
    _store.dispatch(UpdatePropertyDescription(""));
    _store.dispatch(UpdateSuiteunit(""));
    _store.dispatch(UpdateBuildingname(""));
    _store.dispatch(UpdatePropertyCity(""));
    _store.dispatch(UpdatePropertyCountryCode("CA"));
    _store.dispatch(UpdatePropertyCountryName("Canada"));
    _store.dispatch(UpdatePropertyProvince(""));
    _store.dispatch(UpdatePropertyPostalcode(""));
    _store.dispatch(UpdatePropertyRentAmount(""));
    _store.dispatch(UpdateRentPaymentFrequencyValue(null));
    _store.dispatch(UpdateLeaseTypeValue(null));
    _store.dispatch(UpdateMinimumLeasedurationValue(null));
    _store.dispatch(UpdateMinimumleasedurationNumber(""));

    _store.dispatch(UpdatePropertyBedrooms(""));
    _store.dispatch(UpdatePropertyBathrooms(""));
    _store.dispatch(UpdatePropertySizeinsquarefeet(""));
    _store.dispatch(UpdatePropertyMaxoccupancy(""));
    _store.dispatch(UpdateFurnishingValue(null));
    _store.dispatch(UpdateParkingstalls(""));
    _store.dispatch(UpdateStorageAvailableValue(null));
    _store.dispatch(UpdateAgreeTCPP(false));
    _store.dispatch(UpdatePropertyDrafting(1));
    _store.dispatch(UpdatePropertyVacancy(false));

    _store.dispatch(UpdateErrorParkingstalls(false));
    _store.dispatch(UpdateErrorStorageavailable(false));
    _store.dispatch(UpdateErrorOther_Partial_Furniture(false));
    _store.dispatch(UpdateErrorFurnishing(false));
    _store.dispatch(UpdateErrorPropertyMaxoccupancy(false));
    _store.dispatch(UpdateErrorPropertyBathrooms(false));
    _store.dispatch(UpdateErrorPropertyBedrooms(false));
    _store.dispatch(UpdateErrorPropertySizeinsquarefeet(false));
    _store.dispatch(UpdateErrorPropertytype(false));
    _store.dispatch(UpdateErrorPropertytypeOther(false));
    _store.dispatch(UpdateErrorPropertyName(false));
    _store.dispatch(UpdateErrorPropertyAddress(false));
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
    _store.dispatch(UpdatePropertyImageList(<PropertyImageMediaInfo>[]));
  }

  clearpropertySummerydetails() {
    _store.dispatch(UpdateSummeryProperTytypeValue(null));
    _store.dispatch(UpdateSummeryPropertyTypeOtherValue(""));
    _store.dispatch(UpdateSummeryDateofavailable(null));
    _store.dispatch(UpdateSummeryRentalSpaceValue(null));
    _store.dispatch(UpdateSummeryPropertyName(""));
    _store.dispatch(UpdateSummeryPropertyAddress(""));
    _store.dispatch(UpdateSummeryPropertyDescription(""));
    _store.dispatch(UpdateSummerySuiteunit(""));
    _store.dispatch(UpdateSummeryBuildingname(""));
    _store.dispatch(UpdateSummeryPropertyCity(""));
    _store.dispatch(UpdateSummeryPropertyCountryCode("CA"));
    _store.dispatch(UpdateSummeryPropertyCountryName("Canada"));
    _store.dispatch(UpdateSummeryPropertyProvince(""));
    _store.dispatch(UpdateSummeryPropertyPostalcode(""));
    _store.dispatch(UpdateSummeryPropertyRentAmount(""));
    _store.dispatch(UpdateSummeryRentPaymentFrequencyValue(null));
    _store.dispatch(UpdateSummeryLeaseTypeValue(null));
    _store.dispatch(UpdateSummeryMinimumLeasedurationValue(null));
    _store.dispatch(UpdateSummeryMinimumleasedurationNumber(""));
    _store.dispatch(UpdateSummeryPropertyImage(null));
    _store.dispatch(UpdateSummeryPropertyUint8List(null));
    _store.dispatch(UpdateSummeryPropertyBedrooms(""));
    _store.dispatch(UpdateSummeryPropertyBathrooms(""));
    _store.dispatch(UpdateSummeryPropertySizeinsquarefeet(""));
    _store.dispatch(UpdateSummeryPropertyMaxoccupancy(""));
    _store.dispatch(UpdateSummeryFurnishingValue(null));
    _store.dispatch(UpdateSummeryOtherPartialFurniture(""));
    _store.dispatch(UpdateSummeryParkingstalls(""));
    _store.dispatch(UpdateSummeryStorageAvailableValue(null));
    _store.dispatch(UpdateSummeryAgreeTCPP(false));
    _store.dispatch(UpdateSummeryPropertyDrafting(1));
    _store.dispatch(UpdateSummeryPropertyVacancy(false));
    _store.dispatch(UpdateSummeryPropertyImageList(<PropertyImageMediaInfo>[]));
  }

  Widget _actionPopup(PropertyListState propertyListState) {
    return Container(
      height: 32,
      width: 30,
      child: PopupMenuButton(
        onSelected: (value) async {
          PropertyListReqtokens reqtokens = new PropertyListReqtokens();
          reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
          reqtokens.Name = propertyListState.PropertySearchText != null ? propertyListState.PropertySearchText : "";

          List<Sort> sortinglist = [];
          Sort sort = new Sort();
          if (propertyListState.PropertySearchText != null && propertyListState.PropertySearchText.isNotEmpty) {
            sort.fieldId = "ID";
            sort.sortSequence = 0;
          } else {
            if (propertyListState.isPropertyNameSort) {
              sort.fieldId = "PropertyName";
              sort.sortSequence = propertyListState.NameSortAcsDes;
            } else if (propertyListState.isPropertyUnitSort) {
              sort.fieldId = "Suite_Unit";
              sort.sortSequence = propertyListState.UnitSortAcsDes;
            } else if (propertyListState.isCitySort) {
              sort.fieldId = "City";
              sort.sortSequence = propertyListState.CitySortAcsDes;
            } else if (propertyListState.isCountrySort) {
              sort.fieldId = "Country";
              sort.sortSequence = propertyListState.CountrySortAcsDes;
            } else if (propertyListState.isPropertyTypeSort) {
              sort.fieldId = "Property_Type";
              sort.sortSequence = propertyListState.PropertyTypeSortAcsDes;
            } else if (propertyListState.isvacancySort) {
              sort.fieldId = "Vacancy";
              sort.sortSequence = propertyListState.VacancySortAcsDes;
            } else if (propertyListState.isActiveInactiveSort) {
              sort.fieldId = "IsActive";
              sort.sortSequence = propertyListState.ActiveSortAcsDes;
            } else if (propertyListState.isPublishedSort) {
              sort.fieldId = "IsPublished";
              sort.sortSequence = propertyListState.PublishedSortAcsDes;
            } else {
              sort.fieldId = "ID";
              sort.sortSequence = 0;
            }
          }

          sortinglist.add(sort);

          DSQQuery dsqQuery = new DSQQuery();
          dsqQuery.dsqid = Weburl.DSQ_PropertyOnBoardingList;
          dsqQuery.loadLookUpValues = true;
          dsqQuery.loadRecordInfo = true;
          dsqQuery.propertyListReqtokens = reqtokens;
          dsqQuery.sort = sortinglist;

          String filterjson = jsonEncode(dsqQuery);

          await ApiManager().getAllPropertyOnboadingListCSV(context, filterjson);
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

  Widget _tableview(PropertyListState propertyListState) {
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
          PropertyHeader(
            onPressedSortProperty: () async {
              _store.dispatch(UpdatePropertyListNameSort(true));
              updateOtherSortingValue(1, propertyListState);
            },
            onPressedSortUnit: () async {
              _store.dispatch(UpdatePropertyListUnitSort(true));
              updateOtherSortingValue(2, propertyListState);
            },
            onPressedSortCity: () async {
              _store.dispatch(UpdatePropertyListCitySort(true));
              updateOtherSortingValue(3, propertyListState);
            },
            onPressedSortCountry: () async {
              _store.dispatch(UpdatePropertyListCountrySort(true));
              updateOtherSortingValue(4, propertyListState);
            },
            onPressedSortPropertyType: () async {
              _store.dispatch(UpdatePropertyListPropertyTypeSort(true));
              updateOtherSortingValue(5, propertyListState);
            },
            onPressedSortVacancy: () async {
              _store.dispatch(UpdatePropertyListVacancySort(true));
              updateOtherSortingValue(6, propertyListState);
            },
            onPressedSortActiveInactive: () async {
              _store.dispatch(UpdatePropertyListActiveInactiveSort(true));
              updateOtherSortingValue(7, propertyListState);
            },
            onPressedSortIsPublished: () async {
              _store.dispatch(UpdatePropertyListisPublishedSort(true));
              updateOtherSortingValue(8, propertyListState);
            },
          ),
          tableItem(propertyListState),
          if (propertyListState.propertylist != null && propertyListState.propertylist.length > 0) tablefooter(propertyListState)
        ],
      ),
    );
  }

  Widget tableItem(PropertyListState propertyListState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        propertyListState.isloding
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
            : propertyListState.propertylist != null && propertyListState.propertylist.length > 0
                ? Expanded(
                    child: PropertyItem(
                      listdata1: propertyListState.propertylist,
                      onPresseEdit: (PropertyDataList propertyData) {
                        getPropertyDetails(propertyData, 2, propertyData.propDrafting!);
                      },
                      onPresseDuplicat: (PropertyDataList propertyData) {
                        ApiManager().DuplicatPropertyGenerate(context, propertyData.id!, (status, responce) async {
                          if (status) {
                            _store.dispatch(UpdatePropertyListIsloding(true));
                            _store.dispatch(UpdatePropertyList(<PropertyDataList>[]));
                            apimanager("", 1, "PropertyName", 1, 0);
                          } else {
                            ToastUtils.showCustomToast(context, GlobleString.Error1, false);
                          }
                        });
                      },
                      onPressDetails: (PropertyDataList propertyData) {
                        getPropertyDetails(propertyData, 1, propertyData.propDrafting!);
                      },
                      onPressName: (PropertyDataList propertyData) {
                        getPropertyDetails(propertyData, 1, propertyData.propDrafting!);
                      },
                      onPresseInActive: (PropertyDataList propertyData, int pos) {
                        ApiManager().TenantAvailableInProperty(context, Prefs.getString(PrefsName.OwnerID), propertyData.id!,
                            (status, responce) {
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
                                      propertyActive_InAction_call(propertyListState, false, propertyData.id!);
                                    },
                                    onPressedNo: () {
                                      Navigator.of(context1).pop();
                                    },
                                  );
                                },
                              );
                            } else {
                              propertyActive_InAction_call(propertyListState, false, propertyData.id!);
                            }
                          } else {
                            propertyActive_InAction_call(propertyListState, false, propertyData.id!);
                          }
                        });
                      },
                      onPresseActive: (PropertyDataList propertyData, int pos) {
                        if (propertyData.propDrafting != 3) {
                          ToastUtils.showCustomToast(context, GlobleString.PS3_Property_all_details, false);
                        } else if (!propertyData.isAgreedTandC!) {
                          ToastUtils.showCustomToast(context, GlobleString.PS3_Property_Disclosures, false);
                        } else {
                          propertyActive_InAction_call(propertyListState, true, propertyData.id!);
                        }
                      },
                      onPresseIsPublish: (PropertyDataList propertyData, int pos, bool flag) {
                        if (!propertyData.isActive!) {
                          ToastUtils.showCustomToast(context, GlobleString.PS3_Property_Active_publish, false);
                        } else {
                          showDialog(
                            context: context,
                            barrierColor: Colors.black45,
                            useSafeArea: true,
                            barrierDismissible: false,
                            builder: (BuildContext context1) {
                              return AlertDialogBox(
                                title: flag ? GlobleString.Prop_Publish : GlobleString.Prop_UnPublish,
                                positiveText: GlobleString.Prop_btn_yes,
                                negativeText: GlobleString.Prop_btn_cancel,
                                onPressedYes: () {
                                  Navigator.of(context1).pop();
                                  propertyIsPublished_call(propertyListState, flag, propertyData.id!);
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
                        GlobleString.Blank_Property,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: MyStyles.Medium(18, myColor.tabel_msg),
                      ),
                    ),
                  )
      ],
    );
  }

  Widget tablefooter(PropertyListState propertyListState) {
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
              defultHeight: Helper.PagingRecord(propertyListState.totalRecord).length * 35 > 350
                  ? 350
                  : Helper.PagingRecord(propertyListState.totalRecord).length * 35,
              selectedItem: propertyListState.pageNo.toString(),
              items: Helper.PagingRecord(propertyListState.totalRecord),
              showSearchBox: false,
              isFilteredOnline: true,
              onChanged: (value) {
                _store.dispatch(UpdatePropertyListPageNo(int.parse(value.toString())));
                paginationCall(propertyListState, int.parse(value.toString()));
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
                    color: propertyListState.pageNo == 1
                        ? myColor.hintcolor
                        : myColor.black,
                  ),
                  onPressed: () {
                    if (propertyListState.pageNo != 1) {
                      int pageno = propertyListState.pageNo - 1;
                      _store.dispatch(UpdatePropertyListPageNo(pageno));
                      paginationCall(propertyListState, pageno);
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
                    propertyListState.pageNo.toString(),
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
                    propertyListState.totalpage.toString(),
                    style: MyStyles.Medium(14, myColor.text_color),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: propertyListState.pageNo ==
                        propertyListState.totalpage
                        ? myColor.hintcolor
                        : myColor.black,
                  ),
                  onPressed: () {
                    if (propertyListState.pageNo !=
                        propertyListState.totalpage) {
                      int pageno = propertyListState.pageNo + 1;
                      _store.dispatch(UpdatePropertyListPageNo(pageno));
                      paginationCall(propertyListState, pageno);
                    }
                  },
                )
              ],
            )*/
        ],
      ),
    );
  }

  void paginationCall(PropertyListState propertyListState, int pageno) {
    if (propertyListState.isPropertyNameSort) {
      apimanager(propertyListState.PropertySearchText, pageno, "PropertyName", propertyListState.NameSortAcsDes, 1);
    }

    if (propertyListState.isPropertyUnitSort) {
      apimanager(propertyListState.PropertySearchText, pageno, "Suite_Unit", propertyListState.UnitSortAcsDes, 1);
    }

    if (propertyListState.isCitySort) {
      apimanager(propertyListState.PropertySearchText, pageno, "City", propertyListState.CitySortAcsDes, 1);
    }

    if (propertyListState.isCountrySort) {
      apimanager(propertyListState.PropertySearchText, pageno, "Country", propertyListState.CountrySortAcsDes, 1);
    }

    if (propertyListState.isPropertyTypeSort) {
      apimanager(propertyListState.PropertySearchText, pageno, "Property_Type", propertyListState.PropertyTypeSortAcsDes, 1);
    }

    if (propertyListState.isvacancySort) {
      apimanager(propertyListState.PropertySearchText, pageno, "Vacancy", propertyListState.VacancySortAcsDes, 1);
    }

    if (propertyListState.isActiveInactiveSort) {
      apimanager(propertyListState.PropertySearchText, pageno, "IsActive", propertyListState.ActiveSortAcsDes, 1);
    }

    if (propertyListState.isPublishedSort) {
      apimanager(propertyListState.PropertySearchText, pageno, "IsPublished", propertyListState.PublishedSortAcsDes, 1);
    }
  }

  updateOtherSortingValue(int flag, PropertyListState propertyListState) {
    updateSortingFeild(flag);

    if (flag == 1) {
      _store.dispatch(UpdatePropertyListNameSortAcsDes(propertyListState.NameSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdatePropertyListUnitSortAcsDes(0));
      _store.dispatch(UpdatePropertyListCitySortAcsDes(0));
      _store.dispatch(UpdatePropertyListCountrySortAcsDes(0));
      _store.dispatch(UpdatePropertyListPropertyTypeSortAcsDes(0));
      _store.dispatch(UpdatePropertyListVacancySortAcsDes(0));
      _store.dispatch(UpdatePropertyListActiveSortAcsDes(0));
      _store.dispatch(UpdatePropertyListPublishedSortAcsDes(0));

      apimanager("", 1, "PropertyName", propertyListState.NameSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 2) {
      _store.dispatch(UpdatePropertyListUnitSortAcsDes(propertyListState.UnitSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdatePropertyListNameSortAcsDes(0));
      _store.dispatch(UpdatePropertyListCitySortAcsDes(0));
      _store.dispatch(UpdatePropertyListCountrySortAcsDes(0));
      _store.dispatch(UpdatePropertyListPropertyTypeSortAcsDes(0));
      _store.dispatch(UpdatePropertyListVacancySortAcsDes(0));
      _store.dispatch(UpdatePropertyListActiveSortAcsDes(0));
      _store.dispatch(UpdatePropertyListPublishedSortAcsDes(0));

      apimanager("", 1, "Suite_Unit", propertyListState.UnitSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 3) {
      _store.dispatch(UpdatePropertyListCitySortAcsDes(propertyListState.CitySortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdatePropertyListNameSortAcsDes(0));
      _store.dispatch(UpdatePropertyListUnitSortAcsDes(0));
      _store.dispatch(UpdatePropertyListCountrySortAcsDes(0));
      _store.dispatch(UpdatePropertyListPropertyTypeSortAcsDes(0));
      _store.dispatch(UpdatePropertyListVacancySortAcsDes(0));
      _store.dispatch(UpdatePropertyListActiveSortAcsDes(0));
      _store.dispatch(UpdatePropertyListPublishedSortAcsDes(0));

      apimanager("", 1, "City", propertyListState.CitySortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 4) {
      _store.dispatch(UpdatePropertyListCountrySortAcsDes(propertyListState.CountrySortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdatePropertyListNameSortAcsDes(0));
      _store.dispatch(UpdatePropertyListUnitSortAcsDes(0));
      _store.dispatch(UpdatePropertyListCitySortAcsDes(0));
      _store.dispatch(UpdatePropertyListPropertyTypeSortAcsDes(0));
      _store.dispatch(UpdatePropertyListVacancySortAcsDes(0));
      _store.dispatch(UpdatePropertyListActiveSortAcsDes(0));
      _store.dispatch(UpdatePropertyListPublishedSortAcsDes(0));

      apimanager("", 1, "Country", propertyListState.CountrySortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 5) {
      _store.dispatch(UpdatePropertyListPropertyTypeSortAcsDes(propertyListState.PropertyTypeSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdatePropertyListNameSortAcsDes(0));
      _store.dispatch(UpdatePropertyListUnitSortAcsDes(0));
      _store.dispatch(UpdatePropertyListCitySortAcsDes(0));
      _store.dispatch(UpdatePropertyListCountrySortAcsDes(0));
      _store.dispatch(UpdatePropertyListVacancySortAcsDes(0));
      _store.dispatch(UpdatePropertyListActiveSortAcsDes(0));
      _store.dispatch(UpdatePropertyListPublishedSortAcsDes(0));

      apimanager("", 1, "Property_Type", propertyListState.PropertyTypeSortAcsDes == 1 ? 0 : 1, 0);
    } else if (flag == 6) {
      _store.dispatch(UpdatePropertyListVacancySortAcsDes(propertyListState.VacancySortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdatePropertyListNameSortAcsDes(0));
      _store.dispatch(UpdatePropertyListUnitSortAcsDes(0));
      _store.dispatch(UpdatePropertyListCitySortAcsDes(0));
      _store.dispatch(UpdatePropertyListCountrySortAcsDes(0));
      _store.dispatch(UpdatePropertyListPropertyTypeSortAcsDes(0));
      _store.dispatch(UpdatePropertyListActiveSortAcsDes(0));
      _store.dispatch(UpdatePropertyListPublishedSortAcsDes(0));

      apimanager("", 1, "Vacancy", propertyListState.VacancySortAcsDes == 1 ? 0 : 1, 0);
    }

    if (flag == 7) {
      _store.dispatch(UpdatePropertyListActiveSortAcsDes(propertyListState.ActiveSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdatePropertyListNameSortAcsDes(0));
      _store.dispatch(UpdatePropertyListUnitSortAcsDes(0));
      _store.dispatch(UpdatePropertyListCitySortAcsDes(0));
      _store.dispatch(UpdatePropertyListCountrySortAcsDes(0));
      _store.dispatch(UpdatePropertyListPropertyTypeSortAcsDes(0));
      _store.dispatch(UpdatePropertyListVacancySortAcsDes(0));
      _store.dispatch(UpdatePropertyListPublishedSortAcsDes(0));

      apimanager("", 1, "IsActive", propertyListState.ActiveSortAcsDes == 1 ? 0 : 1, 0);
    }

    if (flag == 8) {
      _store.dispatch(UpdatePropertyListPublishedSortAcsDes(propertyListState.PublishedSortAcsDes == 1 ? 0 : 1));
      _store.dispatch(UpdatePropertyListNameSortAcsDes(0));
      _store.dispatch(UpdatePropertyListUnitSortAcsDes(0));
      _store.dispatch(UpdatePropertyListCitySortAcsDes(0));
      _store.dispatch(UpdatePropertyListCountrySortAcsDes(0));
      _store.dispatch(UpdatePropertyListPropertyTypeSortAcsDes(0));
      _store.dispatch(UpdatePropertyListVacancySortAcsDes(0));
      _store.dispatch(UpdatePropertyListActiveSortAcsDes(0));

      apimanager("", 1, "IsPublished", propertyListState.PublishedSortAcsDes == 1 ? 0 : 1, 0);
    }
  }

  updateSortingFeild(int flag) {
    if (flag != 1) {
      _store.dispatch(UpdatePropertyListNameSort(false));
    }
    if (flag != 2) {
      _store.dispatch(UpdatePropertyListUnitSort(false));
    }
    if (flag != 3) {
      _store.dispatch(UpdatePropertyListCitySort(false));
    }
    if (flag != 4) {
      _store.dispatch(UpdatePropertyListCountrySort(false));
    }
    if (flag != 5) {
      _store.dispatch(UpdatePropertyListPropertyTypeSort(false));
    }
    if (flag != 6) {
      _store.dispatch(UpdatePropertyListVacancySort(false));
    }
    if (flag != 7) {
      _store.dispatch(UpdatePropertyListActiveInactiveSort(false));
    }
    if (flag != 8) {
      _store.dispatch(UpdatePropertyListisPublishedSort(false));
    }
  }

  propertyActive_InAction_call(PropertyListState propertyListState, bool isAct, String propertyid) {
    PropertyActive proactive = PropertyActive();
    proactive.IsActive = isAct;
    proactive.IsPublished = false;

    PropertyUpdate propertyUpdate = PropertyUpdate();
    propertyUpdate.ID = propertyid;
    propertyUpdate.Owner_ID = Prefs.getString(PrefsName.OwnerID);

    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().UpdatePropertyActive(context, propertyUpdate, proactive, (error, responce) async {
      if (error) {
        if (isAct) {
          /*  await ApiManager().getPropertyOnboadingList(
              context, Prefs.getString(PrefsName.OwnerID));
          loader.remove();*/
          ApiManager().ArchiveLeadRestoreInProperty(context, propertyid, (status, responce) async {
            if (status) {
              ToastUtils.showCustomToast(context, GlobleString.Prop_activated_success, true);
              paginationCall(propertyListState, propertyListState.pageNo);
              loader.remove();
            } else {
              loader.remove();
              ToastUtils.showCustomToast(context, GlobleString.Error1, false);
            }
          });
        } else {
          /* await ApiManager().getPropertyOnboadingList(
              context, Prefs.getString(PrefsName.OwnerID));
          loader.remove();*/

          ApiManager().ArchiveLeadInProperty(context, propertyid, (status, responce) async {
            if (status) {
              ToastUtils.showCustomToast(context, GlobleString.Prop_deactivated_success, true);
              paginationCall(propertyListState, propertyListState.pageNo);
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

  propertyIsPublished_call(PropertyListState propertyListState, bool isAct, String propertyid) {
    PropertyIsPublished proactive = PropertyIsPublished();
    proactive.IsPublished = isAct;

    PropertyUpdate propertyUpdate = PropertyUpdate();
    propertyUpdate.ID = propertyid;
    propertyUpdate.Owner_ID = Prefs.getString(PrefsName.OwnerID);

    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().UpdatePropertyActive(context, propertyUpdate, proactive, (error, responce) async {
      if (error) {
        if (isAct) {
          ToastUtils.showCustomToast(context, GlobleString.Prop_published_success, true);
        } else {
          ToastUtils.showCustomToast(context, GlobleString.Prop_unpublished_success, true);
        }
        paginationCall(propertyListState, propertyListState.pageNo);
        loader.remove();
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
  }

  getPropertyDetails(PropertyDataList propertyData1, int flag, int PropDrafting) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String propId = propertyData1.id.toString();

    ApiManager().getPropertyRestriction(context, propId, (status, responce, restrictionlist) {
      if (status) {
        _store.dispatch(UpdateRestrictionlist(List.from(restrictionlist)));

        List<SystemEnumDetails> secondList = restrictionlist.map((item) => new SystemEnumDetails.clone(item)).toList();

        _store.dispatch(UpdateSummeryRestrictionlist(secondList));
      } else {
        _store.dispatch(UpdateRestrictionlist([]));
        _store.dispatch(UpdateSummeryRestrictionlist([]));
      }
    });

    ApiManager().getPropertyImagesDSQ(context, propId, (status, responce, PropertyImageMediaInfolist) {
      if (status) {
        _store.dispatch(UpdatePropertyImageList(List.from(PropertyImageMediaInfolist)));
        _store.dispatch(UpdateSummeryPropertyImageList(List.from(PropertyImageMediaInfolist)));
      } else {
        _store.dispatch(UpdatePropertyImageList([]));
        _store.dispatch(UpdateSummeryPropertyImageList([]));
      }
    });

    ApiManager().getPropertyAmanityUtility(context, propId, (status, responce, amenitieslist, utilitylist) async {
      if (status) {
        amenitieslist.sort((a, b) => a.id!.compareTo(b.id!));
        utilitylist.sort((a, b) => a.id!.compareTo(b.id!));

        _store.dispatch(UpdatePropertyAmenitiesList(List.from(amenitieslist)));
        _store.dispatch(UpdatePropertyUtilitiesList(List.from(utilitylist)));

        List<PropertyAmenitiesUtility> secondAmenityList = amenitieslist.map((item) => new PropertyAmenitiesUtility.clone(item)).toList();

        _store.dispatch(UpdateSummeryPropertyAmenitiesList(List.from(secondAmenityList)));

        List<PropertyAmenitiesUtility> secondUtilityList = utilitylist.map((item) => new PropertyAmenitiesUtility.clone(item)).toList();

        _store.dispatch(UpdateSummeryPropertyUtilitiesList(List.from(secondUtilityList)));
      } else {
        _store.dispatch(UpdatePropertyAmenitiesList([]));
        _store.dispatch(UpdatePropertyUtilitiesList([]));
        _store.dispatch(UpdateSummeryPropertyAmenitiesList([]));
        _store.dispatch(UpdateSummeryPropertyUtilitiesList([]));
        await ApiManager().getPropertyFeaturelist(context);
      }
    });

    await ApiManager().getPropertyDetails(context, propId, (status, responce, propertyData) async {
      if (status) {
        await ApiManager().bindPropertyData(propertyData!);

        AddEditProperty.isValueUpdate = false;

        await Prefs.setBool(PrefsName.PropertyActive, propertyData.isActive!);
        await Prefs.setBool(PrefsName.PropertyEdit, true);
        await Prefs.setBool(PrefsName.PropertyEditMode, true);
        await Prefs.setString(PrefsName.PropertyID, propertyData.ID!);
        await Prefs.setBool(PrefsName.PropertyAgreeTC, propertyData.isAgreedTandC!);
        // await Prefs.setBool(PrefsName.PropertyAgreeTC, true);

        if (PropDrafting == 3) {
          await Prefs.setBool(PrefsName.PropertyStep1, true);
          await Prefs.setBool(PrefsName.PropertyStep2, true);
          await Prefs.setBool(PrefsName.PropertyStep3, true);
        } else if (PropDrafting == 2) {
          await Prefs.setBool(PrefsName.PropertyStep1, true);
          await Prefs.setBool(PrefsName.PropertyStep2, true);
          await Prefs.setBool(PrefsName.PropertyStep3, false);
        } else if (PropDrafting == 1) {
          await Prefs.setBool(PrefsName.PropertyStep1, true);
          await Prefs.setBool(PrefsName.PropertyStep2, false);
          await Prefs.setBool(PrefsName.PropertyStep3, false);
        }

        if (flag == 2) {
          _store.dispatch(UpdatePropertyForm(1));
        } else if (PropDrafting >= 1 && PropDrafting < 2) {
          _store.dispatch(UpdatePropertyForm(2));
        } else if (PropDrafting >= 2 && PropDrafting < 3) {
          _store.dispatch(UpdatePropertyForm(3));
        } else if (PropDrafting == 3 && !propertyData.isAgreedTandC!) {
          _store.dispatch(UpdatePropertyForm(4));
        } else if (PropDrafting == 3 && flag == 1) {
          _store.dispatch(UpdatePropertyForm(4));
        }

        _store.dispatch(UpdateAddEditProperty());

        loader.remove();
      } else {
        loader.remove();
      }
    });
  }
}
