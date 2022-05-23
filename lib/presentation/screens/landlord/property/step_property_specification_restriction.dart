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
import 'package:silverhome/domain/actions/landlord_action/property_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/property_feature_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/property_specification_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/property_summery_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/propertyform_actions.dart';
import 'package:silverhome/presentation/models/landlord_models/property_summery_state.dart';
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

import '../../../models/landlord_models/property_state.dart';
import 'add_edit_property.dart';

class StepPropertySpecificationRestriction extends StatefulWidget {
  final VoidCallback _callbackBack;
  final VoidCallback _callbackSaveandNext;

  StepPropertySpecificationRestriction({
    required VoidCallback onPressedBack,
    required VoidCallback onPressedSave,
  })  : _callbackBack = onPressedBack,
        _callbackSaveandNext = onPressedSave;

  @override
  _StepPropertySpecificationRestrictionState createState() =>
      _StepPropertySpecificationRestrictionState();
}

class _StepPropertySpecificationRestrictionState
    extends State<StepPropertySpecificationRestriction> {
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
    AddEditProperty.isValueUpdate = false;
    super.initState();
  }

  _changeData() {
    if (!change) {
      AddEditProperty.isValueUpdate = true;
      change = true;
    }
  }

  initNavigationBack() {
    navigationNotifier.addListener(() {
      if (mounted) if (navigationNotifier.backScreen ==
          NavigationConstant.specificationAndRestriction) {
        isGotoBack = navigationNotifier.gotoBack;
        stepper = navigationNotifier.stepper;
        apiCallAndValication(_store.state!.propertyState);
      }
    });
  }

  void filldata() {
    List<SystemEnumDetails> furnishinglist = [];
    furnishinglist = QueryFilter().PlainValues(eSystemEnums().Furnishing);

    _store.dispatch(UpdateFurnishinglist(furnishinglist));
  }

  void initilize() {
    if (_store.state!.propertySummeryState != null) {
      PropertySummeryState propertySummeryState =
          _store.state!.propertySummeryState;

      _store.dispatch(
          UpdatePropertyBedrooms(propertySummeryState.PropertyBedrooms));
      _store.dispatch(
          UpdatePropertyBathrooms(propertySummeryState.PropertyBathrooms));
      _store.dispatch(UpdatePropertySizeinsquarefeet(
          propertySummeryState.PropertySizeinsquarefeet));
      _store.dispatch(UpdatePropertyMaxoccupancy(
          propertySummeryState.PropertyMaxoccupancy));
      _store.dispatch(
          UpdateFurnishingValue(propertySummeryState.furnishingValue));
      _store.dispatch(UpdateOtherPartialFurniture(
          propertySummeryState.Other_Partial_Furniture));

      List<SystemEnumDetails> secondList = propertySummeryState.restrictionlist
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
      child: ConnectState<PropertyState>(
          map: (state) => state.propertyState,
          where: notIdentical,
          builder: (propertyState) {
            if (propertyState!.PropertySizeinsquarefeet != null &&
                propertyState.PropertySizeinsquarefeet.isNotEmpty) {
              String valuerat = formatNumber(
                  propertyState.PropertySizeinsquarefeet.replaceAll(',', ''));
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
                          GlobleString.PS2_Property_Specifications,
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
                              GlobleString.PS2_Property_Bedrooms,
                              style: MyStyles.Medium(14, myColor.black),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              initialValue: propertyState.PropertyBedrooms,
                              textAlign: TextAlign.start,
                              autofocus: true,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [MaskedInputFormatter("0")],
                              style: MyStyles.Regular(14, myColor.text_color),
                              decoration: InputDecoration(
                                  //border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            propertyState.error_PropertyBedrooms
                                                ? myColor.errorcolor
                                                : myColor.blue,
                                        width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            propertyState.error_PropertyBedrooms
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
                                _store.dispatch(UpdatePropertyBedrooms(value));
                                _store.dispatch(
                                    UpdateErrorPropertyBedrooms(false));
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
                              GlobleString.PS2_Property_Bathrooms,
                              style: MyStyles.Medium(14, myColor.black),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              initialValue: propertyState.PropertyBathrooms,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [MaskedInputFormatter("0")],
                              style: MyStyles.Regular(14, myColor.text_color),
                              decoration: InputDecoration(
                                  //border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: propertyState
                                                .error_PropertyBathrooms
                                            ? myColor.errorcolor
                                            : myColor.blue,
                                        width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: propertyState
                                                .error_PropertyBathrooms
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
                                _store.dispatch(UpdatePropertyBathrooms(value));
                                _store.dispatch(
                                    UpdateErrorPropertyBathrooms(false));
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
                              GlobleString.PS2_Property_Sizeinsquarefeet,
                              style: MyStyles.Medium(14, myColor.black),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextField(
                              //initialValue: propertyState.PropertySizeinsquarefeet,
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
                                        color: propertyState
                                                .error_PropertySizeinsquarefeet
                                            ? myColor.errorcolor
                                            : myColor.blue,
                                        width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: propertyState
                                                .error_PropertySizeinsquarefeet
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
                                    UpdatePropertySizeinsquarefeet(valuesize));
                                _store.dispatch(
                                    UpdateErrorPropertySizeinsquarefeet(false));
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
                              GlobleString.PS2_Property_Maxoccupancy,
                              style: MyStyles.Medium(14, myColor.black),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              initialValue: propertyState.PropertyMaxoccupancy,
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
                                        color: propertyState
                                                .error_PropertyMaxoccupancy
                                            ? myColor.errorcolor
                                            : myColor.blue,
                                        width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: propertyState
                                                .error_PropertyMaxoccupancy
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
                                    UpdatePropertyMaxoccupancy(value));
                                _store.dispatch(
                                    UpdateErrorPropertyMaxoccupancy(false));
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
                              GlobleString.PS2_Property_Furnishing,
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
                                isError: propertyState.error_furnishing,
                                popupBackgroundColor: myColor.white,
                                items: propertyState.furnishinglist,
                                defultHeight: double.parse(
                                    (propertyState.furnishinglist.length * 35)
                                        .toString()),
                                textstyle:
                                    MyStyles.Medium(14, myColor.text_color),
                                itemAsString: (SystemEnumDetails? u) =>
                                    u!.displayValue,
                                hint: "Select furnishing",
                                showSearchBox: false,
                                selectedItem:
                                    propertyState.furnishingValue != null
                                        ? propertyState.furnishingValue
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
                      propertyState.furnishingValue != null &&
                              propertyState.furnishingValue!.EnumDetailID == 3
                          ? Container(
                              width: 350,
                              margin: EdgeInsets.only(top: 20),
                              child: TextFormField(
                                initialValue:
                                    propertyState.Other_Partial_Furniture,
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
                                          color: propertyState
                                                  .error_Other_Partial_Furniture
                                              ? myColor.errorcolor
                                              : myColor.blue,
                                          width: 2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: propertyState
                                                  .error_Other_Partial_Furniture
                                              ? myColor.errorcolor
                                              : myColor.gray,
                                          width: 1.0),
                                    ),
                                    isDense: true,
                                    hintText: GlobleString
                                        .PS2_Property_Furnishing_partial,
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
                          GlobleString.PS2_Property_Restrictions,
                          style: MyStyles.Medium(20, myColor.Circle_main),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RestrictionList(propertyState),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          back(),
                          SizedBox(width: 10),
                          saveandnext(propertyState)
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

  Widget RestrictionList(PropertyState propertyState) {
    List<SystemEnumDetails> myrestrictionlist = propertyState.restrictionlist;

    return Container(
      width: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            GlobleString.PS2_Property_restrictions,
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

                            //propertyState.restrictionlist[Index].ischeck = value;
                            //_store.dispatch(UpdateRestrictionlist(propertyState.restrictionlist));
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

  Widget saveandnext(PropertyState propertyState) {
    return InkWell(
      onTap: () {
        apiCallAndValication(propertyState);
        //widget._callbackSaveandNext();
      },
      child: CustomeWidget.SaveAndNext(GlobleString.Save_and_next),
    );
  }

  void apiCallAndValication(PropertyState propertyState) {
    if (propertyState.PropertyBedrooms.isEmpty ||
        propertyState.PropertyBedrooms == "0") {
      _store.dispatch(UpdateErrorPropertyBedrooms(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS2_Property_Bedrooms_error, false);
    } else if (propertyState.PropertyBathrooms.isEmpty ||
        propertyState.PropertyBathrooms == "0") {
      _store.dispatch(UpdateErrorPropertyBathrooms(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS2_Property_Bathrooms_error, false);
    } else if (propertyState.PropertySizeinsquarefeet == "" ||
        propertyState.PropertySizeinsquarefeet == "0") {
      _store.dispatch(UpdateErrorPropertySizeinsquarefeet(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS2_Property_Sizeinsquarefeet_error, false);
    } else if (propertyState.PropertyMaxoccupancy == "") {
      _store.dispatch(UpdateErrorPropertyMaxoccupancy(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS2_Property_Maxoccupancy_error, false);
    } else if (propertyState.furnishingValue == null) {
      _store.dispatch(UpdateErrorFurnishing(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS2_Property_Furnishing_error, false);
    } else if (propertyState.furnishingValue!.EnumDetailID == 3 &&
        propertyState.Other_Partial_Furniture.isEmpty) {
      _store.dispatch(UpdateErrorOther_Partial_Furniture(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS2_Property_partial_furniture_error, false);
    } else if (RestrictionValidation(propertyState.restrictionlist)) {
      ToastUtils.showCustomToast(
          context, GlobleString.PS2_Property_restrictions_error, false);
    } else {
      List<PropertyRestriction> restrictionlist = <PropertyRestriction>[];

      for (int i = 0; i < propertyState.restrictionlist.length; i++) {
        if (propertyState.restrictionlist[i].ischeck!) {
          PropertyRestriction propertyRestriction = new PropertyRestriction();

          propertyRestriction.Prop_ID = Prefs.getString(PrefsName.PropertyID);
          propertyRestriction.Restrictions =
              propertyState.restrictionlist[i].EnumDetailID.toString();

          restrictionlist.add(propertyRestriction);
        }
      }

      PropertySpecification propertySpecification = new PropertySpecification();
      propertySpecification.Bedrooms =
          propertyState.PropertyBedrooms.toString().trim();
      propertySpecification.Bathrooms =
          propertyState.PropertyBathrooms.toString().trim();
      propertySpecification.Max_Occupancy =
          propertyState.PropertyMaxoccupancy.toString().trim();
      propertySpecification.Furnishing =
          propertyState.furnishingValue!.EnumDetailID.toString().trim();
      propertySpecification.Size =
          propertyState.PropertySizeinsquarefeet.replaceAll(",", "")
              .toString()
              .trim();
      propertySpecification.Other_Partial_Furniture =
          propertyState.Other_Partial_Furniture.toString().trim();

      PropertyUpdate propertyUpdate = new PropertyUpdate();
      propertyUpdate.ID = Prefs.getString(PrefsName.PropertyID);
      propertyUpdate.Owner_ID = Prefs.getString(PrefsName.OwnerID);

      if (propertyState.PropDrafting >= 1 && propertyState.PropDrafting <= 2) {
        propertySpecification.PropDrafting = 2;
      } else {
        propertySpecification.PropDrafting = propertyState.PropDrafting;
      }

      UpdateSummeryData(propertyState);

      loader = Helper.overlayLoader(context);
      Overlay.of(context)!.insert(loader);

      PropID propID =
          new PropID(Prop_ID: Prefs.getString(PrefsName.PropertyID));

      ApiManager().deleteAllRestriction(context, propID,
          (error, respoce) async {
        if (error) {
          ApiManager().AddPropertySpecificatinRestriction(
              context, restrictionlist, propertyUpdate, propertySpecification,
              (error, responce) async {
            if (error) {
              await Prefs.setBool(PrefsName.PropertyStep2, true);
              loader.remove();
              _store.dispatch(
                  UpdatePropertyDrafting(propertySpecification.PropDrafting!));
              _store.dispatch(UpdateSummeryPropertyDrafting(
                  propertySpecification.PropDrafting!));

              ToastUtils.showCustomToast(
                  context, GlobleString.PS_Save_Propertyse, true);

              if (!isGotoBack) {
                if (stepper == 0)
                  widget._callbackSaveandNext();
                else
                  _store.dispatch(UpdatePropertyForm(stepper));
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

  void UpdateSummeryData(PropertyState propertyState) {
    _store.dispatch(
        UpdateSummeryPropertyBedrooms(propertyState.PropertyBedrooms));
    _store.dispatch(
        UpdateSummeryPropertyBathrooms(propertyState.PropertyBathrooms));
    _store.dispatch(UpdateSummeryPropertySizeinsquarefeet(
        propertyState.PropertySizeinsquarefeet));
    _store.dispatch(
        UpdateSummeryPropertyMaxoccupancy(propertyState.PropertyMaxoccupancy));
    _store
        .dispatch(UpdateSummeryFurnishingValue(propertyState.furnishingValue));
    _store.dispatch(UpdateSummeryOtherPartialFurniture(
        propertyState.Other_Partial_Furniture));
    _store
        .dispatch(UpdateSummeryRestrictionlist(propertyState.restrictionlist));
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
