import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/navigation_constants.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/portal_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypes_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypes_feature_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypes_specification_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypes_summery_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypesform_actions.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_filter.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/tabclass.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

import '../../../../models/landlord_models/event_types_state.dart';
import 'add_edit_eventtypes.dart';

class StepEventTypesAvailability extends StatefulWidget {
  final VoidCallback _callbackBack;
  final VoidCallback _callbackSaveandNext;

  StepEventTypesAvailability({
    required VoidCallback onPressedBack,
    required VoidCallback onPressedSave,
  })  : _callbackBack = onPressedBack,
        _callbackSaveandNext = onPressedSave;

  @override
  _StepEventTypesAvailabilityState createState() =>
      _StepEventTypesAvailabilityState();
}

class _StepEventTypesAvailabilityState
    extends State<StepEventTypesAvailability> {
  double ssheight = 0, sswidth = 0;

  final _store = getIt<AppStore>();

  String formatNumber(String s) =>
      NumberFormat.decimalPattern('en').format(int.parse(s));
  final controllerSize = TextEditingController();

  late OverlayEntry overlayEntry;
  late OverlayEntry loader;
  bool isGotoBack = false;
  int stepper = 0;
  // bool firsttime = true;
  bool change = false;

  void initState() {
    Prefs.init();
    filldata();
    initilize();
    initNavigationBack();
    AddEditEventTypes.isValueUpdate = false;
    super.initState();
  }

  _changeData() {
    if (!change) {
      AddEditEventTypes.isValueUpdate = true;
      change = true;
    }
  }

  initNavigationBack() {
    navigationNotifier.addListener(() {
      if (mounted) if (navigationNotifier.backScreen ==
          NavigationConstant.specificationAndRestriction) {
        isGotoBack = navigationNotifier.gotoBack;
        stepper = navigationNotifier.stepper;
        apiCallAndValication(_store.state!.eventTypesState);
      }
    });
  }

  void filldata() {
    List<SystemEnumDetails> furnishinglist = [];
    furnishinglist = QueryFilter().PlainValues(eSystemEnums().Furnishing);

    _store.dispatch(UpdateFurnishinglist(furnishinglist));
  }

  void initilize() {
    if (_store.state!.eventTypesSummeryState != null) {
      EventTypesState eventTypesState = _store.state!.eventTypesState;

      // _store.dispatch(
      //     UpdateEventTypesBedrooms(eventtypesSummeryState.EventTypesBedrooms));
      // _store.dispatch(UpdateEventTypesBathrooms(
      //     eventtypesSummeryState.EventTypesBathrooms));
      // _store.dispatch(UpdateEventTypesSizeinsquarefeet(
      //     eventtypesSummeryState.EventTypesSizeinsquarefeet));
      // _store.dispatch(UpdateEventTypesMaxoccupancy(
      //     eventtypesSummeryState.EventTypesMaxoccupancy));
      // _store.dispatch(
      //     UpdateFurnishingValue(eventtypesSummeryState.furnishingValue));
      // _store.dispatch(UpdateOtherPartialFurniture(
      //     eventtypesSummeryState.Other_Partial_Furniture));

      // List<SystemEnumDetails> secondList = eventtypesSummeryState
      //     .restrictionlist
      //     .map((item) => new SystemEnumDetails.clone(item))
      //     .toList();

      // _store.dispatch(UpdateRestrictionlist(secondList));
    }
  }

  @override
  Widget build(BuildContext context) {
    ssheight = MediaQuery.of(context).size.height - 75;
    sswidth = MediaQuery.of(context).size.width - 230;

    return Container(
      width: sswidth,
      height: ssheight - 186,
      child: ConnectState<EventTypesState>(
          map: (state) => state.eventTypesState,
          where: notIdentical,
          builder: (eventtypesState) {
            return SingleChildScrollView(
              child: Container(
                child: FocusScope(
                  node: FocusScopeNode(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(
                          GlobleString.ET_Set_Availability,
                          style: MyStyles.Medium(20, myColor.Circle_main),
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          eventtypesState!
                              .EventTypesName, // este sale de la pantalla anterior: Event Type Name
                          style: MyStyles.Bold(20, myColor.Circle_main),
                        ),
                      ]),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    GlobleString.Time_Zone,
                                    style: MyStyles.Medium(16, myColor.black),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Container(
                                  height: 32,
                                  child: DropdownSearch<String>(
                                    key: UniqueKey(),
                                    mode: Mode.MENU,
                                    errorcolor: myColor.errorcolor,
                                    isError: eventtypesState
                                        .error_minimumleaseduration,
                                    focuscolor: myColor.blue,
                                    focusWidth: 2,
                                    popupBackgroundColor: myColor.white,
                                    items: [
                                      "Pacific Time",
                                      "Mountain Time",
                                      "Eastern Time",
                                      "Central Time"
                                    ],
                                    defultHeight: 80,
                                    textstyle:
                                        MyStyles.Medium(14, myColor.text_color),
                                    hint: "Select",
                                    showSearchBox: false,
                                    selectedItem: eventtypesState.timezone,
                                    isFilteredOnline: true,
                                    onChanged: (value) {
                                      _changeData();
                                      AddEditEventTypes.isValueUpdate = true;

                                      _store.dispatch(UpdateTimezon(value!));

                                      // _store.dispatch(
                                      //     UpdateErrorMinimumleaseduration(false));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 30.0),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                GlobleString.ET_Time_Zone_Display,
                                style: MyStyles.Medium(16, myColor.black),
                                textAlign: TextAlign.start,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 25,
                                    width: 25,
                                    color: myColor.pf_incudevalue,
                                    alignment: Alignment.center,
                                    child: Radio(
                                      value: 0,
                                      //autofocus: Index == 0 ? true :false,
                                      groupValue: eventtypesState.displaytz,
                                      activeColor: myColor.Circle_main,
                                      onChanged: (value) {
                                        _store.dispatch(UpdateDisplaytz(0));
                                        /*AddEditProperty.isValueUpdate = true;
                                            widget._callbackradio(Index, value.toString());
                                            widget.listdata[Index].value = value.toString();
                                            _store.dispatch(UpdatePropertyAmenitiesList(widget.listdata));*/
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  const Text(GlobleString.ET_TZ_Auto),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Container(
                                    height: 25,
                                    width: 25,
                                    color: myColor.pf_incudevalue,
                                    alignment: Alignment.center,
                                    child: Radio(
                                      value: 1,
                                      //autofocus: Index == 0 ? true :false,
                                      groupValue: eventtypesState.displaytz,
                                      activeColor: myColor.Circle_main,
                                      onChanged: (value) {
                                        _store.dispatch(UpdateDisplaytz(1));
                                        /*AddEditProperty.isValueUpdate = true;
                                            widget._callbackradio(Index, value.toString());
                                            widget.listdata[Index].value = value.toString();
                                            _store.dispatch(UpdatePropertyAmenitiesList(widget.listdata));*/
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  const Text(GlobleString.ET_TZ_Lock),
                                ],
                              ),
                            ],
                          )),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      const Divider(),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Container(
                              width: sswidth * 0.6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10.0),
                                  Text(GlobleString.ET_Your_Weekly,
                                      style: MyStyles.Bold(
                                          18, myColor.Circle_main)),
                                  const SizedBox(height: 20.0),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        activeColor: myColor.Circle_main,
                                        checkColor: myColor.white,
                                        value: eventtypesState
                                            .sun, //tfAdditionalReferenceState.isAutherize,
                                        onChanged: (value) {
                                          _store.dispatch(UpdateSun(value!));
                                          _changeData();
                                        },
                                      ),
                                      const SizedBox(width: 5.0),
                                      Container(
                                          padding:
                                              const EdgeInsets.only(top: 7.0),
                                          width: 50.0,
                                          child: Text(GlobleString.SUN,
                                              style: MyStyles.Bold(
                                                  16, myColor.Circle_main))),
                                      const SizedBox(width: 5.0),
                                      (eventtypesState.sun)
                                          ? Column(
                                              children: [
                                                for (int i = 0;
                                                    i <
                                                        eventtypesState
                                                            .sunh1.length;
                                                    i++)
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 130,
                                                            height: 34,
                                                            child:
                                                                DropdownSearch<
                                                                    String>(
                                                              key: UniqueKey(),
                                                              mode: Mode.MENU,
                                                              errorcolor: myColor
                                                                  .errorcolor,
                                                              isError:
                                                                  eventtypesState
                                                                      .error_minimumleaseduration,
                                                              focuscolor:
                                                                  myColor.blue,
                                                              focusWidth: 2,
                                                              popupBackgroundColor:
                                                                  myColor.white,
                                                              items: [
                                                                "01:00:00",
                                                                "02:00:00",
                                                                "03:00:00",
                                                                "04:00:00",
                                                                "05:00:00",
                                                                "06:00:00",
                                                                "07:00:00",
                                                                "08:00:00",
                                                                "09:00:00",
                                                                "10:00:00",
                                                                "11:00:00",
                                                                "12:00:00",
                                                                "13:00:00",
                                                                "14:00:00",
                                                                "15:00:00",
                                                                "16:00:00",
                                                                "17:00:00",
                                                                "18:00:00",
                                                                "19:00:00",
                                                                "20:00:00",
                                                                "21:00:00",
                                                                "22:00:00",
                                                                "23:00:00"
                                                              ],
                                                              textstyle: MyStyles
                                                                  .Medium(
                                                                      14,
                                                                      myColor
                                                                          .text_color),
                                                              hint: "Select",
                                                              showSearchBox:
                                                                  false,
                                                              selectedItem:
                                                                  eventtypesState
                                                                      .sunh1[i],
                                                              isFilteredOnline:
                                                                  true,
                                                              onChanged:
                                                                  (value) {
                                                                eventtypesState
                                                                        .sunh1[
                                                                    i] = value!;
                                                                _changeData();
                                                                AddEditEventTypes
                                                                        .isValueUpdate =
                                                                    true;

                                                                _store.dispatch(
                                                                    Updatsunh1(
                                                                        eventtypesState
                                                                            .sunh1));

                                                                // _store.dispatch(
                                                                //     UpdateErrorMinimumleaseduration(false));
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 4.0),
                                                          Icon(Icons.remove),
                                                          const SizedBox(
                                                              width: 4.0),
                                                          Container(
                                                            width: 130,
                                                            height: 34,
                                                            child:
                                                                DropdownSearch<
                                                                    String>(
                                                              key: UniqueKey(),
                                                              mode: Mode.MENU,
                                                              errorcolor: myColor
                                                                  .errorcolor,
                                                              isError:
                                                                  eventtypesState
                                                                      .error_minimumleaseduration,
                                                              focuscolor:
                                                                  myColor.blue,
                                                              focusWidth: 2,
                                                              popupBackgroundColor:
                                                                  myColor.white,
                                                              items: [
                                                                "01:00:00",
                                                                "02:00:00",
                                                                "03:00:00",
                                                                "04:00:00",
                                                                "05:00:00",
                                                                "06:00:00",
                                                                "07:00:00",
                                                                "08:00:00",
                                                                "09:00:00",
                                                                "10:00:00",
                                                                "11:00:00",
                                                                "12:00:00",
                                                                "13:00:00",
                                                                "14:00:00",
                                                                "15:00:00",
                                                                "16:00:00",
                                                                "17:00:00",
                                                                "18:00:00",
                                                                "19:00:00",
                                                                "20:00:00",
                                                                "21:00:00",
                                                                "22:00:00",
                                                                "23:00:00"
                                                              ],
                                                              textstyle: MyStyles
                                                                  .Medium(
                                                                      14,
                                                                      myColor
                                                                          .text_color),
                                                              hint: "Select",
                                                              showSearchBox:
                                                                  false,
                                                              selectedItem:
                                                                  eventtypesState
                                                                      .sunh2[i],
                                                              isFilteredOnline:
                                                                  true,
                                                              onChanged:
                                                                  (value) {
                                                                eventtypesState
                                                                        .sunh2[
                                                                    i] = value!;
                                                                _changeData();
                                                                AddEditEventTypes
                                                                        .isValueUpdate =
                                                                    true;

                                                                _store.dispatch(
                                                                    Updatsunh2(
                                                                        eventtypesState
                                                                            .sunh2));

                                                                // _store.dispatch(
                                                                //     UpdateErrorMinimumleaseduration(false));
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 10.0),
                                                          if (eventtypesState
                                                                  .sunh1
                                                                  .length >
                                                              1)
                                                            GestureDetector(
                                                              onTap: () {
                                                                eventtypesState
                                                                    .sunh1
                                                                    .removeAt(
                                                                        i);
                                                                eventtypesState
                                                                    .sunh2
                                                                    .removeAt(
                                                                        i);
                                                                _store.dispatch(
                                                                    Updatsunh1(
                                                                        eventtypesState
                                                                            .sunh1));
                                                                _store.dispatch(
                                                                    Updatsunh2(
                                                                        eventtypesState
                                                                            .sunh2));
                                                              },
                                                              child: Icon(Icons
                                                                  .delete_outline),
                                                            ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 5.0),
                                                    ],
                                                  ),
                                              ],
                                            )
                                          : Container(
                                              padding: const EdgeInsets.only(
                                                  top: 7.0),
                                              child: Text(
                                                  GlobleString.Unavailable,
                                                  style: MyStyles.Light(
                                                      16, myColor.TA_Border)),
                                            ),
                                      Expanded(child: Container()),
                                      GestureDetector(
                                          child: Icon(Icons.add),
                                          onTap: () {
                                            eventtypesState.sunh1.add("");
                                            eventtypesState.sunh2.add("");
                                            _store.dispatch(Updatsunh1(
                                                eventtypesState.sunh1));
                                            _store.dispatch(Updatsunh2(
                                                eventtypesState.sunh2));
                                          }),
                                      const SizedBox(width: 10.0),
                                      Icon(Icons.copy),
                                      const SizedBox(width: 15.0),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Divider(),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        activeColor: myColor.Circle_main,
                                        checkColor: myColor.white,
                                        value: eventtypesState
                                            .mon, //tfAdditionalReferenceState.isAutherize,
                                        onChanged: (value) {
                                          _store.dispatch(UpdateMon(value!));
                                          _changeData();
                                        },
                                      ),
                                      const SizedBox(width: 5.0),
                                      Container(
                                          padding:
                                              const EdgeInsets.only(top: 7.0),
                                          width: 50.0,
                                          child: Text(GlobleString.MON,
                                              style: MyStyles.Bold(
                                                  16, myColor.Circle_main))),
                                      const SizedBox(width: 5.0),
                                      (eventtypesState.mon)
                                          ? Column(
                                              children: [
                                                for (int i = 0;
                                                    i <
                                                        eventtypesState
                                                            .monh1.length;
                                                    i++)
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 130,
                                                            height: 34,
                                                            child:
                                                                DropdownSearch<
                                                                    String>(
                                                              key: UniqueKey(),
                                                              mode: Mode.MENU,
                                                              errorcolor: myColor
                                                                  .errorcolor,
                                                              isError:
                                                                  eventtypesState
                                                                      .error_minimumleaseduration,
                                                              focuscolor:
                                                                  myColor.blue,
                                                              focusWidth: 2,
                                                              popupBackgroundColor:
                                                                  myColor.white,
                                                              items: [
                                                                "01:00:00",
                                                                "02:00:00",
                                                                "03:00:00",
                                                                "04:00:00",
                                                                "05:00:00",
                                                                "06:00:00",
                                                                "07:00:00",
                                                                "08:00:00",
                                                                "09:00:00",
                                                                "10:00:00",
                                                                "11:00:00",
                                                                "12:00:00",
                                                                "13:00:00",
                                                                "14:00:00",
                                                                "15:00:00",
                                                                "16:00:00",
                                                                "17:00:00",
                                                                "18:00:00",
                                                                "19:00:00",
                                                                "20:00:00",
                                                                "21:00:00",
                                                                "22:00:00",
                                                                "23:00:00"
                                                              ],
                                                              textstyle: MyStyles
                                                                  .Medium(
                                                                      14,
                                                                      myColor
                                                                          .text_color),
                                                              hint: "Select",
                                                              showSearchBox:
                                                                  false,
                                                              selectedItem:
                                                                  eventtypesState
                                                                      .monh1[i],
                                                              isFilteredOnline:
                                                                  true,
                                                              onChanged:
                                                                  (value) {
                                                                eventtypesState
                                                                        .monh1[
                                                                    i] = value!;
                                                                _changeData();
                                                                AddEditEventTypes
                                                                        .isValueUpdate =
                                                                    true;

                                                                _store.dispatch(
                                                                    Updatmonh1(
                                                                        eventtypesState
                                                                            .monh1));

                                                                // _store.dispatch(
                                                                //     UpdateErrorMinimumleaseduration(false));
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 4.0),
                                                          Icon(Icons.remove),
                                                          const SizedBox(
                                                              width: 4.0),
                                                          Container(
                                                            width: 130,
                                                            height: 34,
                                                            child:
                                                                DropdownSearch<
                                                                    String>(
                                                              key: UniqueKey(),
                                                              mode: Mode.MENU,
                                                              errorcolor: myColor
                                                                  .errorcolor,
                                                              isError:
                                                                  eventtypesState
                                                                      .error_minimumleaseduration,
                                                              focuscolor:
                                                                  myColor.blue,
                                                              focusWidth: 2,
                                                              popupBackgroundColor:
                                                                  myColor.white,
                                                              items: [
                                                                "01:00:00",
                                                                "02:00:00",
                                                                "03:00:00",
                                                                "04:00:00",
                                                                "05:00:00",
                                                                "06:00:00",
                                                                "07:00:00",
                                                                "08:00:00",
                                                                "09:00:00",
                                                                "10:00:00",
                                                                "11:00:00",
                                                                "12:00:00",
                                                                "13:00:00",
                                                                "14:00:00",
                                                                "15:00:00",
                                                                "16:00:00",
                                                                "17:00:00",
                                                                "18:00:00",
                                                                "19:00:00",
                                                                "20:00:00",
                                                                "21:00:00",
                                                                "22:00:00",
                                                                "23:00:00"
                                                              ],
                                                              textstyle: MyStyles
                                                                  .Medium(
                                                                      14,
                                                                      myColor
                                                                          .text_color),
                                                              hint: "Select",
                                                              showSearchBox:
                                                                  false,
                                                              selectedItem:
                                                                  eventtypesState
                                                                      .monh2[i],
                                                              isFilteredOnline:
                                                                  true,
                                                              onChanged:
                                                                  (value) {
                                                                eventtypesState
                                                                        .monh2[
                                                                    i] = value!;
                                                                _changeData();
                                                                AddEditEventTypes
                                                                        .isValueUpdate =
                                                                    true;

                                                                _store.dispatch(
                                                                    Updatmonh2(
                                                                        eventtypesState
                                                                            .monh2));

                                                                // _store.dispatch(
                                                                //     UpdateErrorMinimumleaseduration(false));
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 10.0),
                                                          if (eventtypesState
                                                                  .monh1
                                                                  .length >
                                                              1)
                                                            GestureDetector(
                                                              onTap: () {
                                                                eventtypesState
                                                                    .monh1
                                                                    .removeAt(
                                                                        i);
                                                                eventtypesState
                                                                    .monh2
                                                                    .removeAt(
                                                                        i);
                                                                _store.dispatch(
                                                                    Updatmonh1(
                                                                        eventtypesState
                                                                            .monh1));
                                                                _store.dispatch(
                                                                    Updatmonh2(
                                                                        eventtypesState
                                                                            .monh2));
                                                              },
                                                              child: Icon(Icons
                                                                  .delete_outline),
                                                            ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 5.0),
                                                    ],
                                                  ),
                                              ],
                                            )
                                          : Container(
                                              padding: const EdgeInsets.only(
                                                  top: 7.0),
                                              child: Text(
                                                  GlobleString.Unavailable,
                                                  style: MyStyles.Light(
                                                      16, myColor.TA_Border)),
                                            ),
                                      Expanded(child: Container()),
                                      GestureDetector(
                                          child: Icon(Icons.add),
                                          onTap: () {
                                            eventtypesState.monh1.add("");
                                            eventtypesState.monh2.add("");
                                            _store.dispatch(Updatmonh1(
                                                eventtypesState.monh1));
                                            _store.dispatch(Updatmonh2(
                                                eventtypesState.monh2));
                                          }),
                                      const SizedBox(width: 10.0),
                                      Icon(Icons.copy),
                                      const SizedBox(width: 15.0),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Divider(),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        activeColor: myColor.Circle_main,
                                        checkColor: myColor.white,
                                        value: eventtypesState
                                            .tue, //tfAdditionalReferenceState.isAutherize,
                                        onChanged: (value) {
                                          _store.dispatch(Updatetue(value!));
                                          _changeData();
                                        },
                                      ),
                                      const SizedBox(width: 5.0),
                                      Container(
                                          padding:
                                              const EdgeInsets.only(top: 7.0),
                                          width: 50.0,
                                          child: Text(GlobleString.TUE,
                                              style: MyStyles.Bold(
                                                  16, myColor.Circle_main))),
                                      const SizedBox(width: 5.0),
                                      (eventtypesState.tue)
                                          ? Column(
                                              children: [
                                                for (int i = 0;
                                                    i <
                                                        eventtypesState
                                                            .tueh1.length;
                                                    i++)
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 130,
                                                            height: 34,
                                                            child:
                                                                DropdownSearch<
                                                                    String>(
                                                              key: UniqueKey(),
                                                              mode: Mode.MENU,
                                                              errorcolor: myColor
                                                                  .errorcolor,
                                                              isError:
                                                                  eventtypesState
                                                                      .error_minimumleaseduration,
                                                              focuscolor:
                                                                  myColor.blue,
                                                              focusWidth: 2,
                                                              popupBackgroundColor:
                                                                  myColor.white,
                                                              items: [
                                                                "01:00:00",
                                                                "02:00:00",
                                                                "03:00:00",
                                                                "04:00:00",
                                                                "05:00:00",
                                                                "06:00:00",
                                                                "07:00:00",
                                                                "08:00:00",
                                                                "09:00:00",
                                                                "10:00:00",
                                                                "11:00:00",
                                                                "12:00:00",
                                                                "13:00:00",
                                                                "14:00:00",
                                                                "15:00:00",
                                                                "16:00:00",
                                                                "17:00:00",
                                                                "18:00:00",
                                                                "19:00:00",
                                                                "20:00:00",
                                                                "21:00:00",
                                                                "22:00:00",
                                                                "23:00:00"
                                                              ],
                                                              textstyle: MyStyles
                                                                  .Medium(
                                                                      14,
                                                                      myColor
                                                                          .text_color),
                                                              hint: "Select",
                                                              showSearchBox:
                                                                  false,
                                                              selectedItem:
                                                                  eventtypesState
                                                                      .tueh1[i],
                                                              isFilteredOnline:
                                                                  true,
                                                              onChanged:
                                                                  (value) {
                                                                eventtypesState
                                                                        .tueh1[
                                                                    i] = value!;
                                                                _changeData();
                                                                AddEditEventTypes
                                                                        .isValueUpdate =
                                                                    true;

                                                                _store.dispatch(
                                                                    Updattueh1(
                                                                        eventtypesState
                                                                            .tueh1));

                                                                // _store.dispatch(
                                                                //     UpdateErrorMinimumleaseduration(false));
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 4.0),
                                                          Icon(Icons.remove),
                                                          const SizedBox(
                                                              width: 4.0),
                                                          Container(
                                                            width: 130,
                                                            height: 34,
                                                            child:
                                                                DropdownSearch<
                                                                    String>(
                                                              key: UniqueKey(),
                                                              mode: Mode.MENU,
                                                              errorcolor: myColor
                                                                  .errorcolor,
                                                              isError:
                                                                  eventtypesState
                                                                      .error_minimumleaseduration,
                                                              focuscolor:
                                                                  myColor.blue,
                                                              focusWidth: 2,
                                                              popupBackgroundColor:
                                                                  myColor.white,
                                                              items: [
                                                                "01:00:00",
                                                                "02:00:00",
                                                                "03:00:00",
                                                                "04:00:00",
                                                                "05:00:00",
                                                                "06:00:00",
                                                                "07:00:00",
                                                                "08:00:00",
                                                                "09:00:00",
                                                                "10:00:00",
                                                                "11:00:00",
                                                                "12:00:00",
                                                                "13:00:00",
                                                                "14:00:00",
                                                                "15:00:00",
                                                                "16:00:00",
                                                                "17:00:00",
                                                                "18:00:00",
                                                                "19:00:00",
                                                                "20:00:00",
                                                                "21:00:00",
                                                                "22:00:00",
                                                                "23:00:00"
                                                              ],
                                                              textstyle: MyStyles
                                                                  .Medium(
                                                                      14,
                                                                      myColor
                                                                          .text_color),
                                                              hint: "Select",
                                                              showSearchBox:
                                                                  false,
                                                              selectedItem:
                                                                  eventtypesState
                                                                      .tueh2[i],
                                                              isFilteredOnline:
                                                                  true,
                                                              onChanged:
                                                                  (value) {
                                                                eventtypesState
                                                                        .tueh2[
                                                                    i] = value!;
                                                                _changeData();
                                                                AddEditEventTypes
                                                                        .isValueUpdate =
                                                                    true;

                                                                _store.dispatch(
                                                                    Updattueh2(
                                                                        eventtypesState
                                                                            .tueh2));

                                                                // _store.dispatch(
                                                                //     UpdateErrorMinimumleaseduration(false));
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 10.0),
                                                          if (eventtypesState
                                                                  .tueh1
                                                                  .length >
                                                              1)
                                                            GestureDetector(
                                                              onTap: () {
                                                                eventtypesState
                                                                    .tueh1
                                                                    .removeAt(
                                                                        i);
                                                                eventtypesState
                                                                    .tueh2
                                                                    .removeAt(
                                                                        i);
                                                                _store.dispatch(
                                                                    Updattueh1(
                                                                        eventtypesState
                                                                            .tueh1));
                                                                _store.dispatch(
                                                                    Updattueh2(
                                                                        eventtypesState
                                                                            .tueh2));
                                                              },
                                                              child: Icon(Icons
                                                                  .delete_outline),
                                                            ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 5.0),
                                                    ],
                                                  ),
                                              ],
                                            )
                                          : Container(
                                              padding: const EdgeInsets.only(
                                                  top: 7.0),
                                              child: Text(
                                                  GlobleString.Unavailable,
                                                  style: MyStyles.Light(
                                                      16, myColor.TA_Border)),
                                            ),
                                      Expanded(child: Container()),
                                      GestureDetector(
                                          child: Icon(Icons.add),
                                          onTap: () {
                                            eventtypesState.tueh1.add("");
                                            eventtypesState.tueh2.add("");
                                            _store.dispatch(Updattueh1(
                                                eventtypesState.tueh1));
                                            _store.dispatch(Updattueh2(
                                                eventtypesState.tueh2));
                                          }),
                                      const SizedBox(width: 10.0),
                                      Icon(Icons.copy),
                                      const SizedBox(width: 15.0),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Divider(),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        activeColor: myColor.Circle_main,
                                        checkColor: myColor.white,
                                        value: eventtypesState
                                            .wed, //tfAdditionalReferenceState.isAutherize,
                                        onChanged: (value) {
                                          _store.dispatch(Updatewed(value!));
                                          _changeData();
                                        },
                                      ),
                                      const SizedBox(width: 5.0),
                                      Container(
                                          padding:
                                              const EdgeInsets.only(top: 7.0),
                                          width: 50.0,
                                          child: Text(GlobleString.WED,
                                              style: MyStyles.Bold(
                                                  16, myColor.Circle_main))),
                                      const SizedBox(width: 5.0),
                                      (eventtypesState.wed)
                                          ? Column(
                                              children: [
                                                for (int i = 0;
                                                    i <
                                                        eventtypesState
                                                            .wedh1.length;
                                                    i++)
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 130,
                                                            height: 34,
                                                            child:
                                                                DropdownSearch<
                                                                    String>(
                                                              key: UniqueKey(),
                                                              mode: Mode.MENU,
                                                              errorcolor: myColor
                                                                  .errorcolor,
                                                              isError:
                                                                  eventtypesState
                                                                      .error_minimumleaseduration,
                                                              focuscolor:
                                                                  myColor.blue,
                                                              focusWidth: 2,
                                                              popupBackgroundColor:
                                                                  myColor.white,
                                                              items: [
                                                                "01:00:00",
                                                                "02:00:00",
                                                                "03:00:00",
                                                                "04:00:00",
                                                                "05:00:00",
                                                                "06:00:00",
                                                                "07:00:00",
                                                                "08:00:00",
                                                                "09:00:00",
                                                                "10:00:00",
                                                                "11:00:00",
                                                                "12:00:00",
                                                                "13:00:00",
                                                                "14:00:00",
                                                                "15:00:00",
                                                                "16:00:00",
                                                                "17:00:00",
                                                                "18:00:00",
                                                                "19:00:00",
                                                                "20:00:00",
                                                                "21:00:00",
                                                                "22:00:00",
                                                                "23:00:00"
                                                              ],
                                                              textstyle: MyStyles
                                                                  .Medium(
                                                                      14,
                                                                      myColor
                                                                          .text_color),
                                                              hint: "Select",
                                                              showSearchBox:
                                                                  false,
                                                              selectedItem:
                                                                  eventtypesState
                                                                      .wedh1[i],
                                                              isFilteredOnline:
                                                                  true,
                                                              onChanged:
                                                                  (value) {
                                                                eventtypesState
                                                                        .wedh1[
                                                                    i] = value!;
                                                                _changeData();
                                                                AddEditEventTypes
                                                                        .isValueUpdate =
                                                                    true;

                                                                _store.dispatch(
                                                                    Updatwedh1(
                                                                        eventtypesState
                                                                            .wedh1));

                                                                // _store.dispatch(
                                                                //     UpdateErrorMinimumleaseduration(false));
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 4.0),
                                                          Icon(Icons.remove),
                                                          const SizedBox(
                                                              width: 4.0),
                                                          Container(
                                                            width: 130,
                                                            height: 34,
                                                            child:
                                                                DropdownSearch<
                                                                    String>(
                                                              key: UniqueKey(),
                                                              mode: Mode.MENU,
                                                              errorcolor: myColor
                                                                  .errorcolor,
                                                              isError:
                                                                  eventtypesState
                                                                      .error_minimumleaseduration,
                                                              focuscolor:
                                                                  myColor.blue,
                                                              focusWidth: 2,
                                                              popupBackgroundColor:
                                                                  myColor.white,
                                                              items: [
                                                                "01:00:00",
                                                                "02:00:00",
                                                                "03:00:00",
                                                                "04:00:00",
                                                                "05:00:00",
                                                                "06:00:00",
                                                                "07:00:00",
                                                                "08:00:00",
                                                                "09:00:00",
                                                                "10:00:00",
                                                                "11:00:00",
                                                                "12:00:00",
                                                                "13:00:00",
                                                                "14:00:00",
                                                                "15:00:00",
                                                                "16:00:00",
                                                                "17:00:00",
                                                                "18:00:00",
                                                                "19:00:00",
                                                                "20:00:00",
                                                                "21:00:00",
                                                                "22:00:00",
                                                                "23:00:00"
                                                              ],
                                                              textstyle: MyStyles
                                                                  .Medium(
                                                                      14,
                                                                      myColor
                                                                          .text_color),
                                                              hint: "Select",
                                                              showSearchBox:
                                                                  false,
                                                              selectedItem:
                                                                  eventtypesState
                                                                      .wedh2[i],
                                                              isFilteredOnline:
                                                                  true,
                                                              onChanged:
                                                                  (value) {
                                                                eventtypesState
                                                                        .wedh2[
                                                                    i] = value!;
                                                                _changeData();
                                                                AddEditEventTypes
                                                                        .isValueUpdate =
                                                                    true;

                                                                _store.dispatch(
                                                                    Updatwedh2(
                                                                        eventtypesState
                                                                            .wedh2));

                                                                // _store.dispatch(
                                                                //     UpdateErrorMinimumleaseduration(false));
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 10.0),
                                                          if (eventtypesState
                                                                  .wedh1
                                                                  .length >
                                                              1)
                                                            GestureDetector(
                                                              onTap: () {
                                                                eventtypesState
                                                                    .wedh1
                                                                    .removeAt(
                                                                        i);
                                                                eventtypesState
                                                                    .wedh2
                                                                    .removeAt(
                                                                        i);
                                                                _store.dispatch(
                                                                    Updatwedh1(
                                                                        eventtypesState
                                                                            .wedh1));
                                                                _store.dispatch(
                                                                    Updatwedh2(
                                                                        eventtypesState
                                                                            .wedh2));
                                                              },
                                                              child: Icon(Icons
                                                                  .delete_outline),
                                                            ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 5.0),
                                                    ],
                                                  ),
                                              ],
                                            )
                                          : Container(
                                              padding: const EdgeInsets.only(
                                                  top: 7.0),
                                              child: Text(
                                                  GlobleString.Unavailable,
                                                  style: MyStyles.Light(
                                                      16, myColor.TA_Border)),
                                            ),
                                      Expanded(child: Container()),
                                      GestureDetector(
                                          child: Icon(Icons.add),
                                          onTap: () {
                                            eventtypesState.wedh1.add("");
                                            eventtypesState.wedh2.add("");
                                            _store.dispatch(Updatwedh1(
                                                eventtypesState.wedh1));
                                            _store.dispatch(Updatwedh2(
                                                eventtypesState.wedh2));
                                          }),
                                      const SizedBox(width: 10.0),
                                      Icon(Icons.copy),
                                      const SizedBox(width: 15.0),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Divider(),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        activeColor: myColor.Circle_main,
                                        checkColor: myColor.white,
                                        value: eventtypesState
                                            .thu, //tfAdditionalReferenceState.isAutherize,
                                        onChanged: (value) {
                                          _store.dispatch(Updatethu(value!));
                                          _changeData();
                                        },
                                      ),
                                      const SizedBox(width: 5.0),
                                      Container(
                                          padding:
                                              const EdgeInsets.only(top: 7.0),
                                          width: 50.0,
                                          child: Text(GlobleString.THU,
                                              style: MyStyles.Bold(
                                                  16, myColor.Circle_main))),
                                      const SizedBox(width: 5.0),
                                      (eventtypesState.thu)
                                          ? Column(
                                              children: [
                                                for (int i = 0;
                                                    i <
                                                        eventtypesState
                                                            .thuh1.length;
                                                    i++)
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 130,
                                                            height: 34,
                                                            child:
                                                                DropdownSearch<
                                                                    String>(
                                                              key: UniqueKey(),
                                                              mode: Mode.MENU,
                                                              errorcolor: myColor
                                                                  .errorcolor,
                                                              isError:
                                                                  eventtypesState
                                                                      .error_minimumleaseduration,
                                                              focuscolor:
                                                                  myColor.blue,
                                                              focusWidth: 2,
                                                              popupBackgroundColor:
                                                                  myColor.white,
                                                              items: [
                                                                "01:00:00",
                                                                "02:00:00",
                                                                "03:00:00",
                                                                "04:00:00",
                                                                "05:00:00",
                                                                "06:00:00",
                                                                "07:00:00",
                                                                "08:00:00",
                                                                "09:00:00",
                                                                "10:00:00",
                                                                "11:00:00",
                                                                "12:00:00",
                                                                "13:00:00",
                                                                "14:00:00",
                                                                "15:00:00",
                                                                "16:00:00",
                                                                "17:00:00",
                                                                "18:00:00",
                                                                "19:00:00",
                                                                "20:00:00",
                                                                "21:00:00",
                                                                "22:00:00",
                                                                "23:00:00"
                                                              ],
                                                              textstyle: MyStyles
                                                                  .Medium(
                                                                      14,
                                                                      myColor
                                                                          .text_color),
                                                              hint: "Select",
                                                              showSearchBox:
                                                                  false,
                                                              selectedItem:
                                                                  eventtypesState
                                                                      .thuh1[i],
                                                              isFilteredOnline:
                                                                  true,
                                                              onChanged:
                                                                  (value) {
                                                                eventtypesState
                                                                        .thuh1[
                                                                    i] = value!;
                                                                _changeData();
                                                                AddEditEventTypes
                                                                        .isValueUpdate =
                                                                    true;

                                                                _store.dispatch(
                                                                    Updatthuh1(
                                                                        eventtypesState
                                                                            .thuh1));

                                                                // _store.dispatch(
                                                                //     UpdateErrorMinimumleaseduration(false));
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 4.0),
                                                          Icon(Icons.remove),
                                                          const SizedBox(
                                                              width: 4.0),
                                                          Container(
                                                            width: 130,
                                                            height: 34,
                                                            child:
                                                                DropdownSearch<
                                                                    String>(
                                                              key: UniqueKey(),
                                                              mode: Mode.MENU,
                                                              errorcolor: myColor
                                                                  .errorcolor,
                                                              isError:
                                                                  eventtypesState
                                                                      .error_minimumleaseduration,
                                                              focuscolor:
                                                                  myColor.blue,
                                                              focusWidth: 2,
                                                              popupBackgroundColor:
                                                                  myColor.white,
                                                              items: [
                                                                "01:00:00",
                                                                "02:00:00",
                                                                "03:00:00",
                                                                "04:00:00",
                                                                "05:00:00",
                                                                "06:00:00",
                                                                "07:00:00",
                                                                "08:00:00",
                                                                "09:00:00",
                                                                "10:00:00",
                                                                "11:00:00",
                                                                "12:00:00",
                                                                "13:00:00",
                                                                "14:00:00",
                                                                "15:00:00",
                                                                "16:00:00",
                                                                "17:00:00",
                                                                "18:00:00",
                                                                "19:00:00",
                                                                "20:00:00",
                                                                "21:00:00",
                                                                "22:00:00",
                                                                "23:00:00"
                                                              ],
                                                              textstyle: MyStyles
                                                                  .Medium(
                                                                      14,
                                                                      myColor
                                                                          .text_color),
                                                              hint: "Select",
                                                              showSearchBox:
                                                                  false,
                                                              selectedItem:
                                                                  eventtypesState
                                                                      .thuh2[i],
                                                              isFilteredOnline:
                                                                  true,
                                                              onChanged:
                                                                  (value) {
                                                                eventtypesState
                                                                        .thuh2[
                                                                    i] = value!;
                                                                _changeData();
                                                                AddEditEventTypes
                                                                        .isValueUpdate =
                                                                    true;

                                                                _store.dispatch(
                                                                    Updatthuh2(
                                                                        eventtypesState
                                                                            .thuh2));

                                                                // _store.dispatch(
                                                                //     UpdateErrorMinimumleaseduration(false));
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 10.0),
                                                          if (eventtypesState
                                                                  .thuh1
                                                                  .length >
                                                              1)
                                                            GestureDetector(
                                                              onTap: () {
                                                                eventtypesState
                                                                    .thuh1
                                                                    .removeAt(
                                                                        i);
                                                                eventtypesState
                                                                    .thuh2
                                                                    .removeAt(
                                                                        i);
                                                                _store.dispatch(
                                                                    Updatthuh1(
                                                                        eventtypesState
                                                                            .thuh1));
                                                                _store.dispatch(
                                                                    Updatthuh2(
                                                                        eventtypesState
                                                                            .thuh2));
                                                              },
                                                              child: Icon(Icons
                                                                  .delete_outline),
                                                            ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 5.0),
                                                    ],
                                                  ),
                                              ],
                                            )
                                          : Container(
                                              padding: const EdgeInsets.only(
                                                  top: 7.0),
                                              child: Text(
                                                  GlobleString.Unavailable,
                                                  style: MyStyles.Light(
                                                      16, myColor.TA_Border)),
                                            ),
                                      Expanded(child: Container()),
                                      GestureDetector(
                                          child: Icon(Icons.add),
                                          onTap: () {
                                            eventtypesState.thuh1.add("");
                                            eventtypesState.thuh2.add("");
                                            _store.dispatch(Updatthuh1(
                                                eventtypesState.thuh1));
                                            _store.dispatch(Updatthuh2(
                                                eventtypesState.thuh2));
                                          }),
                                      const SizedBox(width: 10.0),
                                      Icon(Icons.copy),
                                      const SizedBox(width: 15.0),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Divider(),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        activeColor: myColor.Circle_main,
                                        checkColor: myColor.white,
                                        value: eventtypesState
                                            .fri, //tfAdditionalReferenceState.isAutherize,
                                        onChanged: (value) {
                                          _store.dispatch(Updatefri(value!));
                                          _changeData();
                                        },
                                      ),
                                      const SizedBox(width: 5.0),
                                      Container(
                                          padding:
                                              const EdgeInsets.only(top: 7.0),
                                          width: 50.0,
                                          child: Text(GlobleString.FRI,
                                              style: MyStyles.Bold(
                                                  16, myColor.Circle_main))),
                                      const SizedBox(width: 5.0),
                                      (eventtypesState.fri)
                                          ? Column(
                                              children: [
                                                for (int i = 0;
                                                    i <
                                                        eventtypesState
                                                            .frih1.length;
                                                    i++)
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 130,
                                                            height: 34,
                                                            child:
                                                                DropdownSearch<
                                                                    String>(
                                                              key: UniqueKey(),
                                                              mode: Mode.MENU,
                                                              errorcolor: myColor
                                                                  .errorcolor,
                                                              isError:
                                                                  eventtypesState
                                                                      .error_minimumleaseduration,
                                                              focuscolor:
                                                                  myColor.blue,
                                                              focusWidth: 2,
                                                              popupBackgroundColor:
                                                                  myColor.white,
                                                              items: [
                                                                "01:00:00",
                                                                "02:00:00",
                                                                "03:00:00",
                                                                "04:00:00",
                                                                "05:00:00",
                                                                "06:00:00",
                                                                "07:00:00",
                                                                "08:00:00",
                                                                "09:00:00",
                                                                "10:00:00",
                                                                "11:00:00",
                                                                "12:00:00",
                                                                "13:00:00",
                                                                "14:00:00",
                                                                "15:00:00",
                                                                "16:00:00",
                                                                "17:00:00",
                                                                "18:00:00",
                                                                "19:00:00",
                                                                "20:00:00",
                                                                "21:00:00",
                                                                "22:00:00",
                                                                "23:00:00"
                                                              ],
                                                              textstyle: MyStyles
                                                                  .Medium(
                                                                      14,
                                                                      myColor
                                                                          .text_color),
                                                              hint: "Select",
                                                              showSearchBox:
                                                                  false,
                                                              selectedItem:
                                                                  eventtypesState
                                                                      .frih1[i],
                                                              isFilteredOnline:
                                                                  true,
                                                              onChanged:
                                                                  (value) {
                                                                eventtypesState
                                                                        .frih1[
                                                                    i] = value!;
                                                                _changeData();
                                                                AddEditEventTypes
                                                                        .isValueUpdate =
                                                                    true;

                                                                _store.dispatch(
                                                                    Updatfrih1(
                                                                        eventtypesState
                                                                            .frih1));

                                                                // _store.dispatch(
                                                                //     UpdateErrorMinimumleaseduration(false));
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 4.0),
                                                          Icon(Icons.remove),
                                                          const SizedBox(
                                                              width: 4.0),
                                                          Container(
                                                            width: 130,
                                                            height: 34,
                                                            child:
                                                                DropdownSearch<
                                                                    String>(
                                                              key: UniqueKey(),
                                                              mode: Mode.MENU,
                                                              errorcolor: myColor
                                                                  .errorcolor,
                                                              isError:
                                                                  eventtypesState
                                                                      .error_minimumleaseduration,
                                                              focuscolor:
                                                                  myColor.blue,
                                                              focusWidth: 2,
                                                              popupBackgroundColor:
                                                                  myColor.white,
                                                              items: [
                                                                "01:00:00",
                                                                "02:00:00",
                                                                "03:00:00",
                                                                "04:00:00",
                                                                "05:00:00",
                                                                "06:00:00",
                                                                "07:00:00",
                                                                "08:00:00",
                                                                "09:00:00",
                                                                "10:00:00",
                                                                "11:00:00",
                                                                "12:00:00",
                                                                "13:00:00",
                                                                "14:00:00",
                                                                "15:00:00",
                                                                "16:00:00",
                                                                "17:00:00",
                                                                "18:00:00",
                                                                "19:00:00",
                                                                "20:00:00",
                                                                "21:00:00",
                                                                "22:00:00",
                                                                "23:00:00"
                                                              ],
                                                              textstyle: MyStyles
                                                                  .Medium(
                                                                      14,
                                                                      myColor
                                                                          .text_color),
                                                              hint: "Select",
                                                              showSearchBox:
                                                                  false,
                                                              selectedItem:
                                                                  eventtypesState
                                                                      .frih2[i],
                                                              isFilteredOnline:
                                                                  true,
                                                              onChanged:
                                                                  (value) {
                                                                eventtypesState
                                                                        .frih2[
                                                                    i] = value!;
                                                                _changeData();
                                                                AddEditEventTypes
                                                                        .isValueUpdate =
                                                                    true;

                                                                _store.dispatch(
                                                                    Updatfrih2(
                                                                        eventtypesState
                                                                            .frih2));

                                                                // _store.dispatch(
                                                                //     UpdateErrorMinimumleaseduration(false));
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 10.0),
                                                          if (eventtypesState
                                                                  .frih1
                                                                  .length >
                                                              1)
                                                            GestureDetector(
                                                              onTap: () {
                                                                eventtypesState
                                                                    .frih1
                                                                    .removeAt(
                                                                        i);
                                                                eventtypesState
                                                                    .frih2
                                                                    .removeAt(
                                                                        i);
                                                                _store.dispatch(
                                                                    Updatfrih1(
                                                                        eventtypesState
                                                                            .frih1));
                                                                _store.dispatch(
                                                                    Updatfrih2(
                                                                        eventtypesState
                                                                            .frih2));
                                                              },
                                                              child: Icon(Icons
                                                                  .delete_outline),
                                                            ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 5.0),
                                                    ],
                                                  ),
                                              ],
                                            )
                                          : Container(
                                              padding: const EdgeInsets.only(
                                                  top: 7.0),
                                              child: Text(
                                                  GlobleString.Unavailable,
                                                  style: MyStyles.Light(
                                                      16, myColor.TA_Border)),
                                            ),
                                      Expanded(child: Container()),
                                      GestureDetector(
                                          child: Icon(Icons.add),
                                          onTap: () {
                                            eventtypesState.frih1.add("");
                                            eventtypesState.frih2.add("");
                                            _store.dispatch(Updatfrih1(
                                                eventtypesState.frih1));
                                            _store.dispatch(Updatfrih2(
                                                eventtypesState.frih2));
                                          }),
                                      const SizedBox(width: 10.0),
                                      Icon(Icons.copy),
                                      const SizedBox(width: 15.0),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Divider(),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        activeColor: myColor.Circle_main,
                                        checkColor: myColor.white,
                                        value: eventtypesState
                                            .sat, //tfAdditionalReferenceState.isAutherize,
                                        onChanged: (value) {
                                          _store.dispatch(Updatesat(value!));
                                          _changeData();
                                        },
                                      ),
                                      const SizedBox(width: 5.0),
                                      Container(
                                          padding:
                                              const EdgeInsets.only(top: 7.0),
                                          width: 50.0,
                                          child: Text(GlobleString.SAT,
                                              style: MyStyles.Bold(
                                                  16, myColor.Circle_main))),
                                      const SizedBox(width: 5.0),
                                      (eventtypesState.sat)
                                          ? Column(
                                              children: [
                                                for (int i = 0;
                                                    i <
                                                        eventtypesState
                                                            .sath1.length;
                                                    i++)
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 130,
                                                            height: 34,
                                                            child:
                                                                DropdownSearch<
                                                                    String>(
                                                              key: UniqueKey(),
                                                              mode: Mode.MENU,
                                                              errorcolor: myColor
                                                                  .errorcolor,
                                                              isError:
                                                                  eventtypesState
                                                                      .error_minimumleaseduration,
                                                              focuscolor:
                                                                  myColor.blue,
                                                              focusWidth: 2,
                                                              popupBackgroundColor:
                                                                  myColor.white,
                                                              items: [
                                                                "01:00:00",
                                                                "02:00:00",
                                                                "03:00:00",
                                                                "04:00:00",
                                                                "05:00:00",
                                                                "06:00:00",
                                                                "07:00:00",
                                                                "08:00:00",
                                                                "09:00:00",
                                                                "10:00:00",
                                                                "11:00:00",
                                                                "12:00:00",
                                                                "13:00:00",
                                                                "14:00:00",
                                                                "15:00:00",
                                                                "16:00:00",
                                                                "17:00:00",
                                                                "18:00:00",
                                                                "19:00:00",
                                                                "20:00:00",
                                                                "21:00:00",
                                                                "22:00:00",
                                                                "23:00:00"
                                                              ],
                                                              textstyle: MyStyles
                                                                  .Medium(
                                                                      14,
                                                                      myColor
                                                                          .text_color),
                                                              hint: "Select",
                                                              showSearchBox:
                                                                  false,
                                                              selectedItem:
                                                                  eventtypesState
                                                                      .sath1[i],
                                                              isFilteredOnline:
                                                                  true,
                                                              onChanged:
                                                                  (value) {
                                                                eventtypesState
                                                                        .sath1[
                                                                    i] = value!;
                                                                _changeData();
                                                                AddEditEventTypes
                                                                        .isValueUpdate =
                                                                    true;

                                                                _store.dispatch(
                                                                    Updatsath1(
                                                                        eventtypesState
                                                                            .sath1));

                                                                // _store.dispatch(
                                                                //     UpdateErrorMinimumleaseduration(false));
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 4.0),
                                                          Icon(Icons.remove),
                                                          const SizedBox(
                                                              width: 4.0),
                                                          Container(
                                                            width: 130,
                                                            height: 34,
                                                            child:
                                                                DropdownSearch<
                                                                    String>(
                                                              key: UniqueKey(),
                                                              mode: Mode.MENU,
                                                              errorcolor: myColor
                                                                  .errorcolor,
                                                              isError:
                                                                  eventtypesState
                                                                      .error_minimumleaseduration,
                                                              focuscolor:
                                                                  myColor.blue,
                                                              focusWidth: 2,
                                                              popupBackgroundColor:
                                                                  myColor.white,
                                                              items: [
                                                                "01:00:00",
                                                                "02:00:00",
                                                                "03:00:00",
                                                                "04:00:00",
                                                                "05:00:00",
                                                                "06:00:00",
                                                                "07:00:00",
                                                                "08:00:00",
                                                                "09:00:00",
                                                                "10:00:00",
                                                                "11:00:00",
                                                                "12:00:00",
                                                                "13:00:00",
                                                                "14:00:00",
                                                                "15:00:00",
                                                                "16:00:00",
                                                                "17:00:00",
                                                                "18:00:00",
                                                                "19:00:00",
                                                                "20:00:00",
                                                                "21:00:00",
                                                                "22:00:00",
                                                                "23:00:00"
                                                              ],
                                                              textstyle: MyStyles
                                                                  .Medium(
                                                                      14,
                                                                      myColor
                                                                          .text_color),
                                                              hint: "Select",
                                                              showSearchBox:
                                                                  false,
                                                              selectedItem:
                                                                  eventtypesState
                                                                      .sath2[i],
                                                              isFilteredOnline:
                                                                  true,
                                                              onChanged:
                                                                  (value) {
                                                                eventtypesState
                                                                        .sath2[
                                                                    i] = value!;
                                                                _changeData();
                                                                AddEditEventTypes
                                                                        .isValueUpdate =
                                                                    true;

                                                                _store.dispatch(
                                                                    Updatsath2(
                                                                        eventtypesState
                                                                            .sath2));

                                                                // _store.dispatch(
                                                                //     UpdateErrorMinimumleaseduration(false));
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 10.0),
                                                          if (eventtypesState
                                                                  .sath1
                                                                  .length >
                                                              1)
                                                            GestureDetector(
                                                              onTap: () {
                                                                eventtypesState
                                                                    .sath1
                                                                    .removeAt(
                                                                        i);
                                                                eventtypesState
                                                                    .sath2
                                                                    .removeAt(
                                                                        i);
                                                                _store.dispatch(
                                                                    Updatsath1(
                                                                        eventtypesState
                                                                            .sath1));
                                                                _store.dispatch(
                                                                    Updatsath2(
                                                                        eventtypesState
                                                                            .sath2));
                                                              },
                                                              child: Icon(Icons
                                                                  .delete_outline),
                                                            ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 5.0),
                                                    ],
                                                  ),
                                              ],
                                            )
                                          : Container(
                                              padding: const EdgeInsets.only(
                                                  top: 7.0),
                                              child: Text(
                                                  GlobleString.Unavailable,
                                                  style: MyStyles.Light(
                                                      16, myColor.TA_Border)),
                                            ),
                                      Expanded(child: Container()),
                                      GestureDetector(
                                          child: Icon(Icons.add),
                                          onTap: () {
                                            eventtypesState.sath1.add("");
                                            eventtypesState.sath2.add("");
                                            _store.dispatch(Updatsath1(
                                                eventtypesState.sath1));
                                            _store.dispatch(Updatsath2(
                                                eventtypesState.sath2));
                                          }),
                                      const SizedBox(width: 10.0),
                                      Icon(Icons.copy),
                                      const SizedBox(width: 15.0),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                ],
                              ),
                            ),
                            const VerticalDivider(),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10.0),
                                    Text(GlobleString.ET_Overrides,
                                        style: MyStyles.Bold(
                                            18, myColor.Circle_main)),
                                    const SizedBox(height: 10.0),
                                    Text(GlobleString.ET_Overrides_Txt),
                                    const SizedBox(height: 10.0),
                                    InkWell(
                                      onTap: () {},
                                      child: CustomeWidget.AddETOverride(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 20.0),
                      Text(
                        GlobleString.ET_Scheduling_Conditions,
                        style: MyStyles.Medium(14, myColor.black),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  GlobleString.ET_SC_Cant,
                                  style: MyStyles.Medium(
                                      14, myColor.CM_Lead_border),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(height: 10.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 32,
                                      child: TextFormField(
                                        initialValue:
                                            (eventtypesState.timescheduling ==
                                                    0)
                                                ? ''
                                                : eventtypesState.timescheduling
                                                    .toString(),
                                        textAlign: TextAlign.start,
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          MaskedInputFormatter("0000000000")
                                        ],
                                        decoration: InputDecoration(
                                            //border: InputBorder.none,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: eventtypesState
                                                          .error_minimumleasedurationnumber
                                                      ? myColor.errorcolor
                                                      : myColor.blue,
                                                  width: 2),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: eventtypesState
                                                          .error_minimumleasedurationnumber
                                                      ? myColor.errorcolor
                                                      : myColor.gray,
                                                  width: 1.0),
                                            ),
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(12),
                                            fillColor: myColor.white,
                                            filled: true),
                                        onChanged: (value) {
                                          _changeData();
                                          AddEditEventTypes.isValueUpdate =
                                              true;

                                          _store.dispatch(Updatetimescheduling(
                                              int.parse(value)));
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 5.0),
                                    Container(
                                      width: 150,
                                      height: 32,
                                      // ignore: missing_required_param
                                      child: DropdownSearch<String>(
                                        key: UniqueKey(),
                                        mode: Mode.MENU,
                                        errorcolor: myColor.errorcolor,
                                        isError: eventtypesState
                                            .error_minimumleaseduration,
                                        focuscolor: myColor.blue,
                                        focusWidth: 2,
                                        popupBackgroundColor: myColor.white,
                                        items: ["minutes", "hours"],
                                        defultHeight: 80,
                                        textstyle: MyStyles.Medium(
                                            14, myColor.text_color),
                                        hint: "Select",
                                        showSearchBox: false,
                                        selectedItem:
                                            eventtypesState.timeschedulingmed,
                                        isFilteredOnline: true,
                                        onChanged: (value) {
                                          _changeData();
                                          AddEditEventTypes.isValueUpdate =
                                              true;

                                          _store.dispatch(
                                              Updatetimeschedulingmed(value!));

                                          // _store.dispatch(
                                          //     UpdateErrorMinimumleaseduration(false));
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 5.0),
                                    Container(
                                        width: 180,
                                        height: 32,
                                        child: Text(
                                            GlobleString.ET_SC_Of_Start_Time)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                GlobleString.ET_SC_Max_Allowed,
                                style:
                                    MyStyles.Medium(14, myColor.CM_Lead_border),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 10.0),
                              Container(
                                width: 100,
                                height: 32,
                                child: TextFormField(
                                  initialValue: (eventtypesState.maximum == 0)
                                      ? ''
                                      : eventtypesState.maximum.toString(),
                                  textAlign: TextAlign.start,
                                  style:
                                      MyStyles.Regular(14, myColor.text_color),
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    MaskedInputFormatter("0000000000")
                                  ],
                                  decoration: InputDecoration(
                                      //border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: eventtypesState
                                                    .error_minimumleasedurationnumber
                                                ? myColor.errorcolor
                                                : myColor.blue,
                                            width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: eventtypesState
                                                    .error_minimumleasedurationnumber
                                                ? myColor.errorcolor
                                                : myColor.gray,
                                            width: 1.0),
                                      ),
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(12),
                                      fillColor: myColor.white,
                                      filled: true),
                                  onChanged: (value) {
                                    _changeData();
                                    AddEditEventTypes.isValueUpdate = true;

                                    _store.dispatch(
                                        Updatemaximum(int.parse(value)));
                                  },
                                ),
                              ),
                            ],
                          ))
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          back(),
                          const SizedBox(width: 10.0),
                          saveandnext(eventtypesState)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget RestrictionList(EventTypesState eventtypesState) {
    List<SystemEnumDetails> myrestrictionlist = eventtypesState.restrictionlist;

    return Container(
      width: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "GlobleString.PS2_EventTypes_restrictions",
            style: MyStyles.Medium(14, myColor.black),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: ListView.builder(
              //scrollDirection: Axis.vertical,
              key: UniqueKey(),
              itemCount: myrestrictionlist.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext ctxt, int Index) {
                SystemEnumDetails data = myrestrictionlist[Index];
                return Column(
                  key: UniqueKey(),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          activeColor: myColor.Circle_main,
                          checkColor: myColor.white,
                          value: data.ischeck,
                          onChanged: (value) {
                            _changeData();
                            data.ischeck = value;

                            myrestrictionlist[Index] = data;

                            _store.dispatch(UpdateRestrictionlist(
                                List.from(myrestrictionlist)));

                            //eventtypesState.restrictionlist[Index].ischeck = value;
                            //_store.dispatch(UpdateRestrictionlist(eventtypesState.restrictionlist));
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          data.displayValue,
                          style: MyStyles.Regular(14, myColor.text_color),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget back() {
    return InkWell(
      onTap: () {
        widget._callbackBack();
      },
      child: CustomeWidget.TenantBackButton(),
    );
  }

  Widget saveandnext(EventTypesState eventtypesState) {
    return InkWell(
      onTap: () {
        apiCallAndValication(eventtypesState);
        //widget._callbackSaveandNext();
      },
      child: CustomeWidget.SaveAndNext(GlobleString.Save_and_next),
    );
  }

  void apiCallAndValication(EventTypesState eventtypesState) {
    if (1 == 2) {
      _store.dispatch(UpdateErrorEventTypesBedrooms(true));
      ToastUtils.showCustomToast(
          context, "GlobleString.PS2_EventTypes_Bedrooms_error", false);
    } else {
      //sunday
      if (eventtypesState.sun) {
        EventTypesAvailability eventtypesAvailability =
            new EventTypesAvailability();
        eventtypesAvailability.event_type_id =
            int.parse(Prefs.getString(PrefsName.EventTypesID));
        eventtypesAvailability.weekday = 1;
        ApiManager().AddEventTypesAvailability(context, eventtypesAvailability,
            (error, responce) async {
          if (error) {
            for (int i = 0; i < eventtypesState.sunh1.length; i++) {
              EventTypesAvailabilityTime eventtypesAvailabilitytime =
                  new EventTypesAvailabilityTime();
              eventtypesAvailabilitytime.availability_id = int.parse(responce);
              eventtypesAvailabilitytime.start_time = eventtypesState.sunh1[i];
              eventtypesAvailabilitytime.end_time = eventtypesState.sunh2[i];
              ApiManager().AddEventTypesAvailabilityTime(
                  context, eventtypesAvailabilitytime, (error, responce) async {
                if (error) {
                } else {
                  // loader.remove();
                  ToastUtils.showCustomToast(context, responce, false);
                }
              });
            }
          } else {
            // loader.remove();
            ToastUtils.showCustomToast(context, responce, false);
          }
        });
      }
      //monday
      if (eventtypesState.mon) {
        EventTypesAvailability eventtypesAvailability2 =
            new EventTypesAvailability();
        eventtypesAvailability2.event_type_id =
            int.parse(Prefs.getString(PrefsName.EventTypesID));
        eventtypesAvailability2.weekday = 2;
        ApiManager().AddEventTypesAvailability(context, eventtypesAvailability2,
            (error, responce) async {
          if (error) {
            for (int i = 0; i < eventtypesState.monh1.length; i++) {
              EventTypesAvailabilityTime eventtypesAvailabilitytime =
                  new EventTypesAvailabilityTime();
              eventtypesAvailabilitytime.availability_id = int.parse(responce);
              eventtypesAvailabilitytime.start_time = eventtypesState.monh1[i];
              eventtypesAvailabilitytime.end_time = eventtypesState.monh2[i];
              ApiManager().AddEventTypesAvailabilityTime(
                  context, eventtypesAvailabilitytime, (error, responce) async {
                if (error) {
                } else {
                  // loader.remove();
                  ToastUtils.showCustomToast(context, responce, false);
                }
              });
            }
          } else {
            // loader.remove();
            ToastUtils.showCustomToast(context, responce, false);
          }
        });
      }

      //tuesday
      if (eventtypesState.tue) {
        EventTypesAvailability eventtypesAvailability2 =
            new EventTypesAvailability();
        eventtypesAvailability2.event_type_id =
            int.parse(Prefs.getString(PrefsName.EventTypesID));
        eventtypesAvailability2.weekday = 3;
        ApiManager().AddEventTypesAvailability(context, eventtypesAvailability2,
            (error, responce) async {
          if (error) {
            for (int i = 0; i < eventtypesState.tueh1.length; i++) {
              EventTypesAvailabilityTime eventtypesAvailabilitytime =
                  new EventTypesAvailabilityTime();
              eventtypesAvailabilitytime.availability_id = int.parse(responce);
              eventtypesAvailabilitytime.start_time = eventtypesState.tueh1[i];
              eventtypesAvailabilitytime.end_time = eventtypesState.tueh2[i];
              ApiManager().AddEventTypesAvailabilityTime(
                  context, eventtypesAvailabilitytime, (error, responce) async {
                if (error) {
                } else {
                  // loader.remove();
                  ToastUtils.showCustomToast(context, responce, false);
                }
              });
            }
          } else {
            // loader.remove();
            ToastUtils.showCustomToast(context, responce, false);
          }
        });
      }

//wetday
      if (eventtypesState.wed) {
        EventTypesAvailability eventtypesAvailability2 =
            new EventTypesAvailability();
        eventtypesAvailability2.event_type_id =
            int.parse(Prefs.getString(PrefsName.EventTypesID));
        eventtypesAvailability2.weekday = 4;
        ApiManager().AddEventTypesAvailability(context, eventtypesAvailability2,
            (error, responce) async {
          if (error) {
            for (int i = 0; i < eventtypesState.wedh1.length; i++) {
              EventTypesAvailabilityTime eventtypesAvailabilitytime =
                  new EventTypesAvailabilityTime();
              eventtypesAvailabilitytime.availability_id = int.parse(responce);
              eventtypesAvailabilitytime.start_time = eventtypesState.wedh1[i];
              eventtypesAvailabilitytime.end_time = eventtypesState.wedh2[i];
              ApiManager().AddEventTypesAvailabilityTime(
                  context, eventtypesAvailabilitytime, (error, responce) async {
                if (error) {
                } else {
                  // loader.remove();
                  ToastUtils.showCustomToast(context, responce, false);
                }
              });
            }
          } else {
            // loader.remove();
            ToastUtils.showCustomToast(context, responce, false);
          }
        });
      }

      //thuday
      if (eventtypesState.thu) {
        EventTypesAvailability eventtypesAvailability2 =
            new EventTypesAvailability();
        eventtypesAvailability2.event_type_id =
            int.parse(Prefs.getString(PrefsName.EventTypesID));
        eventtypesAvailability2.weekday = 5;
        ApiManager().AddEventTypesAvailability(context, eventtypesAvailability2,
            (error, responce) async {
          if (error) {
            for (int i = 0; i < eventtypesState.thuh1.length; i++) {
              EventTypesAvailabilityTime eventtypesAvailabilitytime =
                  new EventTypesAvailabilityTime();
              eventtypesAvailabilitytime.availability_id = int.parse(responce);
              eventtypesAvailabilitytime.start_time = eventtypesState.thuh1[i];
              eventtypesAvailabilitytime.end_time = eventtypesState.thuh2[i];
              ApiManager().AddEventTypesAvailabilityTime(
                  context, eventtypesAvailabilitytime, (error, responce) async {
                if (error) {
                } else {
                  // loader.remove();
                  ToastUtils.showCustomToast(context, responce, false);
                }
              });
            }
          } else {
            // loader.remove();
            ToastUtils.showCustomToast(context, responce, false);
          }
        });
      }

      //friday
      if (eventtypesState.fri) {
        EventTypesAvailability eventtypesAvailability2 =
            new EventTypesAvailability();
        eventtypesAvailability2.event_type_id =
            int.parse(Prefs.getString(PrefsName.EventTypesID));
        eventtypesAvailability2.weekday = 6;
        ApiManager().AddEventTypesAvailability(context, eventtypesAvailability2,
            (error, responce) async {
          if (error) {
            for (int i = 0; i < eventtypesState.frih1.length; i++) {
              EventTypesAvailabilityTime eventtypesAvailabilitytime =
                  new EventTypesAvailabilityTime();
              eventtypesAvailabilitytime.availability_id = int.parse(responce);
              eventtypesAvailabilitytime.start_time = eventtypesState.frih1[i];
              eventtypesAvailabilitytime.end_time = eventtypesState.frih2[i];
              ApiManager().AddEventTypesAvailabilityTime(
                  context, eventtypesAvailabilitytime, (error, responce) async {
                if (error) {
                } else {
                  // loader.remove();
                  ToastUtils.showCustomToast(context, responce, false);
                }
              });
            }
          } else {
            // loader.remove();
            ToastUtils.showCustomToast(context, responce, false);
          }
        });
      }

      //saturday
      if (eventtypesState.sat) {
        EventTypesAvailability eventtypesAvailability2 =
            new EventTypesAvailability();
        eventtypesAvailability2.event_type_id =
            int.parse(Prefs.getString(PrefsName.EventTypesID));
        eventtypesAvailability2.weekday = 7;
        ApiManager().AddEventTypesAvailability(context, eventtypesAvailability2,
            (error, responce) async {
          if (error) {
            for (int i = 0; i < eventtypesState.sath1.length; i++) {
              EventTypesAvailabilityTime eventtypesAvailabilitytime =
                  new EventTypesAvailabilityTime();
              eventtypesAvailabilitytime.availability_id = int.parse(responce);
              eventtypesAvailabilitytime.start_time = eventtypesState.sath1[i];
              eventtypesAvailabilitytime.end_time = eventtypesState.sath2[i];
              ApiManager().AddEventTypesAvailabilityTime(
                  context, eventtypesAvailabilitytime, (error, responce) async {
                if (error) {
                } else {
                  // loader.remove();
                  ToastUtils.showCustomToast(context, responce, false);
                }
              });
            }
          } else {
            // loader.remove();
            ToastUtils.showCustomToast(context, responce, false);
          }
        });
      }

      // for (int i = 0; i < eventtypesState.restrictionlist.length; i++) {
      //   if (eventtypesState.restrictionlist[i].ischeck!) {
      //     EventTypesRestriction eventtypesRestriction =
      //         new EventTypesRestriction();

      //     eventtypesRestriction.Prop_ID =
      //         Prefs.getString(PrefsName.EventTypesID);
      //     eventtypesRestriction.Restrictions =
      //         eventtypesState.restrictionlist[i].EnumDetailID.toString();

      //     availabilitylist.add(eventtypesRestriction);
      //   }
      // }

      // EventTypesSpecification eventtypesSpecification =
      //     new EventTypesSpecification();
      // eventtypesSpecification.Bedrooms =
      //     eventtypesState.EventTypesBedrooms.toString().trim();
      // eventtypesSpecification.Bathrooms =
      //     eventtypesState.EventTypesBathrooms.toString().trim();
      // eventtypesSpecification.Max_Occupancy =
      //     eventtypesState.EventTypesMaxoccupancy.toString().trim();
      // eventtypesSpecification.Furnishing =
      //     eventtypesState.furnishingValue!.EnumDetailID.toString().trim();
      // eventtypesSpecification.Size =
      //     eventtypesState.EventTypesSizeinsquarefeet.replaceAll(",", "")
      //         .toString()
      //         .trim();
      // eventtypesSpecification.Other_Partial_Furniture =
      //     eventtypesState.Other_Partial_Furniture.toString().trim();

      // EventTypesUpdate eventtypesUpdate = new EventTypesUpdate();
      // eventtypesUpdate.ID = Prefs.getString(PrefsName.EventTypesID);
      // eventtypesUpdate.Owner_ID = Prefs.getString(PrefsName.OwnerID);

      // if (eventtypesState.PropDrafting >= 1 &&
      //     eventtypesState.PropDrafting <= 2) {
      //   eventtypesSpecification.PropDrafting = 2;
      // } else {
      //   eventtypesSpecification.PropDrafting = eventtypesState.PropDrafting;
      // }

      // UpdateSummeryData(eventtypesState);

      // loader = Helper.overlayLoader(context);
      // Overlay.of(context)!.insert(loader);

      // PropID propID =
      //     new PropID(Prop_ID: Prefs.getString(PrefsName.EventTypesID));

      // ApiManager().deleteAllRestriction(context, propID,
      //     (error, respoce) async {
      //   if (error) {
      //     ApiManager().AddEventTypesSpecificatinRestriction(
      //         context,
      //         restrictionlist,
      //         eventtypesUpdate,
      //         eventtypesSpecification, (error, responce) async {
      //       if (error) {
      //         await Prefs.setBool(PrefsName.EventTypesStep2, true);
      //         loader.remove();
      //         _store.dispatch(UpdateEventTypesDrafting(
      //             eventtypesSpecification.PropDrafting!));
      //         _store.dispatch(UpdateSummeryEventTypesDrafting(
      //             eventtypesSpecification.PropDrafting!));

      //         ToastUtils.showCustomToast(
      //             context, "GlobleString.PS_Save_EventTypesse", true);

      //         if (!isGotoBack) {
      //           if (stepper == 0)
      //             widget._callbackSaveandNext();
      //           else
      //             _store.dispatch(UpdateEventTypesForm(stepper));
      //         } else {
      //           _store
      //               .dispatch(UpdatePortalPage(1, GlobleString.NAV_Properties));
      //         }
      //       } else {
      //         loader.remove();
      //         ToastUtils.showCustomToast(context, responce, false);
      //       }
      //     });
      //   } else {
      //     loader.remove();
      //     ToastUtils.showCustomToast(context, respoce, false);
      //     Helper.Log("respoce", respoce);
      //   }
      // });
    }
  }

  void UpdateSummeryData(EventTypesState eventtypesState) {
    _store.dispatch(
        UpdateSummeryEventTypesBedrooms(eventtypesState.EventTypesBedrooms));
    _store.dispatch(
        UpdateSummeryEventTypesBathrooms(eventtypesState.EventTypesBathrooms));
    _store.dispatch(UpdateSummeryEventTypesSizeinsquarefeet(
        eventtypesState.EventTypesSizeinsquarefeet));
    _store.dispatch(UpdateSummeryEventTypesMaxoccupancy(
        eventtypesState.EventTypesMaxoccupancy));
    _store.dispatch(
        UpdateSummeryFurnishingValue(eventtypesState.furnishingValue));
    _store.dispatch(UpdateSummeryOtherPartialFurniture(
        eventtypesState.Other_Partial_Furniture));
    _store.dispatch(
        UpdateSummeryRestrictionlist(eventtypesState.restrictionlist));
  }

  bool RestrictionValidation(List<SystemEnumDetails> restrictionlist) {
    bool isvehicallist = true;

    for (int i = 0; i < restrictionlist.length; i++) {
      SystemEnumDetails vehical = restrictionlist[i];

      if (vehical.ischeck!) {
        isvehicallist = false;
        break;
      }
    }

    return isvehicallist;
  }
}
