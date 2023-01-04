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
import 'package:silverhome/domain/actions/landlord_action/tenancyaddoccupant_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancyform_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancyperson_actions.dart';
import 'package:silverhome/domain/entities/newlead.dart';
import 'package:silverhome/domain/entities/tenancy_additionaloccupants.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/presentation/models/landlord_models/tf_additonal_occupant_state.dart';
import 'package:silverhome/presentation/models/landlord_models/tf_personal_state.dart';
import 'package:silverhome/presentation/screens/landlord/tenancyform/tenancyapplicationfrom_screen.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/alert/alert_dialogbox.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/tenantScreening/widget.dart';
import 'package:sizer/sizer.dart';

typedef VoidCallbackRecordStep = void Function(int stepper);

class TAFPersonalScreen extends StatefulWidget {
  final VoidCallback _callbackSaveandNext;
  final VoidCallback _callbackGotoBack;
  final VoidCallbackRecordStep _callbackRecordStep;

  TAFPersonalScreen({
    required VoidCallbackRecordStep onPressedRecordStep,
    required VoidCallback onPressedSave,
    required VoidCallback onPressGotoback,
  })  : _callbackSaveandNext = onPressedSave,
        _callbackGotoBack = onPressGotoback,
        _callbackRecordStep = onPressedRecordStep;

  @override
  _TAFPersonalScreenState createState() => _TAFPersonalScreenState();
}

class _TAFPersonalScreenState extends State<TAFPersonalScreen> {
  double height = 0, width = 0;
  final _store = getIt<AppStore>();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  late OverlayEntry loader;
  bool isGotoback = false;
  int stepper = 0;
  bool change = false;
  int forms = 0;
  late TFAdditionalOccupantState tfAdditionalOccupantState1;
  late TFPersonalState tenancyFormState1;

  @override
  void initState() {
    initilizedata();
    initilizedata2();
    initNavigationBack();
    TenancyApplicationFormScreen.changeFormData = false;
    super.initState();
  }

  initilizedata() {
    if (_store.state!.tfPersonalState != null) {
      TFPersonalState tfPersonalState = _store.state!.tfPersonalState;

      _store.dispatch(UpdateTFPersonFirstname(tfPersonalState.FNLperFirstname));
      _store.dispatch(UpdateTFPersonLastname(tfPersonalState.FNLperLastname));
      _store.dispatch(UpdateTFPersonEmail(tfPersonalState.FNLperEmail));
      _store.dispatch(
          UpdateTFPersonPhoneNumber(tfPersonalState.FNLperPhoneNumber));
      _store.dispatch(
          UpdateTFPersonCountryCode(tfPersonalState.FNLperCountryCode));
      _store.dispatch(UpdateTFPersonDialCode(tfPersonalState.FNLperDialCode));
      _store.dispatch(UpdateTFPersonStory(tfPersonalState.FNLperStory));
      _store
          .dispatch(UpdateTFPersonDateofBirth(tfPersonalState.FNLdateofbirth));
    }
  }

  initilizedata2() {
    if (_store.state!.tfAdditionalOccupantState != null) {
      TFAdditionalOccupantState tfAdditionalOccupantState =
          _store.state!.tfAdditionalOccupantState;

      _store.dispatch(UpdateTFAddOccupantlist([]));
      List<TenancyAdditionalOccupant> secondList =
          tfAdditionalOccupantState.FNLliveserveroccupantlist.map(
              (item) => new TenancyAdditionalOccupant.clone(item)).toList();

      _store.dispatch(UpdateTFAddOccupantlist(secondList));
      _store.dispatch(UpdateTFAddLiveServerOccupantlist(secondList));

      _store.dispatch(UpdateTFAddOccupantNotApplicable(
          tfAdditionalOccupantState.FNLnotapplicable));
    }
  }

  initNavigationBack() {
    navigationNotifier.addListener(() {
      if (mounted) if (navigationNotifier.backScreen ==
          NavigationConstant.tenancyPersonal) {
        isGotoback = navigationNotifier.gotoBack;
        stepper = navigationNotifier.stepper;
        _saveDataAndNext(_store.state!.tfPersonalState);
      }
    });
  }

  _changeData() {
    if (!change) {
      TenancyApplicationFormScreen.changeFormData = true;
      change = true;
    }
  }

/*
  List stepsList = [
    "Step1",
    "Step1",
    "Step1",
    "Step1",
    "Step1",
  ];

  List stepsListFunction = [
    "Step1",
    "Step1",
    "Step1",
    "Step1",
    "Step1",
  ];
*/
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      // height: height - 250,
      margin: EdgeInsets.only(bottom: 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // AppWidgetTenant().indicatorStepsList(steps: stepsList),
            SizedBox(
              height: 10.sp,
            ),
            _form(),
            Form2(),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, TFPersonalState tenancyFormState) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
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

