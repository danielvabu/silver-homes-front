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
    ssheight = MediaQuery.of(context).size.height - 75;
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
                          'Showing - 867 Hamilton St.', // este sale de la pantalla anterior: Event Type Name
                          style: MyStyles.Bold(20, myColor.Circle_main),
                        ),
                      ]),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 8.0),
                                  child: Text(
                                    GlobleString.Time_Zone,
                                    style: MyStyles.Medium(14, myColor.black),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Container(
                                  height: 32,
                                  child: DropdownSearch<SystemEnumDetails>(
                                    mode: Mode.MENU,
                                    key: UniqueKey(),
                                    errorcolor: myColor.errorcolor,
                                    isError:
                                        eventtypesState!.error_eventtypestype,
                                    focuscolor: myColor.blue,
                                    focusWidth: 2,
                                    popupBackgroundColor: myColor.white,
                                    items: eventtypesState.eventtypestypelist,
                                    defultHeight: eventtypesState
                                                    .eventtypestypelist.length *
                                                35 >
                                            250
                                        ? 250
                                        : eventtypesState
                                                .eventtypestypelist.length *
                                            35,
                                    textstyle:
                                        MyStyles.Medium(14, myColor.text_color),
                                    itemAsString: (SystemEnumDetails? u) =>
                                        u != null ? u.displayValue : "",
                                    hint: GlobleString.ET_Select_Template,
                                    selectedItem: eventtypesState
                                                .eventtypestypeValue !=
                                            null
                                        ? eventtypesState.eventtypestypeValue
                                        : null,
                                    onChanged: (value) {
                                      /*_changeData();
                                      AddEditEventTypes.isValueUpdate = true;
                                      if (value!.EnumDetailID != 6) {_store.dispatch(UpdateEventTypesTypeOtherValue(""));}
                                      _store.dispatch(UpdateProperTytypeValue(value));
                                      _store.dispatch(UpdateErrorEventTypestype(false));*/
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 30.0),
                          Expanded(child: Container()),
                        ],
                      ),
                      const SizedBox(height: 20.0),
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
