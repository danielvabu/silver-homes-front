import 'package:flutter/cupertino.dart';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:signature/signature.dart';
import 'package:silverhome/common/DecimalTextInputFormatter.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/navigation_constants.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancy_varification_doc_actions.dart';

import 'package:silverhome/domain/actions/landlord_action/tenancyform_actions.dart';

import 'package:silverhome/presentation/models/landlord_models/tenancy_varification_doc_state.dart';

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
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/alert/message_dialogbox.dart';
import 'package:silverhome/widget/alert/message_dialogboxAlert.dart';

import 'package:silverhome/widget/landlord/customewidget.dart';

import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

typedef VoidCallbackRecordStep = void Function(int stepper);

class TAFDisclaimerScreen extends StatefulWidget {
  final VoidCallback _callbackSaveandNext;
  final VoidCallback _callbackGotoBack;
  final VoidCallbackRecordStep _callbackRecordStep;

  TAFDisclaimerScreen({
    required VoidCallbackRecordStep onPressedRecordStep,
    required VoidCallback onPressedSave,
    required VoidCallback onPressGotoBack,
  })  : _callbackSaveandNext = onPressedSave,
        _callbackGotoBack = onPressGotoBack,
        _callbackRecordStep = onPressedRecordStep;

  @override
  _TAFDisclaimerScreenState createState() => _TAFDisclaimerScreenState();
}

class _TAFDisclaimerScreenState extends State<TAFDisclaimerScreen> {
  double height = 0, width = 0;

  final _store = getIt<AppStore>();
  late OverlayEntry loader;

  static List<SystemEnumDetails> empstatuslist = [];
  static List<SystemEnumDetails> anualincomelist = [];
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  bool isGotoback = false;
  int stepper = 0;
  bool change = false;
  bool apr1 = false;
  bool apr2 = false;

  @override
  void initState() {
    super.initState();
    empstatuslist.clear();
    anualincomelist.clear();
    cargarvar();

    // initNavigationBack();
    TenancyApplicationFormScreen.changeFormData = false;
  }

  // initNavigationBack() {
  //   navigationNotifier.addListener(() {
  //     if (mounted) if (navigationNotifier.backScreen ==
  //         NavigationConstant.tenancyDisclaimer) {
  //       isGotoback = navigationNotifier.gotoBack;
  //       stepper = navigationNotifier.stepper;
  //       _saveDataAndNext(_store.state!.tfDisclaimerState);
  //     }
  //   });
  // }
  cargarvar() async {
    await Prefs.init();
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

    return SafeArea(
      minimum: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Center(
          child: _initialview(),
        ),
      ),
    );
  }

  Widget _initialview() {
    return Container(
      width: 1000,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              GlobleString.TAF_Disclaimers,
              style: MyStyles.Medium(20, myColor.text_color),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (Prefs.getBool(PrefsName.TCF_Step0) == false)
                        ? Checkbox(
                            activeColor: myColor.Circle_main,
                            checkColor: myColor.white,
                            value: apr1,
                            onChanged: (value) {
                              setState(() {
                                apr1 = value!;
                              });
                              // _store.dispatch(
                              //     UpdateTFCurrenttenantisReference(value!));
                              // _changeData();
                            },
                          )
                        : Checkbox(
                            activeColor: myColor.Circle_main,
                            checkColor: myColor.white,
                            value: true,
                            onChanged: null,
                          ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "For the purpose of determining whether this Application for Tenancy is acceptable, the Applicant consents to the Landlord obtaining credit, personal and employment \n information on the Applicant from one or more consumer reporting agencies and any other sources of such information. The Applicant authorized the reporting \n agencies and any other person, including personnel from any government ministry or agency, to disclose relevant information about the Applicant to the Landlord.\n if this application is accepted, the Applicant understands that the above information will also be used and disclosed for responding to emergencies, ensuring\n the orderly management of the tenancy and complying with legal requirements.",
                      style: MyStyles.Medium(12, myColor.text_color),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (Prefs.getBool(PrefsName.TCF_Step0) == false)
                        ? Checkbox(
                            activeColor: myColor.Circle_main,
                            checkColor: myColor.white,
                            value: apr2,
                            onChanged: (value) {
                              setState(() {
                                apr2 = value!;
                              });
                              // _store.dispatch(
                              //     UpdateTFCurrenttenantisReference(value!));
                              // _changeData();
                            },
                          )
                        : Checkbox(
                            activeColor: myColor.Circle_main,
                            checkColor: myColor.white,
                            value: true,
                            onChanged: null,
                          ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "I have read and agree to the Terms and Conditions and Privacy Policy of Silver Homes.",
                      style: MyStyles.Medium(12, myColor.text_color),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              GlobleString.TAF_addSignature,
              style: MyStyles.Medium(17, myColor.text_color),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Container(
            width: 700,
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(border: Border.all(color: myColor.gray)),
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.clear();
                    //  _controller.toPngBytes();
                  },
                  child: Icon(Icons.clear),
                ),
                Signature(
                  controller: _controller,
                  width: 550,
                  height: 80,
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          if (Prefs.getBool(PrefsName.TCF_Step0) == false)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    saveandnext(),
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
      ),
    );
  }

  Widget back() {
    return InkWell(
      onTap: () {
        widget._callbackGotoBack();
      },
      child: CustomeWidget.TenantBackButton(),
    );
  }

  Widget saveandnext() {
    return InkWell(
      onTap: () {
        if (apr1 == true && apr2 == true && _controller.isNotEmpty) {
          if (Prefs.getBool(PrefsName.TCF_Step0) == false) {
            CommonID commonID = new CommonID();
            commonID.ID = Prefs.getString(PrefsName.TCF_ApplicationID);
            EditLeadDisclaimer editlead = new EditLeadDisclaimer();
            editlead.disclaimer = true;
            ApiManager().UpdateLead(context, commonID, editlead,
                (error, respoce) {
              if (error) {
                gotoNext();
              } else {
                ToastUtils.showCustomToast(
                    context, GlobleString.NL_error_insertcall, false);
              }
            });
          } else {
            gotoNext();
          }
        } else {
          openalertDialog();
        }
      },
      child: CustomeWidget.SaveAndNext(GlobleString.Submit),
    );
  }

  void gotoNext() {
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
  }

  openalertDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MessageDialogBoxAlert(
          buttontitle: GlobleString.dailog_finish,
          title: GlobleString.ALERT_Disclamer,
          onPressed: () async {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
