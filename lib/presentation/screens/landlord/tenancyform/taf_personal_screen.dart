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
import 'package:silverhome/domain/actions/landlord_action/tenancyform_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancyperson_actions.dart';
import 'package:silverhome/presentation/models/landlord_models/tf_personal_state.dart';
import 'package:silverhome/presentation/screens/landlord/tenancyform/tenancyapplicationfrom_screen.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';

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

  @override
  void initState() {
    initilizedata();
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
            _form(),
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
                              SizedBox(
                                height: 10,
                              ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [saveandnext(tfPersonalState)],
                    ),
                  ],
                ));
          }),
    );
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
}
