import 'package:flutter/cupertino.dart';
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
import 'package:silverhome/domain/actions/landlord_action/tenancyemployment_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancyform_actions.dart';
import 'package:silverhome/domain/entities/tenancy_employment_information.dart';
import 'package:silverhome/presentation/models/landlord_models/tf_employment_state.dart';
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

typedef VoidCallbackRecordStep = void Function(int stepper);

class TAFEmploymentScreen extends StatefulWidget {
  final VoidCallback _callbackBack;
  final VoidCallback _callbackSaveandNext;
  final VoidCallback _callbackGotoBack;
  final VoidCallbackRecordStep _callbackRecordStep;

  TAFEmploymentScreen({
    required VoidCallbackRecordStep onPressedRecordStep,
    required VoidCallback onPressedBack,
    required VoidCallback onPressedSave,
    required VoidCallback onPressGotoBack,
  })  : _callbackBack = onPressedBack,
        _callbackSaveandNext = onPressedSave,
        _callbackGotoBack = onPressGotoBack,
        _callbackRecordStep = onPressedRecordStep;

  @override
  _TAFEmploymentScreenState createState() => _TAFEmploymentScreenState();
}

class _TAFEmploymentScreenState extends State<TAFEmploymentScreen> {
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
    empstatuslist = QueryFilter().PlainValues(eSystemEnums().EmploymentStatus);
    anualincomelist =
        QueryFilter().PlainValues(eSystemEnums().AnnualIncomeStatus);
    _store.dispatch(UpdateTFEmploymentempstatuslist(empstatuslist));
    _store.dispatch(UpdateTFEmploymentanualincomestatuslist(anualincomelist));
    initilizedata();
    initNavigationBack();
    TenancyApplicationFormScreen.changeFormData = false;
  }

  initilizedata() {
    if (_store.state!.tfEmploymentState != null) {
      TFEmploymentState tfEmploymentState = _store.state!.tfEmploymentState;

      _store.dispatch(UpdateTFEmploymentothersourceincome(
          tfEmploymentState.FNLothersourceincome));
      _store.dispatch(
          UpdateTFEmploymentlinkedprofile(tfEmploymentState.FNLlinkedprofile));
      _store.dispatch(UpdateTFEmploymentanualincomestatus(
          tfEmploymentState.FNLanualincomestatus));
      _store.dispatch(
          UpdateTFEmploymentempstatus(tfEmploymentState.FNLempstatus));

      _store.dispatch(UpdateTFEmploymentlistoccupation([]));
      List<TenancyEmploymentInformation> secondList =
          tfEmploymentState.FNLlistoccupation.map(
              (item) => new TenancyEmploymentInformation.clone(item)).toList();

      _store.dispatch(UpdateTFEmploymentlistoccupation(secondList));
    }
  }

  initNavigationBack() {
    navigationNotifier.addListener(() {
      if (mounted) if (navigationNotifier.backScreen ==
          NavigationConstant.tenancyEmployment) {
        isGotoback = navigationNotifier.gotoBack;
        stepper = navigationNotifier.stepper;
        _saveDataAndNext(_store.state!.tfEmploymentState);
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

  String valueHint = "Select Status";

  Widget Form() {
    return Container(
      width: 1000,
      child: ConnectState<TFEmploymentState>(
          map: (state) => state.tfEmploymentState,
          where: notIdentical,
          builder: (tfEmploymentState) {
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
                          GlobleString.TAF_Primary_Applicant,
                          style: MyStyles.Medium(20, myColor.text_color),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          GlobleString.TAF_Employment_Information,
                          style: MyStyles.Medium(20, myColor.text_color),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          GlobleString.TAF_Employment_status,
                          style: MyStyles.Medium(14, myColor.text_color),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 30,
                          width: 200,
                          // ignore: missing_required_param
                          child: DropdownSearch<SystemEnumDetails>(
                            mode: Mode.MENU,
                            //isfocus: true,
                            //focusScopeNode: _focusScopeNode,
                            focuscolor: myColor.blue,
                            focusWidth: 2,
                            key: UniqueKey(),
                            errorcolor: myColor.errorcolor,
                            isError: tfEmploymentState!.error_empstatus,
                            items: tfEmploymentState.empstatuslist,
                            defultHeight: 210,
                            textstyle: MyStyles.Medium(13, myColor.text_color),
                            itemAsString: (SystemEnumDetails? u) =>
                                u != null ? u.displayValue : "",
                            hint: valueHint.toString(),
                            showSearchBox: false,
                            selectedItem: tfEmploymentState.empstatus != null
                                ? tfEmploymentState.empstatus
                                : null,
                            isFilteredOnline: true,
                            onChanged: (data) {
                              valueHint = data!.displayValue.toString();
                              _store
                                  .dispatch(UpdateTFEmploymentempstatus(data));

                              _store.dispatch(
                                  UpdateTFEmploymentError_empstatus(false));

                              if (tfEmploymentState.listoccupation.length ==
                                  0) {
                                List<TenancyEmploymentInformation>
                                    listoccupation = [];

                                TenancyEmploymentInformation empinfo =
                                    new TenancyEmploymentInformation();
                                empinfo.id = "1";
                                empinfo.occupation = "";
                                empinfo.organization = "";
                                empinfo.lenthofemp = "";
                                empinfo.anualIncome = null;
                                empinfo.error_occupation = false;
                                empinfo.error_organization = false;
                                empinfo.error_lenthofemp = false;
                                empinfo.error_anualIncome = false;

                                listoccupation.add(empinfo);

                                _store.dispatch(
                                    UpdateTFEmploymentlistoccupation(
                                        listoccupation));
                              }
                              _changeData();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  checkvalidation(tfEmploymentState),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              GlobleString.TAF_Employment_LinkedIn_profile_link,
                              style: MyStyles.Medium(14, myColor.text_color),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              GlobleString.Optional,
                              style: MyStyles.Medium(10, myColor.optional),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          initialValue: tfEmploymentState.linkedprofile,
                          textAlign: TextAlign.start,
                          style: MyStyles.Regular(13, myColor.text_color),
                          decoration: InputDecoration(
                            //border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      /* tfEmploymentState
                                          .error_linkedprofile
                                          ? myColor.errorcolor
                                          : */
                                      myColor.gray,
                                  width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      /*tfEmploymentState
                                          .error_linkedprofile
                                          ? myColor.errorcolor
                                          : */
                                      myColor.gray,
                                  width: 1.0),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.all(11),
                            fillColor: myColor.white,
                            filled: true,
                          ),
                          onChanged: (value) {
                            _store.dispatch(
                                UpdateTFEmploymentlinkedprofile(value));

                            /* if (tfEmploymentState.error_linkedprofile)
                                _store.dispatch(
                                    UpdateTFEmploymentError_linkedprofile(
                                        false));*/
                            _changeData();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            GlobleString.TAF_Employment_other_source_of_income,
                            style: MyStyles.Medium(14, myColor.text_color),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            GlobleString.Optional,
                            style: MyStyles.Medium(10, myColor.optional),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        initialValue: tfEmploymentState.othersourceincome,
                        textAlign: TextAlign.start,
                        style: MyStyles.Regular(14, myColor.text_color),
                        maxLines: 6,
                        maxLength: 500,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: myColor.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: myColor.gray, width: 1.0),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.all(11),
                            fillColor: myColor.white,
                            filled: true),
                        onChanged: (value) {
                          _store.dispatch(
                              UpdateTFEmploymentothersourceincome(value));
                          _changeData();
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  (tfEmploymentState.empstatus != null &&
                          (tfEmploymentState.empstatus!.EnumDetailID == 2 ||
                              tfEmploymentState.empstatus!.EnumDetailID == 3 ||
                              tfEmploymentState.empstatus!.EnumDetailID == 4))
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [AddNewOccupationbutton(tfEmploymentState)],
                        )
                      : SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      back(),
                      SizedBox(width: 10),
                      saveandnext(tfEmploymentState)
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget checkvalidation(TFEmploymentState tfEmploymentState) {
    if (tfEmploymentState.empstatus != null &&
        (tfEmploymentState.empstatus!.EnumDetailID == 2 ||
            tfEmploymentState.empstatus!.EnumDetailID == 3 ||
            tfEmploymentState.empstatus!.EnumDetailID == 4))
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        key: UniqueKey(),
        itemCount: tfEmploymentState.listoccupation.length,
        itemBuilder: (BuildContext ctxt, int index) {
          TenancyEmploymentInformation tempinfo =
              tfEmploymentState.listoccupation[index];

          //return Text("Item"+index.toString());

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          index == 0
                              ? GlobleString.TAF_Employment_current_occupation
                              : GlobleString.TAF_Employment_Occupation,
                          style: MyStyles.Medium(14, myColor.text_color),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          initialValue: tempinfo.occupation,
                          textAlign: TextAlign.start,
                          style: MyStyles.Regular(13, myColor.text_color),
                          decoration: InputDecoration(
                            //border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: myColor.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: tempinfo.error_occupation!
                                      ? myColor.errorcolor
                                      : myColor.gray,
                                  width: 1.0),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.all(11),
                            fillColor: myColor.white,
                            filled: true,
                          ),
                          onChanged: (value) {
                            tfEmploymentState.listoccupation[index].occupation =
                                value.toString();

                            tfEmploymentState
                                .listoccupation[index].error_occupation = false;
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
                          GlobleString.TAF_Employment_Organization,
                          style: MyStyles.Medium(14, myColor.text_color),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          initialValue: tempinfo.organization,
                          textAlign: TextAlign.start,
                          style: MyStyles.Regular(13, myColor.text_color),
                          decoration: InputDecoration(
                            //border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: myColor.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: tempinfo.error_organization!
                                      ? myColor.errorcolor
                                      : myColor.gray,
                                  width: 1.0),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.all(11),
                            fillColor: myColor.white,
                            filled: true,
                          ),
                          onChanged: (value) {
                            tfEmploymentState.listoccupation[index]
                                .organization = value.toString();

                            tfEmploymentState.listoccupation[index]
                                .error_organization = false;
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
                          GlobleString.TAF_Employment_legth_of_empoyment,
                          style: MyStyles.Medium(14, myColor.text_color),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          initialValue: tempinfo.lenthofemp,
                          textAlign: TextAlign.start,
                          style: MyStyles.Regular(13, myColor.text_color),
                          inputFormatters: [
                            /*FilteringTextInputFormatter
                                                .allow(RegExp(
                                                "[0-9]")),*/
                            //MaskedInputFormatter("00000")
                            FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                            DecimalTextInputFormatter(decimalRange: 2),
                            LengthLimitingTextInputFormatter(5),
                          ],
                          decoration: InputDecoration(
                            //border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: myColor.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: tempinfo.error_lenthofemp!
                                      ? myColor.errorcolor
                                      : myColor.gray,
                                  width: 1.0),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.all(11),
                            fillColor: myColor.white,
                            filled: true,
                          ),
                          onChanged: (value) {
                            tfEmploymentState.listoccupation[index].lenthofemp =
                                value.toString();

                            tfEmploymentState
                                .listoccupation[index].error_lenthofemp = false;
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
                          GlobleString.TAF_Employment_Annual_Income,
                          style: MyStyles.Medium(14, myColor.text_color),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 30,
                          // ignore: missing_required_param
                          child: DropdownSearch<SystemEnumDetails>(
                            mode: Mode.MENU,
                            focuscolor: myColor.blue,
                            focusWidth: 2,
                            key: UniqueKey(),
                            errorcolor: myColor.errorcolor,
                            isError: tempinfo.error_anualIncome,
                            items: tfEmploymentState.anualincomelist,
                            defultHeight: 175,
                            textstyle: MyStyles.Medium(13, myColor.text_color),
                            itemAsString: (SystemEnumDetails? u) =>
                                u != null ? u.displayValue : "",
                            hint: "Select Income",
                            showSearchBox: false,
                            selectedItem: tfEmploymentState
                                        .listoccupation[index].anualIncome !=
                                    null
                                ? tfEmploymentState
                                    .listoccupation[index].anualIncome
                                : null,
                            isFilteredOnline: true,
                            onChanged: (data) {
                              tfEmploymentState
                                  .listoccupation[index].anualIncome = data;

                              tfEmploymentState.listoccupation[index]
                                  .error_anualIncome = false;

                              _store.dispatch(UpdateTFEmploymentlistoccupation(
                                  tfEmploymentState.listoccupation));
                              _changeData();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  index == 0
                      ? Container(width: 30)
                      : Container(
                          margin: EdgeInsets.only(top: 20, left: 5),
                          width: 30,
                          height: 30,
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
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
                                      tfEmploymentState.listoccupation
                                          .removeAt(index);

                                      _store.dispatch(
                                          UpdateTFEmploymentlistoccupation(
                                              tfEmploymentState
                                                  .listoccupation));
                                      _changeData();
                                    },
                                    onPressedNo: () {
                                      Navigator.of(context1).pop();
                                    },
                                  );
                                },
                              );
                            },
                            child: Image.asset(
                              "assets/images/ic_delete.png",
                              height: 22,
                              //width: 20,
                              alignment: Alignment.centerLeft,
                            ),
                          ),
                        )
                ],
              ),
              SizedBox(
                height: 15,
              ),
            ],
          );
        },
      );
    else
      return Container(
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              GlobleString.TAF_Employment_Annual_Income,
              style: MyStyles.Medium(14, myColor.text_color),
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 30,
              // ignore: missing_required_param
              child: DropdownSearch<SystemEnumDetails>(
                mode: Mode.MENU,
                focuscolor: myColor.blue,
                focusWidth: 2,
                //focusScopeNode: _focusScopeNode,
                key: UniqueKey(),
                errorcolor: myColor.errorcolor,
                isError: tfEmploymentState.error_anualincomestatus,
                items: tfEmploymentState.anualincomelist,
                defultHeight: 175,
                textstyle: MyStyles.Medium(13, myColor.text_color),
                itemAsString: (SystemEnumDetails? u) => u!.displayValue,
                hint: "Select Income",
                showSearchBox: false,
                selectedItem: tfEmploymentState.anualincomestatus != null
                    ? tfEmploymentState.anualincomestatus
                    : null,
                isFilteredOnline: true,
                onChanged: (data) {
                  _store.dispatch(UpdateTFEmploymentanualincomestatus(data!));
                  _changeData();
                  /* _store.dispatch(
                                          UpdateTFEmploymentError_anualincomestatus(
                                              false));*/
                },
              ),
            ),
          ],
        ),
      );
  }

  Widget AddNewOccupationbutton(TFEmploymentState tfEmploymentState) {
    return InkWell(
      onTap: () {
        _addnewoccupation(tfEmploymentState);
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
              GlobleString.TAF_Employment_Add_New_Occupation,
              style: MyStyles.Medium(14, myColor.white),
            ),
          ],
        ),
      ),
    );
  }

  void _addnewoccupation(TFEmploymentState tfEmploymentState) {
    bool isAdd = false;

    for (int i = 0; i < tfEmploymentState.listoccupation.length; i++) {
      TenancyEmploymentInformation empinfo =
          tfEmploymentState.listoccupation[i];

      if (empinfo.occupation == null || empinfo.occupation!.isEmpty) {
        isAdd = true;
        ToastUtils.showCustomToast(
            context, GlobleString.taf_person_error_occupation, false);

        /*tfEmploymentState.listoccupation[i].error_occupation = true;
        _store.dispatch(
            UpdateTFEmploymentlistoccupation(tfEmploymentState.listoccupation));*/
        break;
      } else if (empinfo.organization == null ||
          empinfo.organization!.isEmpty) {
        isAdd = true;
        ToastUtils.showCustomToast(
            context, GlobleString.taf_person_error_organization, false);

        /* tfEmploymentState.listoccupation[i].error_organization = true;
        _store.dispatch(
            UpdateTFEmploymentlistoccupation(tfEmploymentState.listoccupation));*/
        break;
      } else if (empinfo.lenthofemp == null || empinfo.lenthofemp!.isEmpty) {
        isAdd = true;
        ToastUtils.showCustomToast(
            context, GlobleString.taf_person_error_lenthofemp, false);

        /*tfEmploymentState.listoccupation[i].error_lenthofemp = true;
        _store.dispatch(
            UpdateTFEmploymentlistoccupation(tfEmploymentState.listoccupation));*/
        break;
      } else if (empinfo.anualIncome == null) {
        isAdd = true;
        ToastUtils.showCustomToast(
            context, GlobleString.taf_person_error_annualincome, false);

        /*tfEmploymentState.listoccupation[i].error_anualIncome = true;
        _store.dispatch(
            UpdateTFEmploymentlistoccupation(tfEmploymentState.listoccupation));*/
        break;
      }

      if ((tfEmploymentState.listoccupation.length - 1) == i && !isAdd) {
        tfEmploymentState.listoccupation.add(new TenancyEmploymentInformation(
          id: (tfEmploymentState.listoccupation.length + 1).toString(),
          occupation: "",
          organization: "",
          lenthofemp: "",
          anualIncome: null,
          error_anualIncome: false,
          error_lenthofemp: false,
          error_organization: false,
          error_occupation: false,
        ));

        _store.dispatch(
            UpdateTFEmploymentlistoccupation(tfEmploymentState.listoccupation));
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

  Widget saveandnext(TFEmploymentState tfEmploymentState) {
    return InkWell(
      onTap: () => _saveDataAndNext(tfEmploymentState),
      child: CustomeWidget.SaveAndNext(GlobleString.Save_and_next),
    );
  }

  _saveDataAndNext(TFEmploymentState tfEmploymentState) {
    if (tfEmploymentState.empstatus == null) {
      _store.dispatch(UpdateTFEmploymentError_empstatus(true));
      ToastUtils.showCustomToast(
          context, GlobleString.taf_person_error_employmentstatus, false);
    } else if (tfEmploymentState.empstatus!.EnumDetailID == 2 ||
        tfEmploymentState.empstatus!.EnumDetailID == 3 ||
        tfEmploymentState.empstatus!.EnumDetailID == 4) {
      bool isAdd = false;

      for (int i = 0; i < tfEmploymentState.listoccupation.length; i++) {
        TenancyEmploymentInformation empinfo =
            tfEmploymentState.listoccupation[i];

        if (empinfo.occupation == null || empinfo.occupation == "") {
          isAdd = true;
          ToastUtils.showCustomToast(
              context, GlobleString.taf_person_error_occupation, false);
          /*tfEmploymentState.listoccupation[i].error_occupation = true;
              _store.dispatch(UpdateTFEmploymentlistoccupation(
                  tfEmploymentState.listoccupation));*/
          break;
        } else if (empinfo.organization == null || empinfo.organization == "") {
          isAdd = true;
          ToastUtils.showCustomToast(
              context, GlobleString.taf_person_error_organization, false);
          /*tfEmploymentState.listoccupation[i].error_organization = true;
              _store.dispatch(UpdateTFEmploymentlistoccupation(
                  tfEmploymentState.listoccupation));*/
          break;
        } else if (empinfo.lenthofemp == null || empinfo.lenthofemp == "") {
          isAdd = true;
          ToastUtils.showCustomToast(
              context, GlobleString.taf_person_error_lenthofemp, false);
          /* tfEmploymentState.listoccupation[i].error_lenthofemp = true;
              _store.dispatch(UpdateTFEmploymentlistoccupation(
                  tfEmploymentState.listoccupation));*/
          break;
        } else if (empinfo.anualIncome == null) {
          isAdd = true;
          ToastUtils.showCustomToast(
              context, GlobleString.taf_person_error_annualincome, false);
          /* tfEmploymentState.listoccupation[i].error_anualIncome = true;
              _store.dispatch(UpdateTFEmploymentlistoccupation(
                  tfEmploymentState.listoccupation));*/
          break;
        }

        if ((tfEmploymentState.listoccupation.length - 1) == i && !isAdd) {
          //ToastUtils.showCustomToast(context, "Success", true);
          //ApiCall(tfEmploymentState, 1);

          if (tfEmploymentState.linkedprofile != null &&
              tfEmploymentState.linkedprofile.isNotEmpty) {
            if (!Helper.ValidLinkLinedProfile(
                tfEmploymentState.linkedprofile.toString())) {
              _store.dispatch(UpdateTFEmploymentError_linkedprofile(true));
              ToastUtils.showCustomToast(
                  context, GlobleString.taf_person_error_LinkedIn, false);
            } else {
              ApiCall(tfEmploymentState, 1);
            }
          } else {
            ApiCall(tfEmploymentState, 1);
          }
        }
      }
    } else if (tfEmploymentState.empstatus!.EnumDetailID == 1 ||
        tfEmploymentState.empstatus!.EnumDetailID == 5 ||
        tfEmploymentState.empstatus!.EnumDetailID == 6) {
      if (tfEmploymentState.anualincomestatus == null) {
        _store.dispatch(UpdateTFEmploymentError_anualincomestatus(true));
        ToastUtils.showCustomToast(
            context, GlobleString.taf_person_error_annualincome, false);
      } else {
        //ToastUtils.showCustomToast(context, "Success", true);
        // ApiCall(tfEmploymentState, 2);
        if (tfEmploymentState.linkedprofile != null &&
            tfEmploymentState.linkedprofile.isNotEmpty) {
          if (!Helper.ValidLinkLinedProfile(
              tfEmploymentState.linkedprofile.toString())) {
            _store.dispatch(UpdateTFEmploymentError_linkedprofile(true));
            ToastUtils.showCustomToast(
                context, GlobleString.taf_person_error_LinkedIn, false);
          } else {
            ApiCall(tfEmploymentState, 2);
          }
        } else {
          ApiCall(tfEmploymentState, 2);
        }
      }
    }
  }

  ApiCall(TFEmploymentState tfEmploymentState, int flag) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    if (tfEmploymentState.EmploymentID != null &&
        tfEmploymentState.EmploymentID != "") {
      DeleteOccupation deleteOccupation = new DeleteOccupation();
      deleteOccupation.Employment_ID = tfEmploymentState.EmploymentID;

      /* CommonID commonID = new CommonID();
      commonID.ID = tfEmploymentState.EmploymentID; */

      DeleteEmployment commonID = new DeleteEmployment();
      commonID.Applicant_ID = Prefs.getString(PrefsName.TCF_ApplicantID);

      ApiManager().TFEmployementDelete(context, commonID, deleteOccupation,
          (status, responce) {
        if (status) {
          InserData(tfEmploymentState, flag);
        } else {
          loader.remove();
          ToastUtils.showCustomToast(context, responce, false);
        }
      });
    } else {
      InserData(tfEmploymentState, flag);
    }
  }

  InserData(TFEmploymentState tfEmploymentState, int flag) {
    EmploymentInfo employmentInfo = new EmploymentInfo();
    employmentInfo.Applicant_ID = Prefs.getString(PrefsName.TCF_ApplicantID);
    if (flag == 1) {
      employmentInfo.Annual_Income_Status = null;
    } else if (flag == 2) {
      employmentInfo.Annual_Income_Status =
          tfEmploymentState.anualincomestatus!.EnumDetailID.toString();
    }
    employmentInfo.Emp_Status_ID =
        tfEmploymentState.empstatus!.EnumDetailID.toString();
    employmentInfo.LinkedIn = tfEmploymentState.linkedprofile;
    employmentInfo.OtherSourceIncome = tfEmploymentState.othersourceincome;

    ApiManager().TFEmployementOnly(context, employmentInfo, (status, responce) {
      if (status) {
        if (flag == 1) {
          List<EmpOccupation> empOccupationlist = <EmpOccupation>[];
          for (int i = 0; i < tfEmploymentState.listoccupation.length; i++) {
            TenancyEmploymentInformation empinfo =
                tfEmploymentState.listoccupation[i];

            EmpOccupation empOccupation = new EmpOccupation();
            empOccupation.Employment_ID = responce;
            empOccupation.IsCurrentOccupation = i == 0 ? true : false;
            empOccupation.Occupation = empinfo.occupation;
            empOccupation.organization = empinfo.organization;
            empOccupation.duration = empinfo.lenthofemp;
            empOccupation.annual_Income_Status =
                empinfo.anualIncome!.EnumDetailID.toString();

            empOccupationlist.add(empOccupation);
          }

          ApiManager().TFEmployementOccuapation(context, empOccupationlist,
              (status, responce) {
            if (status) {
              loader.remove();
              gotoNext();
            } else {
              loader.remove();
              ToastUtils.showCustomToast(context, responce, false);
            }
          });
        } else {
          loader.remove();
          gotoNext();
        }
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
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
