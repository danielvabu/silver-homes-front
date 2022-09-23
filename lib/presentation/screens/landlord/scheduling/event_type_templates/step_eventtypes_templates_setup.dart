import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
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
import 'package:silverhome/domain/actions/landlord_action/portal_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypes_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypes_summery_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypesform_actions.dart';
import 'package:silverhome/domain/entities/property_drop_data.dart';
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
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

import '../../../../models/landlord_models/event_types_state.dart';
import 'add_edit_eventtypes_templates.dart';

class StepEventTypesTemplateSetup extends StatefulWidget {
  final VoidCallback _callbackSaveandNext;

  StepEventTypesTemplateSetup({
    required VoidCallback onPressedSave,
  }) : _callbackSaveandNext = onPressedSave;

  @override
  _StepEventTypesTemplateSetupState createState() =>
      _StepEventTypesTemplateSetupState();
}

class _StepEventTypesTemplateSetupState
    extends State<StepEventTypesTemplateSetup> {
  double ssheight = 0, sswidth = 0;

  final _store = getIt<AppStore>();

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern('en').format(int.parse(s));
  final _mycontroller = TextEditingController();

  ScrollController _controller = ScrollController();
  FocusNode _focus1 = FocusNode();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  bool isGotoback = false;
  int stepper = 0;
  String color = "";
  TextEditingController locationcontroler = new TextEditingController();
  late OverlayEntry loader;
  //FocusNode _focusNode = new FocusNode();
  // bool firsttime = true;
  bool change = false;
  String textprop = "";
  @override
  void initState() {
    Prefs.init();
    traerpropiedades();
    //traerplantillas();
    // filldata();
    initNavigationBack();
    AddEditEventTypesTemplates.isValueUpdate = false;
    super.initState();
  }

  _changeData() {
    if (!change) {
      AddEditEventTypesTemplates.isValueUpdate = true;
      change = true;
    }
  }

  traerpropiedades() async {
    _store.dispatch(UpdateMER_PropertyDropDatalist1([]));
    await ApiManager()
        .getPropertyMaintenanceList(context, Prefs.getString(PrefsName.OwnerID),
            (status, responce, errorlist) {
      if (status) {
        _store.dispatch(UpdateMAR_PropertyDropDatalist(errorlist));
      } else {
        _store.dispatch(UpdateMER_PropertyDropDatalist1([]));
      }
    });
  }

  // traerplantillas() async {
  //   // _store.dispatch(UpdateProperTytypeValue1([]));
  //   await ApiManager().getTemplates(context, Prefs.getString(PrefsName.OwnerID),
  //       (status, responce, errorlist) {
  //     if (status) {
  //       _store.dispatch(UpdateProperTytypeList(errorlist));
  //     } else {
  //       //  _store.dispatch(UpdateProperTytypeValue1([]));
  //     }
  //   });
  // }

  initNavigationBack() {
    navigationNotifier.addListener(() {
      if (mounted) if (navigationNotifier.backScreen ==
          NavigationConstant.eventtypesDetails) {
        isGotoback = navigationNotifier.gotoBack;
        stepper = navigationNotifier.stepper;
        Helper.Log("navigationNotifier", "Call...");
        apiCallAndValidation(_store.state!.eventTypesState);
        //navigationNotifier.dispose();
      }
    });
  }

  // void filldata() {
  //   List<SystemEnumDetails> eventtypestypelist = [];
  //   eventtypestypelist =
  //       QueryFilter().PlainValues(eSystemEnums().EventTypesType);

  //   _store.dispatch(UpdateProperTytypeList(eventtypestypelist));

  //   List<SystemEnumDetails> rentalspacelist = [];
  //   rentalspacelist = QueryFilter().PlainValues(eSystemEnums().RentalSpace);

  //   _store.dispatch(UpdateRentalSpaceList(rentalspacelist));

  //   List<SystemEnumDetails> leasetypelist = [];
  //   leasetypelist = QueryFilter().PlainValues(eSystemEnums().LeaseType);

  //   _store.dispatch(UpdateLeaseTypeList(leasetypelist));

  //   List<SystemEnumDetails> rentplaymentFrequencylist = [];
  //   rentplaymentFrequencylist =
  //       QueryFilter().PlainValues(eSystemEnums().RentPaymentFrequency);

  //   _store.dispatch(UpdateRentPaymentFrequencylist(rentplaymentFrequencylist));

  //   List<SystemEnumDetails> minimumleasedurationlist = [];
  //   minimumleasedurationlist =
  //       QueryFilter().PlainValues(eSystemEnums().MinLeaseTime);

  //   _store.dispatch(UpdateMinimumLeasedurationList(minimumleasedurationlist));
  // }

  Future<void> _selectDate2(BuildContext context, eventtypesState) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2200),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: MaterialColor(0xFF010B32, Helper.color))
                .copyWith(secondary: myColor.Circle_main),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != eventtypesState.dateto) {
      AddEditEventTypesTemplates.isValueUpdate = true;
      _store.dispatch(UpdateDateto2(pickedDate));
      // _store.dispatch(UpdateErrorDateofavailable(false));
    }
  }

  Future<void> _selectDate1(BuildContext context, eventtypesState) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2200),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: MaterialColor(0xFF010B32, Helper.color))
                .copyWith(secondary: myColor.Circle_main),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != eventtypesState.datefrom) {
      AddEditEventTypesTemplates.isValueUpdate = true;
      _store.dispatch(UpdateDatefrom2(pickedDate));
      //_store.dispatch(UpdateErrorDateofavailable(false));
    }
  }

  @override
  Widget build(BuildContext context) {
    ssheight = MediaQuery.of(context).size.height - 75;
    sswidth = MediaQuery.of(context).size.width - 230;

    return Container(
      width: sswidth,
      height: ssheight - 186,
      child: ConnectState<EventTypesState>(
          map: (state) => state.eventTypesState,
          where: notIdentical,
          builder: (eventtypesState) {
            locationcontroler.text = eventtypesState!.EventTypesLocation;
            if (eventtypesState != null &&
                eventtypesState.RentAmount != null &&
                eventtypesState.RentAmount.isNotEmpty) {
              String valuerat =
                  '${_formatNumber(eventtypesState.RentAmount.replaceAll(',', ''))}';
              _mycontroller.value = TextEditingValue(
                text: valuerat,
                selection: TextSelection.collapsed(offset: valuerat.length),
              );
            }

            return SingleChildScrollView(
              controller: _controller,
              child: Container(
                child: FocusScope(
                  node: _focusScopeNode,
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    GlobleString.ET_Event_Types_Name,
                                    style: MyStyles.Medium(14, myColor.black),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(height: 5.0),
                                  TextFormField(
                                    initialValue:
                                        eventtypesState.EventTypesName,
                                    textAlign: TextAlign.start,
                                    autofocus: false,
                                    focusNode: _focus1,
                                    style: MyStyles.Regular(
                                        14, myColor.text_color),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(25),
                                      /* FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),*/
                                    ],
                                    decoration: InputDecoration(
                                        //border: InputBorder.none,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: eventtypesState
                                                      .error_EventTypesName
                                                  ? myColor.errorcolor
                                                  : myColor.blue,
                                              width: 2),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: eventtypesState
                                                      .error_EventTypesName
                                                  ? myColor.errorcolor
                                                  : myColor.gray,
                                              width: 1.0),
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(12),
                                        fillColor: myColor.white,
                                        filled: true),
                                    onChanged: (value) {
                                      _changeData();
                                      AddEditEventTypesTemplates.isValueUpdate =
                                          true;
                                      _store.dispatch(
                                          UpdateEventTypesName(value));
                                      //_store.dispatch(UpdateErrorEventTypesName(false));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0),
                        child: Row(
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
                                        GlobleString.ET_Relationship,
                                        style:
                                            MyStyles.Medium(14, myColor.black),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(width: 10.0),
                                      Text(
                                        GlobleString.Optional,
                                        style: MyStyles.Regular(
                                            12, myColor.optional),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Container(
                                        height: 25,
                                        width: 25,
                                        color: myColor.pf_incudevalue,
                                        alignment: Alignment.center,
                                        child: Radio(
                                          value: true,
                                          //autofocus: Index == 0 ? true :false,
                                          groupValue: eventtypesState
                                              .EventTypesRelation,
                                          activeColor: myColor.Circle_main,
                                          onChanged: (value) {
                                            AddEditEventTypesTemplates
                                                .isValueUpdate = false;

                                            _store.dispatch(
                                                UpdateEventTypesRelations(
                                                    true));
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 5.0),
                                      const Text(GlobleString.ET_One_on_one),
                                      const Text(' (' +
                                          GlobleString.ET_One_Invitee +
                                          ')'),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Container(
                                        height: 25,
                                        width: 25,
                                        color: myColor.pf_incudevalue,
                                        alignment: Alignment.center,
                                        child: Radio(
                                          value: false,
                                          //autofocus: Index == 0 ? true :false,
                                          groupValue: eventtypesState
                                              .EventTypesRelation,
                                          activeColor: myColor.Circle_main,
                                          onChanged: (value) {
                                            AddEditEventTypesTemplates
                                                .isValueUpdate = false;

                                            _store.dispatch(
                                                UpdateEventTypesRelations(
                                                    false));
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 5.0),
                                      const Text(GlobleString.ET_Group),
                                      const Text(' (' +
                                          GlobleString.ET_Multiple_Invitees +
                                          ')'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 30.0),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        GlobleString.ET_Event_Category,
                                        style:
                                            MyStyles.Medium(14, myColor.black),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(width: 10.0),
                                      Text(
                                        GlobleString.Optional,
                                        style: MyStyles.Regular(
                                            12, myColor.optional),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Text(GlobleString.ET_Is_Showing),
                                      SizedBox(width: 5.0),
                                      FlutterSwitch(
                                        width: 55.0,
                                        height: 25.0,
                                        valueFontSize: 10.0,
                                        toggleSize: 20.0,
                                        value:
                                            eventtypesState.EventTypesShowing,
                                        borderRadius: 30.0,
                                        padding: 2.0,
                                        activeColor: myColor.propertyOn,
                                        activeText: "ON",
                                        activeTextColor: myColor.white,
                                        inactiveColor: myColor.gray,
                                        inactiveText: "OFF",
                                        inactiveTextColor: myColor.white,
                                        showOnOff: true,
                                        onToggle: (val) {
                                          AddEditEventTypesTemplates
                                              .isValueUpdate = false;

                                          _store.dispatch(
                                              UpdateEventTypesShowing(val));
                                          //if (val) {widget._callbackActive(model, index);} else {widget._callbackInActive(model, index);}
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(width: 8.0),
                                      Text(
                                        GlobleString.ET_Property_Name,
                                        style:
                                            MyStyles.Medium(14, myColor.black),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Container(
                                    height: 32,
                                    child: DropdownSearch<PropertyDropData>(
                                      enabled: (eventtypesState.EventTypesNA)
                                          ? false
                                          : true,
                                      mode: Mode.MENU,
                                      items:
                                          eventtypesState.PropertyDropDatalist,
                                      textstyle:
                                          MyStyles.Medium(12, myColor.black),
                                      itemAsString: (PropertyDropData? u) =>
                                          u!.propertyName!,
                                      hint: GlobleString.Select_Property,
                                      showSearchBox: true,
                                      defultHeight: eventtypesState
                                                      .PropertyDropDatalist
                                                      .length *
                                                  35 >
                                              300
                                          ? 300
                                          : (eventtypesState
                                                      .PropertyDropDatalist
                                                      .length *
                                                  35) +
                                              50,
                                      showClearButton: false,
                                      selectedItem:
                                          eventtypesState.selectproperty,
                                      focuscolor: myColor.blue,
                                      focusWidth: 2,
                                      isFilteredOnline: true,
                                      onChanged: (value) {
                                        _store.dispatch(
                                            UpdateMER_selectproperty1(value));
                                        _changeData();
                                        textprop = value!.adress!;
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Checkbox(
                                        activeColor: myColor.Circle_main,
                                        checkColor: myColor.white,
                                        value: eventtypesState
                                            .EventTypesNA, //tfAdditionalReferenceState.isAutherize,
                                        onChanged: (value) {
                                          if (value == true) {
                                            _store.dispatch(
                                                UpdateMER_selectproperty1(
                                                    null));
                                          }
                                          _store.dispatch(
                                              UpdateNotAplicable(value!));
                                          _changeData();
                                        },
                                      ),
                                      const Text(
                                          GlobleString.ET_Not_Applicable),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 30.0),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    GlobleString.ET_Location,
                                    style: MyStyles.Medium(14, myColor.black),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(height: 5.0),
                                  TextFormField(
                                    controller: locationcontroler,
                                    textAlign: TextAlign.start,
                                    style: MyStyles.Regular(
                                        14, myColor.text_color),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(25),
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[a-z A-Z]")),
                                    ],
                                    decoration: InputDecoration(
                                        //border: InputBorder.none,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  eventtypesState.error_Province
                                                      ? myColor.errorcolor
                                                      : myColor.blue,
                                              width: 2),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  eventtypesState.error_Province
                                                      ? myColor.errorcolor
                                                      : myColor.gray,
                                              width: 1.0),
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(12),
                                        fillColor: myColor.white,
                                        filled: true),
                                    onChanged: (value) {
                                      _changeData();
                                      AddEditEventTypesTemplates.isValueUpdate =
                                          true;
                                      _store.dispatch(UpdateLocation(value));
                                      // _store
                                      //     .dispatch(UpdateErrorProvince(false));
                                    },
                                  ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Checkbox(
                                        activeColor: myColor.Circle_main,
                                        checkColor: myColor.white,
                                        value: eventtypesState
                                            .EventTypesSPA, //tfAdditionalReferenceState.isAutherize,
                                        onChanged: (value) {
                                          _store.dispatch(UpdateSPA(value!));

                                          if (value == true) {
                                            AddEditEventTypesTemplates
                                                .isValueUpdate = true;
                                            _store.dispatch(
                                                UpdateLocation(textprop));

                                            setState(() {
                                              locationcontroler.text = textprop;
                                            });
                                          }

                                          _changeData();
                                        },
                                      ),
                                      const Text(GlobleString.ET_Same_Address),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0),
                        child: Row(
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
                                        GlobleString.ET_Description,
                                        style:
                                            MyStyles.Medium(14, myColor.black),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(width: 10.0),
                                      Text(
                                        GlobleString.Optional,
                                        style: MyStyles.Regular(
                                            12, myColor.optional),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  TextFormField(
                                    initialValue:
                                        eventtypesState.EventTypesDescription,
                                    textAlign: TextAlign.start,
                                    maxLines: 4,
                                    maxLength: 10000,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(450),
                                    ],
                                    style: MyStyles.Regular(
                                        14, myColor.text_color),
                                    decoration: const InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: myColor.blue, width: 2),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: myColor.gray, width: 1.0),
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(12),
                                        fillColor: myColor.white,
                                        filled: true),
                                    onChanged: (value) {
                                      _changeData();
                                      AddEditEventTypesTemplates.isValueUpdate =
                                          true;
                                      _store.dispatch(
                                          UpdateEventTypesDescription(value));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              GlobleString.ET_Event_Link,
                              style: MyStyles.Medium(14, myColor.black),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0),
                        child: Row(
                          children: [
                            Container(
                              height: 33,
                              width: sswidth - 90,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: myColor.gray,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 33,
                                    color: Colors.black12,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Text(
                                      Weburl.Email_URL +
                                          "events/" +
                                          Prefs.getString(
                                              PrefsName.user_CompanyName) +
                                          "/",
                                      style: MyStyles.Medium(14, myColor.black),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      onChanged: (newValue) {
                                        _store.dispatch(UpdateURL(newValue));
                                      },
                                      initialValue:
                                          eventtypesState.EventTypesLink,
                                      keyboardType: TextInputType.text,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[a-zA-Z0-9]"))
                                      ],
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: GlobleString.LL_cfl_hint,
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        contentPadding: EdgeInsets.all(12),
                                        isDense: true,
                                      ),
                                      style: MyStyles.Medium(
                                          14, myColor.text_color),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              GlobleString.ET_Event_Colour,
                              style: MyStyles.Medium(14, myColor.black),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Container(
                            height: 33,
                            width: sswidth - 80,
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _changeData();
                                    AddEditEventTypesTemplates.isValueUpdate =
                                        true;
                                    _store.dispatch(
                                        UpdateEventTypesColor('grey'));
                                  },
                                  child: (eventtypesState.EventTypesColor ==
                                          'grey')
                                      ? Icon(Icons.check)
                                      : Container(), //Icon(Icons.check),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(15),
                                      primary: Colors.grey),
                                ),
                                const SizedBox(width: 1.0),
                                ElevatedButton(
                                  onPressed: () {
                                    _changeData();
                                    AddEditEventTypesTemplates.isValueUpdate =
                                        true;
                                    _store
                                        .dispatch(UpdateEventTypesColor('red'));
                                  },
                                  child:
                                      (eventtypesState.EventTypesColor == 'red')
                                          ? Icon(Icons.check)
                                          : Container(),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(15),
                                      primary: Colors.red),
                                ),
                                const SizedBox(width: 1.0),
                                ElevatedButton(
                                  onPressed: () {
                                    _changeData();
                                    AddEditEventTypesTemplates.isValueUpdate =
                                        true;
                                    _store.dispatch(
                                        UpdateEventTypesColor('orange'));
                                  },
                                  child: (eventtypesState.EventTypesColor ==
                                          'orange')
                                      ? Icon(Icons.check)
                                      : Container(),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(15),
                                      primary: Colors.orange),
                                ),
                                const SizedBox(width: 1.0),
                                ElevatedButton(
                                  onPressed: () {
                                    _changeData();
                                    AddEditEventTypesTemplates.isValueUpdate =
                                        true;
                                    _store.dispatch(
                                        UpdateEventTypesColor('yellow'));
                                  },
                                  child: (eventtypesState.EventTypesColor ==
                                          'yellow')
                                      ? Icon(Icons.check)
                                      : Container(),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(15),
                                      primary: Colors.yellow),
                                ),
                                const SizedBox(width: 1.0),
                                ElevatedButton(
                                  onPressed: () {
                                    _changeData();
                                    AddEditEventTypesTemplates.isValueUpdate =
                                        true;
                                    _store.dispatch(
                                        UpdateEventTypesColor('green'));
                                  },
                                  child: (eventtypesState.EventTypesColor ==
                                          'green')
                                      ? Icon(Icons.check)
                                      : Container(),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(15),
                                      primary: Colors.green),
                                ),
                                const SizedBox(width: 1.0),
                                ElevatedButton(
                                  onPressed: () {
                                    _changeData();
                                    AddEditEventTypesTemplates.isValueUpdate =
                                        true;
                                    _store.dispatch(
                                        UpdateEventTypesColor('cyan'));
                                  },
                                  child: (eventtypesState.EventTypesColor ==
                                          'cyan')
                                      ? Icon(Icons.check)
                                      : Container(),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(15),
                                      primary: Colors.cyan),
                                ),
                                const SizedBox(width: 1.0),
                                ElevatedButton(
                                  onPressed: () {
                                    _changeData();
                                    AddEditEventTypesTemplates.isValueUpdate =
                                        true;
                                    _store.dispatch(
                                        UpdateEventTypesColor('blue'));
                                  },
                                  child: (eventtypesState.EventTypesColor ==
                                          'blue')
                                      ? Icon(Icons.check)
                                      : Container(),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(15),
                                      primary: Colors.blue),
                                ),
                                const SizedBox(width: 1.0),
                                ElevatedButton(
                                  onPressed: () {
                                    _changeData();
                                    AddEditEventTypesTemplates.isValueUpdate =
                                        true;
                                    _store.dispatch(
                                        UpdateEventTypesColor('deepPurple'));
                                  },
                                  child: (eventtypesState.EventTypesColor ==
                                          'deepPurple')
                                      ? Icon(Icons.check)
                                      : Container(),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(15),
                                      primary: Colors.deepPurple),
                                ),
                                const SizedBox(width: 1.0),
                                ElevatedButton(
                                  onPressed: () {
                                    _changeData();
                                    AddEditEventTypesTemplates.isValueUpdate =
                                        true;
                                    _store.dispatch(
                                        UpdateEventTypesColor('purple'));
                                  },
                                  child: (eventtypesState.EventTypesColor ==
                                          'purple')
                                      ? Icon(Icons.check)
                                      : Container(),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(15),
                                      primary: Colors.purple),
                                ),
                                const SizedBox(width: 1.0),
                                ElevatedButton(
                                  onPressed: () {
                                    _changeData();
                                    AddEditEventTypesTemplates.isValueUpdate =
                                        true;
                                    _store.dispatch(
                                        UpdateEventTypesColor('pink'));
                                  },
                                  child: (eventtypesState.EventTypesColor ==
                                          'pink')
                                      ? Icon(Icons.check)
                                      : Container(),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(15),
                                      primary: Colors.pink),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              GlobleString.ET_Date_Range,
                              style: MyStyles.Medium(14, myColor.black),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0),
                        child: Row(
                          children: [
                            Container(
                              width: sswidth - 90,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 25,
                                        width: 25,
                                        color: myColor.pf_incudevalue,
                                        alignment: Alignment.center,
                                        child: Radio(
                                          value: 1,
                                          //autofocus: Index == 0 ? true :false,
                                          groupValue:
                                              eventtypesState.EventTypesRange,
                                          activeColor: myColor.Circle_main,
                                          onChanged: (value) {
                                            AddEditEventTypesTemplates
                                                .isValueUpdate = true;
                                            _store.dispatch(
                                                UpdateEventTypesRanges(1));
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 5.0),
                                      const Text(GlobleString.ET_Single_day),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  if (eventtypesState.EventTypesRange == 1)
                                    Row(
                                      children: [
                                        const SizedBox(width: 22.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: const [
                                                SizedBox(width: 8.0),
                                                Text("Date"),
                                              ],
                                            ),
                                            const SizedBox(width: 5.0),
                                            Container(
                                              child: TextButton(
                                                onPressed: () {
                                                  _selectDate1(
                                                      context, eventtypesState);
                                                },
                                                child: Container(
                                                  width: 220,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: myColor
                                                          .gray, //tfPersonalState.error_dateofbirth ? myColor.errorcolor : myColor.gray,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8),
                                                          child: Text(
                                                            eventtypesState
                                                                        .datefrom ==
                                                                    null
                                                                ? ""
                                                                : DateFormat(
                                                                        "dd-MMM-yyyy")
                                                                    .format(eventtypesState
                                                                        .datefrom!)
                                                                    .toString(),
                                                            style: MyStyles.Medium(
                                                                13,
                                                                myColor
                                                                    .text_color),
                                                          ),
                                                        ),
                                                      ),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 8,
                                                                right: 5),
                                                        child: Icon(
                                                          Icons
                                                              .calendar_today_outlined,
                                                          color: Colors.grey,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Container(
                                        height: 25,
                                        width: 25,
                                        color: myColor.pf_incudevalue,
                                        alignment: Alignment.center,
                                        child: Radio(
                                          value: 2,
                                          //autofocus: Index == 0 ? true :false,
                                          groupValue:
                                              eventtypesState.EventTypesRange,
                                          activeColor: myColor.Circle_main,
                                          onChanged: (value) {
                                            AddEditEventTypesTemplates
                                                .isValueUpdate = true;
                                            _store.dispatch(
                                                UpdateEventTypesRanges(2));
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 5.0),
                                      const Text(GlobleString.ET_Date_Range),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  if (eventtypesState.EventTypesRange == 2)
                                    Row(
                                      children: [
                                        SizedBox(width: 22.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: const [
                                                SizedBox(width: 8.0),
                                                Text(GlobleString.ET_From_Date),
                                              ],
                                            ),
                                            const SizedBox(width: 5.0),
                                            Container(
                                              child: TextButton(
                                                onPressed: () {
                                                  _selectDate1(
                                                      context, eventtypesState);
                                                },
                                                child: Container(
                                                  width: 220,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: myColor
                                                          .gray, //tfPersonalState.error_dateofbirth ? myColor.errorcolor : myColor.gray,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8),
                                                          child: Text(
                                                            eventtypesState
                                                                        .datefrom ==
                                                                    null
                                                                ? ""
                                                                : DateFormat(
                                                                        "dd-MMM-yyyy")
                                                                    .format(eventtypesState
                                                                        .datefrom!)
                                                                    .toString(),
                                                            style: MyStyles.Medium(
                                                                13,
                                                                myColor
                                                                    .text_color),
                                                          ),
                                                        ),
                                                      ),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 8,
                                                                right: 5),
                                                        child: Icon(
                                                          Icons
                                                              .calendar_today_outlined,
                                                          color: Colors.grey,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: const [
                                                SizedBox(width: 8.0),
                                                Text(GlobleString.ET_To_Date),
                                              ],
                                            ),
                                            const SizedBox(width: 5.0),
                                            Container(
                                              child: TextButton(
                                                onPressed: () {
                                                  _selectDate2(
                                                      context, eventtypesState);
                                                },
                                                child: Container(
                                                  width: 220,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: myColor
                                                          .gray, //tfPersonalState.error_dateofbirth ? myColor.errorcolor : myColor.gray,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8),
                                                          child: Text(
                                                            eventtypesState
                                                                        .dateto ==
                                                                    null
                                                                ? ""
                                                                : DateFormat(
                                                                        "dd-MMM-yyyy")
                                                                    .format(eventtypesState
                                                                        .dateto!)
                                                                    .toString(),
                                                            style: MyStyles.Medium(
                                                                13,
                                                                myColor
                                                                    .text_color),
                                                          ),
                                                        ),
                                                      ),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 8,
                                                                right: 5),
                                                        child: Icon(
                                                          Icons
                                                              .calendar_today_outlined,
                                                          color: Colors.grey,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Container(
                                        height: 25,
                                        width: 25,
                                        color: myColor.pf_incudevalue,
                                        alignment: Alignment.center,
                                        child: Radio(
                                          value: 3,
                                          //autofocus: Index == 0 ? true :false,
                                          groupValue:
                                              eventtypesState.EventTypesRange,
                                          activeColor: myColor.Circle_main,
                                          onChanged: (value) {
                                            AddEditEventTypesTemplates
                                                .isValueUpdate = true;
                                            _store.dispatch(
                                                UpdateEventTypesRanges(3));
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 5.0),
                                      const Text(GlobleString.ET_Indefinitely),
                                    ],
                                  ),
                                  const SizedBox(width: 5.0),
                                  if (eventtypesState.EventTypesRange == 3)
                                    Row(
                                      children: [
                                        const SizedBox(width: 22.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: const [
                                                SizedBox(width: 8.0),
                                                Text(GlobleString.ET_From_Date),
                                              ],
                                            ),
                                            const SizedBox(width: 5.0),
                                            Container(
                                              child: TextButton(
                                                onPressed: () {
                                                  _selectDate1(
                                                      context, eventtypesState);
                                                },
                                                child: Container(
                                                  width: 220,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: myColor
                                                          .gray, //tfPersonalState.error_dateofbirth ? myColor.errorcolor : myColor.gray,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8),
                                                          child: Text(
                                                            eventtypesState
                                                                        .datefrom ==
                                                                    null
                                                                ? ""
                                                                : DateFormat(
                                                                        "dd-MMM-yyyy")
                                                                    .format(eventtypesState
                                                                        .datefrom!)
                                                                    .toString(),
                                                            style: MyStyles.Medium(
                                                                13,
                                                                myColor
                                                                    .text_color),
                                                          ),
                                                        ),
                                                      ),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 8,
                                                                right: 5),
                                                        child: Icon(
                                                          Icons
                                                              .calendar_today_outlined,
                                                          color: Colors.grey,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 5.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              GlobleString.ET_Event_Duration,
                              style: MyStyles.Medium(14, myColor.black),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 32,
                              child: TextFormField(
                                initialValue:
                                    (eventtypesState.EventTypesDuration == 0)
                                        ? ""
                                        : eventtypesState.EventTypesDuration
                                            .toString(),
                                textAlign: TextAlign.start,
                                style: MyStyles.Regular(14, myColor.text_color),
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  MaskedInputFormatter("0000000000")
                                ],
                                decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: eventtypesState
                                                  .error_minimumleasedurationnumber
                                              ? myColor.errorcolor
                                              : myColor.blue,
                                          width: 2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: eventtypesState
                                                  .error_minimumleasedurationnumber
                                              ? myColor.errorcolor
                                              : myColor.gray,
                                          width: 1.0),
                                    ),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.all(12),
                                    fillColor: myColor.white,
                                    filled: true),
                                onChanged: (value) {
                                  _changeData();
                                  AddEditEventTypesTemplates.isValueUpdate =
                                      true;

                                  _store.dispatch(
                                      UpdateDuration(int.parse(value)));
                                },
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            Container(
                              width: 150,
                              height: 32,
                              // ignore: missing_required_param
                              child: DropdownSearch<String>(
                                key: UniqueKey(),
                                mode: Mode.MENU,
                                errorcolor: myColor.errorcolor,
                                isError:
                                    eventtypesState.error_minimumleaseduration,
                                focuscolor: myColor.blue,
                                focusWidth: 2,
                                popupBackgroundColor: myColor.white,
                                items: ["minutes", "hours"],
                                defultHeight: 80,
                                textstyle:
                                    MyStyles.Medium(14, myColor.text_color),
                                hint: "Select",
                                showSearchBox: false,
                                selectedItem:
                                    eventtypesState.EventTypesDurationPeriod,
                                isFilteredOnline: true,
                                onChanged: (value) {
                                  _changeData();
                                  AddEditEventTypesTemplates.isValueUpdate =
                                      true;

                                  _store.dispatch(UpdateDurationp(value!));

                                  // _store.dispatch(
                                  //     UpdateErrorMinimumleaseduration(false));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              GlobleString.ET_Buffer_Time,
                              style: MyStyles.Medium(14, myColor.black),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              GlobleString.ET_Buffer_msg,
                              style:
                                  MyStyles.Medium(14, myColor.CM_Lead_border),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: 105,
                                height: 32,
                                child:
                                    const Text(GlobleString.ET_Before_event)),
                            Container(
                              width: 100,
                              height: 32,
                              child: TextFormField(
                                initialValue:
                                    (eventtypesState.EventTypesBefore == 0)
                                        ? ""
                                        : eventtypesState.EventTypesBefore
                                            .toString(),
                                textAlign: TextAlign.start,
                                style: MyStyles.Regular(14, myColor.text_color),
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  MaskedInputFormatter("0000000000")
                                ],
                                decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: eventtypesState
                                                  .error_minimumleasedurationnumber
                                              ? myColor.errorcolor
                                              : myColor.blue,
                                          width: 2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: eventtypesState
                                                  .error_minimumleasedurationnumber
                                              ? myColor.errorcolor
                                              : myColor.gray,
                                          width: 1.0),
                                    ),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.all(12),
                                    fillColor: myColor.white,
                                    filled: true),
                                onChanged: (value) {
                                  _changeData();
                                  AddEditEventTypesTemplates.isValueUpdate =
                                      true;

                                  _store
                                      .dispatch(UpdateBefore(int.parse(value)));
                                },
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            Container(
                              width: 150,
                              height: 32,
                              // ignore: missing_required_param
                              child: DropdownSearch<String>(
                                key: UniqueKey(),
                                mode: Mode.MENU,
                                errorcolor: myColor.errorcolor,
                                isError:
                                    eventtypesState.error_minimumleaseduration,
                                focuscolor: myColor.blue,
                                focusWidth: 2,
                                popupBackgroundColor: myColor.white,
                                items: const ["minutes", "hours"],
                                defultHeight: 80,
                                textstyle:
                                    MyStyles.Medium(14, myColor.text_color),
                                hint: "Select",
                                showSearchBox: false,
                                selectedItem:
                                    eventtypesState.EventTypesBeforePeriod,
                                isFilteredOnline: true,
                                onChanged: (value) {
                                  _changeData();
                                  AddEditEventTypesTemplates.isValueUpdate =
                                      true;

                                  _store.dispatch(UpdateBeforep(value!));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: 105,
                                height: 32,
                                child: const Text(GlobleString.ET_After_event)),
                            Container(
                              width: 100,
                              height: 32,
                              child: TextFormField(
                                initialValue:
                                    (eventtypesState.EventTypesAfter == 0)
                                        ? ""
                                        : eventtypesState.EventTypesAfter
                                            .toString(),
                                textAlign: TextAlign.start,
                                style: MyStyles.Regular(14, myColor.text_color),
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  MaskedInputFormatter("0000000000")
                                ],
                                decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: eventtypesState
                                                  .error_minimumleasedurationnumber
                                              ? myColor.errorcolor
                                              : myColor.blue,
                                          width: 2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: eventtypesState
                                                  .error_minimumleasedurationnumber
                                              ? myColor.errorcolor
                                              : myColor.gray,
                                          width: 1.0),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(12),
                                    fillColor: myColor.white,
                                    filled: true),
                                onChanged: (value) {
                                  _changeData();
                                  AddEditEventTypesTemplates.isValueUpdate =
                                      true;

                                  _store
                                      .dispatch(UpdateAfter(int.parse(value)));
                                },
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            Container(
                              width: 150,
                              height: 32,
                              // ignore: missing_required_param
                              child: DropdownSearch<String>(
                                key: UniqueKey(),
                                mode: Mode.MENU,
                                errorcolor: myColor.errorcolor,
                                isError:
                                    eventtypesState.error_minimumleaseduration,
                                focuscolor: myColor.blue,
                                focusWidth: 2,
                                popupBackgroundColor: myColor.white,
                                items: ["minutes", "hours"],
                                defultHeight: 80,
                                textstyle:
                                    MyStyles.Medium(14, myColor.text_color),
                                hint: "Select",
                                showSearchBox: false,
                                selectedItem:
                                    eventtypesState.EventTypesAfterPeriod,
                                isFilteredOnline: true,
                                onChanged: (value) {
                                  _changeData();
                                  AddEditEventTypesTemplates.isValueUpdate =
                                      true;

                                  _store.dispatch(UpdateAfterp(value!));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Confirmation Message",
                              style: MyStyles.Medium(14, myColor.black),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "This message will be displayed after the invitee has Sheduled an event.",
                              style:
                                  MyStyles.Medium(14, myColor.CM_Lead_border),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0),
                        child: TextFormField(
                          initialValue: eventtypesState.EventTypesConfirmation,
                          textAlign: TextAlign.start,
                          maxLines: 4,
                          maxLength: 10000,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(450),
                          ],
                          style: MyStyles.Regular(14, myColor.text_color),
                          decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: myColor.blue, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: myColor.gray, width: 1.0),
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.all(12),
                              fillColor: myColor.white,
                              filled: true),
                          onChanged: (value) {
                            _changeData();
                            AddEditEventTypesTemplates.isValueUpdate = true;
                            _store
                                .dispatch(UpdateEventTypesConfirmation(value));
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [saveandnext(eventtypesState)],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  // Widget UpdateMethod() {
  //   if (Prefs.getBool(PrefsName.EventTypesEditMode)) {
  //     if (!firsttime && !AddEditEventTypesTemplates.isValueUpdate) {
  //       AddEditEventTypesTemplates.isValueUpdate = true;
  //       firsttime = false;
  //     } else if (firsttime) {
  //       AddEditEventTypesTemplates.isValueUpdate = false;
  //       firsttime = false;
  //     }
  //   }

  //   return SizedBox(
  //     width: 0,
  //     height: 0,
  //   );
  // }

  Widget saveandnext(EventTypesState eventtypesState) {
    return InkWell(
      onTap: () {
        /*String address = eventtypesState.EventTypesName +
            ": " +
            eventtypesState.Suiteunit +
            " - " +
            eventtypesState.EventTypesAddress +
            ", " +
            eventtypesState.City +
            ", " +
            eventtypesState.Province +
            ", " +
            eventtypesState.Postalcode +
            ", " +
            eventtypesState.CountryName;

        _store.dispatch(UpdateEventTypesFormAddress(address));
        apiCallAndValidation(eventtypesState);
        widget._callbackSaveandNext();*/
        apiCallAndValidation(eventtypesState);
        widget._callbackSaveandNext();
        //Paso al pantallazo automatico pa maquetarlo
        //no se como
      },
      child: CustomeWidget.SaveAndNext(GlobleString.Save_and_next),
    );
  }

  void apiCallAndValidation(EventTypesState eventtypesState) {
    if (eventtypesState.EventTypesName == "") {
      /* setState(() {
        FocusManager.instance.primaryFocus!.unfocus();
        FocusScope.of(context).requestFocus(_focus1);
      });*/

      // _controller.jumpTo(-1.0);
      _store.dispatch(UpdateErrorEventTypesName(true));
      ToastUtils.showCustomToast(
          context, "GlobleString.PS1_EventTypes_name_error", false);
    } else {
      EventTypesInsert eventtypesInsert = new EventTypesInsert();
      eventtypesInsert.name = eventtypesState.EventTypesName;
      eventtypesInsert.relation = eventtypesState.EventTypesRelation;
      eventtypesInsert.showing = eventtypesState.EventTypesShowing;
      eventtypesInsert.location = eventtypesState.EventTypesLocation;
      eventtypesInsert.description = eventtypesState.EventTypesDescription;
      eventtypesInsert.link = eventtypesState.EventTypesLink;
      eventtypesInsert.color = eventtypesState.EventTypesColor;
      eventtypesInsert.range = eventtypesState.EventTypesRange;
      eventtypesInsert.duration = eventtypesState.EventTypesDuration;
      eventtypesInsert.buffer_after = eventtypesState.EventTypesAfter;
      eventtypesInsert.buffer_before = eventtypesState.EventTypesBefore;
      eventtypesInsert.confirmation_message =
          eventtypesState.EventTypesConfirmation;

      eventtypesInsert.prop_id = (eventtypesState.selectproperty == null)
          ? "dddddddd-dddd-dddd-dddd-dddddddddddd"
          : eventtypesState.selectproperty!.id;
      eventtypesInsert.owner_id = int.parse(Prefs.getString(PrefsName.OwnerID));
      eventtypesInsert.datefrom = (eventtypesState.datefrom == null)
          ? "2000-12-01 00:00:00"
          : eventtypesState.datefrom.toString();
      eventtypesInsert.dateto = (eventtypesState.dateto == null)
          ? "2000-12-01 00:00:00"
          : eventtypesState.dateto.toString();
      eventtypesInsert.durationmed = eventtypesState.EventTypesDurationPeriod;
      eventtypesInsert.aftermed = eventtypesState.EventTypesAfterPeriod;
      eventtypesInsert.beforemed = eventtypesState.EventTypesBeforePeriod;
      eventtypesInsert.spa = eventtypesState.EventTypesSPA;
      eventtypesInsert.notap = eventtypesState.EventTypesNA;
      //updateSummeryData(eventtypesState);

      if (Prefs.getBool(PrefsName.EventTypesEdit)) {
        EventTypesUpdate ceventtypesUpdate = new EventTypesUpdate();
        ceventtypesUpdate.ID = Prefs.getString(PrefsName.EventTypesID);
        ceventtypesUpdate.Owner_ID = Prefs.getString(PrefsName.OwnerID);

        ApiManager().UpdateEventTypesDetailsTemplate(
            context, ceventtypesUpdate, eventtypesInsert,
            (error, respoce) async {
          if (error) {
            await Prefs.setBool(PrefsName.EventTypesStep1, true);

            // String address = eventtypesState.EventTypesName +
            //     ": " +
            //     eventtypesState.Suiteunit +
            //     " - " +
            //     eventtypesState.EventTypesAddress +
            //     ", " +
            //     eventtypesState.City +
            //     ", " +
            //     eventtypesState.Province +
            //     ", " +
            //     eventtypesState.Postalcode +
            //     ", " +
            //     eventtypesState.CountryName;

            // _store.dispatch(UpdateEventTypesFormAddress(address));
            // _store.dispatch(
            //     UpdateEventTypesDrafting(eventtypesInsert.PropDrafting!));
            // _store.dispatch(UpdateSummeryEventTypesDrafting(
            //     eventtypesInsert.PropDrafting!));

            ToastUtils.showCustomToast(
                context, "GlobleString.PS_Save_EventTypesse", true);

            if (!isGotoback) {
              if (stepper == 0)
                widget._callbackSaveandNext();
              else
                _store.dispatch(UpdateEventTypesForm(stepper));
            } else {
              _store.dispatch(UpdatePortalPage(1, GlobleString.NAV_Properties));
            }
          } else {
            ToastUtils.showCustomToast(context, respoce, false);
          }
        });
      } else {
        ApiManager().InsertEventTypesDetailsTemplates(context, eventtypesInsert,
            (error, respoce) async {
          if (error) {
            await Prefs.setBool(PrefsName.EventTypesEdit, true);
            await Prefs.setBool(PrefsName.EventTypesStep1, true);
            await Prefs.setString(PrefsName.EventTypesID, respoce.toString());

            // String address = eventtypesState.EventTypesName +
            //     ": " +
            //     eventtypesState.Suiteunit +
            //     " - " +
            //     eventtypesState.EventTypesAddress +
            //     ", " +
            //     eventtypesState.City +
            //     ", " +
            //     eventtypesState.Province +
            //     ", " +
            //     eventtypesState.Postalcode +
            //     ", " +
            //     eventtypesState.CountryName;

            // _store.dispatch(UpdateEventTypesFormAddress(address));
            // _store.dispatch(UpdateEventTypesDrafting(1));
            // _store.dispatch(UpdateSummeryEventTypesDrafting(1));

            //widget._callbackSaveandNext();

            ToastUtils.showCustomToast(
                context, "GlobleString.EventTypes_creation", true);

            if (!isGotoback) {
              widget._callbackSaveandNext();
            } else {
              _store.dispatch(
                  UpdatePortalPage(1, GlobleString.NAV_Scheduling_event_types));
            }
          } else {
            ToastUtils.showCustomToast(context, respoce, false);
          }
        });
      }
    }
  }
}
