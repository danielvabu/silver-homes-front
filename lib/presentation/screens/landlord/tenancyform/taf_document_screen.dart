import 'package:flutter/cupertino.dart';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
import 'package:silverhome/presentation/screens/landlord/varificationDocument/varification_document.dart';
import 'package:silverhome/presentation/screens/landlord/varificationDocument/varification_document_req.dart';
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

import 'package:silverhome/widget/landlord/customewidget.dart';

import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

typedef VoidCallbackRecordStep = void Function(int stepper);

class TAFDocumentScreen extends StatefulWidget {
  final String? id;
  final VoidCallback _callbackBack;
  final VoidCallback _callbackSaveandNext;
  final VoidCallback _callbackGotoBack;
  final VoidCallbackRecordStep _callbackRecordStep;

  TAFDocumentScreen({
    required VoidCallbackRecordStep onPressedRecordStep,
    required VoidCallback onPressedBack,
    required VoidCallback onPressedSave,
    required VoidCallback onPressGotoBack,
    required this.id,
  })  : _callbackBack = onPressedBack,
        _callbackSaveandNext = onPressedSave,
        _callbackGotoBack = onPressGotoBack,
        _callbackRecordStep = onPressedRecordStep;

  @override
  _TAFDocumentScreenState createState() => _TAFDocumentScreenState();
}

class _TAFDocumentScreenState extends State<TAFDocumentScreen> {
  double height = 0, width = 0;

  final _store = getIt<AppStore>();
  late OverlayEntry loader;

  static List<SystemEnumDetails> empstatuslist = [];
  static List<SystemEnumDetails> anualincomelist = [];
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  bool isGotoback = false;
  int stepper = 0;
  bool change = false;

  @override
  void initState() {
    super.initState();
    empstatuslist.clear();
    anualincomelist.clear();

    // initNavigationBack();
    TenancyApplicationFormScreen.changeFormData = false;
  }

  // initNavigationBack() {
  //   navigationNotifier.addListener(() {
  //     if (mounted) if (navigationNotifier.backScreen ==
  //         NavigationConstant.tenancyDocument) {
  //       isGotoback = navigationNotifier.gotoBack;
  //       stepper = navigationNotifier.stepper;
  //       _saveDataAndNext(_store.state!.tfDocumentState);
  //     }
  //   });
  // }

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
      width: width,
      child: ConnectState<TenancyVarificationDocumentState>(
          map: (state) => state.tenancyVarificationDocumentState,
          where: notIdentical,
          builder: (TVDState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                VarificationDocumentView2(
                  onPressedSave: () {
                    opensuccessDialog(TVDState!);
                  },
                  id: widget.id,
                ),
              ],
            );
          }),
    );
  }

  opensuccessDialog(TenancyVarificationDocumentState tvdState) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MessageDialogBox(
          buttontitle: GlobleString.dailog_finish,
          title: GlobleString.dailog_varification_document,
          onPressed: () async {
            Navigator.of(context).pop();

            final String id = '__file_picker_web-file-input';
            var element = html.document.getElementById(id);
            if (element != null) {
              element.remove();
            }

            callNavigate(tvdState);
          },
        );
      },
    );
  }

  callNavigate(TenancyVarificationDocumentState tvdState) async {
    await Prefs.clear();

    if (tvdState.CustomerFeatureListingURL != null &&
        tvdState.CustomerFeatureListingURL != "") {
      Helper.Log(
          "CustomerFeatureListingURL", tvdState.CustomerFeatureListingURL);

      Helper.Log("Url: ",
          Weburl.CustomerFeaturedPage + tvdState.CustomerFeatureListingURL);

      html.window.open(
          Weburl.CustomerFeaturedPage + tvdState.CustomerFeatureListingURL,
          "_self");
    } else {
      html.window.location.replace(Weburl.silverhomes_url);
    }
  }

  checkbuttonActive(TenancyVarificationDocumentState? TVDState) {
    if (TVDState!.docs1_filename != "" &&
        TVDState.docs2_filename != "" &&
        (TVDState.docs3_filename != "" || TVDState.notapplicable_doc3) &&
        (TVDState.docs4_filename != "" || TVDState.notapplicable_doc4)) {
      _store.dispatch(UpdateTVDIsbuttonActive(true));
    } else {
      _store.dispatch(UpdateTVDIsbuttonActive(false));
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

  void gotoNext() {
    if (!isGotoback) {
      Prefs.setBool(PrefsName.TCF_Step2, true);
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