    if (pickedDate != null && pickedDate != tenancyFormState.dateofbirth)
      _store.dispatch(UpdateTFPersonDateofBirth(pickedDate));
    _store.dispatch(UpdateTFPersonError_dateofbirth(false));
    _changeData();
  }

  Widget _form() {
    return Container(
      width: 1000,
      child: ConnectState<TFPersonalState>(
          map: (state) => state.tfPersonalState,
          where: notIdentical,
          builder: (tfPersonalState) {
            tenancyFormState1 = tfPersonalState!;
            return FocusScope(
                node: _focusScopeNode,
                autofocus: true,
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
                            GlobleString.TAF_Primary_Applicant,
                            style: MyStyles.Medium(20, myColor.text_color),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            GlobleString.TAF_Personal_Information,
                            style: MyStyles.Medium(20, myColor.text_color),
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
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                GlobleString.TAF_Personal_firstname,
                                style: MyStyles.Medium(13, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                initialValue: tfPersonalState!.perFirstname,
                                textAlign: TextAlign.start,
                                style: MyStyles.Medium(13, myColor.text_color),
                                decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              tfPersonalState.error_perFirstname
                                                  ? myColor.errorcolor
                                                  : myColor.blue,
                                          width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              tfPersonalState.error_perFirstname
                                                  ? myColor.errorcolor
                                                  : myColor.gray,
                                          width: 1.0),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(10),
                                    fillColor: myColor.white,
                                    filled: true),
                                onChanged: (value) {
                                  Helper.Log("Firstname onChanged", "Calll");
                                  _store.dispatch(UpdateTFPersonFirstname(
                                      value.toString().trim()));
                                  _store.dispatch(
                                      UpdateTFPersonError_perFirstname(false));
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
                                GlobleString.TAF_Personal_lastname,
                                style: MyStyles.Medium(13, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                initialValue: tfPersonalState.perLastname,
                                textAlign: TextAlign.start,
                                style: MyStyles.Medium(13, myColor.text_color),
                                decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              tfPersonalState.error_perLastname
                                                  ? myColor.errorcolor
                                                  : myColor.blue,
                                          width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              tfPersonalState.error_perLastname
                                                  ? myColor.errorcolor
                                                  : myColor.gray,
                                          width: 1.0),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(10),
                                    fillColor: myColor.white,
                                    filled: true),
                                onChanged: (value) {
                                  _store.dispatch(UpdateTFPersonLastname(
                                      value.toString().trim()));
                                  _store.dispatch(
                                      UpdateTFPersonError_perLastname(false));
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
                                GlobleString.TAF_Personal_dateofbirth,
                                style: MyStyles.Medium(13, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 10.0),
                              TextButton(
                                onPressed: () {
                                  _selectDate(context, tfPersonalState);
                                },
                                child: Container(
                                  width: 220,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: tfPersonalState.error_dateofbirth
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
                                            tfPersonalState.dateofbirth == null
                                                ? ""
                                                : new DateFormat("dd-MMM-yyyy")
                                                    .format(tfPersonalState
                                                        .dateofbirth!)
                                                    .toString(),
                                            style: MyStyles.Medium(
                                                13, myColor.text_color),
                                          ),
                                        ),
                                      ),
                                      const Padding(
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
                    const SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                GlobleString.TAF_Personal_email,
                                style:
                                    MyStyles.Medium(13, myColor.disablecolor),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                readOnly: true,
                                initialValue: tfPersonalState.perEmail,
                                textAlign: TextAlign.start,
                                style:
                                    MyStyles.Medium(13, myColor.disablecolor),
                                decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: tfPersonalState.error_perEmail
                                              ? myColor.errorcolor
                                              : myColor.disablecolor,
                                          width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: tfPersonalState.error_perEmail
                                              ? myColor.errorcolor
                                              : myColor.disablecolor,
                                          width: 1.0),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(10),
                                    fillColor: myColor.white,
                                    filled: true),
                                onChanged: (value) {
                                  _store.dispatch(UpdateTFPersonEmail(
                                      value.toString().trim()));
                                  _store.dispatch(
                                      UpdateTFPersonError_perEmail(false));
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
                          width: 240,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                GlobleString.TAF_Personal_phonenumber,
                                style: MyStyles.Medium(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 250,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: tfPersonalState.error_perPhoneNumber
                                        ? myColor.errorcolor
                                        : myColor.gray,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CountryCodePicker(
                                      onChanged: (value) {
                                        _store.dispatch(
                                            UpdateTFPersonCountryCode(
                                                value.code.toString()));

                                        _store.dispatch(UpdateTFPersonDialCode(
                                            value.dialCode.toString()));

                                        setState(() {});
                                        _changeData();
                                      },
                                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                      initialSelection:
                                          tfPersonalState.perCountryCode,
                                      showFlag: true,
                                      textStyle: MyStyles.Medium(
                                          13, myColor.text_color),
                                      dialogTextStyle: MyStyles.Medium(
                                          13, myColor.text_color),
                                      //showDropDownButton: true,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        initialValue:
                                            tfPersonalState.perPhoneNumber,
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          MaskedInputFormatter("(000) 000 0000")
                                        ],
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          contentPadding: EdgeInsets.all(10),
                                          isDense: true,
                                        ),
                                        style: MyStyles.Medium(
                                            13, myColor.text_color),
                                        onChanged: (value) {
                                          _store.dispatch(
                                              UpdateTFPersonPhoneNumber(
                                                  value.toString().trim()));
                                          _store.dispatch(
                                              UpdateTFPersonError_perPhoneNumber(
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
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "",
                                style: MyStyles.Medium(13, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
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
                                    GlobleString.TAF_Personal_yourstory,
                                    style:
                                        MyStyles.Medium(13, myColor.text_color),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    GlobleString.Optional,
                                    style:
                                        MyStyles.Medium(10, myColor.optional),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                initialValue: tfPersonalState.perStory,
                                textAlign: TextAlign.start,
                                style: MyStyles.Medium(13, myColor.text_color),
                                maxLength: 500,
                                maxLines: 4,
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
                                  _store.dispatch(UpdateTFPersonStory(
                                      value.toString().trim()));
                                  _changeData();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [saveandnext(tfPersonalState)],
                    // ),
                  ],
                ));
          }),
    );
  }

  Widget Form2() {
    return Container(
      width: 1000,
      child: ConnectState<TFAdditionalOccupantState>(
          map: (state) => state.tfAdditionalOccupantState,
          where: notIdentical,
          builder: (tfAdditionalOccupantState) {
            // if (tfAdditionalOccupantState!.occupantlist.length == 0) {
            //   List<TenancyAdditionalOccupant> listoccupation = [];
            //   TenancyAdditionalOccupant oocupinfo =
            //       new TenancyAdditionalOccupant();

            //   oocupinfo.id = "1";
            //   oocupinfo.firstname = "";
            //   oocupinfo.lastname = "";
            //   oocupinfo.email = "";
            //   oocupinfo.mobilenumber = "";
            //   oocupinfo.primaryApplicant = "";
            //   oocupinfo.OccupantID = "";
            //   oocupinfo.applicant = false;
            //   oocupinfo.errro_firstname = false;
            //   oocupinfo.errro_lastname = false;
            //   oocupinfo.errro_email = false;
            //   oocupinfo.errro_mobilenumber = false;
            //   oocupinfo.errro_primaryApplicant = false;
            //   oocupinfo.explain = "";

            //   listoccupation.add(oocupinfo);

            //   _store.dispatch(UpdateTFAddOccupantlist(listoccupation));
            // }
            tfAdditionalOccupantState1 = tfAdditionalOccupantState!;
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
                            GlobleString.TAF_Additional_Applicants,
                            style: MyStyles.SemiBold(20, myColor.text_color),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      key: UniqueKey(),
                      itemCount: tfAdditionalOccupantState.occupantlist.length,
                      itemBuilder: (BuildContext ctxt, int Index) {
                        TenancyAdditionalOccupant oocupinfo =
                            tfAdditionalOccupantState.occupantlist[Index];
                        if (oocupinfo.email == null) {
                          oocupinfo.email = "";
                        }
                        if (oocupinfo.mobilenumber == null) {
                          oocupinfo.mobilenumber = "";
                        }
                        if (oocupinfo.errro_email == null) {
                          oocupinfo.errro_email = false;
                        }
                        if (oocupinfo.errro_mobilenumber == null) {
                          oocupinfo.errro_mobilenumber = false;
                        }

                        if (oocupinfo.applicant == null) {
                          oocupinfo.applicant = false;
                        }
                        if (oocupinfo.explain == null) {
                          oocupinfo.explain = "";
                        }
                        /*return FocusScope(
                        node: FocusScopeNode(),
                        onFocusChange: (value) {
                          */ /* _store.dispatch(UpdateTFAddOccupantlist(
                            tfAdditionalOccupantState
                                .occupantlist));*/ /*
                        },
                        child: ,
                      );*/

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        GlobleString.TAF_AO_first_name,
                                        style: MyStyles.Medium(
                                            13,
                                            tfAdditionalOccupantState
                                                    .notapplicable
                                                ? myColor.disablecolor
                                                : myColor.text_color),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        initialValue: oocupinfo.firstname,
                                        textAlign: TextAlign.start,
                                        autofocus: true,
                                        readOnly: tfAdditionalOccupantState
                                            .notapplicable,
                                        style: MyStyles.Medium(
                                            13,
                                            tfAdditionalOccupantState
                                                    .notapplicable
                                                ? myColor.disablecolor
                                                : myColor.text_color),
                                        decoration: InputDecoration(
                                            //border: InputBorder.none,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      tfAdditionalOccupantState
                                                              .notapplicable
                                                          ? myColor.disablecolor
                                                          : myColor.blue,
                                                  width: 1.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: tfAdditionalOccupantState
                                                          .notapplicable
                                                      ? myColor.disablecolor
                                                      : oocupinfo
                                                              .errro_firstname!
                                                          ? myColor.errorcolor
                                                          : myColor.gray,
                                                  width: 1.0),
                                            ),
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(10),
                                            fillColor: myColor.white,
                                            filled: true),
                                        onChanged: (value) {
                                          tfAdditionalOccupantState
                                              .occupantlist[Index]
                                              .firstname = value.toString();

                                          tfAdditionalOccupantState
                                              .occupantlist[Index]
                                              .errro_firstname = false;
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        GlobleString.TAF_AO_Last_name,
                                        style: MyStyles.Medium(
                                            13,
                                            tfAdditionalOccupantState
                                                    .notapplicable
                                                ? myColor.disablecolor
                                                : myColor.text_color),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        initialValue: oocupinfo.lastname,
                                        textAlign: TextAlign.start,
                                        readOnly: tfAdditionalOccupantState
                                            .notapplicable,
                                        style: MyStyles.Medium(
                                            13,
                                            tfAdditionalOccupantState
                                                    .notapplicable
                                                ? myColor.disablecolor
                                                : myColor.text_color),
                                        decoration: InputDecoration(
                                            //border: InputBorder.none,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      tfAdditionalOccupantState
                                                              .notapplicable
                                                          ? myColor.disablecolor
                                                          : myColor.blue,
                                                  width: 1.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: tfAdditionalOccupantState
                                                          .notapplicable
                                                      ? myColor.disablecolor
                                                      : oocupinfo
                                                              .errro_lastname!
                                                          ? myColor.errorcolor
                                                          : myColor.gray,
                                                  width: 1.0),
                                            ),
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(10),
                                            fillColor: myColor.white,
                                            filled: true),
                                        onChanged: (value) {
                                          tfAdditionalOccupantState
                                              .occupantlist[Index]
                                              .lastname = value.toString();

                                          tfAdditionalOccupantState
                                              .occupantlist[Index]
                                              .errro_lastname = false;

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        GlobleString
                                            .TAF_AO_Relationship_applicant,
                                        style: MyStyles.Medium(
                                            13,
                                            tfAdditionalOccupantState
                                                    .notapplicable
                                                ? myColor.disablecolor
                                                : myColor.text_color),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        initialValue:
                                            oocupinfo.primaryApplicant,
                                        textAlign: TextAlign.start,
                                        readOnly: tfAdditionalOccupantState
                                            .notapplicable,
                                        style: MyStyles.Medium(
                                            13,
                                            tfAdditionalOccupantState
                                                    .notapplicable
                                                ? myColor.disablecolor
                                                : myColor.text_color),
                                        decoration: InputDecoration(
                                            //border: InputBorder.none,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      tfAdditionalOccupantState
                                                              .notapplicable
                                                          ? myColor.disablecolor
                                                          : myColor.blue,
                                                  width: 1.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: tfAdditionalOccupantState
                                                          .notapplicable
                                                      ? myColor.disablecolor
                                                      : oocupinfo
                                                              .errro_primaryApplicant!
                                                          ? myColor.errorcolor
                                                          : myColor.gray,
                                                  width: 1.0),
                                            ),
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(10),
                                            fillColor: myColor.white,
                                            filled: true),
                                        onChanged: (value) {
                                          tfAdditionalOccupantState
                                                  .occupantlist[Index]
                                                  .primaryApplicant =
                                              value.toString();

                                          tfAdditionalOccupantState
                                              .occupantlist[Index]
                                              .errro_primaryApplicant = false;
                                          _changeData();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                tfAdditionalOccupantState.occupantlist.length >
                                        1
                                    ? !tfAdditionalOccupantState.notapplicable
                                        ? InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                barrierColor: Colors.black45,
                                                useSafeArea: true,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context1) {
                                                  return AlertDialogBox(
                                                    title: GlobleString
                                                        .TAF_Additional_Occupants_dailog_remove_msg,
                                                    positiveText: GlobleString
                                                        .TAF_Additional_Occupants_dailog_yes,
                                                    negativeText: GlobleString
                                                        .TAF_Additional_Occupants_dailog_no,
                                                    onPressedYes: () {
                                                      Navigator.of(context1)
                                                          .pop();
                                                      tfAdditionalOccupantState
                                                          .occupantlist
                                                          .removeAt(Index);
                                                      _store.dispatch(
                                                          UpdateTFAddOccupantlist(
                                                              tfAdditionalOccupantState
                                                                  .occupantlist));
                                                      _changeData();
                                                    },
                                                    onPressedNo: () {
                                                      Navigator.of(context1)
                                                          .pop();
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            canRequestFocus: true,
                                            hoverColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            child: Container(
                                              height: 30,
                                              width: 50,
                                              padding: EdgeInsets.only(
                                                  left: 15, right: 15),
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
                                        : InkWell(
                                            onTap: () {},
                                            canRequestFocus: true,
                                            hoverColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            child: Container(
                                              height: 30,
                                              width: 50,
                                              padding: EdgeInsets.only(
                                                  left: 15, right: 15),
                                              margin: EdgeInsets.only(top: 20),
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                "assets/images/ic_delete.png",
                                                height: 22,
                                                //width: 20,
                                                alignment: Alignment.centerLeft,
                                                color: myColor.disablecolor,
                                              ),
                                            ),
                                          )
                                    : InkWell(
                                        onTap: () {},
                                        onFocusChange: (value) {},
                                        canRequestFocus: true,
                                        hoverColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        child: Container(
                                          height: 30,
                                          width: 50,
                                          padding: EdgeInsets.only(
                                              left: 15, right: 15),
                                          margin: EdgeInsets.only(top: 20),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "",
                                            style: MyStyles.Medium(
                                                12, myColor.white),
                                          ),
                                        ),
                                      )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        GlobleString.TAF_Personal_email,
                                        style: MyStyles.Medium(
                                            13,
                                            tfAdditionalOccupantState
                                                    .notapplicable
                                                ? myColor.disablecolor
                                                : myColor.text_color),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        initialValue: oocupinfo.email,
                                        textAlign: TextAlign.start,
                                        autofocus: true,
                                        readOnly: tfAdditionalOccupantState
                                            .notapplicable,
                                        style: MyStyles.Medium(
                                            13,
                                            tfAdditionalOccupantState
                                                    .notapplicable
                                                ? myColor.disablecolor
                                                : myColor.text_color),
                                        decoration: InputDecoration(
                                            //border: InputBorder.none,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      tfAdditionalOccupantState
                                                              .notapplicable
                                                          ? myColor.disablecolor
                                                          : myColor.blue,
                                                  width: 1.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      tfAdditionalOccupantState
                                                              .notapplicable
                                                          ? myColor.disablecolor
                                                          : oocupinfo
                                                                  .errro_email!
                                                              ? myColor
                                                                  .errorcolor
                                                              : myColor.gray,
                                                  width: 1.0),
                                            ),
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(10),
                                            fillColor: myColor.white,
                                            filled: true),
                                        onChanged: (value) {
                                          tfAdditionalOccupantState
                                              .occupantlist[Index]
                                              .email = value.toString();

                                          tfAdditionalOccupantState
                                              .occupantlist[Index]
                                              .errro_email = false;
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        GlobleString.TAF_Personal_phonenumber,
                                        style: MyStyles.Medium(
                                            13,
                                            tfAdditionalOccupantState
                                                    .notapplicable
                                                ? myColor.disablecolor
                                                : myColor.text_color),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        initialValue: oocupinfo.mobilenumber,
                                        textAlign: TextAlign.start,
                                        readOnly: tfAdditionalOccupantState
                                            .notapplicable,
                                        style: MyStyles.Medium(
                                            13,
                                            tfAdditionalOccupantState
                                                    .notapplicable
                                                ? myColor.disablecolor
                                                : myColor.text_color),
                                        decoration: InputDecoration(
                                            //border: InputBorder.none,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      tfAdditionalOccupantState
                                                              .notapplicable
                                                          ? myColor.disablecolor
                                                          : myColor.blue,
                                                  width: 1.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: tfAdditionalOccupantState
                                                          .notapplicable
                                                      ? myColor.disablecolor
                                                      : oocupinfo
                                                              .errro_mobilenumber!
                                                          ? myColor.errorcolor
                                                          : myColor.gray,
                                                  width: 1.0),
                                            ),
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(10),
                                            fillColor: myColor.white,
                                            filled: true),
                                        onChanged: (value) {
                                          tfAdditionalOccupantState
                                              .occupantlist[Index]
                                              .mobilenumber = value.toString();

                                          tfAdditionalOccupantState
                                              .occupantlist[Index]
                                              .errro_mobilenumber = false;
                                          _changeData();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      activeColor: myColor.Circle_main,
                                      checkColor: myColor.white,
                                      value: tfAdditionalOccupantState
                                          .occupantlist[Index].applicant,
                                      onChanged: (value) {
                                        setState(() {
                                          tfAdditionalOccupantState
                                              .occupantlist[Index]
                                              .applicant = value;
                                        });

                                        _changeData();
                                        //   _changeData();
                                      },
                                    ),
                                    Text(
                                      GlobleString.TAF_AO_NotApplicable,
                                      style: MyStyles.Medium(
                                          13, myColor.text_color),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            if (tfAdditionalOccupantState
                                    .occupantlist[Index].applicant! ==
                                true)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              GlobleString.TAF_Personal_explain,
                                              style: MyStyles.Medium(
                                                  13, myColor.text_color),
                                              textAlign: TextAlign.start,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          initialValue:
                                              tfAdditionalOccupantState
                                                  .occupantlist[Index].explain,
                                          textAlign: TextAlign.start,
                                          style: MyStyles.Medium(
                                              13, myColor.text_color),
                                          maxLength: 500,
                                          maxLines: 3,
                                          decoration: InputDecoration(
                                              //border: InputBorder.none,
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: myColor.blue,
                                                    width: 1.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: myColor.gray,
                                                    width: 1.0),
                                              ),
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              fillColor: myColor.white,
                                              filled: true),
                                          onChanged: (value) {
                                            tfAdditionalOccupantState
                                                .occupantlist[Index]
                                                .explain = value;
                                            _changeData();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [AddNewOccupation(tfAdditionalOccupantState)],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            saveandnext(tenancyFormState1),
                            // Checkbox(
                            //   activeColor: myColor.Circle_main,
                            //   checkColor: myColor.white,
                            //   value: tfAdditionalOccupantState.notapplicable,
                            //   onChanged: (value) {
                            //     _store.dispatch(
                            //         UpdateTFAddOccupantNotApplicable(value!));
                            //     //   _changeData();
                            //   },
                            // ),
                            // Text(
                            //   GlobleString.TAF_AO_NotApplicable,
                            //   style: MyStyles.Medium(13, myColor.text_color),
                            //   textAlign: TextAlign.start,
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ));
          }),
    );
  }

  Widget AddNewOccupation(TFAdditionalOccupantState tfAdditionalOccupantState) {
    return InkWell(
      onTap: () {
        if (!tfAdditionalOccupantState.notapplicable) {
          _addnewoccupation(tfAdditionalOccupantState);
          _changeData();
        }
      },
      child: Container(
        height: 35,
        padding: EdgeInsets.only(left: 15, right: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: tfAdditionalOccupantState.notapplicable
              ? myColor.disablecolor
              : myColor.Circle_main,
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
              GlobleString.TAF_CT_Add_New_Applicant,
              style: MyStyles.Medium(14, myColor.white),
            ),
          ],
        ),
      ),
    );
  }

  void _addnewoccupation(TFAdditionalOccupantState tfAdditionalOccupantState) {
    tfAdditionalOccupantState.occupantlist.add(new TenancyAdditionalOccupant(
        id: (tfAdditionalOccupantState.occupantlist.length + 1).toString(),
        firstname: "",
        lastname: "",
        email: "",
        mobilenumber: "",
        primaryApplicant: "",
        OccupantID: "",
        explain: "",
        applicant: false,
        errro_firstname: false,
        errro_lastname: false,
        errro_email: false,
        errro_mobilenumber: false,
        errro_primaryApplicant: false));

    _store.dispatch(
        UpdateTFAddOccupantlist(tfAdditionalOccupantState.occupantlist));
  }

  void _addnewoccupationback(
      TFAdditionalOccupantState tfAdditionalOccupantState) {
    bool isAdd = false;

    for (int i = 0; i < tfAdditionalOccupantState.occupantlist.length; i++) {
      TenancyAdditionalOccupant empinfo =
          tfAdditionalOccupantState.occupantlist[i];

      if (empinfo.firstname == "") {
        isAdd = true;
        ToastUtils.showCustomToast(
            context, GlobleString.taf_occupant_error_firstname, false);

        /*tfAdditionalOccupantState.occupantlist[i].errro_firstname = true;
        _store.dispatch(UpdateTFAddOccupantlist(tfAdditionalOccupantState.occupantlist));*/
        break;
      } else if (empinfo.lastname == "") {
        isAdd = true;
        ToastUtils.showCustomToast(
            context, GlobleString.taf_occupant_error_lastname, false);
        /*tfAdditionalOccupantState.occupantlist[i].errro_lastname = true;
       _store.dispatch(UpdateTFAddOccupantlist(tfAdditionalOccupantState.occupantlist));*/
        break;
      } else if (empinfo.primaryApplicant == "") {
        isAdd = true;
        ToastUtils.showCustomToast(
            context, GlobleString.taf_occupant_error_primaryApplicant, false);
        /* tfAdditionalOccupantState.occupantlist[i].errro_primaryApplicant = true;
        _store.dispatch(
            UpdateTFAddOccupantlist(tfAdditionalOccupantState.occupantlist));*/
        break;
      } else if (empinfo.email == "") {
        isAdd = true;
        ToastUtils.showCustomToast(
            context, GlobleString.taf_occupant_error_email, false);
        /* tfAdditionalOccupantState.occupantlist[i].errro_primaryApplicant = true;
        _store.dispatch(
            UpdateTFAddOccupantlist(tfAdditionalOccupantState.occupantlist));*/
        break;
      } else if (empinfo.mobilenumber == "") {
        isAdd = true;
        ToastUtils.showCustomToast(
            context, GlobleString.taf_occupant_error_phone, false);
        /* tfAdditionalOccupantState.occupantlist[i].errro_primaryApplicant = true;
        _store.dispatch(
            UpdateTFAddOccupantlist(tfAdditionalOccupantState.occupantlist));*/
        break;
      }

      if ((tfAdditionalOccupantState.occupantlist.length - 1) == i && !isAdd) {
        tfAdditionalOccupantState.occupantlist.add(
            new TenancyAdditionalOccupant(
                id: (tfAdditionalOccupantState.occupantlist.length + 1)
                    .toString(),
                firstname: "",
                lastname: "",
                email: "",
                mobilenumber: "",
                primaryApplicant: "",
                OccupantID: "",
                explain: "",
                applicant: false,
                errro_firstname: false,
                errro_lastname: false,
                errro_email: false,
                errro_mobilenumber: false,
                errro_primaryApplicant: false));

        _store.dispatch(
            UpdateTFAddOccupantlist(tfAdditionalOccupantState.occupantlist));
        break;
      }
    }
  }

  Widget saveandnext(TFPersonalState tfPersonalState) {
    return InkWell(
      onTap: () => _saveDataAndNext(tfPersonalState),
      child: CustomeWidget.SaveAndNext(GlobleString.Save_and_next),
    );
  }

  void _saveDataAndNext(TFPersonalState tfPersonalState) {
    if (tfPersonalState.perFirstname == "") {
      ToastUtils.showCustomToast(
          context, GlobleString.taf_person_error_first_name, false);
      _store.dispatch(UpdateTFPersonError_perFirstname(true));
    } else if (tfPersonalState.perLastname == "") {
      _store.dispatch(UpdateTFPersonError_perLastname(true));
      ToastUtils.showCustomToast(
          context, GlobleString.taf_person_error_last_name, false);
    } else if (tfPersonalState.dateofbirth == null) {
      _store.dispatch(UpdateTFPersonError_dateofbirth(true));
      ToastUtils.showCustomToast(
          context, GlobleString.taf_person_error_dateofbarth, false);
    } else if (!Helper.isAdult2(tfPersonalState.dateofbirth.toString())) {
      _store.dispatch(UpdateTFPersonError_dateofbirth(true));
      ToastUtils.showCustomToast(
          context, GlobleString.taf_person_error_dateofbarth1, false);
    } else if (tfPersonalState.perEmail == "") {
      _store.dispatch(UpdateTFPersonError_perEmail(true));
      ToastUtils.showCustomToast(
          context, GlobleString.taf_person_error_email, false);
    } else if (Helper.ValidEmail(tfPersonalState.perEmail) != true) {
      _store.dispatch(UpdateTFPersonError_perEmail(true));
      ToastUtils.showCustomToast(
          context, GlobleString.taf_person_error_valid_email, false);
    } else if (tfPersonalState.perPhoneNumber == "") {
      _store.dispatch(UpdateTFPersonError_perPhoneNumber(true));
      ToastUtils.showCustomToast(
          context, GlobleString.taf_person_error_mobile, false);
    } else if (Helper.ValidPhonenumber(tfPersonalState.perPhoneNumber)) {
      _store.dispatch(UpdateTFPersonError_perPhoneNumber(true));
      ToastUtils.showCustomToast(
          context, GlobleString.taf_person_error_validmobile, false);
    } else {
      String dob =
          new DateFormat("yyyy-MM-dd").format(tfPersonalState.dateofbirth!);

      PersonIdInfo personIdInfo = new PersonIdInfo();
      personIdInfo.ID = tfPersonalState.Person_ID;
      personIdInfo.FirstName = tfPersonalState.perFirstname;
      personIdInfo.LastName = tfPersonalState.perLastname;
      personIdInfo.DOB = dob;
      personIdInfo.Email = tfPersonalState.perEmail;
      personIdInfo.MobileNumber = tfPersonalState.perPhoneNumber;
      personIdInfo.Country_Code = tfPersonalState.perCountryCode;
      personIdInfo.Dial_Code = tfPersonalState.perDialCode;

      UpdatePersonInfo upersonInfo = new UpdatePersonInfo();
      upersonInfo.YourStory = tfPersonalState.perStory;
      upersonInfo.Person_ID = personIdInfo;

      CommonID commonID = new CommonID();
      commonID.ID = Prefs.getString(PrefsName.TCF_ApplicantID);

      loader = Helper.overlayLoader(context);
      Overlay.of(context)!.insert(loader);

      ApiManager().UpdateTFPersonalInfo(context, commonID, upersonInfo,
          (status, responce) {
        if (status) {
          _saveDataAndNext2(tfAdditionalOccupantState1);
          //_saveDataAndNext2(occupantlist);
          loader.remove();
          if (!isGotoback) {
            Prefs.setBool(PrefsName.TCF_Step1, true);
            if (stepper == 0) {
              widget._callbackSaveandNext();
            } else {
              widget._callbackRecordStep(stepper);
              //_store.dispatch(UpdateTenacyFormIndex(stepper));
            }
          } else {
            widget._callbackGotoBack();
          }
        } else {
          loader.remove();
        }
      });
    }
  }

  Widget AddNewApplicant() {
    return InkWell(
      onTap: () {
        setState(() {
          forms = forms + 1;
        });
      },
      child: Container(
        height: 35,
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
              GlobleString.TAF_CT_Add_New_Applicant,
              style: MyStyles.Medium(14, myColor.white),
            ),
          ],
        ),
      ),
    );
  }

