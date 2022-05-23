import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:silverhome/domain/actions/landlord_action/tenancycurrenttenant_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancyform_actions.dart';
import 'package:silverhome/presentation/screens/landlord/tenancyform/tenancyapplicationfrom_screen.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';

import '../../../models/landlord_models/tf_currenttenancy_state.dart';

typedef VoidCallbackRecordStep = void Function(int stepper);

class TAFCurrentTenancyScreen extends StatefulWidget {
  final VoidCallback _callbackBack;
  final VoidCallback _callbackSaveandNext;
  final VoidCallback _callbackGotoBack;
  final VoidCallbackRecordStep _callbackRecordStep;

  TAFCurrentTenancyScreen({
    required VoidCallbackRecordStep onPressedRecordStep,
    required VoidCallback onPressedBack,
    required VoidCallback onPressedSave,
    required VoidCallback onPressGotoback,
  })  : _callbackBack = onPressedBack,
        _callbackSaveandNext = onPressedSave,
        _callbackGotoBack = onPressGotoback,
        _callbackRecordStep = onPressedRecordStep;

  @override
  _TAFCurrentTenancyScreenState createState() =>
      _TAFCurrentTenancyScreenState();
}

class _TAFCurrentTenancyScreenState extends State<TAFCurrentTenancyScreen> {
  double height = 0, width = 0;
  final _store = getIt<AppStore>();

  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  bool isGotoback = false;
  int stepper = 0;
  bool change = false;

  @override
  void initState() {
    initilizedata();
    initNavigationBack();
    TenancyApplicationFormScreen.changeFormData = false;
    super.initState();
  }

  initilizedata() {
    if (_store.state!.tfCurrentTenancyState != null) {
      TFCurrentTenancyState tfCurrentTenancyState =
          _store.state!.tfCurrentTenancyState;

      _store.dispatch(UpdateTFCurrenttenantStartDate(
          tfCurrentTenancyState.FNLct_startdate));
      _store.dispatch(
          UpdateTFCurrenttenantEndDate(tfCurrentTenancyState.FNLct_enddate));

      _store.dispatch(
          UpdateTFCurrenttenantSuiteUnit(tfCurrentTenancyState.FNLsuiteunit));
      _store.dispatch(
          UpdateTFCurrenttenantAddress(tfCurrentTenancyState.FNLct_address));
      _store.dispatch(
          UpdateTFCurrenttenantCity(tfCurrentTenancyState.FNLct_city));
      _store.dispatch(
          UpdateTFCurrenttenantProvince(tfCurrentTenancyState.FNLct_province));
      _store.dispatch(UpdateTFCurrenttenantPostalcode(
          tfCurrentTenancyState.FNLct_postalcode));
      _store.dispatch(UpdateTFCurrenttenantisReference(
          tfCurrentTenancyState.FNLcl_isReference));

      _store.dispatch(UpdateTFCurrenttenantFirstname(
          tfCurrentTenancyState.FNLcl_firstname));
      _store.dispatch(
          UpdateTFCurrenttenantLastname(tfCurrentTenancyState.FNLcl_lastname));
      _store.dispatch(
          UpdateTFCurrenttenantEmail(tfCurrentTenancyState.FNLcl_email));
      _store.dispatch(UpdateTFCurrenttenantPhonenumber(
          tfCurrentTenancyState.FNLcl_phonenumber));
      _store.dispatch(
          UpdateTFCurrenttenantCode(tfCurrentTenancyState.FNLcl_code));
      _store.dispatch(
          UpdateTFCurrenttenantDailCode(tfCurrentTenancyState.FNLcl_dailcode));
    }
  }

  initNavigationBack() {
    navigationNotifier.addListener(() {
      if (mounted) if (navigationNotifier.backScreen ==
          NavigationConstant.tenancyCurrentTenancy) {
        isGotoback = navigationNotifier.gotoBack;
        stepper = navigationNotifier.stepper;
        _saveDataAndNext(_store.state!.tfCurrentTenancyState);
      }
    });
  }

