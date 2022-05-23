import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
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

class StepPropertyDetails extends StatefulWidget {
  final VoidCallback _callbackSaveandNext;
  StepPropertyDetails({
    required VoidCallback onPressedSave,
  }) : _callbackSaveandNext = onPressedSave;

  @override
  _StepPropertyDetailsState createState() => _StepPropertyDetailsState();
}

class _StepPropertyDetailsState extends State<StepPropertyDetails> {
  double ssheight = 0, sswidth = 0;

  final _store = getIt<AppStore>();

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern('en').format(int.parse(s));
  final _mycontroller = TextEditingController();

  ScrollController _controller = new ScrollController();
  FocusNode _focus1 = new FocusNode();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  bool isGotoback = false;
  int stepper = 0;
  //FocusNode _focusNode = new FocusNode();
  // bool firsttime = true;
  bool change = false;

  @override
  void initState() {
    Prefs.init();
    initilizedata();
    filldata();
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

  initilizedata() {
    if (_store.state!.propertySummeryState != null) {
      PropertySummeryState propertySummeryState =
          _store.state!.propertySummeryState;

      _store.dispatch(
          UpdateProperTytypeValue(propertySummeryState.propertytypeValue));
      _store.dispatch(UpdatePropertyTypeOtherValue(
          propertySummeryState.propertytypeOtherValue));

      _store.dispatch(
          UpdateDateofavailable(propertySummeryState.dateofavailable));
      _store.dispatch(
          UpdateRentalSpaceValue(propertySummeryState.rentalspaceValue));
      _store.dispatch(UpdatePropertyName(propertySummeryState.PropertyName));
      _store.dispatch(
          UpdatePropertyAddress(propertySummeryState.PropertyAddress));
      _store.dispatch(
          UpdatePropertyDescription(propertySummeryState.PropertyDescription));
      _store.dispatch(UpdateSuiteunit(propertySummeryState.Suiteunit));
      _store.dispatch(UpdateBuildingname(propertySummeryState.Buildingname));
      _store.dispatch(UpdatePropertyCity(propertySummeryState.City));
      _store.dispatch(
          UpdatePropertyCountryCode(propertySummeryState.CountryCode));
      _store.dispatch(
          UpdatePropertyCountryName(propertySummeryState.CountryName));
      _store.dispatch(UpdatePropertyProvince(propertySummeryState.Province));
      _store
          .dispatch(UpdatePropertyPostalcode(propertySummeryState.Postalcode));
      _store
          .dispatch(UpdatePropertyRentAmount(propertySummeryState.RentAmount));
      _store.dispatch(UpdateRentPaymentFrequencyValue(
          propertySummeryState.rentpaymentFrequencyValue));
      _store
          .dispatch(UpdateLeaseTypeValue(propertySummeryState.leasetypeValue));
      _store.dispatch(UpdateMinimumLeasedurationValue(
          propertySummeryState.minimumleasedurationValue));
      _store.dispatch(UpdateMinimumleasedurationNumber(
          propertySummeryState.minimumleasedurationnumber));
    }
  }

  initNavigationBack() {
    navigationNotifier.addListener(() {
      if (mounted) if (navigationNotifier.backScreen ==
          NavigationConstant.propertyDetails) {
        isGotoback = navigationNotifier.gotoBack;
        stepper = navigationNotifier.stepper;
        Helper.Log("navigationNotifier", "Call...");
        apiCallAndValidation(_store.state!.propertyState);
        //navigationNotifier.dispose();
      }
    });
  }

  void filldata() {
    List<SystemEnumDetails> propertytypelist = [];
    propertytypelist = QueryFilter().PlainValues(eSystemEnums().PropertyType);

    _store.dispatch(UpdateProperTytypeList(propertytypelist));

    List<SystemEnumDetails> rentalspacelist = [];
    rentalspacelist = QueryFilter().PlainValues(eSystemEnums().RentalSpace);

    _store.dispatch(UpdateRentalSpaceList(rentalspacelist));

    List<SystemEnumDetails> leasetypelist = [];
    leasetypelist = QueryFilter().PlainValues(eSystemEnums().LeaseType);

    _store.dispatch(UpdateLeaseTypeList(leasetypelist));

    List<SystemEnumDetails> rentplaymentFrequencylist = [];
    rentplaymentFrequencylist =
        QueryFilter().PlainValues(eSystemEnums().RentPaymentFrequency);

    _store.dispatch(UpdateRentPaymentFrequencylist(rentplaymentFrequencylist));

    List<SystemEnumDetails> minimumleasedurationlist = [];
    minimumleasedurationlist =
        QueryFilter().PlainValues(eSystemEnums().MinLeaseDuration);

    _store.dispatch(UpdateMinimumLeasedurationList(minimumleasedurationlist));
  }

  Future<void> _selectDate(BuildContext context, propertyState) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2200),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data: new ThemeData(
            primarySwatch: MaterialColor(0xFF010B32, Helper.color),
            accentColor: myColor.Circle_main,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != propertyState.dateofavailable) {
      AddEditProperty.isValueUpdate = true;
      _store.dispatch(UpdateDateofavailable(pickedDate));
      _store.dispatch(UpdateErrorDateofavailable(false));
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
            if (propertyState != null &&
                propertyState.RentAmount != null &&
                propertyState.RentAmount.isNotEmpty) {
              String valuerat =
                  '${_formatNumber(propertyState.RentAmount.replaceAll(',', ''))}';
              _mycontroller.value = TextEditingValue(
                text: valuerat,
                selection: TextSelection.collapsed(offset: valuerat.length),
              );
            }
            return SingleChildScrollView(
              controller: _controller,
              child: Container(
                child: FocusScope(
                  node: _focusScopeNode,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          GlobleString.PS1_Property_Details,
                          style: MyStyles.Medium(20, myColor.Circle_main),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  GlobleString.PS1_Property_type,
                                  style: MyStyles.Medium(14, myColor.black),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 32,
                                  // ignore: missing_required_param
                                  child: DropdownSearch<SystemEnumDetails>(
                                    mode: Mode.MENU,
                                    key: UniqueKey(),
                                    errorcolor: myColor.errorcolor,
                                    isError: propertyState!.error_propertytype,
                                    focuscolor: myColor.blue,
                                    focusWidth: 2,
                                    popupBackgroundColor: myColor.white,
                                    items: propertyState.propertytypelist,
                                    defultHeight:
                                        propertyState.propertytypelist.length *
                                                    35 >
                                                250
                                            ? 250
                                            : propertyState
                                                    .propertytypelist.length *
                                                35,
                                    textstyle:
                                        MyStyles.Medium(14, myColor.text_color),
                                    itemAsString: (SystemEnumDetails? u) =>
                                        u != null ? u.displayValue : "",
                                    hint: "Select Property Type",
                                    selectedItem:
                                        propertyState.propertytypeValue != null
                                            ? propertyState.propertytypeValue
                                            : null,
                                    onChanged: (value) {
                                      //FocusScope.of(context).requestFocus(new FocusNode());
                                      _changeData();
                                      AddEditProperty.isValueUpdate = true;

                                      if (value!.EnumDetailID != 6) {
                                        _store.dispatch(
                                            UpdatePropertyTypeOtherValue(""));
                                      }
                                      _store.dispatch(
                                          UpdateProperTytypeValue(value));

                                      _store.dispatch(
                                          UpdateErrorPropertytype(false));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  GlobleString.PS1_Rental_space,
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
                                    errorcolor: myColor.errorcolor,
                                    isError: propertyState.error_rentalspace,
                                    focuscolor: myColor.blue,
                                    focusWidth: 2,
                                    popupBackgroundColor: myColor.white,
                                    items: propertyState.rentalspacelist,
                                    defultHeight: propertyState
                                                    .rentalspacelist.length *
                                                35 >
                                            250
                                        ? 250
                                        : propertyState.rentalspacelist.length *
                                            35,
                                    textstyle:
                                        MyStyles.Medium(14, myColor.text_color),
                                    itemAsString: (SystemEnumDetails? u) =>
                                        u!.displayValue,
                                    hint: "Select Rental space",
                                    showSearchBox: false,
                                    selectedItem:
                                        propertyState.rentalspaceValue != null
                                            ? propertyState.rentalspaceValue
                                            : null,
                                    isFilteredOnline: true,
                                    onChanged: (value) {
                                      _changeData();
                                      AddEditProperty.isValueUpdate = true;

                                      _store.dispatch(
                                          UpdateRentalSpaceValue(value!));
                                      _store.dispatch(
                                          UpdateErrorRentalspace(false));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      propertyState.propertytypeValue != null &&
                              propertyState.propertytypeValue!.EnumDetailID == 6
                          ? Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          initialValue: propertyState
                                              .propertytypeOtherValue,
                                          textAlign: TextAlign.start,
                                          style: MyStyles.Regular(
                                              14, myColor.text_color),
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                25),
                                            FilteringTextInputFormatter.allow(
                                                RegExp("[a-z A-Z]")),
                                          ],
                                          decoration: InputDecoration(
                                              //border: InputBorder.none,
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: propertyState
                                                            .error_propertytypeOther
                                                        ? myColor.errorcolor
                                                        : myColor.blue,
                                                    width: 2),
                                              ),
                                              hintText: GlobleString
                                                  .PS1_enter_your_answer,
                                              hintStyle: MyStyles.Regular(
                                                  14, myColor.hintcolor),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: propertyState
                                                            .error_propertytypeOther
                                                        ? myColor.errorcolor
                                                        : myColor.gray,
                                                    width: 1.0),
                                              ),
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.all(12),
                                              fillColor: myColor.white,
                                              filled: true),
                                          onChanged: (value) {
                                            _changeData();
                                            AddEditProperty.isValueUpdate =
                                                true;

                                            _store.dispatch(
                                                UpdatePropertyTypeOtherValue(
                                                    value));

                                            _store.dispatch(
                                                UpdateErrorPropertytypeOther(
                                                    false));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  GlobleString.PS1_Property_name,
                                  style: MyStyles.Medium(14, myColor.black),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  initialValue: propertyState.PropertyName,
                                  textAlign: TextAlign.start,
                                  autofocus: false,
                                  focusNode: _focus1,
                                  style:
                                      MyStyles.Regular(14, myColor.text_color),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(25),
                                    /* FilteringTextInputFormatter.allow(
                                        RegExp("[a-z A-Z]")),*/
                                  ],
                                  decoration: InputDecoration(
                                      //border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                propertyState.error_PropertyName
                                                    ? myColor.errorcolor
                                                    : myColor.blue,
                                            width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                propertyState.error_PropertyName
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
                                    AddEditProperty.isValueUpdate = true;
                                    _store.dispatch(UpdatePropertyName(value));
                                    _store.dispatch(
                                        UpdateErrorPropertyName(false));
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  GlobleString.PS1_Property_Address,
                                  style: MyStyles.Medium(14, myColor.black),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  initialValue: propertyState.PropertyAddress,
                                  textAlign: TextAlign.start,
                                  style:
                                      MyStyles.Regular(14, myColor.text_color),
                                  decoration: InputDecoration(
                                      //border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: propertyState
                                                    .error_PropertyAddress
                                                ? myColor.errorcolor
                                                : myColor.blue,
                                            width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: propertyState
                                                    .error_PropertyAddress
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
                                    AddEditProperty.isValueUpdate = true;

                                    _store
                                        .dispatch(UpdatePropertyAddress(value));
                                    _store.dispatch(
                                        UpdateErrorPropertyAddress(false));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      GlobleString.PS1_Suiteunit,
                                      style: MyStyles.Medium(14, myColor.black),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      GlobleString.Optional,
                                      style: MyStyles.Regular(
                                          12, myColor.optional),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  initialValue: propertyState.Suiteunit,
                                  textAlign: TextAlign.start,
                                  style:
                                      MyStyles.Regular(14, myColor.text_color),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(25),
                                    /* FilteringTextInputFormatter.allow(
                                        RegExp("[0-9]")),*/
                                  ],
                                  decoration: InputDecoration(
                                      //border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: myColor.blue, width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: myColor.gray, width: 1.0),
                                      ),
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(12),
                                      fillColor: myColor.white,
                                      filled: true),
                                  onChanged: (value) {
                                    _changeData();
                                    AddEditProperty.isValueUpdate = true;
                                    _store.dispatch(UpdateSuiteunit(value));
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      GlobleString.PS1_Building_name,
                                      style: MyStyles.Medium(14, myColor.black),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      GlobleString.Optional,
                                      style: MyStyles.Regular(
                                          12, myColor.optional),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  initialValue: propertyState.Buildingname,
                                  textAlign: TextAlign.start,
                                  style:
                                      MyStyles.Regular(14, myColor.text_color),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(50),
                                    /* FilteringTextInputFormatter.allow(
                                        RegExp("[a-z A-Z]")),*/
                                  ],
                                  decoration: InputDecoration(
                                      //border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: myColor.blue, width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: myColor.gray, width: 1.0),
                                      ),
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(12),
                                      fillColor: myColor.white,
                                      filled: true),
                                  onChanged: (value) {
                                    _changeData();
                                    AddEditProperty.isValueUpdate = true;
                                    _store.dispatch(UpdateBuildingname(value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  GlobleString.PS1_City,
                                  style: MyStyles.Medium(14, myColor.black),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  initialValue: propertyState.City,
                                  textAlign: TextAlign.start,
                                  style:
                                      MyStyles.Regular(14, myColor.text_color),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(25),
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[a-z A-Z]")),
                                  ],
                                  decoration: InputDecoration(
                                      //border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: propertyState.error_City
                                                ? myColor.errorcolor
                                                : myColor.blue,
                                            width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: propertyState.error_City
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
                                    AddEditProperty.isValueUpdate = true;
                                    _store.dispatch(UpdatePropertyCity(value));
                                    _store.dispatch(UpdateErrorCity(false));
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  GlobleString.PS1_Province,
                                  style: MyStyles.Medium(14, myColor.black),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  initialValue: propertyState.Province,
                                  textAlign: TextAlign.start,
                                  style:
                                      MyStyles.Regular(14, myColor.text_color),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(25),
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[a-z A-Z]")),
                                  ],
                                  decoration: InputDecoration(
                                      //border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: propertyState.error_Province
                                                ? myColor.errorcolor
                                                : myColor.blue,
                                            width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: propertyState.error_Province
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
                                    AddEditProperty.isValueUpdate = true;
                                    _store.dispatch(
                                        UpdatePropertyProvince(value));
                                    _store.dispatch(UpdateErrorProvince(false));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  GlobleString.PS1_Postal_code,
                                  style: MyStyles.Medium(14, myColor.black),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  initialValue: propertyState.Postalcode,
                                  textAlign: TextAlign.start,
                                  style:
                                      MyStyles.Regular(14, myColor.text_color),
                                  decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: propertyState.error_Postalcode
                                              ? myColor.errorcolor
                                              : myColor.blue,
                                          width: 2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: propertyState.error_Postalcode
                                              ? myColor.errorcolor
                                              : myColor.gray,
                                          width: 1.0),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(12),
                                    fillColor: myColor.white,
                                    filled: true,
                                  ),
                                  onChanged: (value) {
                                    _changeData();
                                    AddEditProperty.isValueUpdate = true;
                                    _store.dispatch(
                                        UpdatePropertyPostalcode(value));
                                    _store
                                        .dispatch(UpdateErrorPostalcode(false));
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  GlobleString.PS1_Country,
                                  style: MyStyles.Medium(14, myColor.black),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 34,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: myColor.gray,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: CountryCodePicker(
                                          onChanged: (value) {
                                            _changeData();
                                            String cname = "";

                                            if (value.name.toString().contains(
                                                "State of Palestine")) {
                                              cname = "State of Palestine";
                                            } else if (value.name
                                                .toString()
                                                .contains(
                                                    "Russian Federation")) {
                                              cname = "Russian Federation";
                                            } else if (value.name
                                                .toString()
                                                .contains(
                                                    "Taiwan, Province of China")) {
                                              cname = "Taiwan";
                                            } else if (value.name
                                                .toString()
                                                .contains("United Kingdom")) {
                                              cname = "United Kingdom";
                                            } else if (value.name
                                                .toString()
                                                .contains(
                                                    "United States of America")) {
                                              cname =
                                                  "United States of America";
                                            } else {
                                              cname = value.name.toString();
                                            }

                                            AddEditProperty.isValueUpdate =
                                                true;

                                            _store.dispatch(
                                                UpdatePropertyCountryName(
                                                    cname.toString()));

                                            _store.dispatch(
                                                UpdatePropertyCountryCode(
                                                    value.code.toString()));
                                          },
                                          initialSelection:
                                              propertyState.CountryCode,
                                          showFlag: false,
                                          alignLeft: true,
                                          padding: EdgeInsets.only(
                                              left: 12, bottom: 2),
                                          backgroundColor: myColor.white,
                                          textStyle: MyStyles.Regular(
                                              14, myColor.text_color),
                                          showFlagDialog: true,
                                          showCountryOnly: true,
                                          showOnlyCountryWhenClosed: true,
                                          showDropDownButton: true,
                                          dialogTextStyle: MyStyles.Medium(
                                              14, myColor.text_color),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      GlobleString.PS1_Property_description,
                                      style: MyStyles.Medium(14, myColor.black),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      GlobleString.Optional,
                                      style: MyStyles.Regular(
                                          12, myColor.optional),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  initialValue:
                                      propertyState.PropertyDescription,
                                  textAlign: TextAlign.start,
                                  maxLines: 4,
                                  maxLength: 500,
                                  style:
                                      MyStyles.Regular(14, myColor.text_color),
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: myColor.blue, width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: myColor.gray, width: 1.0),
                                      ),
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(12),
                                      fillColor: myColor.white,
                                      filled: true),
                                  onChanged: (value) {
                                    _changeData();
                                    AddEditProperty.isValueUpdate = true;
                                    _store.dispatch(
                                        UpdatePropertyDescription(value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          GlobleString.PS1_Lease_Details,
                          style: MyStyles.Medium(20, myColor.Circle_main),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  GlobleString.PS1_Rent_amount,
                                  style: MyStyles.Medium(14, myColor.black),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  //initialValue: propertyState.RentAmount,
                                  controller: _mycontroller,
                                  textAlign: TextAlign.start,
                                  style:
                                      MyStyles.Regular(14, myColor.text_color),
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    //MaskedInputFormatter("0000000000")
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9]")),
                                  ],
                                  decoration: InputDecoration(
                                      //border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                propertyState.error_RentAmount
                                                    ? myColor.errorcolor
                                                    : myColor.blue,
                                            width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                propertyState.error_RentAmount
                                                    ? myColor.errorcolor
                                                    : myColor.gray,
                                            width: 1.0),
                                      ),
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(12),
                                      fillColor: myColor.white,
                                      filled: true),
                                  onChanged: (valuerat) {
                                    _changeData();
                                    AddEditProperty.isValueUpdate = true;

                                    if (valuerat.isNotEmpty) {
                                      valuerat =
                                          '${_formatNumber(valuerat.replaceAll(',', ''))}';
                                      _mycontroller.value = TextEditingValue(
                                        text: valuerat,
                                        selection: TextSelection.collapsed(
                                            offset: valuerat.length),
                                      );
                                    } else {
                                      _mycontroller.text = "";
                                    }

                                    _store.dispatch(
                                        UpdatePropertyRentAmount(valuerat));
                                    _store
                                        .dispatch(UpdateErrorRentAmount(false));
                                  },
                                  onEditingComplete: () {},
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  GlobleString.PS1_Rent_payment_frequency_New,
                                  style: MyStyles.Medium(14, myColor.black),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 32,
                                  // ignore: missing_required_param
                                  child: DropdownSearch<SystemEnumDetails>(
                                    key: UniqueKey(),
                                    mode: Mode.MENU,
                                    errorcolor: myColor.errorcolor,
                                    isError: propertyState
                                        .error_rentpaymentFrequency,
                                    focuscolor: myColor.blue,
                                    focusWidth: 2,
                                    popupBackgroundColor: myColor.white,
                                    items:
                                        propertyState.rentpaymentFrequencylist,
                                    defultHeight: double.parse((propertyState
                                                .rentpaymentFrequencylist
                                                .length *
                                            35)
                                        .toString()),
                                    textstyle:
                                        MyStyles.Medium(14, myColor.text_color),
                                    itemAsString: (SystemEnumDetails? u) =>
                                        u != null ? u.displayValue : "",
                                    hint: "Select Rent Payment",
                                    showSearchBox: false,
                                    selectedItem: propertyState
                                                .rentpaymentFrequencyValue !=
                                            null
                                        ? propertyState
                                            .rentpaymentFrequencyValue
                                        : null,
                                    isFilteredOnline: false,
                                    onChanged: (value) {
                                      _changeData();
                                      AddEditProperty.isValueUpdate = true;

                                      _store.dispatch(
                                          UpdateRentPaymentFrequencyValue(
                                              value!));

                                      _store.dispatch(
                                          UpdateErrorRentpaymentFrequency(
                                              false));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  GlobleString.PS1_Lease_type,
                                  style: MyStyles.Medium(14, myColor.black),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 32,
                                  // ignore: missing_required_param
                                  child: DropdownSearch<SystemEnumDetails>(
                                    key: UniqueKey(),
                                    mode: Mode.MENU,
                                    errorcolor: myColor.errorcolor,
                                    isError: propertyState.error_leasetype,
                                    focuscolor: myColor.blue,
                                    focusWidth: 2,
                                    popupBackgroundColor: myColor.white,
                                    items: propertyState.leasetypelist,
                                    defultHeight: double.parse(
                                        (propertyState.leasetypelist.length *
                                                35)
                                            .toString()),
                                    textstyle:
                                        MyStyles.Medium(14, myColor.text_color),
                                    itemAsString: (SystemEnumDetails? u) =>
                                        u!.displayValue,
                                    hint: "Select Lease Type",
                                    showSearchBox: false,
                                    selectedItem:
                                        propertyState.leasetypeValue != null
                                            ? propertyState.leasetypeValue
                                            : null,
                                    isFilteredOnline: true,
                                    onChanged: (value) {
                                      _changeData();
                                      AddEditProperty.isValueUpdate = true;

                                      _store.dispatch(
                                          UpdateLeaseTypeValue(value!));

                                      _store.dispatch(
                                          UpdateErrorLeasetype(false));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  GlobleString.PS1_Date_available,
                                  style: MyStyles.Medium(14, myColor.black),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextButton(
                                  onPressed: () =>
                                      _selectDate(context, propertyState),
                                  child: Container(
                                    height: 32,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            propertyState.error_dateofavailable
                                                ? myColor.errorcolor
                                                : myColor.gray,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 8),
                                            child: Text(
                                              propertyState.dateofavailable ==
                                                      null
                                                  ? ""
                                                  : new DateFormat(
                                                          "dd-MMM-yyyy")
                                                      .format(propertyState
                                                          .dateofavailable!)
                                                      .toString(),
                                              style: MyStyles.Regular(
                                                  14, myColor.text_color),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 8, right: 5),
                                          child: Icon(
                                            Icons.calendar_today_outlined,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            GlobleString.PS1_Minimum_lease_duration,
                            style: MyStyles.Medium(14, myColor.black),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        GlobleString.PS1_Minimum_lease_Number,
                                        style:
                                            MyStyles.Medium(14, myColor.black),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        initialValue: propertyState
                                            .minimumleasedurationnumber,
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
                                                  color: propertyState
                                                          .error_minimumleasedurationnumber
                                                      ? myColor.errorcolor
                                                      : myColor.blue,
                                                  width: 2),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: propertyState
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
                                          AddEditProperty.isValueUpdate = true;

                                          _store.dispatch(
                                              UpdateMinimumleasedurationNumber(
                                                  value));
                                          _store.dispatch(
                                              UpdateErrorMinimumleasedurationnumber(
                                                  false));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        GlobleString.PS1_Minimum_lease_Period,
                                        style:
                                            MyStyles.Medium(14, myColor.black),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        height: 32,
                                        // ignore: missing_required_param
                                        child:
                                            DropdownSearch<SystemEnumDetails>(
                                          key: UniqueKey(),
                                          mode: Mode.MENU,
                                          errorcolor: myColor.errorcolor,
                                          isError: propertyState
                                              .error_minimumleaseduration,
                                          focuscolor: myColor.blue,
                                          focusWidth: 2,
                                          popupBackgroundColor: myColor.white,
                                          items: propertyState
                                              .minimumleasedurationlist,
                                          defultHeight: double.parse((propertyState
                                                      .minimumleasedurationlist
                                                      .length *
                                                  35)
                                              .toString()),
                                          textstyle: MyStyles.Medium(
                                              14, myColor.text_color),
                                          itemAsString:
                                              (SystemEnumDetails? u) =>
                                                  u != null
                                                      ? u.displayValue
                                                      : "",
                                          hint: "Select Period",
                                          showSearchBox: false,
                                          selectedItem: propertyState
                                                      .minimumleasedurationValue !=
                                                  null
                                              ? propertyState
                                                  .minimumleasedurationValue
                                              : null,
                                          isFilteredOnline: true,
                                          onChanged: (value) {
                                            _changeData();
                                            AddEditProperty.isValueUpdate =
                                                true;

                                            _store.dispatch(
                                                UpdateMinimumLeasedurationValue(
                                                    value!));

                                            _store.dispatch(
                                                UpdateErrorMinimumleaseduration(
                                                    false));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [saveandnext(propertyState)],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  // Widget UpdateMethod() {
  //   if (Prefs.getBool(PrefsName.PropertyEditMode)) {
  //     if (!firsttime && !AddEditProperty.isValueUpdate) {
  //       AddEditProperty.isValueUpdate = true;
  //       firsttime = false;
  //     } else if (firsttime) {
  //       AddEditProperty.isValueUpdate = false;
  //       firsttime = false;
  //     }
  //   }

  //   return SizedBox(
  //     width: 0,
  //     height: 0,
  //   );
  // }

  Widget saveandnext(PropertyState propertyState) {
    return InkWell(
      onTap: () {
        /*String address = propertyState.PropertyName +
            ": " +
            propertyState.Suiteunit +
            " - " +
            propertyState.PropertyAddress +
            ", " +
            propertyState.City +
            ", " +
            propertyState.Province +
            ", " +
            propertyState.Postalcode +
            ", " +
            propertyState.CountryName;

        _store.dispatch(UpdatePropertyFormAddress(address));*/

        apiCallAndValidation(propertyState);
        //widget._callbackSaveandNext();
      },
      child: CustomeWidget.SaveAndNext(GlobleString.Save_and_next),
    );
  }

  void apiCallAndValidation(PropertyState propertyState) {
    if (propertyState.propertytypeValue == null) {
      _store.dispatch(UpdateErrorPropertytype(true));
      //_controller.jumpTo(-1.0);
      ToastUtils.showCustomToast(
          context, GlobleString.PS1_Property_type_error, false);
    } else if (propertyState.propertytypeValue!.EnumDetailID == 6 &&
        propertyState.propertytypeOtherValue.isEmpty) {
      //_controller.jumpTo(-1.0);
      _store.dispatch(UpdateErrorPropertytypeOther(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS1_Property_type_value_error, false);
    } else if (propertyState.rentalspaceValue == null) {
      //_controller.jumpTo(-1.0);
      _store.dispatch(UpdateErrorRentalspace(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS1_Rental_space_error, false);
    } else if (propertyState.PropertyName == "") {
      /* setState(() {
        FocusManager.instance.primaryFocus!.unfocus();
        FocusScope.of(context).requestFocus(_focus1);
      });*/

      // _controller.jumpTo(-1.0);
      _store.dispatch(UpdateErrorPropertyName(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS1_Property_name_error, false);
    } else if (propertyState.PropertyAddress == "") {
      // _controller.jumpTo(-1.0);
      _store.dispatch(UpdateErrorPropertyAddress(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS1_Property_address_error, false);
    } else if (propertyState.City == "") {
      // _controller.jumpTo(0.0);
      _store.dispatch(UpdateErrorCity(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS1_Property_City_error, false);
    } else if (propertyState.Province == "") {
      // _controller.jumpTo(0.0);
      _store.dispatch(UpdateErrorProvince(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS1_Property_province_error, false);
    } else if (propertyState.CountryName == "") {
      //_controller.jumpTo(0.0);
      _store.dispatch(UpdateErrorCountryName(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS1_Property_country_error, false);
    } else if (propertyState.Postalcode == "") {
      //_controller.jumpTo(0.0);
      _store.dispatch(UpdateErrorPostalcode(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS1_Property_postalcode_error, false);
    } else if (propertyState.RentAmount == "") {
      // _controller.jumpTo(1.0);
      _store.dispatch(UpdateErrorRentAmount(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS1_Property_rentamount_error, false);
    } else if (propertyState.rentpaymentFrequencyValue == null) {
      // _controller.jumpTo(1.0);
      _store.dispatch(UpdateErrorRentpaymentFrequency(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS1_Rent_payment_frequency_error, false);
    } else if (propertyState.leasetypeValue == null) {
      //_controller.jumpTo(1.0);
      _store.dispatch(UpdateErrorLeasetype(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS1_Lease_type_error, false);
    } else if (propertyState.dateofavailable == null) {
      //_controller.jumpTo(1.0);
      _store.dispatch(UpdateErrorDateofavailable(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS1_Date_available_error, false);
    } else if (propertyState.minimumleasedurationnumber == "") {
      // _controller.jumpTo(1.0);
      _store.dispatch(UpdateErrorMinimumleasedurationnumber(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS1_Minimum_lease_duration_value_error, false);
    } else if (propertyState.minimumleasedurationValue == null) {
      //_controller.jumpTo(1.0);
      _store.dispatch(UpdateErrorMinimumleaseduration(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS1_Minimum_lease_duration_error, false);
    } else {
      PropertyInsert propertyInsert = new PropertyInsert();
      propertyInsert.Property_Type =
          propertyState.propertytypeValue!.EnumDetailID.toString();
      propertyInsert.Rental_Space =
          propertyState.rentalspaceValue!.EnumDetailID.toString();
      propertyInsert.Rent_Payment_Frequency =
          propertyState.rentpaymentFrequencyValue!.EnumDetailID.toString();
      propertyInsert.Lease_Type =
          propertyState.leasetypeValue!.EnumDetailID.toString();
      propertyInsert.Min_Lease_Duration =
          propertyState.minimumleasedurationValue!.EnumDetailID.toString();
      propertyInsert.PropertyName = propertyState.PropertyName.toString();
      propertyInsert.Property_Address =
          propertyState.PropertyAddress.toString();
      propertyInsert.Property_Description =
          propertyState.PropertyDescription.toString();
      propertyInsert.City = propertyState.City.toString();
      propertyInsert.Province = propertyState.Province.toString();
      propertyInsert.Country = propertyState.CountryName.toString();
      propertyInsert.Country_Code = propertyState.CountryCode.toString();
      propertyInsert.Postal_Code = propertyState.Postalcode.toString();
      propertyInsert.Suite_Unit = propertyState.Suiteunit.toString();
      propertyInsert.Building_Name = propertyState.Buildingname.toString();
      propertyInsert.Other_Property_Type =
          propertyState.propertytypeOtherValue.toString();
      propertyInsert.Min_Lease_Number =
          propertyState.minimumleasedurationnumber.toString();
      propertyInsert.Rent_Amount = propertyState.RentAmount.toString();
      propertyInsert.Date_Available = propertyState.dateofavailable.toString();
      propertyInsert.Owner_ID = Prefs.getString(PrefsName.OwnerID);
      propertyInsert.Vacancy = propertyState.PropVacancy;

      updateSummeryData(propertyState);

      if (Prefs.getBool(PrefsName.PropertyEdit)) {
        PropertyUpdate cpropertyUpdate = new PropertyUpdate();
        cpropertyUpdate.ID = Prefs.getString(PrefsName.PropertyID);
        cpropertyUpdate.Owner_ID = Prefs.getString(PrefsName.OwnerID);

        if (propertyState.PropDrafting == 1 ||
            propertyState.PropDrafting == 0) {
          propertyInsert.PropDrafting = 1;
        } else {
          propertyInsert.PropDrafting = propertyState.PropDrafting;
        }

        ApiManager().UpdatePropertyDetails(
            context, cpropertyUpdate, propertyInsert, (error, respoce) async {
          if (error) {
            await Prefs.setBool(PrefsName.PropertyStep1, true);

            String address = propertyState.PropertyName +
                ": " +
                propertyState.Suiteunit +
                " - " +
                propertyState.PropertyAddress +
                ", " +
                propertyState.City +
                ", " +
                propertyState.Province +
                ", " +
                propertyState.Postalcode +
                ", " +
                propertyState.CountryName;

            _store.dispatch(UpdatePropertyFormAddress(address));
            _store
                .dispatch(UpdatePropertyDrafting(propertyInsert.PropDrafting!));
            _store.dispatch(
                UpdateSummeryPropertyDrafting(propertyInsert.PropDrafting!));

            ToastUtils.showCustomToast(
                context, GlobleString.PS_Save_Propertyse, true);

            if (!isGotoback) {
              if (stepper == 0)
                widget._callbackSaveandNext();
              else
                _store.dispatch(UpdatePropertyForm(stepper));
            } else {
              _store.dispatch(UpdatePortalPage(1, GlobleString.NAV_Properties));
            }
          } else {
            ToastUtils.showCustomToast(context, respoce, false);
          }
        });
      } else {
        propertyInsert.PropDrafting = propertyState.PropDrafting;

        ApiManager().InsertPropertyDetails(context, propertyInsert,
            (error, respoce) async {
          if (error) {
            await Prefs.setBool(PrefsName.PropertyEdit, true);
            await Prefs.setBool(PrefsName.PropertyStep1, true);
            await Prefs.setString(PrefsName.PropertyID, respoce.toString());

            String address = propertyState.PropertyName +
                ": " +
                propertyState.Suiteunit +
                " - " +
                propertyState.PropertyAddress +
                ", " +
                propertyState.City +
                ", " +
                propertyState.Province +
                ", " +
                propertyState.Postalcode +
                ", " +
                propertyState.CountryName;

            _store.dispatch(UpdatePropertyFormAddress(address));
            _store.dispatch(UpdatePropertyDrafting(1));
            _store.dispatch(UpdateSummeryPropertyDrafting(1));

            //widget._callbackSaveandNext();

            ToastUtils.showCustomToast(
                context, GlobleString.Property_creation, true);

            if (!isGotoback) {
              widget._callbackSaveandNext();
            } else {
              _store.dispatch(UpdatePortalPage(1, GlobleString.NAV_Properties));
            }
          } else {
            ToastUtils.showCustomToast(context, respoce, false);
          }
        });
      }
    }
  }

  void updateSummeryData(PropertyState propertyState) {
    _store.dispatch(
        UpdateSummeryProperTytypeValue(propertyState.propertytypeValue));
    _store.dispatch(UpdateSummeryPropertyTypeOtherValue(
        propertyState.propertytypeOtherValue));
    _store
        .dispatch(UpdateSummeryDateofavailable(propertyState.dateofavailable));
    _store.dispatch(
        UpdateSummeryRentalSpaceValue(propertyState.rentalspaceValue));
    _store.dispatch(UpdateSummeryPropertyName(propertyState.PropertyName));
    _store
        .dispatch(UpdateSummeryPropertyAddress(propertyState.PropertyAddress));
    _store.dispatch(
        UpdateSummeryPropertyDescription(propertyState.PropertyDescription));
    _store.dispatch(UpdateSummerySuiteunit(propertyState.Suiteunit));
    _store.dispatch(UpdateSummeryBuildingname(propertyState.Buildingname));
    _store.dispatch(UpdateSummeryPropertyCity(propertyState.City));
    _store
        .dispatch(UpdateSummeryPropertyCountryCode(propertyState.CountryCode));
    _store
        .dispatch(UpdateSummeryPropertyCountryName(propertyState.CountryName));
    _store.dispatch(UpdateSummeryPropertyProvince(propertyState.Province));
    _store.dispatch(UpdateSummeryPropertyPostalcode(propertyState.Postalcode));
    _store.dispatch(UpdateSummeryPropertyRentAmount(propertyState.RentAmount));
    _store.dispatch(UpdateSummeryRentPaymentFrequencyValue(
        propertyState.rentpaymentFrequencyValue));
    _store.dispatch(UpdateSummeryLeaseTypeValue(propertyState.leasetypeValue));
    _store.dispatch(UpdateSummeryMinimumLeasedurationValue(
        propertyState.minimumleasedurationValue));
    _store.dispatch(UpdateSummeryMinimumleasedurationNumber(
        propertyState.minimumleasedurationnumber.toString()));
  }
}