//save ocupants
  _saveDataAndNext2(TFAdditionalOccupantState tfAddOState) {
    if (tfAddOState.notapplicable) {
      ApiCall2(tfAddOState);
    } else {
      bool isAdd = false;
      for (int i = 0; i < tfAddOState.occupantlist.length; i++) {
        TenancyAdditionalOccupant empinfo = tfAddOState.occupantlist[i];

        if (empinfo.firstname == "" &&
            empinfo.lastname == "" &&
            empinfo.primaryApplicant == "") {
          isAdd = true;
          //ToastUtils.showCustomToast(context, GlobleString.taf_occupant_error_mandatory, false);
          break;
        } else if (empinfo.firstname == "") {
          isAdd = true;
          //ToastUtils.showCustomToast(context, GlobleString.taf_occupant_error_firstname, false);
          /* tfAddOState.occupantlist[i].errro_firstname = true;
              _store
                  .dispatch(UpdateTFAddOccupantlist(tfAddOState.occupantlist));*/
          break;
        } else if (empinfo.lastname == "") {
          isAdd = true;
          //ToastUtils.showCustomToast(context, GlobleString.taf_occupant_error_lastname, false);
          /* tfAddOState.occupantlist[i].errro_lastname = true;
              _store
                  .dispatch(UpdateTFAddOccupantlist(tfAddOState.occupantlist));*/
          break;
        } else if (empinfo.primaryApplicant == "") {
          isAdd = true;
          //ToastUtils.showCustomToast(context, GlobleString.taf_occupant_error_primaryApplicant, false);
          /* tfAddOState.occupantlist[i].errro_primaryApplicant = true;
              _store
                  .dispatch(UpdateTFAddOccupantlist(tfAddOState.occupantlist));*/
          break;
        }

        if ((tfAddOState.occupantlist.length - 1) == i && !isAdd) {
          ApiCall2(tfAddOState);
        }
      }
    }
  }

  ApiCall2(TFAdditionalOccupantState tfAddOccState) {
    //loader = Helper.overlayLoader(context);
    //Overlay.of(context)!.insert(loader);

    List<CommonID> CommonIDlist = <CommonID>[];

    for (int i = 0; i < tfAddOccState.liveserveroccupantlist.length; i++) {
      TenancyAdditionalOccupant taoccupant =
          tfAddOccState.liveserveroccupantlist[i];

      if (taoccupant.OccupantID != "") {
        CommonIDlist.add(new CommonID(ID: taoccupant.OccupantID));
      }
    }

    if (CommonIDlist.length > 0) {
      DeleteAdditionalOccupant deleteOccupant = new DeleteAdditionalOccupant(
          Applicantion_ID: Prefs.getString(PrefsName.TCF_ApplicationID));

      ApiManager().TFAdditionalOCcupantDelete(
          context, CommonIDlist, deleteOccupant, (status, responce) {
        if (status) {
          InserData(tfAddOccState);
        } else {
          loader.remove();
          ToastUtils.showCustomToast(context, responce, false);
        }
      });
    } else {
      InserData(tfAddOccState);
    }
  }

  InserData(TFAdditionalOccupantState tfAdditionalOccupantState) {
    List<AdditionalOccupants> additionalOccupantslist = <AdditionalOccupants>[];
    List<AddLead2> applicantIdlist = <AddLead2>[];
    List<String> emails = [];
    if (!tfAdditionalOccupantState.notapplicable) {
      for (int j = 0; j < tfAdditionalOccupantState.occupantlist.length; j++) {
        TenancyAdditionalOccupant taoccupant1 =
            tfAdditionalOccupantState.occupantlist[j];

        if (taoccupant1.firstname != "" &&
            taoccupant1.lastname != "" &&
            taoccupant1.primaryApplicant != "" &&
            taoccupant1.applicant == true) {
          Occupant occupant = new Occupant();
          occupant.FirstName = taoccupant1.firstname;
          occupant.LastName = taoccupant1.lastname;
          occupant.email = taoccupant1.email;
          occupant.mobilenumber = taoccupant1.mobilenumber;
          occupant.suspendedreason = taoccupant1.explain;
          AdditionalOccupants additionalOccupants = new AdditionalOccupants();
          additionalOccupants.Applicantion_ID =
              Prefs.getString(PrefsName.TCF_ApplicationID);
          additionalOccupants.relationWithApplicant =
              taoccupant1.primaryApplicant;
          additionalOccupants.occupant = occupant;

          additionalOccupantslist.add(additionalOccupants);
        }
        if (taoccupant1.firstname != "" &&
            taoccupant1.lastname != "" &&
            taoccupant1.primaryApplicant != "" &&
            taoccupant1.applicant == false) {
          PersonId personid = new PersonId();
          personid.firstName = taoccupant1.firstname;
          personid.lastName = taoccupant1.lastname;
          personid.email = taoccupant1.email;
          personid.mobileNumber = taoccupant1.mobilenumber;
          personid.Country_Code = "";
          personid.Dial_Code = "";

          ApplicantId applicationid = new ApplicantId();
          applicationid.note = "";
          applicationid.personId = personid;

          AddLead2 addlead = new AddLead2();
          addlead.propId = Prefs.getString(PrefsName.PropertyID);
          addlead.applicationStatus = "2";
          addlead.docReviewStatus = "2";
          addlead.referenceStatus = null;
          addlead.leaseStatus = "2";
          addlead.applicantId = applicationid;
          addlead.Owner_ID = Prefs.getString(PrefsName.OwnerID);
          addlead.group1 = Prefs.getString(PrefsName.TCF_ApplicationID);

          applicantIdlist.add(addlead);
          emails.add(taoccupant1.email!);
        }
      }
    }

    UpdateAdditionalOccupants upojo = new UpdateAdditionalOccupants(
        IsNotApplicableAddOccupant: tfAdditionalOccupantState.notapplicable);

    CommonID cpojo =
        new CommonID(ID: Prefs.getString(PrefsName.TCF_ApplicationID));

    ApiManager().InsetTFAdditionalOCcupant(
        context, additionalOccupantslist, cpojo, upojo, (status, responce) {
      if (status) {
        // if (!isGotoback) {
        //   Prefs.setBool(PrefsName.TCF_Step4, true);
        //   if (stepper == 0) {
        //     widget._callbackSaveandNext();
        //   } else {
        //     widget._callbackRecordStep(stepper);
        //     //_store.dispatch(UpdateTenacyFormIndex(stepper));
        //   }
        // } else {
        //   widget._callbackGotoback();
        // }
      } else {
        // loader.remove();
        // ToastUtils.showCustomToast(context, responce, false);
      }
    });
    leadcall(applicantIdlist, emails);
  }

  leadcall(List<AddLead2> applicantIdlist, List<String> emails) {
    ApiManager().InsetNewLeadAPI(context, applicantIdlist,
        (error, respoce) async {
      if (error) {
        InviteWorkFlowReqtokens reqtokens = new InviteWorkFlowReqtokens();
        List<String> ids = respoce.split(",");
        ids.removeLast();
        for (int i = 0; i < ids.length; i++) {
          await ApiManager().DuplicatTemplateHtml(
              context, Prefs.getString(PrefsName.TCF_ApplicationID), ids[i],
              (status, responce) async {
            if (status) {
              reqtokens.id = ids[i];
              reqtokens.ToEmail = emails[i];
              reqtokens.applicationSentDate =
                  new DateFormat("yyyy-MM-dd HH:mm:ss")
                      .format(DateTime.now())
                      .toString();
              reqtokens.HostURL = Weburl.Email_URL;
              reqtokens.DbAppCode = Weburl.API_CODE;
              InviteWorkFlow inviteWorkFlow = new InviteWorkFlow();
              inviteWorkFlow.workFlowId =
                  Weburl.Lead_Invitation_workflow.toString();
              inviteWorkFlow.reqtokens = reqtokens;
              await ApiManager().Emailworkflow(context, inviteWorkFlow,
                  (error, respoce) {
                if (error) {
                  // widget._callbackSave();
                } else {}
              });
            } else {
              ToastUtils.showCustomToast(context, GlobleString.Error1, false);
            }
          });
        }
      } else {
        loader.remove();
        ToastUtils.showCustomToast(
            context, GlobleString.NL_error_insertcall, false);
      }
    });
  }
}
