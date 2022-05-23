import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:silverhome/domain/entities/tenancy_additionaloccupants.dart';
import 'package:silverhome/presentation/models/landlord_models/tf_additonal_occupant_state.dart';
import 'package:silverhome/presentation/screens/landlord/tenancyform/tenancyapplicationfrom_screen.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/widget/alert_dialogbox.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';

typedef VoidCallbackRecordStep = void Function(int stepper);

class TAFAdditionalOccupantsScreen extends StatefulWidget {
  final VoidCallback _callbackBack;
  final VoidCallback _callbackSaveandNext;
  final VoidCallback _callbackGotoback;
  final VoidCallbackRecordStep _callbackRecordStep;

  TAFAdditionalOccupantsScreen({
    required VoidCallbackRecordStep onPressedRecordStep,
    required VoidCallback onPressedBack,
    required VoidCallback onPressedSave,
    required VoidCallback onPressGotoBack,
  })  : _callbackBack = onPressedBack,
        _callbackSaveandNext = onPressedSave,
        _callbackGotoback = onPressGotoBack,
        _callbackRecordStep = onPressedRecordStep;

  @override
  _TAFAdditionalOccupantsScreenState createState() =>
      _TAFAdditionalOccupantsScreenState();
}

class _TAFAdditionalOccupantsScreenState
    extends State<TAFAdditionalOccupantsScreen> {
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
          NavigationConstant.tenancyotherApplicant) {
        isGotoback = navigationNotifier.gotoBack;
        stepper = navigationNotifier.stepper;
        Helper.Log("back", navigationNotifier.backScreen);
        _saveDataAndNext(_store.state!.tfAdditionalOccupantState);
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
      child: ConnectState<TFAdditionalOccupantState>(
          map: (state) => state.tfAdditionalOccupantState,
          where: notIdentical,
          builder: (tfAdditionalOccupantState) {
            if (tfAdditionalOccupantState!.occupantlist.length == 0) {
              List<TenancyAdditionalOccupant> listoccupation = [];
              TenancyAdditionalOccupant oocupinfo =
                  new TenancyAdditionalOccupant();
              oocupinfo.id = "1";
              oocupinfo.firstname = "";
              oocupinfo.lastname = "";
              oocupinfo.primaryApplicant = "";
              oocupinfo.OccupantID = "";
              oocupinfo.errro_firstname = false;
              oocupinfo.errro_lastname = false;
              oocupinfo.errro_primaryApplicant = false;

              listoccupation.add(oocupinfo);

              _store.dispatch(UpdateTFAddOccupantlist(listoccupation));
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
                            GlobleString.TAF_Additional_Occupants,
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
                              height: 20,
                            ),
                          ],
                        );
                      },
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
                            Checkbox(
                              activeColor: myColor.Circle_main,
                              checkColor: myColor.white,
                              value: tfAdditionalOccupantState.notapplicable,
                              onChanged: (value) {
                                _store.dispatch(
                                    UpdateTFAddOccupantNotApplicable(value!));
                                _changeData();
                              },
                            ),
                            Text(
                              GlobleString.TAF_AO_NotApplicable,
                              style: MyStyles.Medium(13, myColor.text_color),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        back(),
                        SizedBox(width: 10),
                        saveandnext(tfAdditionalOccupantState)
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
              GlobleString.TAF_CT_Add_New_Occupant,
              style: MyStyles.Medium(14, myColor.white),
            ),
          ],
        ),
      ),
    );
  }

  void _addnewoccupation(TFAdditionalOccupantState tfAdditionalOccupantState) {
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
      }

      if ((tfAdditionalOccupantState.occupantlist.length - 1) == i && !isAdd) {
        tfAdditionalOccupantState.occupantlist.add(
            new TenancyAdditionalOccupant(
                id: (tfAdditionalOccupantState.occupantlist.length + 1)
                    .toString(),
                firstname: "",
                lastname: "",
                primaryApplicant: "",
                OccupantID: "",
                errro_firstname: false,
                errro_lastname: false,
                errro_primaryApplicant: false));

        _store.dispatch(
            UpdateTFAddOccupantlist(tfAdditionalOccupantState.occupantlist));
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

  Widget saveandnext(TFAdditionalOccupantState tfAddOState) {
    return InkWell(
      onTap: () => _saveDataAndNext(tfAddOState),
      child: CustomeWidget.SaveAndNext(GlobleString.Save_and_next),
    );
  }

  _saveDataAndNext(TFAdditionalOccupantState tfAddOState) {
    if (tfAddOState.notapplicable) {
      ApiCall(tfAddOState);
    } else {
      bool isAdd = false;
      for (int i = 0; i < tfAddOState.occupantlist.length; i++) {
        TenancyAdditionalOccupant empinfo = tfAddOState.occupantlist[i];

        if (empinfo.firstname == "" &&
            empinfo.lastname == "" &&
            empinfo.primaryApplicant == "") {
          isAdd = true;
          ToastUtils.showCustomToast(
              context, GlobleString.taf_occupant_error_mandatory, false);
          break;
        } else if (empinfo.firstname == "") {
          isAdd = true;
          ToastUtils.showCustomToast(
              context, GlobleString.taf_occupant_error_firstname, false);
          /* tfAddOState.occupantlist[i].errro_firstname = true;
              _store
                  .dispatch(UpdateTFAddOccupantlist(tfAddOState.occupantlist));*/
          break;
        } else if (empinfo.lastname == "") {
          isAdd = true;
          ToastUtils.showCustomToast(
              context, GlobleString.taf_occupant_error_lastname, false);
          /* tfAddOState.occupantlist[i].errro_lastname = true;
              _store
                  .dispatch(UpdateTFAddOccupantlist(tfAddOState.occupantlist));*/
          break;
        } else if (empinfo.primaryApplicant == "") {
          isAdd = true;
          ToastUtils.showCustomToast(
              context, GlobleString.taf_occupant_error_primaryApplicant, false);
          /* tfAddOState.occupantlist[i].errro_primaryApplicant = true;
              _store
                  .dispatch(UpdateTFAddOccupantlist(tfAddOState.occupantlist));*/
          break;
        }

        if ((tfAddOState.occupantlist.length - 1) == i && !isAdd) {
          ApiCall(tfAddOState);
        }
      }
    }
  }

  ApiCall(TFAdditionalOccupantState tfAddOccState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

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

    if (!tfAdditionalOccupantState.notapplicable) {
      for (int j = 0; j < tfAdditionalOccupantState.occupantlist.length; j++) {
        TenancyAdditionalOccupant taoccupant1 =
            tfAdditionalOccupantState.occupantlist[j];

        if (taoccupant1.firstname != "" &&
            taoccupant1.lastname != "" &&
            taoccupant1.primaryApplicant != "") {
          Occupant occupant = new Occupant();
          occupant.FirstName = taoccupant1.firstname;
          occupant.LastName = taoccupant1.lastname;

          AdditionalOccupants additionalOccupants = new AdditionalOccupants();
          additionalOccupants.Applicantion_ID =
              Prefs.getString(PrefsName.TCF_ApplicationID);
          additionalOccupants.relationWithApplicant =
              taoccupant1.primaryApplicant;
          additionalOccupants.occupant = occupant;

          additionalOccupantslist.add(additionalOccupants);
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
        loader.remove();
        if (!isGotoback) {
          Prefs.setBool(PrefsName.TCF_Step4, true);
          if (stepper == 0) {
            widget._callbackSaveandNext();
          } else {
            widget._callbackRecordStep(stepper);
            //_store.dispatch(UpdateTenacyFormIndex(stepper));
          }
        } else {
          widget._callbackGotoback();
        }
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
  }
}