  _changeData() {
    if (!change) {
      TenancyApplicationFormScreen.changeFormData = true;
      change = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      //height: height - 250,
      margin: EdgeInsets.only(bottom: 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Form(),
          ],
        ),
      ),
    );
  }

  Future<void> _selectStartDate(
      BuildContext context, tfCurrentTenancyState) async {
    final DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: tfCurrentTenancyState.ct_enddate == null
          ? DateTime.now()
          : tfCurrentTenancyState.ct_enddate,
      firstDate: DateTime(1950),
      lastDate: tfCurrentTenancyState.ct_enddate == null
          ? DateTime.now()
          : tfCurrentTenancyState.ct_enddate,
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

    if (pickedStartDate != null &&
        pickedStartDate != tfCurrentTenancyState.ct_startdate) {
      _store.dispatch(UpdateTFCurrenttenantStartDate(pickedStartDate));
      _store.dispatch(UpdateTFCurrenttenantError_startdate(false));
      _changeData();
    }
  }

  Future<void> _selectEndDate(
      BuildContext context, tfCurrentTenancyState) async {
    final DateTime? pickedEndDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: tfCurrentTenancyState.ct_startdate == null
          ? DateTime(1950)
          : tfCurrentTenancyState.ct_startdate,
      lastDate: DateTime(2050),
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

    if (pickedEndDate != null &&
        pickedEndDate != tfCurrentTenancyState.ct_enddate) {
      _store.dispatch(UpdateTFCurrenttenantEndDate(pickedEndDate));
      _store.dispatch(UpdateTFCurrenttenantError_enddate(false));
      _changeData();
    }
  }

  Widget Form() {
    return Container(
      width: 1000,
      child: ConnectState<TFCurrentTenancyState>(
          map: (state) => state.tfCurrentTenancyState,
          where: notIdentical,
          builder: (tfCurrentTenancyState) {
            return FocusScope(
                node: _focusScopeNode,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            GlobleString.TAF_Current_tenancy,
                            style: MyStyles.SemiBold(20, myColor.text_color),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 220,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                GlobleString.TAF_CT_start_date,
                                style: MyStyles.Medium(13, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextButton(
                                onPressed: () {
                                  _selectStartDate(
                                      context, tfCurrentTenancyState);
                                },
                                autofocus: true,
                                child: Container(
                                  width: 220,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          tfCurrentTenancyState!.error_startdate
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
                                            tfCurrentTenancyState
                                                        .ct_startdate ==
                                                    null
                                                ? ""
                                                : new DateFormat("dd-MMM-yyyy")
                                                    .format(
                                                        tfCurrentTenancyState
                                                            .ct_startdate!)
                                                    .toString(),
                                            style: MyStyles.Medium(
                                                13, myColor.text_color),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: 8, right: 5),
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
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: 220,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                GlobleString.TAF_CT_end_date,
                                style: MyStyles.Medium(13, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextButton(
                                onPressed: () {
                                  _selectEndDate(
                                      context, tfCurrentTenancyState);
                                },
                                child: Container(
                                  width: 220,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: tfCurrentTenancyState.error_enddate
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
                                            tfCurrentTenancyState.ct_enddate ==
                                                    null
                                                ? ""
                                                : new DateFormat("dd-MMM-yyyy")
                                                    .format(
                                                        tfCurrentTenancyState
                                                            .ct_enddate!)
                                                    .toString(),
                                            style: MyStyles.Medium(
                                                13, myColor.text_color),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: 8, right: 5),
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
                        Container(
                          width: 130,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    GlobleString.TAF_CT_suite_unit,
                                    style:
                                        MyStyles.Medium(13, myColor.text_color),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    GlobleString.Optional,
                                    style:
                                        MyStyles.Regular(12, myColor.optional),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                initialValue: tfCurrentTenancyState.suiteunit,
                                textAlign: TextAlign.start,
                                style: MyStyles.Medium(13, myColor.text_color),
                                decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: myColor.blue, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: myColor.gray, width: 1.0),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(10),
                                    fillColor: myColor.white,
                                    filled: true),
                                onChanged: (value) {
                                  _store.dispatch(
                                      UpdateTFCurrenttenantSuiteUnit(
                                          value.toString()));
                                  _changeData();
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                GlobleString.TAF_CT_Address,
                                style: MyStyles.Medium(13, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                initialValue: tfCurrentTenancyState.ct_address,
                                textAlign: TextAlign.start,
                                style: MyStyles.Medium(13, myColor.text_color),
                                decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: tfCurrentTenancyState
                                                  .error_address
                                              ? myColor.errorcolor
                                              : myColor.blue,
                                          width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: tfCurrentTenancyState
                                                  .error_address
                                              ? myColor.errorcolor
                                              : myColor.gray,
                                          width: 1.0),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(10),
                                    fillColor: myColor.white,
                                    filled: true),
                                onChanged: (value) {
                                  _store.dispatch(UpdateTFCurrenttenantAddress(
                                      value.toString()));
                                  _store.dispatch(
                                      UpdateTFCurrenttenantError_address(
                                          false));
                                  _changeData();
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: 220,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                GlobleString.TAF_CT_City,
                                style: MyStyles.Medium(13, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                initialValue: tfCurrentTenancyState.ct_city,
                                textAlign: TextAlign.start,
                                style: MyStyles.Medium(13, myColor.text_color),
                                decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              tfCurrentTenancyState.error_city
                                                  ? myColor.errorcolor
                                                  : myColor.blue,
                                          width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              tfCurrentTenancyState.error_city
                                                  ? myColor.errorcolor
                                                  : myColor.gray,
                                          width: 1.0),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(10),
                                    fillColor: myColor.white,
                                    filled: true),
                                onChanged: (value) {
                                  _store.dispatch(UpdateTFCurrenttenantCity(
                                      value.toString()));
                                  _store.dispatch(
                                      UpdateTFCurrenttenantError_city(false));
                                  _changeData();
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                GlobleString.TAF_CT_Province,
                                style: MyStyles.Medium(13, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                initialValue: tfCurrentTenancyState.ct_province,
                                textAlign: TextAlign.start,
                                style: MyStyles.Medium(13, myColor.text_color),
                                decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: tfCurrentTenancyState
                                                  .error_province
                                              ? myColor.errorcolor
                                              : myColor.blue,
                                          width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: tfCurrentTenancyState
                                                  .error_province
                                              ? myColor.errorcolor
                                              : myColor.gray,
                                          width: 1.0),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(10),
                                    fillColor: myColor.white,
                                    filled: true),
                                onChanged: (value) {
                                  _store.dispatch(UpdateTFCurrenttenantProvince(
                                      value.toString()));
                                  _store.dispatch(
                                      UpdateTFCurrenttenantError_province(
                                          false));
                                  _changeData();
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                GlobleString.TAF_CT_Postal_code,
                                style: MyStyles.Medium(13, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                initialValue:
                                    tfCurrentTenancyState.ct_postalcode,
                                textAlign: TextAlign.start,
                                style: MyStyles.Medium(13, myColor.text_color),
                                decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: tfCurrentTenancyState
                                                  .error_postalcode
                                              ? myColor.errorcolor
                                              : myColor.blue,
                                          width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: tfCurrentTenancyState
                                                  .error_postalcode
                                              ? myColor.errorcolor
                                              : myColor.gray,
                                          width: 1.0),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(10),
                                    fillColor: myColor.white,
                                    filled: true),
                                onChanged: (value) {
                                  _store.dispatch(
                                      UpdateTFCurrenttenantPostalcode(
                                          value.toString()));
                                  _store.dispatch(
                                      UpdateTFCurrenttenantError_postalcode(
                                          false));
                                  _changeData();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            GlobleString.TAF_CT_Current_landlord,
                            style: MyStyles.SemiBold(16, myColor.text_color),
                            textAlign: TextAlign.center,
                          ),
                        ],
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
                                GlobleString.TAF_CT_first_name,
                                style: MyStyles.Medium(
                                    13,
                                    Prefs.getBool(
                                            PrefsName
                                                .TCF_Current_isReference_Receive,
                                            false)
                                        ? myColor.disablecolor
                                        : myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                initialValue:
                                    tfCurrentTenancyState.cl_firstname,
                                textAlign: TextAlign.start,
                                readOnly: Prefs.getBool(
                                    PrefsName.TCF_Current_isReference_Receive,
                                    false),
                                style: MyStyles.Medium(
                                    13,
                                    Prefs.getBool(
                                            PrefsName
                                                .TCF_Current_isReference_Receive,
                                            false)
                                        ? myColor.disablecolor
                                        : myColor.text_color),
                                decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: tfCurrentTenancyState
                                                  .error_firstname
                                              ? myColor.errorcolor
                                              : Prefs.getBool(
                                                      PrefsName
                                                          .TCF_Current_isReference_Receive,
                                                      false)
                                                  ? myColor.disablecolor
                                                  : myColor.gray,
                                          width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: tfCurrentTenancyState
                                                  .error_firstname
                                              ? myColor.errorcolor
                                              : Prefs.getBool(
                                                      PrefsName
                                                          .TCF_Current_isReference_Receive,
                                                      false)
                                                  ? myColor.disablecolor
                                                  : myColor.gray,
                                          width: 1.0),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(10),
                                    fillColor: myColor.white,
                                    filled: true),
                                onChanged: (value) {
                                  _store.dispatch(
                                      UpdateTFCurrenttenantFirstname(
                                          value.toString()));
                                  _store.dispatch(
                                      UpdateTFCurrenttenantError_firstname(
                                          false));
                                  _changeData();
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                GlobleString.TAF_CT_Last_name,
                                style: MyStyles.Medium(
                                    13,
                                    Prefs.getBool(
                                            PrefsName
                                                .TCF_Current_isReference_Receive,
                                            false)
                                        ? myColor.disablecolor
                                        : myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                initialValue: tfCurrentTenancyState.cl_lastname,
                                textAlign: TextAlign.start,
                                readOnly: Prefs.getBool(
                                    PrefsName.TCF_Current_isReference_Receive,
                                    false),
                                style: MyStyles.Medium(
                                    13,
                                    Prefs.getBool(
                                            PrefsName
                                                .TCF_Current_isReference_Receive,
                                            false)
                                        ? myColor.disablecolor
                                        : myColor.text_color),
                                decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: tfCurrentTenancyState
                                                  .error_lastname
                                              ? myColor.errorcolor
                                              : Prefs.getBool(
                                                      PrefsName
                                                          .TCF_Current_isReference_Receive,
                                                      false)
                                                  ? myColor.disablecolor
                                                  : myColor.gray,
                                          width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: tfCurrentTenancyState
                                                  .error_lastname
                                              ? myColor.errorcolor
                                              : Prefs.getBool(
                                                      PrefsName
                                                          .TCF_Current_isReference_Receive,
                                                      false)
                                                  ? myColor.disablecolor
                                                  : myColor.gray,
                                          width: 1.0),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(10),
                                    fillColor: myColor.white,
                                    filled: true),
                                onChanged: (value) {
                                  _store.dispatch(UpdateTFCurrenttenantLastname(
                                      value.toString()));
                                  _store.dispatch(
                                      UpdateTFCurrenttenantError_lastname(
                                          false));
                                  _changeData();
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: 300,
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
                                GlobleString.TAF_CT_Email_address,
                                style: MyStyles.Medium(
                                    13,
                                    Prefs.getBool(
                                            PrefsName
                                                .TCF_Current_isReference_Receive,
                                            false)
                                        ? myColor.disablecolor
                                        : myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                initialValue: tfCurrentTenancyState.cl_email,
                                textAlign: TextAlign.start,
                                readOnly: Prefs.getBool(
                                    PrefsName.TCF_Current_isReference_Receive,
                                    false),
                                style: MyStyles.Medium(
                                    13,
                                    Prefs.getBool(
                                            PrefsName
                                                .TCF_Current_isReference_Receive,
                                            false)
                                        ? myColor.disablecolor
                                        : myColor.text_color),
                                decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: tfCurrentTenancyState
                                                  .error_email
                                              ? myColor.errorcolor
                                              : Prefs.getBool(
                                                      PrefsName
                                                          .TCF_Current_isReference_Receive,
                                                      false)
                                                  ? myColor.disablecolor
                                                  : myColor.gray,
                                          width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: tfCurrentTenancyState
                                                  .error_email
                                              ? myColor.errorcolor
                                              : Prefs.getBool(
                                                      PrefsName
                                                          .TCF_Current_isReference_Receive,
                                                      false)
                                                  ? myColor.disablecolor
                                                  : myColor.gray,
                                          width: 1.0),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(10),
                                    fillColor: myColor.white,
                                    filled: true),
                                onChanged: (value) {
                                  _store.dispatch(UpdateTFCurrenttenantEmail(
                                      value.toString()));
                                  _store.dispatch(
                                      UpdateTFCurrenttenantError_email(false));
                                  _changeData();
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                GlobleString.TAF_CT_Phone_number,
                                style: MyStyles.Medium(
                                    13,
                                    Prefs.getBool(
                                            PrefsName
                                                .TCF_Current_isReference_Receive,
                                            false)
                                        ? myColor.disablecolor
                                        : myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: tfCurrentTenancyState
                                            .error_phonenumber
                                        ? myColor.errorcolor
                                        : Prefs.getBool(
                                                PrefsName
                                                    .TCF_Current_isReference_Receive,
                                                false)
                                            ? myColor.disablecolor
                                            : myColor.gray,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CountryCodePicker(
                                      onChanged: (value) async {
                                        _store.dispatch(
                                            UpdateTFCurrenttenantCode(
                                                value.code.toString()));
                                        _store.dispatch(
                                            UpdateTFCurrenttenantDailCode(
                                                value.dialCode.toString()));
                                        _changeData();
                                      },
                                      initialSelection:
                                          tfCurrentTenancyState.cl_code,
                                      showFlag: true,
                                      textStyle: MyStyles.Medium(
                                          13, myColor.text_color),
                                      dialogTextStyle: MyStyles.Medium(
                                          13, myColor.text_color),
                                      enabled: !Prefs.getBool(
                                          PrefsName
                                              .TCF_Current_isReference_Receive,
                                          false),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: tfCurrentTenancyState
                                            .cl_phonenumber,
                                        keyboardType: TextInputType.phone,
                                        readOnly: Prefs.getBool(
                                            PrefsName
                                                .TCF_Current_isReference_Receive,
                                            false),
                                        inputFormatters: [
                                          MaskedInputFormatter("(000) 000 0000")
                                        ],
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                              color: Prefs.getBool(
                                                      PrefsName
                                                          .TCF_Current_isReference_Receive,
                                                      false)
                                                  ? myColor.disablecolor
                                                  : Colors.grey),
                                          contentPadding: EdgeInsets.all(10),
                                          isDense: true,
                                        ),
                                        style: MyStyles.Medium(
                                            13,
                                            Prefs.getBool(
                                                    PrefsName
                                                        .TCF_Current_isReference_Receive,
                                                    false)
                                                ? myColor.disablecolor
                                                : myColor.text_color),
                                        onChanged: (value) {
                                          _store.dispatch(
                                              UpdateTFCurrenttenantPhonenumber(
                                                  value.toString()));
                                          _store.dispatch(
                                              UpdateTFCurrenttenantError_phonenumber(
                                                  false));
                                          _changeData();
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
                          width: 15,
                        ),
                        Container(
                          width: 300,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Prefs.getBool(
                                      PrefsName.TCF_Current_isReference_Receive,
                                      false)
                                  ? Checkbox(
                                      activeColor: myColor.disablecolor,
                                      checkColor: myColor.white,
                                      value: Prefs.getBool(
                                          PrefsName
                                              .TCF_Current_isReference_Receive,
                                          false),
                                      onChanged: (value) {
                                        _changeData();
                                      },
                                    )
                                  : Checkbox(
                                      activeColor: myColor.Circle_main,
                                      checkColor: myColor.white,
                                      value:
                                          tfCurrentTenancyState.cl_isReference,
                                      onChanged: (value) {
                                        _store.dispatch(
                                            UpdateTFCurrenttenantisReference(
                                                value!));
                                        _changeData();
                                      },
                                    ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                GlobleString.TAF_CT_aggree,
                                style: MyStyles.Medium(
                                    12,
                                    Prefs.getBool(
                                            PrefsName
                                                .TCF_Current_isReference_Receive,
                                            false)
                                        ? myColor.disablecolor
                                        : myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        back(),
                        SizedBox(width: 10),
                        saveandnext(tfCurrentTenancyState)
                      ],
                    ),
                  ],
                ));
          }),
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

  Widget saveandnext(TFCurrentTenancyState tfCurrentTenancyState) {
    return InkWell(
      onTap: () => _saveDataAndNext(tfCurrentTenancyState),
      child: CustomeWidget.SaveAndNext(GlobleString.Save_and_next),
    );
  }

  _saveDataAndNext(TFCurrentTenancyState tfCurrentTenancyState) async {
    DateTime? startdate = tfCurrentTenancyState.ct_startdate;
    DateTime? enddate = tfCurrentTenancyState.ct_enddate;
    String suiteunit = tfCurrentTenancyState.suiteunit.toString().trim();
    String ct_address = tfCurrentTenancyState.ct_address.toString().trim();
    String ct_city = tfCurrentTenancyState.ct_city.toString().trim();
    String ct_province = tfCurrentTenancyState.ct_province.toString().trim();
    String ct_postalcode =
        tfCurrentTenancyState.ct_postalcode.toString().trim();
    String cl_firstname = tfCurrentTenancyState.cl_firstname.toString().trim();
    String cl_lastname = tfCurrentTenancyState.cl_lastname.toString().trim();
    String cl_email = tfCurrentTenancyState.cl_email.toString().trim();
    String cl_phonenumber =
        tfCurrentTenancyState.cl_phonenumber.toString().trim();
    bool cl_isReference = tfCurrentTenancyState.cl_isReference;

    if (startdate == null) {
      _store.dispatch(UpdateTFCurrenttenantError_startdate(true));
      ToastUtils.showCustomToast(
          context, GlobleString.taf_currenttenancy_error_startdate, false);
    } else if (enddate == null) {
      _store.dispatch(UpdateTFCurrenttenantError_enddate(true));
      ToastUtils.showCustomToast(
          context, GlobleString.taf_currenttenancy_error_enddate, false);
    }
    /*else if (suiteunit.isEmpty) {
          ToastUtils.showCustomToast(
              context, GlobleString.taf_currenttenancy_error_suiteunit, false);
        }*/
    else if (ct_address.isEmpty) {
      _store.dispatch(UpdateTFCurrenttenantError_address(true));
      ToastUtils.showCustomToast(
          context, GlobleString.taf_currenttenancy_error_address, false);
    } else if (ct_city.isEmpty) {
      _store.dispatch(UpdateTFCurrenttenantError_city(true));
      ToastUtils.showCustomToast(
          context, GlobleString.taf_currenttenancy_error_city, false);
    } else if (ct_province.isEmpty) {
      _store.dispatch(UpdateTFCurrenttenantError_province(true));
      ToastUtils.showCustomToast(
          context, GlobleString.taf_currenttenancy_error_province, false);
    } else if (ct_postalcode.isEmpty) {
      _store.dispatch(UpdateTFCurrenttenantError_postalcode(true));
      ToastUtils.showCustomToast(
          context, GlobleString.taf_currenttenancy_error_postalcode, false);
    } else if (cl_firstname.isEmpty) {
      _store.dispatch(UpdateTFCurrenttenantError_firstname(true));
      ToastUtils.showCustomToast(
          context, GlobleString.taf_currenttenancy_error_firstname, false);
    } else if (cl_lastname.isEmpty) {
      _store.dispatch(UpdateTFCurrenttenantError_lastname(true));
      ToastUtils.showCustomToast(
          context, GlobleString.taf_currenttenancy_error_lastname, false);
    } else if (cl_email.isEmpty) {
      _store.dispatch(UpdateTFCurrenttenantError_email(true));
      ToastUtils.showCustomToast(
          context, GlobleString.taf_currenttenancy_error_email, false);
    } else if (Helper.ValidEmail(cl_email) != true) {
      _store.dispatch(UpdateTFCurrenttenantError_email(true));
      ToastUtils.showCustomToast(
          context, GlobleString.taf_currenttenancy_error_valid_email, false);
    } else if (cl_phonenumber.isEmpty) {
      _store.dispatch(UpdateTFCurrenttenantError_phonenumber(true));
      ToastUtils.showCustomToast(
          context, GlobleString.taf_currenttenancy_error_mobile, false);
    } else if (Helper.ValidPhonenumber(cl_phonenumber)) {
      _store.dispatch(UpdateTFCurrenttenantError_phonenumber(true));
      ToastUtils.showCustomToast(
          context, GlobleString.taf_currenttenancy_error_validmobile, false);
    } else {
      // ToastUtils.showCustomToast(context, "Success", true);

      String dd_startdate = new DateFormat("yyyy-MM-dd").format(startdate);
      String dd_enddate = new DateFormat("yyyy-MM-dd").format(enddate);

      if (tfCurrentTenancyState.isUpdate &&
          tfCurrentTenancyState.CurrentTenancyID != "" &&
          tfCurrentTenancyState.CurrentLandLordID != "") {
        UpdateCurrentLandLord updateCurrentLandLord =
            new UpdateCurrentLandLord();
        updateCurrentLandLord.ID = tfCurrentTenancyState.CurrentLandLordID;
        updateCurrentLandLord.FirstName = cl_firstname;
        updateCurrentLandLord.LastName = cl_lastname;
        updateCurrentLandLord.Email = cl_email;
        updateCurrentLandLord.MobileNumber = cl_phonenumber;
        updateCurrentLandLord.Country_Code = tfCurrentTenancyState.cl_code;
        updateCurrentLandLord.Dial_Code = tfCurrentTenancyState.cl_dailcode;

        UpdateCurrentTenancy updateCurrentTenancy = new UpdateCurrentTenancy();
        updateCurrentTenancy.Applicant_ID =
            Prefs.getString(PrefsName.TCF_ApplicantID);
        updateCurrentTenancy.Start_Date = dd_startdate;
        updateCurrentTenancy.End_Date = dd_enddate;
        updateCurrentTenancy.Suite = suiteunit;
        updateCurrentTenancy.Address = ct_address;
        updateCurrentTenancy.City = ct_city;
        updateCurrentTenancy.Province = ct_province;
        updateCurrentTenancy.PostalCode = ct_postalcode;
        updateCurrentTenancy.CurrentLandLordIschecked_As_Reference =
            cl_isReference;
        updateCurrentTenancy.currentLandLord = updateCurrentLandLord;

        ClauseCurrentTenancy clauseCurrentTenancy = new ClauseCurrentTenancy();
        clauseCurrentTenancy.Applicant_ID =
            Prefs.getString(PrefsName.TCF_ApplicantID);

        Prefs.setBool(PrefsName.TCF_Current_isReference, cl_isReference);

        await ApiManager().UpdateTFCurrentTenancy(
            context, clauseCurrentTenancy, updateCurrentTenancy,
            (status, responce) async {
          if (status) {
            if (cl_isReference) {
              await CheckAsReference();
            } else {
              await DeleteAsReference();
            }
          } else {
            ToastUtils.showCustomToast(context, responce, false);
          }
        });
      } else {
        CurrentLandLord currentLandLord = new CurrentLandLord();
        currentLandLord.FirstName = cl_firstname;
        currentLandLord.LastName = cl_lastname;
        currentLandLord.Email = cl_email;
        currentLandLord.MobileNumber = cl_phonenumber;
        currentLandLord.Country_Code = tfCurrentTenancyState.cl_code;
        currentLandLord.Dial_Code = tfCurrentTenancyState.cl_dailcode;

        InsertCurrentTenancy insertCurrentTenancy = new InsertCurrentTenancy();
        insertCurrentTenancy.Applicant_ID =
            Prefs.getString(PrefsName.TCF_ApplicantID);
        insertCurrentTenancy.Start_Date = dd_startdate;
        insertCurrentTenancy.End_Date = dd_enddate;
        insertCurrentTenancy.Suite = suiteunit;
        insertCurrentTenancy.Address = ct_address;
        insertCurrentTenancy.City = ct_city;
        insertCurrentTenancy.Province = ct_province;
        insertCurrentTenancy.PostalCode = ct_postalcode;
        insertCurrentTenancy.CurrentLandLordIschecked_As_Reference =
            cl_isReference;
        insertCurrentTenancy.currentLandLord = currentLandLord;

        Prefs.setBool(PrefsName.TCF_Current_isReference, cl_isReference);

        ApiManager().InsetTFCurrentTenancy(context, insertCurrentTenancy,
            (status, responce) {
          if (status) {
            if (cl_isReference) {
              InsertAsReference();
            } else {
              gotoNext();
            }
          } else {
            ToastUtils.showCustomToast(context, responce, false);
          }
        });
      }
    }
  }

  InsertAsReference() {
    ClauseCurrentTenancy currentLandLord = new ClauseCurrentTenancy();
    currentLandLord.Applicant_ID = Prefs.getString(PrefsName.TCF_ApplicantID);

    ApiManager().getCurrentLandLordIDinTenancy(context, currentLandLord,
        (status, responce) {
      if (status) {
        Prefs.setString(PrefsName.TCF_CurrentlandlordID, responce);

        AdditionalReferencesAsCurrentTenancy arc =
            new AdditionalReferencesAsCurrentTenancy();
        arc.Applicantion_ID = Prefs.getString(PrefsName.TCF_ApplicationID);
        arc.RelationWithApplicant = "Current Landlord";
        arc.referenceID = responce;

        ApiManager().InsertCurrentLandLordAsReference(context, arc,
            (status, responce) {
          if (status) {
            gotoNext();
          } else {
            ToastUtils.showCustomToast(context, responce, false);
          }
        });
      } else {
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
  }

  CheckAsReference() {
    CheckReferenceExit currentLandLord = new CheckReferenceExit();
    currentLandLord.ReferenceID =
        Prefs.getString(PrefsName.TCF_CurrentlandlordID);

    ApiManager().CheckReferenceCurrentLandLord(context, currentLandLord,
        (status, responce) {
      if (status) {
        gotoNext();
      } else {
        AdditionalReferencesAsCurrentTenancy arc =
            new AdditionalReferencesAsCurrentTenancy();
        arc.Applicantion_ID = Prefs.getString(PrefsName.TCF_ApplicationID);
        arc.RelationWithApplicant = "Current Landlord";
        arc.referenceID = Prefs.getString(PrefsName.TCF_CurrentlandlordID);

        ApiManager().InsertCurrentLandLordAsReference(context, arc,
            (status, responce) {
          if (status) {
            gotoNext();
          } else {
            ToastUtils.showCustomToast(context, responce, false);
          }
        });
      }
    });
  }

  DeleteAsReference() {
    CheckReferenceExit currentLandLord = new CheckReferenceExit();
    currentLandLord.ReferenceID =
        Prefs.getString(PrefsName.TCF_CurrentlandlordID);

    ApiManager().DeleteReferenceCurrentLandLord(context, currentLandLord,
        (status, responce) {
      gotoNext();
    });
  }

  void gotoNext() {
    if (!isGotoback) {
      Prefs.setBool(PrefsName.TCF_Step3, true);
      if (stepper == 0) {
        widget._callbackSaveandNext();
      } else {
        widget._callbackRecordStep(stepper);
        //_store.dispatch(UpdateTenacyFormIndex(stepper));
      }
    } else {
      widget._callbackGotoBack();
    }
  }
}
