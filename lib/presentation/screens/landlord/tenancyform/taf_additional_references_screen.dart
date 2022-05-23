import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
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
import 'package:silverhome/domain/actions/landlord_action/tenancyaddreference_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancyform_actions.dart';
import 'package:silverhome/domain/entities/tenancy_additional_reference.dart';
import 'package:silverhome/presentation/models/landlord_models/tf_additonal_reference_state.dart';
import 'package:silverhome/presentation/screens/landlord/tenancyform/tenancyapplicationfrom_screen.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/alert_dialogbox.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/message_dialogbox.dart';

typedef VoidCallbackRecordStep = void Function(int stepper);

class TAFAdditionalReferencesScreen extends StatefulWidget {
  final VoidCallback _callbackBack;
  final VoidCallback _callbackSaveandNext;
  final VoidCallback _callbackGotoBack;
  final VoidCallbackRecordStep _callbackRecordStep;

  TAFAdditionalReferencesScreen({
    required VoidCallbackRecordStep onPressedRecordStep,
    required VoidCallback onPressedBack,
    required VoidCallback onPressedSave,
    required VoidCallback onPressGotoBack,
  })  : _callbackBack = onPressedBack,
        _callbackSaveandNext = onPressedSave,
        _callbackGotoBack = onPressGotoBack,
        _callbackRecordStep = onPressedRecordStep;

  @override
  _TAFAdditionalReferencesScreenState createState() =>
      _TAFAdditionalReferencesScreenState();
}

