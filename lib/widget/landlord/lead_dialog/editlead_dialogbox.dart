import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/editlead_actions.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';

import '../../../presentation/models/landlord_models/editlead_state.dart';
import '../../searchdropdown/dropdown_search.dart';

class EditLeadDialogBox extends StatefulWidget {
  String? applicantID = "";
  final VoidCallback _callbackSave;
  final VoidCallback _callbackClose;

  EditLeadDialogBox({
    required String? applicantid,
    required VoidCallback onPressedSave,
    required VoidCallback onPressedClose,
  })  : applicantID = applicantid,
        _callbackSave = onPressedSave,
        _callbackClose = onPressedClose;

  @override
  _EditLeadDialogBoxState createState() => _EditLeadDialogBoxState();
}

class _EditLeadDialogBoxState extends State<EditLeadDialogBox> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  late OverlayEntry loader;
  final _store = getIt<AppStore>();

  @override
  void initState() {
    apimanager();
    super.initState();
  }

  void apimanager() async {
    await Prefs.init();

    PropertyListInDropDown propertyListInDropDown =
        new PropertyListInDropDown();
    propertyListInDropDown.IsActive = "1";
    propertyListInDropDown.Owner_ID = Prefs.getString(PrefsName.OwnerID);

    ApiManager().PropertyListInDropDownApi(context, propertyListInDropDown,
        (mylitems, error) {
      List<PropertyData> propertylist = <PropertyData>[];
      if (error) {
        propertylist = mylitems;
        _store.dispatch(UpdateEditLeadPropertyList(propertylist));
      } else {
        _store.dispatch(UpdateEditLeadPropertyList(propertylist));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, 0),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: 700, maxWidth: 700, minHeight: 455, maxHeight: 460),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.white),
              child: ConnectState<EditLeadState>(
                  map: (state) => state.editLeadState,
                  where: notIdentical,
                  builder: (editLeadState) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              padding:
                                  EdgeInsets.only(top: 20, left: 30, right: 30),
                              child: Text(
                                GlobleString.NL_Lead_Information,
                                style: MyStyles.Medium(20, myColor.text_color),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 20, left: 30, right: 30),
                                  child: InkWell(
                                    onTap: () {
                                      widget._callbackClose();
                                    },
                                    child: Icon(Icons.clear, size: 25),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 0, right: 0),
                            child: Container(
                              //height: 450,
                              padding: EdgeInsets.only(left: 30, right: 30),
                              child: FocusScope(
                                node: _focusScopeNode,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                GlobleString.NL_Select_property,
                                                style: MyStyles.Medium(
                                                    14, myColor.text_color),
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                height: 30,
                                                // ignore: missing_required_param
                                                child: DropdownSearch<
                                                    PropertyData>(
                                                  mode: Mode.MENU,
                                                  isfocus: true,
                                                  focusScopeNode:
                                                      _focusScopeNode,
                                                  key: UniqueKey(),
                                                  defultHeight: editLeadState!
                                                              .propertylist
                                                              .length >
                                                          5
                                                      ? 224
                                                      : (editLeadState
                                                                  .propertylist
                                                                  .length *
                                                              35) +
                                                          50,
                                                  textstyle: MyStyles.Medium(
                                                      12, myColor.text_color),
                                                  focuscolor: myColor.blue,
                                                  focusWidth: 2,
                                                  items: editLeadState
                                                      .propertylist,
                                                  itemAsString:
                                                      (PropertyData? u) =>
                                                          u!.propertyName!,
                                                  hint: GlobleString
                                                      .Select_Property,
                                                  showSearchBox: true,
                                                  selectedItem: editLeadState
                                                              .propertyValue !=
                                                          null
                                                      ? editLeadState
                                                          .propertyValue
                                                      : null,
                                                  isFilteredOnline: true,
                                                  onChanged: (data) {
                                                    _store.dispatch(
                                                        UpdateEditLeadProperty(
                                                            data));
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                GlobleString.NL_First_name,
                                                style: MyStyles.Medium(
                                                    14, myColor.text_color),
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                initialValue:
                                                    editLeadState.firstname,
                                                textAlign: TextAlign.start,
                                                style: MyStyles.Medium(
                                                    14, myColor.text_color),
                                                decoration: InputDecoration(
                                                    //border: InputBorder.none,
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: myColor.blue,
                                                          width: 1.0),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: myColor.gray,
                                                          width: 1.0),
                                                    ),
                                                    isDense: true,
                                                    hintText: GlobleString
                                                        .NL_hint_First_name,
                                                    hintStyle: MyStyles.Regular(
                                                        12, myColor.hintcolor),
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    fillColor: myColor.white,
                                                    filled: true),
                                                onChanged: (value) {
                                                  _store.dispatch(
                                                      UpdateEditLeadFirstname(
                                                          value.toString()));
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                GlobleString.NL_Last_name,
                                                style: MyStyles.Medium(
                                                    14, myColor.text_color),
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                initialValue:
                                                    editLeadState.lastname,
                                                textAlign: TextAlign.start,
                                                style: MyStyles.Medium(
                                                    14, myColor.text_color),
                                                decoration: InputDecoration(
                                                    //border: InputBorder.none,
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: myColor.blue,
                                                          width: 1.0),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: myColor.gray,
                                                          width: 1.0),
                                                    ),
                                                    isDense: true,
                                                    hintText: GlobleString
                                                        .NL_hint_Last_name,
                                                    hintStyle: MyStyles.Regular(
                                                        12, myColor.hintcolor),
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    fillColor: myColor.white,
                                                    filled: true),
                                                onChanged: (value) {
                                                  _store.dispatch(
                                                      UpdateEditLeadLastname(
                                                          value.toString()));
                                                },
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                GlobleString.NL_Email,
                                                style: MyStyles.Medium(
                                                    14, myColor.text_color),
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                initialValue:
                                                    editLeadState.Email,
                                                textAlign: TextAlign.start,
                                                style: MyStyles.Medium(
                                                    14, myColor.text_color),
                                                decoration: InputDecoration(
                                                    //border: InputBorder.none,
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: myColor.blue,
                                                          width: 1.0),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: myColor.gray,
                                                          width: 1.0),
                                                    ),
                                                    isDense: true,
                                                    hintText: GlobleString
                                                        .NL_hint_Enter_email,
                                                    hintStyle: MyStyles.Regular(
                                                        12, myColor.hintcolor),
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    fillColor: myColor.white,
                                                    filled: true),
                                                onChanged: (value) {
                                                  _store.dispatch(
                                                      UpdateEditLeadEmail(
                                                          value.toString()));
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    GlobleString
                                                        .NL_Phone_Number,
                                                    style: MyStyles.Medium(
                                                        14, myColor.text_color),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    GlobleString.Optional,
                                                    style: MyStyles.Medium(
                                                        10, myColor.optional),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: myColor.gray,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    CountryCodePicker(
                                                      onChanged: (value) {
                                                        _store.dispatch(
                                                            UpdateEditLeadCountryCode(
                                                                value.code
                                                                    .toString()));

                                                        _store.dispatch(
                                                            UpdateEditLeadCountryDialCode(
                                                                value.dialCode
                                                                    .toString()));
                                                      },
                                                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                                      initialSelection:
                                                          editLeadState
                                                              .CountryCode,
                                                      showFlag: true,
                                                      textStyle:
                                                          MyStyles.Medium(
                                                              14,
                                                              myColor
                                                                  .text_color),
                                                      dialogTextStyle:
                                                          MyStyles.Medium(
                                                              14,
                                                              myColor
                                                                  .text_color),
                                                      //showDropDownButton: true,
                                                    ),
                                                    Expanded(
                                                      child: TextFormField(
                                                        initialValue:
                                                            editLeadState
                                                                .phoneNumber,
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        inputFormatters: [
                                                          MaskedInputFormatter(
                                                              "(000) 000 0000")
                                                        ],
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                          contentPadding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          isDense: true,
                                                        ),
                                                        style: MyStyles.Medium(
                                                            14,
                                                            myColor.text_color),
                                                        onChanged: (value) {
                                                          _store.dispatch(
                                                              UpdateEditLeadPhoneNumber(
                                                                  value
                                                                      .toString()));
                                                        },
                                                      ),
                                                    ),
                                                  ],
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                    GlobleString.Notes,
                                                    style: MyStyles.Medium(
                                                        14, myColor.text_color),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    GlobleString.Optional,
                                                    style: MyStyles.Medium(
                                                        10, myColor.optional),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                initialValue:
                                                    editLeadState.PrivateNotes,
                                                textAlign: TextAlign.start,
                                                style: MyStyles.Medium(
                                                    14, myColor.text_color),
                                                maxLines: 4,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      450),
                                                ],
                                                decoration: InputDecoration(
                                                    //border: InputBorder.none,
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: myColor.blue,
                                                          width: 1.0),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: myColor.gray,
                                                          width: 1.0),
                                                    ),
                                                    isDense: true,
                                                    hintText: GlobleString
                                                        .NL_hint_notes_here,
                                                    hintStyle: MyStyles.Regular(
                                                        12, myColor.hintcolor),
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    fillColor: myColor.white,
                                                    filled: true),
                                                onChanged: (value) {
                                                  _store.dispatch(
                                                      UpdateEditLeadNotes(
                                                          value.toString()));
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: 20, left: 30, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  _checkValidation(context, editLeadState);
                                },
                                child: Container(
                                  height: 35,
                                  padding: EdgeInsets.only(left: 25, right: 25),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: myColor.Circle_main,
                                  ),
                                  child: Text(
                                    GlobleString.NL_SAVE,
                                    style: MyStyles.Medium(14, myColor.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  void _checkValidation(BuildContext context, EditLeadState editLeadState) {
    if (editLeadState.propertyValue == null) {
      ToastUtils.showCustomToast(
          context, GlobleString.NL_error_Select_property, false);
    } else if (editLeadState.firstname == null ||
        editLeadState.firstname!.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.NL_error_First_name, false);
    } else if (editLeadState.lastname == null ||
        editLeadState.lastname!.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.NL_error_Last_name, false);
    } else if (editLeadState.Email == null || editLeadState.Email!.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.NL_error_Enter_email, false);
    } else if (Helper.ValidEmail(editLeadState.Email!.trim().toString()) !=
        true) {
      ToastUtils.showCustomToast(
          context, GlobleString.NL_error_valid_email, false);
    } else if (editLeadState.phoneNumber != null &&
        editLeadState.phoneNumber!.isNotEmpty &&
        editLeadState.phoneNumber!.length < 10) {
      ToastUtils.showCustomToast(
          context, GlobleString.NL_error_valid_phone, false);
    } else {
      EditLeadPersonId personid = new EditLeadPersonId();
      personid.ID = editLeadState.PersionId;
      personid.firstName = editLeadState.firstname;
      personid.lastName = editLeadState.lastname;
      personid.email = editLeadState.Email;
      personid.mobileNumber = editLeadState.phoneNumber;
      personid.Country_Code = editLeadState.CountryCode;
      personid.Dial_Code = editLeadState.CountrydialCode;

      EditLeadApplicantId applicationid = new EditLeadApplicantId();
      applicationid.ID = editLeadState.applicantid;
      applicationid.note = editLeadState.PrivateNotes;
      applicationid.personId = personid;

      EditLead editlead = new EditLead();
      editlead.propId = editLeadState.propertyValue!.ID.toString();
      editlead.applicantId = applicationid;

      CommonID commonID = new CommonID();
      commonID.ID = editLeadState.applicationid.toString();

      leadcall(editlead, commonID);
    }
  }

  void leadcall(EditLead editlead, CommonID commonID) {
    ApiManager().UpdateLead(context, commonID, editlead, (error, respoce) {
      if (error) {
        widget._callbackSave();
      } else {
        ToastUtils.showCustomToast(
            context, GlobleString.NL_error_insertcall, false);
      }
    });
  }
}
