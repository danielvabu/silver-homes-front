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
import 'package:silverhome/presentation/models/landlord_models/event_types_summery_state.dart';
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

class StepEventTypesSpecificationRestriction extends StatefulWidget {
  final VoidCallback _callbackBack;
  final VoidCallback _callbackSaveandNext;

  StepEventTypesSpecificationRestriction({
    required VoidCallback onPressedBack,
    required VoidCallback onPressedSave,
  })  : _callbackBack = onPressedBack,
        _callbackSaveandNext = onPressedSave;

  @override
  _StepEventTypesSpecificationRestrictionState createState() =>
      _StepEventTypesSpecificationRestrictionState();
}

class _StepEventTypesSpecificationRestrictionState
    extends State<StepEventTypesSpecificationRestriction> {
  double ssheight = 0, sswidth = 0;

  String formatNumber(String s) =>
      NumberFormat.decimalPattern('en').format(int.parse(s));
  final controllerSize = TextEditingController();

  final _store = getIt<AppStore>();

  late OverlayEntry overlayEntry;
  late OverlayEntry loader;
  bool isGotoBack = false;
  int stepper = 0;
  // bool firsttime = true;
  bool change = false;

  @override
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
      EventTypesSummeryState eventtypesSummeryState =
          _store.state!.eventTypesSummeryState;

      _store.dispatch(
          UpdateEventTypesBedrooms(eventtypesSummeryState.EventTypesBedrooms));
      _store.dispatch(UpdateEventTypesBathrooms(
          eventtypesSummeryState.EventTypesBathrooms));
      _store.dispatch(UpdateEventTypesSizeinsquarefeet(
          eventtypesSummeryState.EventTypesSizeinsquarefeet));
      _store.dispatch(UpdateEventTypesMaxoccupancy(
          eventtypesSummeryState.EventTypesMaxoccupancy));
      _store.dispatch(
          UpdateFurnishingValue(eventtypesSummeryState.furnishingValue));
      _store.dispatch(UpdateOtherPartialFurniture(
          eventtypesSummeryState.Other_Partial_Furniture));

      List<SystemEnumDetails> secondList = eventtypesSummeryState
          .restrictionlist
          .map((item) => new SystemEnumDetails.clone(item))
          .toList();

      _store.dispatch(UpdateRestrictionlist(secondList));
    }
  }

  @override
  Widget build(BuildContext context) {
    ssheight = MediaQuery.of(context).size.height - 70;
    sswidth = MediaQuery.of(context).size.width - 230;

    return Container(
      width: sswidth,
      height: ssheight - 186,
      child: ConnectState<EventTypesState>(
          map: (state) => state.eventTypesState,
          where: notIdentical,
          builder: (eventtypesState) {
            if (eventtypesState!.EventTypesSizeinsquarefeet != null &&
                eventtypesState.EventTypesSizeinsquarefeet.isNotEmpty) {
              String valuerat = formatNumber(
                  eventtypesState.EventTypesSizeinsquarefeet.replaceAll(
                      ',', ''));
              controllerSize.value = TextEditingValue(
                text: valuerat,
                selection: TextSelection.collapsed(offset: valuerat.length),
              );
            }

            return SingleChildScrollView(
              child: Container(
                child: FocusScope(
                  node: new FocusScopeNode(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "GlobleString.PS2_EventTypes_Specifications",
                          style: MyStyles.Medium(20, myColor.Circle_main),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 350,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "GlobleString.PS2_EventTypes_Bedrooms",
                              style: MyStyles.Medium(14, myColor.black),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              initialValue: eventtypesState.EventTypesBedrooms,
                              textAlign: TextAlign.start,
                              autofocus: true,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [MaskedInputFormatter("0")],
                              style: MyStyles.Regular(14, myColor.text_color),
                              decoration: InputDecoration(
                                  //border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: eventtypesState
                                                .error_EventTypesBedrooms
                                            ? myColor.errorcolor
                                            : myColor.blue,
                                        width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: eventtypesState
                                                .error_EventTypesBedrooms
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
                                _store
                                    .dispatch(UpdateEventTypesBedrooms(value));
                                _store.dispatch(
                                    UpdateErrorEventTypesBedrooms(false));
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 350,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "GlobleString.PS2_EventTypes_Bathrooms",
                              style: MyStyles.Medium(14, myColor.black),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              initialValue: eventtypesState.EventTypesBathrooms,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [MaskedInputFormatter("0")],
                              style: MyStyles.Regular(14, myColor.text_color),
                              decoration: InputDecoration(
                                  //border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: eventtypesState
                                                .error_EventTypesBathrooms
                                            ? myColor.errorcolor
                                            : myColor.blue,
                                        width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: eventtypesState
                                                .error_EventTypesBathrooms
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
                                _store
                                    .dispatch(UpdateEventTypesBathrooms(value));
                                _store.dispatch(
                                    UpdateErrorEventTypesBathrooms(false));
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 350,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "GlobleString.PS2_EventTypes_Sizeinsquarefeet",
                              style: MyStyles.Medium(14, myColor.black),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextField(
                              //initialValue: eventtypesState.EventTypesSizeinsquarefeet,
                              controller: controllerSize,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                //MaskedInputFormatter("0000")
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]")),
                              ],
                              style: MyStyles.Regular(14, myColor.text_color),
                              decoration: InputDecoration(
                                  //border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: eventtypesState
                                                .error_EventTypesSizeinsquarefeet
                                            ? myColor.errorcolor
                                            : myColor.blue,
                                        width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: eventtypesState
                                                .error_EventTypesSizeinsquarefeet
                                            ? myColor.errorcolor
                                            : myColor.gray,
                                        width: 1.0),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(12),
                                  fillColor: myColor.white,
                                  filled: true),
                              onChanged: (valuesize) {
                                _changeData();
                                if (valuesize.isNotEmpty) {
                                  valuesize = formatNumber(
                                      valuesize.replaceAll(',', ''));
                                  controllerSize.value = TextEditingValue(
                                    text: valuesize,
                                    selection: TextSelection.collapsed(
                                        offset: valuesize.length),
                                  );
                                } else {
                                  controllerSize.text = "";
                                }

                                _store.dispatch(
                                    UpdateEventTypesSizeinsquarefeet(
                                        valuesize));
                                _store.dispatch(
                                    UpdateErrorEventTypesSizeinsquarefeet(
                                        false));
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 350,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "GlobleString.PS2_EventTypes_Maxoccupancy",
                              style: MyStyles.Medium(14, myColor.black),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              initialValue:
                                  eventtypesState.EventTypesMaxoccupancy,
                              textAlign: TextAlign.start,
                              style: MyStyles.Regular(14, myColor.text_color),
                              inputFormatters: [
                                //FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(25),
                              ],
                              decoration: InputDecoration(
                                  //border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: eventtypesState
                                                .error_EventTypesMaxoccupancy
                                            ? myColor.errorcolor
                                            : myColor.blue,
                                        width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: eventtypesState
                                                .error_EventTypesMaxoccupancy
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
                                _store.dispatch(
                                    UpdateEventTypesMaxoccupancy(value));
                                _store.dispatch(
                                    UpdateErrorEventTypesMaxoccupancy(false));
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 350,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "GlobleString.PS2_EventTypes_Furnishing",
                              style: MyStyles.Medium(14, myColor.black),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 32,
                              child: DropdownSearch<SystemEnumDetails>(
                                mode: Mode.MENU,
                                key: UniqueKey(),
                                focuscolor: myColor.blue,
                                focusWidth: 2,
                                errorcolor: myColor.errorcolor,
                                isError: eventtypesState.error_furnishing,
                                popupBackgroundColor: myColor.white,
                                items: eventtypesState.furnishinglist,
                                defultHeight: double.parse(
                                    (eventtypesState.furnishinglist.length * 35)
                                        .toString()),
                                textstyle:
                                    MyStyles.Medium(14, myColor.text_color),
                                itemAsString: (SystemEnumDetails? u) =>
                                    u!.displayValue,
                                hint: "Select furnishing",
                                showSearchBox: false,
                                selectedItem:
                                    eventtypesState.furnishingValue != null
                                        ? eventtypesState.furnishingValue
                                        : null,
                                isFilteredOnline: true,
                                onChanged: (value) {
                                  _changeData();
                                  _store
                                      .dispatch(UpdateFurnishingValue(value!));
                                  _store.dispatch(UpdateErrorFurnishing(false));

                                  if (value.EnumDetailID != 3) {
                                    _store.dispatch(
                                        UpdateOtherPartialFurniture(""));
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      /* SizedBox(
                        height: 20,
                      ),*/
                      eventtypesState.furnishingValue != null &&
                              eventtypesState.furnishingValue!.EnumDetailID == 3
                          ? Container(
                              width: 350,
                              margin: EdgeInsets.only(top: 20),
                              child: TextFormField(
                                initialValue:
                                    eventtypesState.Other_Partial_Furniture,
                                textAlign: TextAlign.start,
                                autofocus: true,
                                style: MyStyles.Regular(14, myColor.text_color),
                                inputFormatters: [
                                  //FilteringTextInputFormatter.allow(RegExp("[a-z A-Z , &]")),
                                ],
                                decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: eventtypesState
                                                  .error_Other_Partial_Furniture
                                              ? myColor.errorcolor
                                              : myColor.blue,
                                          width: 2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: eventtypesState
                                                  .error_Other_Partial_Furniture
                                              ? myColor.errorcolor
                                              : myColor.gray,
                                          width: 1.0),
                                    ),
                                    isDense: true,
                                    hintText:
                                        "GlobleString.PS2_EventTypes_Furnishing_partial",
                                    hintStyle:
                                        MyStyles.Regular(14, myColor.hintcolor),
                                    contentPadding: EdgeInsets.all(12),
                                    fillColor: myColor.white,
                                    filled: true),
                                onChanged: (value) {
                                  _changeData();
                                  _store.dispatch(
                                      UpdateOtherPartialFurniture(value));
                                  _store.dispatch(
                                      UpdateErrorOther_Partial_Furniture(
                                          false));
                                },
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "GlobleString.PS2_EventTypes_Restrictions",
                          style: MyStyles.Medium(20, myColor.Circle_main),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RestrictionList(eventtypesState),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          back(),
                          SizedBox(width: 10),
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
    if (eventtypesState.EventTypesBedrooms.isEmpty ||
        eventtypesState.EventTypesBedrooms == "0") {
      _store.dispatch(UpdateErrorEventTypesBedrooms(true));
      ToastUtils.showCustomToast(
          context, "GlobleString.PS2_EventTypes_Bedrooms_error", false);
    } else if (eventtypesState.EventTypesBathrooms.isEmpty ||
        eventtypesState.EventTypesBathrooms == "0") {
      _store.dispatch(UpdateErrorEventTypesBathrooms(true));
      ToastUtils.showCustomToast(
          context, "GlobleString.PS2_EventTypes_Bathrooms_error", false);
    } else if (eventtypesState.EventTypesSizeinsquarefeet == "" ||
        eventtypesState.EventTypesSizeinsquarefeet == "0") {
      _store.dispatch(UpdateErrorEventTypesSizeinsquarefeet(true));
      ToastUtils.showCustomToast(
          context, "GlobleString.PS2_EventTypes_Sizeinsquarefeet_error", false);
    } else if (eventtypesState.EventTypesMaxoccupancy == "") {
      _store.dispatch(UpdateErrorEventTypesMaxoccupancy(true));
      ToastUtils.showCustomToast(
          context, "GlobleString.PS2_EventTypes_Maxoccupancy_error", false);
    } else if (eventtypesState.furnishingValue == null) {
      _store.dispatch(UpdateErrorFurnishing(true));
      ToastUtils.showCustomToast(
          context, "GlobleString.PS2_EventTypes_Furnishing_error", false);
    } else if (eventtypesState.furnishingValue!.EnumDetailID == 3 &&
        eventtypesState.Other_Partial_Furniture.isEmpty) {
      _store.dispatch(UpdateErrorOther_Partial_Furniture(true));
      ToastUtils.showCustomToast(context,
          "GlobleString.PS2_EventTypes_partial_furniture_error", false);
    } else if (RestrictionValidation(eventtypesState.restrictionlist)) {
      ToastUtils.showCustomToast(
          context, "GlobleString.PS2_EventTypes_restrictions_error", false);
    } else {
      List<EventTypesRestriction> restrictionlist = <EventTypesRestriction>[];

      for (int i = 0; i < eventtypesState.restrictionlist.length; i++) {
        if (eventtypesState.restrictionlist[i].ischeck!) {
          EventTypesRestriction eventtypesRestriction =
              new EventTypesRestriction();

          eventtypesRestriction.Prop_ID =
              Prefs.getString(PrefsName.EventTypesID);
          eventtypesRestriction.Restrictions =
              eventtypesState.restrictionlist[i].EnumDetailID.toString();

          restrictionlist.add(eventtypesRestriction);
        }
      }

      EventTypesSpecification eventtypesSpecification =
          new EventTypesSpecification();
      eventtypesSpecification.Bedrooms =
          eventtypesState.EventTypesBedrooms.toString().trim();
      eventtypesSpecification.Bathrooms =
          eventtypesState.EventTypesBathrooms.toString().trim();
      eventtypesSpecification.Max_Occupancy =
          eventtypesState.EventTypesMaxoccupancy.toString().trim();
      eventtypesSpecification.Furnishing =
          eventtypesState.furnishingValue!.EnumDetailID.toString().trim();
      eventtypesSpecification.Size =
          eventtypesState.EventTypesSizeinsquarefeet.replaceAll(",", "")
              .toString()
              .trim();
      eventtypesSpecification.Other_Partial_Furniture =
          eventtypesState.Other_Partial_Furniture.toString().trim();

      EventTypesUpdate eventtypesUpdate = new EventTypesUpdate();
      eventtypesUpdate.ID = Prefs.getString(PrefsName.EventTypesID);
      eventtypesUpdate.Owner_ID = Prefs.getString(PrefsName.OwnerID);

      if (eventtypesState.PropDrafting >= 1 &&
          eventtypesState.PropDrafting <= 2) {
        eventtypesSpecification.PropDrafting = 2;
      } else {
        eventtypesSpecification.PropDrafting = eventtypesState.PropDrafting;
      }

      UpdateSummeryData(eventtypesState);

      loader = Helper.overlayLoader(context);
      Overlay.of(context)!.insert(loader);

      PropID propID =
          new PropID(Prop_ID: Prefs.getString(PrefsName.EventTypesID));

      ApiManager().deleteAllRestriction(context, propID,
          (error, respoce) async {
        if (error) {
          ApiManager().AddEventTypesSpecificatinRestriction(
              context,
              restrictionlist,
              eventtypesUpdate,
              eventtypesSpecification, (error, responce) async {
            if (error) {
              await Prefs.setBool(PrefsName.EventTypesStep2, true);
              loader.remove();
              _store.dispatch(UpdateEventTypesDrafting(
                  eventtypesSpecification.PropDrafting!));
              _store.dispatch(UpdateSummeryEventTypesDrafting(
                  eventtypesSpecification.PropDrafting!));

              ToastUtils.showCustomToast(
                  context, "GlobleString.PS_Save_EventTypesse", true);

              if (!isGotoBack) {
                if (stepper == 0)
                  widget._callbackSaveandNext();
                else
                  _store.dispatch(UpdateEventTypesForm(stepper));
              } else {
                _store
                    .dispatch(UpdatePortalPage(1, GlobleString.NAV_Properties));
              }
            } else {
              loader.remove();
              ToastUtils.showCustomToast(context, responce, false);
            }
          });
        } else {
          loader.remove();
          ToastUtils.showCustomToast(context, respoce, false);
          Helper.Log("respoce", respoce);
        }
      });
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
