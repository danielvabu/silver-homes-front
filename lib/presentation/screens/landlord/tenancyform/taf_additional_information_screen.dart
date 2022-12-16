import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/navigation_constants.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancyaddinfo_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancyform_actions.dart';
import 'package:silverhome/domain/entities/tenancy_additional_info.dart';
import 'package:silverhome/presentation/screens/landlord/tenancyform/tenancyapplicationfrom_screen.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_filter.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/tabclass.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/widget/alert/alert_dialogbox.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

import '../../../models/landlord_models/tf_additonal_info_state.dart';

typedef VoidCallbackRecordStep = void Function(int stepper);

class TAFAdditionalInformationScreen extends StatefulWidget {
  final VoidCallback _callbackBack;
  final VoidCallback _callbackSaveandNext;
  final VoidCallback _callabackGotoBack;
  final VoidCallbackRecordStep _callbackRecordStep;

  TAFAdditionalInformationScreen({
    required VoidCallbackRecordStep onPressedRecordStep,
    required VoidCallback onPressedBack,
    required VoidCallback onPressedSave,
    required VoidCallback onPressGotoBack,
  })  : _callbackBack = onPressedBack,
        _callbackSaveandNext = onPressedSave,
        _callabackGotoBack = onPressGotoBack,
        _callbackRecordStep = onPressedRecordStep;

  @override
  _TAFAdditionalInformationScreenState createState() => _TAFAdditionalInformationScreenState();
}

class _TAFAdditionalInformationScreenState extends State<TAFAdditionalInformationScreen> {
  final _store = getIt<AppStore>();
  double height = 0, width = 0;

  late OverlayEntry loader;
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  bool isGotoback = false;
  int stepper = 0;
  bool change = false;

  @override
  void initState() {
    super.initState();

    List<SystemEnumDetails> tenancylengthlist = [];
    tenancylengthlist = QueryFilter().PlainValues(eSystemEnums().TenancyLength);
    _store.dispatch(UpdateTFAdditionalInfoLenthOfTenancyList(tenancylengthlist));

    List<SystemEnumDetails> Periodlist = [];
    Periodlist = QueryFilter().PlainValues(eSystemEnums().MinLeaseDuration);
    _store.dispatch(UpdateTFAdditionalInfoPeriodlist(Periodlist));
    initilizedata();
    initNavigationBack();
    TenancyApplicationFormScreen.changeFormData = false;
  }

  initilizedata() {
    if (_store.state!.tfAdditionalInfoState != null) {
      TFAdditionalInfoState tfAdditionalInfoState = _store.state!.tfAdditionalInfoState;

      _store.dispatch(UpdateTFAdditionalInfoTenancyStartDate(tfAdditionalInfoState.FNLtenancystartdate));

      _store.dispatch(UpdateTFAdditionalInfoisSmoking(tfAdditionalInfoState.FNLisSmoking));
      _store.dispatch(UpdateTFAdditionalInfoIspets(tfAdditionalInfoState.FNLisPets));
      _store.dispatch(UpdateTFAdditionalInfoisVehical(tfAdditionalInfoState.FNLisVehical));
      _store.dispatch(UpdateTFAdditionalInfoComment(tfAdditionalInfoState.FNLComment));
      _store.dispatch(UpdateTFAdditionalInfoLenthOfTenancy(tfAdditionalInfoState.FNLlenthoftenancy));
      _store.dispatch(UpdateTFAdditionalInfoPeriodValue(tfAdditionalInfoState.FNLPeriodValue));
      _store.dispatch(UpdateTFAdditionalInfolenthoftenancynumber(tfAdditionalInfoState.FNLlenthoftenancynumber));

      _store.dispatch(UpdateTFAdditionalInfoPetslist([]));

      List<Pets> secondList = tfAdditionalInfoState.FNLpetslist.map((item) => new Pets.clone(item)).toList();

      _store.dispatch(UpdateTFAdditionalInfoPetslist(secondList));

      _store.dispatch(UpdateTFAdditionalInfoVehicallist([]));

      List<Vehical> secondVehicalList = tfAdditionalInfoState.FNLvehicallist.map((item) => new Vehical.clone(item)).toList();

      _store.dispatch(UpdateTFAdditionalInfoVehicallist(secondVehicalList));
    }
  }