class _TAFAdditionalReferencesScreenState
    extends State<TAFAdditionalReferencesScreen> {
  double height = 0, width = 0;

  final _store = getIt<AppStore>();
  late OverlayEntry loader;
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  bool isGotoback = false;
  int stepper = 0;
  bool change = false;

  @override
  void initState() {
    super.initState();
    initilizedata();
    initNavigationBack();
    TenancyApplicationFormScreen.changeFormData = false;
  }

  initilizedata() {
    if (_store.state!.tfAdditionalReferenceState != null) {
      TFAdditionalReferenceState tfAdditionalReferenceState =
          _store.state!.tfAdditionalReferenceState;

      _store.dispatch(UpdateTFAdditionalReferencelist([]));
      _store.dispatch(UpdateTFAdditionalLiveServerReferencelist([]));

      List<TenancyAdditionalReference> secondList =
          tfAdditionalReferenceState.FNLreferencelist.map(
              (item) => new TenancyAdditionalReference.clone(item)).toList();
      List<TenancyAdditionalReference> livesecondList =
          tfAdditionalReferenceState.FNLLiveServerreferencelist.map(
              (item) => new TenancyAdditionalReference.clone(item)).toList();

      _store.dispatch(UpdateTFAdditionalReferencelist(secondList));
      _store
          .dispatch(UpdateTFAdditionalLiveServerReferencelist(livesecondList));

      _store.dispatch(UpdateTFAdditionalReferenceisAutherize(
          tfAdditionalReferenceState.FNLisAutherize));
      _store.dispatch(UpdateTFAdditionalReferenceisTermsCondition(
          tfAdditionalReferenceState.FNLisTermsCondition));
    }
  }

  initNavigationBack() {
    navigationNotifier.addListener(() {
      if (mounted) if (navigationNotifier.backScreen ==
          NavigationConstant.tenancyReference) {
        isGotoback = navigationNotifier.gotoBack;
        stepper = navigationNotifier.stepper;
        _saveDataAndNext(_store.state!.tfAdditionalReferenceState);
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

  Widget Form() {
    return Container(
      width: 1000,
      child: ConnectState<TFAdditionalReferenceState>(
          map: (state) => state.tfAdditionalReferenceState,
          where: notIdentical,
          builder: (tfAdditionalReferenceState) {
            if (tfAdditionalReferenceState!.referencelist.length == 0) {
              List<TenancyAdditionalReference> listreference = [];
              TenancyAdditionalReference referenceinfo =
                  new TenancyAdditionalReference();
              referenceinfo.id = "1";
              referenceinfo.firstname = "";
              referenceinfo.lastname = "";
              referenceinfo.reletionshipprimaryApplicant = "";
              referenceinfo.phonenumber = "";
              referenceinfo.email = "";
              referenceinfo.countrycode = "CA";
              referenceinfo.dailcode = "+1";
              referenceinfo.isEditable = false;
              listreference.add(referenceinfo);

              _store.dispatch(UpdateTFAdditionalReferencelist(listreference));
            }

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
                          GlobleString.TAF_Additional_References,
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
                    itemCount: tfAdditionalReferenceState.referencelist.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      TenancyAdditionalReference reference =
                          tfAdditionalReferenceState.referencelist[Index];
                      return FocusScope(
                        node: FocusScopeNode(),
                        child: Column(
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
                                        GlobleString.TAF_AR_first_name,
                                        style: MyStyles.Medium(
                                            13,
                                            reference.isEditable!
                                                ? myColor.disablecolor
                                                : myColor.text_color),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        onChanged: (newValue) {
                                          tfAdditionalReferenceState
                                              .referencelist[Index]
                                              .firstname = newValue.toString();
                                          _changeData();
                                        },
                                        autofocus: true,
                                        initialValue: reference.firstname,
                                        textAlign: TextAlign.start,
                                        readOnly: reference.isEditable!,
                                        style: MyStyles.Medium(
                                            13,
                                            reference.isEditable!
                                                ? myColor.disablecolor
                                                : myColor.text_color),
                                        decoration: InputDecoration(
                                            //border: InputBorder.none,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: reference.isEditable!
                                                      ? myColor.disablecolor
                                                      : myColor.blue,
                                                  width: 1.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: reference.isEditable!
                                                      ? myColor.disablecolor
                                                      : myColor.gray,
                                                  width: 1.0),
                                            ),
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(10),
                                            fillColor: myColor.white,
                                            filled: true),
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
                                        GlobleString.TAF_AR_Last_name,
                                        style: MyStyles.Medium(
                                            13,
                                            reference.isEditable!
                                                ? myColor.disablecolor
                                                : myColor.text_color),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        onChanged: (newValue) {
                                          tfAdditionalReferenceState
                                              .referencelist[Index]
                                              .lastname = newValue.toString();
                                          _changeData();
                                        },
                                        initialValue: reference.lastname,
                                        textAlign: TextAlign.start,
                                        readOnly: reference.isEditable!,
                                        style: MyStyles.Medium(
                                            13,
                                            reference.isEditable!
                                                ? myColor.disablecolor
                                                : myColor.text_color),
                                        decoration: InputDecoration(
                                            //border: InputBorder.none,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: reference.isEditable!
                                                      ? myColor.disablecolor
                                                      : myColor.blue,
                                                  width: 1.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: reference.isEditable!
                                                      ? myColor.disablecolor
                                                      : myColor.gray,
                                                  width: 1.0),
                                            ),
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(10),
                                            fillColor: myColor.white,
                                            filled: true),
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
                                            .TAF_AR_Relationship_applicant,
                                        style: MyStyles.Medium(
                                            13,
                                            reference.isEditable!
                                                ? myColor.disablecolor
                                                : myColor.text_color),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        onChanged: (newValue) {
                                          tfAdditionalReferenceState
                                                  .referencelist[Index]
                                                  .reletionshipprimaryApplicant =
                                              newValue.toString();
                                          _changeData();
                                        },
                                        initialValue: reference
                                            .reletionshipprimaryApplicant,
                                        textAlign: TextAlign.start,
                                        readOnly: reference.isEditable!,
                                        style: MyStyles.Medium(
                                            13,
                                            reference.isEditable!
                                                ? myColor.disablecolor
                                                : myColor.text_color),
                                        decoration: InputDecoration(
                                            //border: InputBorder.none,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: reference.isEditable!
                                                      ? myColor.disablecolor
                                                      : myColor.blue,
                                                  width: 1.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: reference.isEditable!
                                                      ? myColor.disablecolor
                                                      : myColor.gray,
                                                  width: 1.0),
                                            ),
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(10),
                                            fillColor: myColor.white,
                                            filled: true),
                                      ),
                                    ],
                                  ),
                                )
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        GlobleString.TAF_AR_Phone_number,
                                        style: MyStyles.Medium(
                                            13,
                                            reference.isEditable!
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
                                            color: reference.isEditable!
                                                ? myColor.disablecolor
                                                : myColor.gray,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            CountryCodePicker(
                                              onChanged: (value) {
                                                tfAdditionalReferenceState
                                                        .referencelist[Index]
                                                        .countrycode =
                                                    value.code.toString();

                                                tfAdditionalReferenceState
                                                        .referencelist[Index]
                                                        .dailcode =
                                                    value.dialCode.toString();
                                                _changeData();
                                              },
                                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                              initialSelection:
                                                  reference.countrycode,
                                              showFlag: true,
                                              textStyle: MyStyles.Medium(
                                                  13, myColor.text_color),
                                              dialogTextStyle: MyStyles.Medium(
                                                  13, myColor.text_color),
                                              enabled: !reference.isEditable!,
                                              //showDropDownButton: true,
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                onChanged: (newValue) {
                                                  tfAdditionalReferenceState
                                                          .referencelist[Index]
                                                          .phonenumber =
                                                      newValue.toString();
                                                  _changeData();
                                                },
                                                initialValue:
                                                    reference.phonenumber,
                                                keyboardType:
                                                    TextInputType.phone,
                                                readOnly: reference.isEditable!,
                                                inputFormatters: [
                                                  MaskedInputFormatter(
                                                      "(000) 000 0000")
                                                ],
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                  isDense: true,
                                                ),
                                                style: MyStyles.Medium(
                                                    13,
                                                    reference.isEditable!
                                                        ? myColor.disablecolor
                                                        : myColor.text_color),
                                              ),
                                            ),
                                          ],
                                        ),
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
                                        GlobleString.TAF_AR_Email_address,
                                        style: MyStyles.Medium(
                                            13,
                                            reference.isEditable!
                                                ? myColor.disablecolor
                                                : myColor.text_color),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        onChanged: (newValue) {
                                          tfAdditionalReferenceState
                                              .referencelist[Index]
                                              .email = newValue.toString();
                                          _changeData();
                                        },
                                        initialValue: reference.email,
                                        textAlign: TextAlign.start,
                                        readOnly: reference.isEditable!,
                                        style: MyStyles.Medium(
                                            13,
                                            reference.isEditable!
                                                ? myColor.disablecolor
                                                : myColor.text_color),
                                        decoration: InputDecoration(
                                            //border: InputBorder.none,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: reference.isEditable!
                                                      ? myColor.disablecolor
                                                      : myColor.blue,
                                                  width: 1.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: reference.isEditable!
                                                      ? myColor.disablecolor
                                                      : myColor.gray,
                                                  width: 1.0),
                                            ),
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(10),
                                            fillColor: myColor.white,
                                            filled: true),
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
                                      tfAdditionalReferenceState
                                                  .referencelist.length >
                                              1
                                          ? reference.isEditable!
                                              ? Container()
                                              : InkWell(
                                                  hoverColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      barrierColor:
                                                          Colors.black45,
                                                      useSafeArea: true,
                                                      barrierDismissible: false,
                                                      builder: (BuildContext
                                                          context1) {
                                                        return AlertDialogBox(
                                                          title: GlobleString
                                                              .TAF_Additional_References_dailog_msg,
                                                          positiveText: GlobleString
                                                              .TAF_Additional_References_dailog_yes,
                                                          negativeText: GlobleString
                                                              .TAF_Additional_References_dailog_no,
                                                          onPressedYes: () {
                                                            Navigator.of(
                                                                    context1)
                                                                .pop();
                                                            tfAdditionalReferenceState
                                                                .referencelist
                                                                .removeAt(
                                                                    Index);

                                                            _store.dispatch(
                                                                UpdateTFAdditionalReferencelist(
                                                                    tfAdditionalReferenceState
                                                                        .referencelist));
                                                            _changeData();
                                                          },
                                                          onPressedNo: () {
                                                            Navigator.of(
                                                                    context1)
                                                                .pop();
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    margin: EdgeInsets.only(
                                                        top: 20),
                                                    alignment: Alignment.center,
                                                    child: Image.asset(
                                                      "assets/images/ic_delete.png",
                                                      height: 22,
                                                      //width: 20,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    ),
                                                  ),
                                                )
                                          : Container()
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [AddNewReference(tfAdditionalReferenceState)],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        activeColor: myColor.Circle_main,
                        checkColor: myColor.white,
                        value: tfAdditionalReferenceState.isAutherize,
                        onChanged: (value) {
                          _store.dispatch(
                              UpdateTFAdditionalReferenceisAutherize(value!));
                          _changeData();
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            GlobleString.AR_Agree1,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: MyStyles.Medium(12, myColor.text_color),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        activeColor: myColor.Circle_main,
                        checkColor: myColor.white,
                        value: tfAdditionalReferenceState.isTermsCondition,
                        onChanged: (value) {
                          _store.dispatch(
                              UpdateTFAdditionalReferenceisTermsCondition(
                                  value!));
                          _changeData();
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text.rich(
                          TextSpan(
                              text: 'I have read and agree with the ',
                              style: MyStyles.Medium(12, myColor.text_color),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: MyStyles.Medium(12, myColor.blue),
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                      Helper.launchURL(Weburl
                                          .PrivacyPolicy_and_TermsConditions);
                                    },
                                ),
                                TextSpan(
                                  text: ' and ',
                                  style:
                                      MyStyles.Medium(12, myColor.text_color),
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: MyStyles.Medium(12, myColor.blue),
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                      Helper.launchURL(Weburl
                                          .PrivacyPolicy_and_TermsConditions);
                                    },
                                ),
                                TextSpan(
                                  text:
                                      ' from Silver Homes Technology Inc. included in the website',
                                  style:
                                      MyStyles.Medium(12, myColor.text_color),
                                )
                              ]),
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
                      saveandnext(tfAdditionalReferenceState)
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget AddNewReference(
      TFAdditionalReferenceState tfAdditionalReferenceState) {
    return InkWell(
      onTap: () {
        _addnewoccupation(tfAdditionalReferenceState);
      },
      child: Container(
        height: 35,
        padding: EdgeInsets.only(left: 15, right: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
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
              GlobleString.TAF_AR_Add_new_Reference,
              style: MyStyles.Medium(14, myColor.white),
            ),
          ],
        ),
      ),
    );
  }

  void _addnewoccupation(
      TFAdditionalReferenceState tfAdditionalReferenceState) {
    bool isAdd = false;

    for (int i = 0; i < tfAdditionalReferenceState.referencelist.length; i++) {
      TenancyAdditionalReference reference =
          tfAdditionalReferenceState.referencelist[i];

      if (reference.firstname!.isEmpty) {
        isAdd = true;
        ToastUtils.showCustomToast(
            context, GlobleString.taf_reference_error_firstname, false);
        break;
      } else if (reference.lastname!.isEmpty) {
        isAdd = true;
        ToastUtils.showCustomToast(
            context, GlobleString.taf_reference_error_lastname, false);
        break;
      } else if (reference.reletionshipprimaryApplicant!.isEmpty) {
        isAdd = true;
        ToastUtils.showCustomToast(
            context, GlobleString.taf_reference_error_primaryApplicant, false);
        break;
      } else if (reference.phonenumber!.isEmpty) {
        isAdd = true;
        ToastUtils.showCustomToast(
            context, GlobleString.taf_reference_error_phonenumber, false);
        break;
      } else if (Helper.ValidPhonenumber(reference.phonenumber!)) {
        isAdd = true;
        ToastUtils.showCustomToast(
            context, GlobleString.taf_reference_error__validphonenumber, false);
      } else if (reference.email!.isEmpty) {
        isAdd = true;
        ToastUtils.showCustomToast(
            context, GlobleString.taf_reference_error_email, false);
        break;
      } else if (Helper.ValidEmail(reference.email!.trim().toString()) !=
          true) {
        isAdd = true;
        ToastUtils.showCustomToast(
            context, GlobleString.taf_reference_error_valid_email, false);
        break;
      }

      if ((tfAdditionalReferenceState.referencelist.length - 1) == i &&
          !isAdd) {
        tfAdditionalReferenceState.referencelist.add(
            new TenancyAdditionalReference(
                id: (tfAdditionalReferenceState.referencelist.length + 1)
                    .toString(),
                firstname: "",
                lastname: "",
                reletionshipprimaryApplicant: "",
                phonenumber: "",
                countrycode: "CA",
                dailcode: "+1",
                email: "",
                isEditable: false,
                isLive: false));

        _store.dispatch(UpdateTFAdditionalReferencelist(
            tfAdditionalReferenceState.referencelist));
        _changeData();
        break;
      }
    }
  }

  Widget back() {
    return InkWell(
      onTap: () {
        widget._callbackBack();
      },
      child: CustomeWidget.TenantBackButton(),
    );
  }

  Widget saveandnext(TFAdditionalReferenceState ReferenceState) {
    return InkWell(
      onTap: () => _saveDataAndNext(ReferenceState),
      child: CustomeWidget.SaveAndNext(GlobleString.Submit),
    );
  }

  _saveDataAndNext(TFAdditionalReferenceState ReferenceState) {
    bool isAdd = false;

    for (int i = 0; i < ReferenceState.referencelist.length; i++) {
      TenancyAdditionalReference reference = ReferenceState.referencelist[i];

      if (Prefs.getBool(PrefsName.TCF_Current_isReference)) {
        if (reference.firstname == "" &&
            reference.lastname == "" &&
            reference.reletionshipprimaryApplicant == "" &&
            reference.phonenumber == "" &&
            reference.email == "") {
          isAdd = false;
        } else {
          if (reference.firstname == "") {
            isAdd = true;
            ToastUtils.showCustomToast(
                context, GlobleString.taf_reference_error_firstname, false);
            break;
          } else if (reference.lastname == "") {
            isAdd = true;
            ToastUtils.showCustomToast(
                context, GlobleString.taf_reference_error_lastname, false);
            break;
          } else if (reference.reletionshipprimaryApplicant == "") {
            isAdd = true;
            ToastUtils.showCustomToast(context,
                GlobleString.taf_reference_error_primaryApplicant, false);
            break;
          } else if (reference.phonenumber == "") {
            isAdd = true;
            ToastUtils.showCustomToast(
                context, GlobleString.taf_reference_error_phonenumber, false);
            break;
          } else if (Helper.ValidPhonenumber(
              reference.phonenumber.toString())) {
            isAdd = true;
            ToastUtils.showCustomToast(context,
                GlobleString.taf_reference_error__validphonenumber, false);
            break;
          } else if (reference.email == "") {
            isAdd = true;
            ToastUtils.showCustomToast(
                context, GlobleString.taf_reference_error_email, false);
            break;
          } else if (Helper.ValidEmail(reference.email!.trim().toString()) !=
              true) {
            isAdd = true;
            ToastUtils.showCustomToast(
                context, GlobleString.taf_reference_error_valid_email, false);
            break;
          }
        }

        if ((ReferenceState.referencelist.length - 1) == i && !isAdd) {
          if (!ReferenceState.isAutherize) {
            ToastUtils.showCustomToast(
                context, GlobleString.taf_reference_error_isAuthorize, false);
          } else if (!ReferenceState.isTermsCondition) {
            ToastUtils.showCustomToast(
                context, GlobleString.taf_reference_error_termcondition, false);
          } else {
            //ToastUtils.showCustomToast(context, "Success", true);
            ApiCall(ReferenceState);
          }
        }
      } else {
        if (reference.firstname == "") {
          isAdd = true;
          ToastUtils.showCustomToast(
              context, GlobleString.taf_reference_error_firstname, false);
          break;
        } else if (reference.lastname == "") {
          isAdd = true;
          ToastUtils.showCustomToast(
              context, GlobleString.taf_reference_error_lastname, false);
          break;
        } else if (reference.reletionshipprimaryApplicant == "") {
          isAdd = true;
          ToastUtils.showCustomToast(context,
              GlobleString.taf_reference_error_primaryApplicant, false);
          break;
        } else if (reference.phonenumber == "") {
          isAdd = true;
          ToastUtils.showCustomToast(
              context, GlobleString.taf_reference_error_phonenumber, false);
          break;
        } else if (Helper.ValidPhonenumber(reference.phonenumber.toString())) {
          isAdd = true;
          ToastUtils.showCustomToast(context,
              GlobleString.taf_reference_error__validphonenumber, false);
          break;
        } else if (reference.email == "") {
          isAdd = true;
          ToastUtils.showCustomToast(
              context, GlobleString.taf_reference_error_email, false);
          break;
        } else if (Helper.ValidEmail(reference.email!.trim().toString()) !=
            true) {
          isAdd = true;
          ToastUtils.showCustomToast(
              context, GlobleString.taf_reference_error_valid_email, false);
          break;
        }

        if ((ReferenceState.referencelist.length - 1) == i && !isAdd) {
          if (!ReferenceState.isAutherize) {
            ToastUtils.showCustomToast(
                context, GlobleString.taf_reference_error_isAuthorize, false);
          } else if (!ReferenceState.isTermsCondition) {
            ToastUtils.showCustomToast(
                context, GlobleString.taf_reference_error_termcondition, false);
          } else {
            //ToastUtils.showCustomToast(context, "Success", true);
            ApiCall(ReferenceState);
          }
        }
      }
    }
  }

  ApiCall(TFAdditionalReferenceState ReferenceState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    List<CommonID> CommonIDlist = <CommonID>[];

    for (int i = 0; i < ReferenceState.LiveServerreferencelist.length; i++) {
      TenancyAdditionalReference taoccupant =
          ReferenceState.LiveServerreferencelist[i];

      if (taoccupant.ReferenceID != "") {
        if (Prefs.getString(PrefsName.TCF_CurrentlandlordID) !=
            taoccupant.ReferenceID) {
          if (!taoccupant.isEditable!) {
            CommonIDlist.add(new CommonID(ID: taoccupant.ReferenceID));
          }
        }
      }
    }

    if (CommonIDlist.length > 0) {
      DeleteAdditionalReference deleteAddreference =
          new DeleteAdditionalReference();
      deleteAddreference.Applicantion_ID =
          Prefs.getString(PrefsName.TCF_ApplicationID);
      deleteAddreference.QuestionnaireSentDate = null;
      deleteAddreference.QuestionnaireReceivedDate = null;

      ApiManager().TFAdditionalReferenceDelete(
          context, CommonIDlist, deleteAddreference, (status, responce) {
        if (status) {
          InserData(ReferenceState);
        } else {
          loader.remove();
          ToastUtils.showCustomToast(context, responce, false);
        }
      });
    } else {
      InserData(ReferenceState);
    }
  }

  InserData(TFAdditionalReferenceState referenceState) {
    List<AdditionalReferencesInfo> additionalreferencelist =
        <AdditionalReferencesInfo>[];

    for (int j = 0; j < referenceState.referencelist.length; j++) {
      TenancyAdditionalReference taoccupant1 = referenceState.referencelist[j];

      if (!taoccupant1.isEditable!) {
        if (Prefs.getBool(PrefsName.TCF_Current_isReference)) {
          if (taoccupant1.firstname == "" &&
              taoccupant1.lastname == "" &&
              taoccupant1.reletionshipprimaryApplicant == "" &&
              taoccupant1.phonenumber == "" &&
              taoccupant1.email == "") {
          } else {
            ReferenceID referenceID = new ReferenceID();
            referenceID.FirstName = taoccupant1.firstname;
            referenceID.LastName = taoccupant1.lastname;
            referenceID.Email = taoccupant1.email;
            referenceID.MobileNumber = taoccupant1.phonenumber;
            referenceID.Dial_Code = taoccupant1.dailcode;
            referenceID.Country_Code = taoccupant1.countrycode;

            AdditionalReferencesInfo additionalOccupants =
                new AdditionalReferencesInfo();
            additionalOccupants.Applicantion_ID =
                Prefs.getString(PrefsName.TCF_ApplicationID);
            additionalOccupants.RelationWithApplicant =
                taoccupant1.reletionshipprimaryApplicant;
            additionalOccupants.referenceID = referenceID;

            additionalreferencelist.add(additionalOccupants);
          }
        } else {
          ReferenceID referenceID = new ReferenceID();
          referenceID.FirstName = taoccupant1.firstname;
          referenceID.LastName = taoccupant1.lastname;
          referenceID.Email = taoccupant1.email;
          referenceID.MobileNumber = taoccupant1.phonenumber;
          referenceID.Dial_Code = taoccupant1.dailcode;
          referenceID.Country_Code = taoccupant1.countrycode;

          AdditionalReferencesInfo additionalOccupants =
              new AdditionalReferencesInfo();
          additionalOccupants.Applicantion_ID =
              Prefs.getString(PrefsName.TCF_ApplicationID);
          additionalOccupants.RelationWithApplicant =
              taoccupant1.reletionshipprimaryApplicant;
          additionalOccupants.referenceID = referenceID;

          additionalreferencelist.add(additionalOccupants);
        }
      }
    }

    AdditionalReferences upojo = new AdditionalReferences();
    upojo.IsAuthorized = referenceState.isAutherize;
    upojo.IsAgreedTerms = referenceState.isTermsCondition;
    upojo.ApplicationReceivedDate =
        new DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();

    CommonID cpojo =
        new CommonID(ID: Prefs.getString(PrefsName.TCF_ApplicationID));

    ApiManager().InsetTFAdditionalReference(
        context, additionalreferencelist, cpojo, upojo, (status, responce) {
      if (status) {
        if (Prefs.getBool(PrefsName.TCF_Current_isReference)) {
          InsertAsReference();
        } else {
          if (Prefs.getBool(PrefsName.TCF_EditApplicant) != null &&
              Prefs.getBool(PrefsName.TCF_EditApplicant) != "" &&
              Prefs.getBool(PrefsName.TCF_EditApplicant) == true) {
            loader.remove();
            showdialod();
          } else {
            NotificationCall();
          }
        }

        /* if (Prefs.getBool(PrefsName.TCF_EditApplicant) != null &&
            Prefs.getBool(PrefsName.TCF_EditApplicant) != "" &&
            Prefs.getBool(PrefsName.TCF_EditApplicant) == true) {
          loader.remove();
          showdialod();
        } else {
          NotificationCall();
        }*/
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
  }

  InsertAsReference() {
    CheckReferenceExit currentLandLord = new CheckReferenceExit();
    currentLandLord.ReferenceID =
        Prefs.getString(PrefsName.TCF_CurrentlandlordID);

    ApiManager().CheckReferenceCurrentLandLord(context, currentLandLord,
        (status, responce) {
      if (status) {
        if (Prefs.getBool(PrefsName.TCF_EditApplicant) != null &&
            Prefs.getBool(PrefsName.TCF_EditApplicant) != "" &&
            Prefs.getBool(PrefsName.TCF_EditApplicant) == true) {
          loader.remove();
          showdialod();
        } else {
          NotificationCall();
        }
      } else {
        AdditionalReferencesAsCurrentTenancy arc =
            new AdditionalReferencesAsCurrentTenancy();
        arc.Applicantion_ID = Prefs.getString(PrefsName.TCF_ApplicationID);
        arc.RelationWithApplicant = "Current LandLord";
        arc.referenceID = Prefs.getString(PrefsName.TCF_CurrentlandlordID);

        ApiManager().InsertCurrentLandLordAsReference(context, arc,
            (status, responce) {
          if (status) {
            if (Prefs.getBool(PrefsName.TCF_EditApplicant) != null &&
                Prefs.getBool(PrefsName.TCF_EditApplicant) != "" &&
                Prefs.getBool(PrefsName.TCF_EditApplicant) == true) {
              loader.remove();
              showdialod();
            } else {
              NotificationCall();
            }
          } else {
            ToastUtils.showCustomToast(context, responce, false);
          }
        });
      }
    });
  }

  NotificationCall() {
    ApiManager().NotificationAppReceive(
        context, Prefs.getString(PrefsName.TCF_ApplicationID),
        (status, responce) async {
      if (status) {
        loader.remove();
        showdialod();
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, GlobleString.Error1, false);
      }
    });
  }

  showdialod() {
    if (!isGotoback) {
      if (stepper == 0) {
        showSuccessdialod();
      } else {
        Prefs.setBool(PrefsName.TCF_Step6, true);
        widget._callbackRecordStep(stepper);
        //_store.dispatch(UpdateTenacyFormIndex(stepper));
      }
    } else {
      widget._callbackGotoBack();
    }
  }

  showSuccessdialod() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MessageDialogBox(
          buttontitle: GlobleString.dailog_application_success_close,
          title: GlobleString.dailog_application_success,
          onPressed: () {
            Navigator.of(context).pop();
            widget._callbackSaveandNext();
          },
        );
      },
    );
  }
}