  initNavigationBack() {
    navigationNotifier.addListener(() {
      if (mounted) if (navigationNotifier.backScreen == NavigationConstant.tenancyAdditionalInfo) {
        isGotoback = navigationNotifier.gotoBack;
        stepper = navigationNotifier.stepper;
        Helper.Log("back", navigationNotifier.backScreen);
        _saveDataAndNext(_store.state!.tfAdditionalInfoState);
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

  Future<void> _selectDate(BuildContext context, tfAdditionalInfoState) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2090),
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

    if (pickedDate != null && pickedDate != tfAdditionalInfoState.tenancystartdate)
      _store.dispatch(UpdateTFAdditionalInfoTenancyStartDate(pickedDate));
    _store.dispatch(UpdateTFAdditionalInfoError_tenancystartdate(false));
    _changeData();
  }

  Widget Form() {
    return Container(
      width: 1000,
      child: ConnectState<TFAdditionalInfoState>(
          map: (state) => state.tfAdditionalInfoState,
          where: notIdentical,
          builder: (tfAdditionalInfoState) {
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
                            GlobleString.TAF_Additional_information,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                GlobleString.TAF_AI_Pets,
                                style: MyStyles.Medium(13, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: FlutterSwitch(
                                  width: 65.0,
                                  height: 30.0,
                                  valueFontSize: 12.0,
                                  toggleSize: 20.0,
                                  value: tfAdditionalInfoState!.isPets,
                                  borderRadius: 30.0,
                                  padding: 4.0,
                                  activeColor: Colors.lightGreen,
                                  activeText: "Yes",
                                  activeTextColor: myColor.white,
                                  inactiveColor: myColor.gray,
                                  inactiveText: "No",
                                  inactiveTextColor: myColor.white,
                                  showOnOff: true,
                                  onToggle: (val) {
                                    _store.dispatch(UpdateTFAdditionalInfoIspets(val));

                                    if (val) {
                                      List<Pets> petslist = [];

                                      Pets pet = new Pets();
                                      pet.id = "1";
                                      pet.typeofpets = "";
                                      pet.size = "";
                                      pet.age = "";
                                      pet.error_typeofpets = false;
                                      pet.error_size = false;
                                      pet.error_age = false;
                                      petslist.add(pet);

                                      _store.dispatch(UpdateTFAdditionalInfoPetslist(petslist));
                                    } else {
                                      _store.dispatch(UpdateTFAdditionalInfoPetslist(List.empty()));
                                    }
                                    _changeData();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        tfAdditionalInfoState.isPets
                            ? Container(
                                width: 935,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            key: UniqueKey(),
                                            itemCount: tfAdditionalInfoState.petslist.length,
                                            itemBuilder: (BuildContext ctxt, int Index) {
                                              Pets pets = tfAdditionalInfoState.petslist[Index];
                                              return Container(
                                                margin: EdgeInsets.only(bottom: 10),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 25,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            GlobleString.TAF_AI_Type_Pets,
                                                            style: MyStyles.Medium(13, myColor.text_color),
                                                            textAlign: TextAlign.start,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          TextFormField(
                                                            autofocus: true,
                                                            initialValue: pets.typeofpets,
                                                            textAlign: TextAlign.start,
                                                            style: MyStyles.Medium(13, myColor.text_color),
                                                            keyboardType: TextInputType.text,
                                                            textCapitalization: TextCapitalization.sentences,
                                                            decoration: InputDecoration(
                                                                //border: InputBorder.none,

                                                                focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(color: myColor.blue, width: 1.0),
                                                                ),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: pets.error_typeofpets! ? myColor.errorcolor : myColor.gray,
                                                                      width: 1.0),
                                                                ),
                                                                isDense: true,
                                                                contentPadding: EdgeInsets.all(10),
                                                                fillColor: myColor.white,
                                                                filled: true),
                                                            onChanged: (value) {
                                                              tfAdditionalInfoState.petslist[Index].typeofpets = value.toString();

                                                              tfAdditionalInfoState.petslist[Index].error_typeofpets = false;
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
                                                            GlobleString.TAF_AI_pets_size,
                                                            style: MyStyles.Medium(13, myColor.text_color),
                                                            textAlign: TextAlign.start,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          TextFormField(
                                                            initialValue: pets.size,
                                                            textAlign: TextAlign.start,
                                                            style: MyStyles.Medium(13, myColor.text_color),
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter.allow(RegExp("[0-9 .]")),
                                                            ],
                                                            decoration: InputDecoration(
                                                                //border: InputBorder.none,
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(color: myColor.blue, width: 1.0),
                                                                ),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: pets.error_size! ? myColor.errorcolor : myColor.gray,
                                                                      width: 1.0),
                                                                ),
                                                                isDense: true,
                                                                contentPadding: EdgeInsets.all(10),
                                                                fillColor: myColor.white,
                                                                filled: true),
                                                            onChanged: (value) {
                                                              tfAdditionalInfoState.petslist[Index].size = value.toString();

                                                              tfAdditionalInfoState.petslist[Index].error_size = false;
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
                                                            GlobleString.TAF_AI_pets_age,
                                                            style: MyStyles.Medium(13, myColor.text_color),
                                                            textAlign: TextAlign.start,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          TextFormField(
                                                            initialValue: pets.age,
                                                            textAlign: TextAlign.start,
                                                            style: MyStyles.Medium(13, myColor.text_color),
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                                            ],
                                                            decoration: InputDecoration(
                                                                //border: InputBorder.none,
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(color: myColor.blue, width: 1.0),
                                                                ),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: pets.error_age! ? myColor.errorcolor : myColor.gray,
                                                                      width: 1.0),
                                                                ),
                                                                isDense: true,
                                                                contentPadding: EdgeInsets.all(10),
                                                                fillColor: myColor.white,
                                                                filled: true),
                                                            onChanged: (value) {
                                                              tfAdditionalInfoState.petslist[Index].age = value.toString();

                                                              tfAdditionalInfoState.petslist[Index].error_age = false;
                                                              _changeData();
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    tfAdditionalInfoState.petslist.length > 1
                                                        ? InkWell(
                                                            onTap: () {
                                                              showDialog(
                                                                context: context,
                                                                barrierColor: Colors.black45,
                                                                useSafeArea: true,
                                                                barrierDismissible: false,
                                                                builder: (BuildContext context1) {
                                                                  return AlertDialogBox(
                                                                    title: GlobleString.dailog_remove_msg,
                                                                    positiveText: GlobleString.dailog_yes,
                                                                    negativeText: GlobleString.dailog_no,
                                                                    onPressedYes: () {
                                                                      Navigator.of(context1).pop();
                                                                      tfAdditionalInfoState.petslist.removeAt(Index);
                                                                      _store.dispatch(
                                                                          UpdateTFAdditionalInfoPetslist(tfAdditionalInfoState.petslist));
                                                                      _changeData();
                                                                    },
                                                                    onPressedNo: () {
                                                                      Navigator.of(context1).pop();
                                                                    },
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            hoverColor: Colors.transparent,
                                                            focusColor: Colors.transparent,
                                                            splashColor: Colors.transparent,
                                                            highlightColor: Colors.transparent,
                                                            child: Container(
                                                              height: 30,
                                                              padding: EdgeInsets.only(left: 10, right: 10),
                                                              margin: EdgeInsets.only(top: 20),
                                                              alignment: Alignment.center,
                                                              child: Image.asset(
                                                                "assets/images/ic_delete.png",
                                                                height: 22,
                                                                //width: 20,
                                                                alignment: Alignment.centerLeft,
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            height: 30,
                                                            padding: EdgeInsets.only(left: 10, right: 10),
                                                            margin: EdgeInsets.only(top: 20),
                                                            alignment: Alignment.center,
                                                          )
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    AddNewPet(tfAdditionalInfoState)
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                GlobleString.TAF_AI_Smoking,
                                style: MyStyles.Medium(13, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: FlutterSwitch(
                                  width: 65.0,
                                  height: 30.0,
                                  valueFontSize: 12.0,
                                  toggleSize: 20.0,
                                  value: tfAdditionalInfoState.isSmoking,
                                  borderRadius: 30.0,
                                  padding: 4.0,
                                  activeColor: Colors.lightGreen,
                                  activeText: "Yes",
                                  activeTextColor: myColor.white,
                                  inactiveColor: myColor.gray,
                                  inactiveText: "No",
                                  inactiveTextColor: myColor.white,
                                  showOnOff: true,
                                  onToggle: (val) {
                                    _store.dispatch(UpdateTFAdditionalInfoisSmoking(val));
                                    _changeData();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        tfAdditionalInfoState.isSmoking
                            ? Container(
                                width: 400,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          GlobleString.TAF_AI_Smoking_comments,
                                          style: MyStyles.Medium(13, myColor.text_color),
                                          textAlign: TextAlign.start,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          GlobleString.Optional,
                                          style: MyStyles.Regular(12, myColor.optional),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      initialValue: tfAdditionalInfoState.Comment,
                                      textAlign: TextAlign.start,
                                      style: MyStyles.Medium(13, myColor.text_color),
                                      decoration: InputDecoration(
                                          //border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: myColor.gray, width: 1.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: myColor.gray, width: 1.0),
                                          ),
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(10),
                                          fillColor: myColor.white,
                                          filled: true),
                                      onChanged: (value) {
                                        _store.dispatch(UpdateTFAdditionalInfoComment(value.toString()));
                                        _changeData();
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : Container()
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                GlobleString.TAF_AI_Vehicle,
                                style: MyStyles.Medium(13, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: FlutterSwitch(
                                  width: 65.0,
                                  height: 30.0,
                                  valueFontSize: 12.0,
                                  toggleSize: 20.0,
                                  value: tfAdditionalInfoState.isVehical,
                                  borderRadius: 30.0,
                                  padding: 4.0,
                                  activeColor: Colors.lightGreen,
                                  activeText: "Yes",
                                  activeTextColor: myColor.white,
                                  inactiveColor: myColor.gray,
                                  inactiveText: "No",
                                  inactiveTextColor: myColor.white,
                                  showOnOff: true,
                                  onToggle: (val) {
                                    _store.dispatch(UpdateTFAdditionalInfoisVehical(val));

                                    if (val) {
                                      List<Vehical> vehicallist = [];

                                      Vehical vehical = new Vehical();
                                      vehical.id = "1";
                                      vehical.make = "";
                                      vehical.model = "";
                                      vehical.year = "";
                                      vehical.error_make = false;
                                      vehical.error_model = false;
                                      vehical.error_year = false;
                                      vehicallist.add(vehical);

                                      _store.dispatch(UpdateTFAdditionalInfoVehicallist(vehicallist));
                                    } else {
                                      _store.dispatch(UpdateTFAdditionalInfoVehicallist(List.empty()));
                                    }
                                    _changeData();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        tfAdditionalInfoState.isVehical
                            ? Container(
                                width: 935,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            key: UniqueKey(),
                                            itemCount: tfAdditionalInfoState.vehicallist.length,
                                            itemBuilder: (BuildContext ctxt, int Index) {
                                              Vehical vehical = tfAdditionalInfoState.vehicallist[Index];
                                              return Container(
                                                margin: EdgeInsets.only(bottom: 10),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 25,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            GlobleString.TAF_AI_Vehicle_make,
                                                            style: MyStyles.Medium(13, myColor.text_color),
                                                            textAlign: TextAlign.start,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          TextFormField(
                                                            autofocus: true,
                                                            initialValue: vehical.make,
                                                            textAlign: TextAlign.start,
                                                            style: MyStyles.Medium(13, myColor.text_color),
                                                            decoration: InputDecoration(
                                                                //border: InputBorder.none,
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(color: myColor.blue, width: 1.0),
                                                                ),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: vehical.error_make! ? myColor.errorcolor : myColor.gray,
                                                                      width: 1.0),
                                                                ),
                                                                isDense: true,
                                                                contentPadding: EdgeInsets.all(10),
                                                                fillColor: myColor.white,
                                                                filled: true),
                                                            onChanged: (value) {
                                                              tfAdditionalInfoState.vehicallist[Index].make = value.toString();

                                                              tfAdditionalInfoState.vehicallist[Index].error_make = false;
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
                                                            GlobleString.TAF_AI_Vehicle_model,
                                                            style: MyStyles.Medium(13, myColor.text_color),
                                                            textAlign: TextAlign.start,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          TextFormField(
                                                            initialValue: vehical.model,
                                                            textAlign: TextAlign.start,
                                                            style: MyStyles.Medium(13, myColor.text_color),
                                                            decoration: InputDecoration(
                                                                //border: InputBorder.none,
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(color: myColor.blue, width: 1.0),
                                                                ),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: vehical.error_model! ? myColor.errorcolor : myColor.gray,
                                                                      width: 1.0),
                                                                ),
                                                                isDense: true,
                                                                contentPadding: EdgeInsets.all(10),
                                                                fillColor: myColor.white,
                                                                filled: true),
                                                            onChanged: (value) {
                                                              tfAdditionalInfoState.vehicallist[Index].model = value.toString();

                                                              tfAdditionalInfoState.vehicallist[Index].error_model = false;
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
                                                            GlobleString.TAF_AI_Vehicle_year,
                                                            style: MyStyles.Medium(13, myColor.text_color),
                                                            textAlign: TextAlign.start,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          TextFormField(
                                                            initialValue: vehical.year,
                                                            textAlign: TextAlign.start,
                                                            style: MyStyles.Medium(13, myColor.text_color),
                                                            inputFormatters: [MaskedInputFormatter("0000")],
                                                            decoration: InputDecoration(
                                                                //border: InputBorder.none,
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(color: myColor.blue, width: 1.0),
                                                                ),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: vehical.error_year! ? myColor.errorcolor : myColor.gray,
                                                                      width: 1.0),
                                                                ),
                                                                isDense: true,
                                                                contentPadding: EdgeInsets.all(10),
                                                                fillColor: myColor.white,
                                                                filled: true),
                                                            onChanged: (value) {
                                                              tfAdditionalInfoState.vehicallist[Index].year = value.toString();

                                                              tfAdditionalInfoState.vehicallist[Index].error_year = false;
                                                              _changeData();
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    tfAdditionalInfoState.vehicallist.length > 1
                                                        ? InkWell(
                                                            onTap: () {
                                                              showDialog(
                                                                context: context,
                                                                barrierColor: Colors.black45,
                                                                useSafeArea: true,
                                                                barrierDismissible: false,
                                                                builder: (BuildContext context1) {
                                                                  return AlertDialogBox(
                                                                    title: GlobleString.dailog_remove_msg,
                                                                    positiveText: GlobleString.dailog_yes,
                                                                    negativeText: GlobleString.dailog_no,
                                                                    onPressedYes: () {
                                                                      Navigator.of(context1).pop();
                                                                      tfAdditionalInfoState.vehicallist.removeAt(Index);
                                                                      _store.dispatch(UpdateTFAdditionalInfoVehicallist(
                                                                          tfAdditionalInfoState.vehicallist));
                                                                      _changeData();
                                                                    },
                                                                    onPressedNo: () {
                                                                      Navigator.of(context1).pop();
                                                                    },
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            hoverColor: Colors.transparent,
                                                            focusColor: Colors.transparent,
                                                            splashColor: Colors.transparent,
                                                            highlightColor: Colors.transparent,
                                                            child: Container(
                                                              height: 30,
                                                              padding: EdgeInsets.only(left: 10, right: 10),
                                                              margin: EdgeInsets.only(top: 20),
                                                              alignment: Alignment.center,
                                                              child: Image.asset(
                                                                "assets/images/ic_delete.png",
                                                                height: 22,
                                                                //width: 20,
                                                                alignment: Alignment.centerLeft,
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            height: 30,
                                                            padding: EdgeInsets.only(left: 10, right: 10),
                                                            margin: EdgeInsets.only(top: 20),
                                                            alignment: Alignment.center,
                                                          )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    AddNewVehicle(tfAdditionalInfoState)
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: 25,
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
                                GlobleString.TAF_AI_Intended_tenancy_start_date,
                                style: MyStyles.Medium(13, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextButton(
                                onPressed: () {
                                  _selectDate(context, tfAdditionalInfoState);
                                },
                                child: Container(
                                  width: 220,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: tfAdditionalInfoState.error_tenancystartdate ? myColor.errorcolor : myColor.gray,
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
                                            tfAdditionalInfoState.tenancystartdate == null
                                                ? ""
                                                : new DateFormat("dd-MMM-yyyy").format(tfAdditionalInfoState.tenancystartdate!).toString(),
                                            style: MyStyles.Medium(13, myColor.text_color),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8, right: 5),
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
                      height: 25,
                    ),
                    /*Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 260,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            GlobleString.TAF_AI_Intended_length_of_tenancy,
                            style: MyStyles.Medium(13, myColor.text_color),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 35,
                            child: DropdownSearch<SystemEnumDetails>(
                                mode: Mode.MENU,
                                items: tfAdditionalInfoState.lenthoftenancylist,
                                defultHeight: 250,
                                textstyle:
                                    MyStyles.Medium(13, myColor.text_color),
                                itemAsString: (SystemEnumDetails? u) =>
                                    u!.displayValue,
                                hint: "Select Status",
                                showSearchBox: false,
                                selectedItem:
                                    tfAdditionalInfoState.lenthoftenancy != null
                                        ? tfAdditionalInfoState.lenthoftenancy
                                        : null,
                                isFilteredOnline: true,
                                onChanged: (data) {
                                  _store.dispatch(
                                      UpdateTFAdditionalInfoLenthOfTenancy(
                                          data!));
                                }),
                          ),
                        ],
                      ),
                    )
                  ],
                ),*/
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          GlobleString.TAF_AI_Intended_length_of_tenancy,
                          style: MyStyles.Medium(13, myColor.text_color),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 300,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      GlobleString.TAF_AI_Number,
                                      style: MyStyles.Medium(13, myColor.text_color),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      initialValue: tfAdditionalInfoState.lenthoftenancynumber,
                                      textAlign: TextAlign.start,
                                      style: MyStyles.Medium(13, myColor.text_color),
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [MaskedInputFormatter("0000000000")],
                                      decoration: InputDecoration(
                                          //border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: myColor.gray, width: 2),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: tfAdditionalInfoState.error_lenthoftenancynumber ? myColor.errorcolor : myColor.gray,
                                                width: 1.0),
                                          ),
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(12),
                                          fillColor: myColor.white,
                                          filled: true),
                                      onChanged: (value) {
                                        _store.dispatch(UpdateTFAdditionalInfolenthoftenancynumber(value));
                                        _store.dispatch(UpdateTFAdditionalInfoError_lenthoftenancynumber(false));
                                        _changeData();
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      GlobleString.TAF_AI_Period,
                                      style: MyStyles.Medium(13, myColor.text_color),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 32,
                                      // ignore: missing_required_param
                                      child: DropdownSearch<SystemEnumDetails>(
                                        mode: Mode.MENU,
                                        key: UniqueKey(),
                                        focuscolor: myColor.blue,
                                        focusWidth: 1,
                                        errorcolor: myColor.errorcolor,
                                        isError: tfAdditionalInfoState.error_PeriodValue,
                                        popupBackgroundColor: myColor.white,
                                        items: tfAdditionalInfoState.Periodlist,
                                        defultHeight: tfAdditionalInfoState.Periodlist.length * 35 > 250
                                            ? 250
                                            : tfAdditionalInfoState.Periodlist.length * 35,
                                        textstyle: MyStyles.Medium(13, myColor.text_color),
                                        itemAsString: (SystemEnumDetails? u) => u!.displayValue,
                                        hint: "Select Period",
                                        showSearchBox: false,
                                        selectedItem: tfAdditionalInfoState.PeriodValue != null ? tfAdditionalInfoState.PeriodValue : null,
                                        isFilteredOnline: true,
                                        onChanged: (value) {
                                          _store.dispatch(UpdateTFAdditionalInfoPeriodValue(value));
                                          _store.dispatch(UpdateTFAdditionalInfoError_PeriodValue(false));
                                          _changeData();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [back(), SizedBox(width: 10), saveandnext(tfAdditionalInfoState)],
                    ),
                  ],
                ));
          }),
    );
  }

  Widget AddNewPet(TFAdditionalInfoState tfAdditionalInfoState) {
    return InkWell(
      onTap: () {
        bool isAdd = false;

        for (int i = 0; i < tfAdditionalInfoState.petslist.length; i++) {
          Pets pets = tfAdditionalInfoState.petslist[i];

          if (pets.typeofpets!.isEmpty) {
            isAdd = true;
            ToastUtils.showCustomToast(context, GlobleString.taf_AdditionalInfo_error_pets_typeofpets, false);
            /*tfAdditionalInfoState.petslist[i].error_typeofpets = true;
            _store.dispatch(UpdateTFAdditionalInfoPetslist(tfAdditionalInfoState.petslist));*/
            break;
          } else if (pets.size!.isEmpty) {
            isAdd = true;
            ToastUtils.showCustomToast(context, GlobleString.taf_AdditionalInfo_error_pets_size, false);
            /*tfAdditionalInfoState.petslist[i].error_size = true;
            _store.dispatch(UpdateTFAdditionalInfoPetslist(tfAdditionalInfoState.petslist));*/
            break;
          } else if (pets.age!.isEmpty) {
            isAdd = true;
            ToastUtils.showCustomToast(context, GlobleString.taf_AdditionalInfo_error_pets_age, false);
            /* tfAdditionalInfoState.petslist[i].error_age = true;
            _store.dispatch(UpdateTFAdditionalInfoPetslist(tfAdditionalInfoState.petslist));*/
            break;
          }

          if ((tfAdditionalInfoState.petslist.length - 1) == i && !isAdd) {
            tfAdditionalInfoState.petslist.add(new Pets(
              id: (tfAdditionalInfoState.petslist.length + 1).toString(),
              typeofpets: "",
              size: "",
              age: "",
              error_typeofpets: false,
              error_size: false,
              error_age: false,
            ));

            _store.dispatch(UpdateTFAdditionalInfoPetslist(tfAdditionalInfoState.petslist));
            _changeData();
            break;
          }
        }
      },
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        height: 30,
        margin: EdgeInsets.only(top: 5, bottom: 10),
        padding: EdgeInsets.only(left: 15, right: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: myColor.Circle_main,
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.add_circle,
                color: Colors.white,
                size: 20,
              ),
            ),
            Text(
              GlobleString.TAF_AI_Add_new_pet,
              style: MyStyles.Medium(14, myColor.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget AddNewVehicle(TFAdditionalInfoState tfAdditionalInfoState) {
    return InkWell(
      onTap: () {
        bool isAdd = false;

        for (int i = 0; i < tfAdditionalInfoState.vehicallist.length; i++) {
          Vehical vehical = tfAdditionalInfoState.vehicallist[i];

          if (vehical.make!.isEmpty) {
            isAdd = true;
            ToastUtils.showCustomToast(context, GlobleString.taf_AdditionalInfo_error_vahical_make, false);
            /*tfAdditionalInfoState.vehicallist[i].error_make = true;
            _store.dispatch(UpdateTFAdditionalInfoVehicallist(tfAdditionalInfoState.vehicallist));*/
            break;
          } else if (vehical.model!.isEmpty) {
            isAdd = true;
            ToastUtils.showCustomToast(context, GlobleString.taf_AdditionalInfo_error_vahical_model, false);
            /* tfAdditionalInfoState.vehicallist[i].error_model = true;
            _store.dispatch(UpdateTFAdditionalInfoVehicallist(tfAdditionalInfoState.vehicallist));*/
            break;
          } else if (vehical.year!.isEmpty) {
            isAdd = true;
            ToastUtils.showCustomToast(context, GlobleString.taf_AdditionalInfo_error_vahical_year, false);
            /*tfAdditionalInfoState.vehicallist[i].error_year = true;
            _store.dispatch(UpdateTFAdditionalInfoVehicallist(tfAdditionalInfoState.vehicallist));*/
            break;
          }

          if ((tfAdditionalInfoState.vehicallist.length - 1) == i && !isAdd) {
            tfAdditionalInfoState.vehicallist.add(new Vehical(
              id: (tfAdditionalInfoState.vehicallist.length + 1).toString(),
              make: "",
              model: "",
              year: "",
              error_make: false,
              error_model: false,
              error_year: false,
            ));

            _store.dispatch(UpdateTFAdditionalInfoVehicallist(tfAdditionalInfoState.vehicallist));
            _changeData();
            break;
          }
        }
      },
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        height: 30,
        margin: EdgeInsets.only(top: 5, bottom: 10),
        padding: EdgeInsets.only(left: 13, right: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: myColor.Circle_main,
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.add_circle,
                color: Colors.white,
                size: 20,
              ),
            ),
            Text(
              GlobleString.TAF_AI_Add_New_Vehicle,
              style: MyStyles.Medium(14, myColor.white),
            ),
          ],
        ),
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

  Widget saveandnext(TFAdditionalInfoState tfAdditionalInfoState) {
    return InkWell(
      onTap: () => _saveDataAndNext(tfAdditionalInfoState),
      child: CustomeWidget.SaveAndNext(GlobleString.Save_and_next),
    );
  }

  void _saveDataAndNext(TFAdditionalInfoState tfAdditionalInfoState) {
    if (tfAdditionalInfoState.isPets && petslistValidation(tfAdditionalInfoState)) {
      return;
    }
    /*else if (tfAdditionalInfoState.isSmoking && tfAdditionalInfoState.Comment.toString().trim().isEmpty) {
          ToastUtils.showCustomToast(context,
              GlobleString.taf_AdditionalInfo_error_smoke_comment, false);
        }*/
    else if (tfAdditionalInfoState.isVehical && vehicallistValidation(tfAdditionalInfoState)) {
      return;
    } else if (tfAdditionalInfoState.tenancystartdate == null) {
      ToastUtils.showCustomToast(context, GlobleString.taf_AdditionalInfo_error_intend_tenancy_start_date, false);
      _store.dispatch(UpdateTFAdditionalInfoError_tenancystartdate(true));
    }
    /*else if (tfAdditionalInfoState.lenthoftenancy == null) {
          ToastUtils.showCustomToast(
              context,
              GlobleString.taf_AdditionalInfo_error_intend_length_of_tenancy,
              false);
        }*/
    else if (tfAdditionalInfoState.lenthoftenancynumber == null || tfAdditionalInfoState.lenthoftenancynumber == "") {
      ToastUtils.showCustomToast(context, GlobleString.taf_AdditionalInfo_error_intend_length_of_tenancy_number, false);
      _store.dispatch(UpdateTFAdditionalInfoError_lenthoftenancynumber(true));
    } else if (tfAdditionalInfoState.PeriodValue == null) {
      ToastUtils.showCustomToast(context, GlobleString.taf_AdditionalInfo_error_intend_length_of_tenancy_period, false);
      _store.dispatch(UpdateTFAdditionalInfoError_PeriodValue(true));
    } else {
      //ToastUtils.showCustomToast(context, "Success", true);

      ApiCall(tfAdditionalInfoState);
    }
  }

  bool petslistValidation(TFAdditionalInfoState tfAdditionalInfoState) {
    bool ispetslist = false;

    for (int i = 0; i < tfAdditionalInfoState.petslist.length; i++) {
      Pets pets = tfAdditionalInfoState.petslist[i];

      if (pets.typeofpets == "") {
        ispetslist = true;
        ToastUtils.showCustomToast(context, GlobleString.taf_AdditionalInfo_error_pets_typeofpets, false);
        /*tfAdditionalInfoState.petslist[i].error_typeofpets = true;
        _store.dispatch(UpdateTFAdditionalInfoPetslist(tfAdditionalInfoState.petslist));*/
        break;
      } else if (pets.size == "") {
        ispetslist = true;
        ToastUtils.showCustomToast(context, GlobleString.taf_AdditionalInfo_error_pets_size, false);
        /*tfAdditionalInfoState.petslist[i].error_size = true;
        _store.dispatch(UpdateTFAdditionalInfoPetslist(tfAdditionalInfoState.petslist));*/
        break;
      } else if (pets.age == "") {
        ispetslist = true;
        ToastUtils.showCustomToast(context, GlobleString.taf_AdditionalInfo_error_pets_age, false);
        /* tfAdditionalInfoState.petslist[i].error_age = true;
        _store.dispatch(UpdateTFAdditionalInfoPetslist(tfAdditionalInfoState.petslist));*/
        break;
      }
    }

    return ispetslist;
  }

  bool vehicallistValidation(TFAdditionalInfoState tfAdditionalInfoState) {
    bool isvehicallist = false;

    for (int i = 0; i < tfAdditionalInfoState.vehicallist.length; i++) {
      Vehical vehical = tfAdditionalInfoState.vehicallist[i];

      if (vehical.make == "") {
        isvehicallist = true;
        ToastUtils.showCustomToast(context, GlobleString.taf_AdditionalInfo_error_vahical_make, false);
        /* tfAdditionalInfoState.vehicallist[i].error_make = true;
        _store.dispatch(UpdateTFAdditionalInfoVehicallist(tfAdditionalInfoState.vehicallist));*/
        break;
      } else if (vehical.model == "") {
        isvehicallist = true;
        ToastUtils.showCustomToast(context, GlobleString.taf_AdditionalInfo_error_vahical_model, false);
        /* tfAdditionalInfoState.vehicallist[i].error_model = true;
        _store.dispatch(UpdateTFAdditionalInfoVehicallist(tfAdditionalInfoState.vehicallist));*/
        break;
      } else if (vehical.year == "") {
        isvehicallist = true;
        ToastUtils.showCustomToast(context, GlobleString.taf_AdditionalInfo_error_vahical_year, false);
        /* tfAdditionalInfoState.vehicallist[i].error_year = true;
        _store.dispatch(UpdateTFAdditionalInfoVehicallist(tfAdditionalInfoState.vehicallist));*/
        break;
      }
    }

    return isvehicallist;
  }

  ApiCall(TFAdditionalInfoState tfAdditionalInfoState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    DeletePetVehicle petVehicle = new DeletePetVehicle(Applicant_ID: Prefs.getString(PrefsName.TCF_ApplicantID));

    ApiManager().TFAdditionalInfoDelete(context, petVehicle, petVehicle, (status, responce) {
      if (status) {
        InserData(tfAdditionalInfoState);
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
  }

  InserData(TFAdditionalInfoState tfAdditionalInfoState) {
    List<PetInfo> petinfolist = <PetInfo>[];

    if (tfAdditionalInfoState.isPets) {
      for (int i = 0; i < tfAdditionalInfoState.petslist.length; i++) {
        Pets pets = tfAdditionalInfoState.petslist[i];

        PetInfo petInfo = new PetInfo();
        petInfo.Applicant_ID = Prefs.getString(PrefsName.TCF_ApplicantID);
        petInfo.TypeOfPet = pets.typeofpets;
        petInfo.Size = pets.size;
        petInfo.Age = pets.age;

        petinfolist.add(petInfo);
      }
    }

    List<VehicleInfo> vehicleinfolist = <VehicleInfo>[];

    if (tfAdditionalInfoState.isVehical) {
      for (int i = 0; i < tfAdditionalInfoState.vehicallist.length; i++) {
        Vehical vehical = tfAdditionalInfoState.vehicallist[i];

        VehicleInfo vehicleInfo = new VehicleInfo();
        vehicleInfo.Applicant_ID = Prefs.getString(PrefsName.TCF_ApplicantID);
        vehicleInfo.Make = vehical.make;
        vehicleInfo.Model = vehical.model;
        vehicleInfo.Year = vehical.year;

        vehicleinfolist.add(vehicleInfo);
      }
    }

    String dd_startdate = new DateFormat("yyyy-MM-dd").format(tfAdditionalInfoState.tenancystartdate!);

    AdditionalInfo additionalInfo = new AdditionalInfo();
    additionalInfo.IntendedPeriod = tfAdditionalInfoState.PeriodValue!.EnumDetailID.toString();
    additionalInfo.IntendedPeriodNo = tfAdditionalInfoState.lenthoftenancynumber;
    additionalInfo.IntendedTenancyStartDate = dd_startdate;
    additionalInfo.IsPet = tfAdditionalInfoState.isPets;
    additionalInfo.IsSmoking = tfAdditionalInfoState.isSmoking;
    additionalInfo.IsVehicle = tfAdditionalInfoState.isVehical;
    additionalInfo.SmokingDesc = tfAdditionalInfoState.Comment;

    CommonID cpojo = new CommonID(ID: Prefs.getString(PrefsName.TCF_ApplicantID));

    ApiManager().InsetTFAdditionalInfo(context, petinfolist, vehicleinfolist, cpojo, additionalInfo, (status, responce) {
      if (status) {
        loader.remove();
        if (!isGotoback) {
          Prefs.setBool(PrefsName.TCF_Step5, true);
          if (stepper == 0) {
            widget._callbackSaveandNext();
          } else {
            widget._callbackRecordStep(stepper);
            //_store.dispatch(UpdateTenacyFormIndex(stepper));
          }
        } else {
          widget._callabackGotoBack();
        }
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
  }
}
