import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:silverhome/presentation/models/landlord_models/event_types_summery_state.dart';
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
import 'add_edit_eventtypes.dart';

class StepEventTypesSetup extends StatefulWidget {
  final VoidCallback _callbackSaveandNext;
  StepEventTypesSetup({
    required VoidCallback onPressedSave,
  }) : _callbackSaveandNext = onPressedSave;

  @override
  _StepEventTypesSetupState createState() => _StepEventTypesSetupState();
}

class _StepEventTypesSetupState extends State<StepEventTypesSetup> {
  double ssheight = 0, sswidth = 0;

  final _store = getIt<AppStore>();

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern('en').format(int.parse(s));
  final _mycontroller = TextEditingController();

  ScrollController _controller = new ScrollController();
  FocusNode _focus1 = new FocusNode();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  bool isGotoback = false;
  int stepper = 0;
  //FocusNode _focusNode = new FocusNode();
  // bool firsttime = true;
  bool change = false;

  @override
  void initState() {
    Prefs.init();
    initilizedata();
    filldata();
    initNavigationBack();
    AddEditEventTypes.isValueUpdate = false;
    super.initState();
  }

  _changeData() {
    if (!change) {
      AddEditEventTypes.isValueUpdate = true;
      change = true;
    }
  }

  initilizedata() {
    if (_store.state!.eventTypesSummeryState != null) {
      EventTypesSummeryState eventtypesSummeryState =
          _store.state!.eventTypesSummeryState;

      _store.dispatch(
          UpdateProperTytypeValue(eventtypesSummeryState.eventtypestypeValue));
      _store.dispatch(UpdateEventTypesTypeOtherValue(
          eventtypesSummeryState.eventtypestypeOtherValue));

      _store.dispatch(
          UpdateDateofavailable(eventtypesSummeryState.dateofavailable));
      _store.dispatch(
          UpdateRentalSpaceValue(eventtypesSummeryState.rentalspaceValue));
      _store.dispatch(
          UpdateEventTypesName(eventtypesSummeryState.EventTypesName));
      _store.dispatch(
          UpdateEventTypesAddress(eventtypesSummeryState.EventTypesAddress));
      _store.dispatch(UpdateEventTypesDescription(
          eventtypesSummeryState.EventTypesDescription));
      _store.dispatch(UpdateSuiteunit(eventtypesSummeryState.Suiteunit));
      _store.dispatch(UpdateBuildingname(eventtypesSummeryState.Buildingname));
      _store.dispatch(UpdateEventTypesCity(eventtypesSummeryState.City));
      _store.dispatch(
          UpdateEventTypesCountryCode(eventtypesSummeryState.CountryCode));
      _store.dispatch(
          UpdateEventTypesCountryName(eventtypesSummeryState.CountryName));
      _store
          .dispatch(UpdateEventTypesProvince(eventtypesSummeryState.Province));
      _store.dispatch(
          UpdateEventTypesPostalcode(eventtypesSummeryState.Postalcode));
      _store.dispatch(
          UpdateEventTypesRentAmount(eventtypesSummeryState.RentAmount));
      _store.dispatch(UpdateRentPaymentFrequencyValue(
          eventtypesSummeryState.rentpaymentFrequencyValue));
      _store.dispatch(
          UpdateLeaseTypeValue(eventtypesSummeryState.leasetypeValue));
      _store.dispatch(UpdateMinimumLeasedurationValue(
          eventtypesSummeryState.minimumleasedurationValue));
      _store.dispatch(UpdateMinimumleasedurationNumber(
          eventtypesSummeryState.minimumleasedurationnumber));
    }
  }

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

  void filldata() {
    List<SystemEnumDetails> eventtypestypelist = [];
    eventtypestypelist =
        QueryFilter().PlainValues(eSystemEnums().EventTypesType);

    _store.dispatch(UpdateProperTytypeList(eventtypestypelist));

    List<SystemEnumDetails> rentalspacelist = [];
    rentalspacelist = QueryFilter().PlainValues(eSystemEnums().RentalSpace);

    _store.dispatch(UpdateRentalSpaceList(rentalspacelist));

    List<SystemEnumDetails> leasetypelist = [];
    leasetypelist = QueryFilter().PlainValues(eSystemEnums().LeaseType);

    _store.dispatch(UpdateLeaseTypeList(leasetypelist));

    List<SystemEnumDetails> rentplaymentFrequencylist = [];
    rentplaymentFrequencylist =
        QueryFilter().PlainValues(eSystemEnums().RentPaymentFrequency);

    _store.dispatch(UpdateRentPaymentFrequencylist(rentplaymentFrequencylist));

    List<SystemEnumDetails> minimumleasedurationlist = [];
    minimumleasedurationlist =
        QueryFilter().PlainValues(eSystemEnums().MinLeaseDuration);

    _store.dispatch(UpdateMinimumLeasedurationList(minimumleasedurationlist));
  }

  Future<void> _selectDate(BuildContext context, eventtypesState) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2200),
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

    if (pickedDate != null && pickedDate != eventtypesState.dateofavailable) {
      AddEditEventTypes.isValueUpdate = true;
      _store.dispatch(UpdateDateofavailable(pickedDate));
      _store.dispatch(UpdateErrorDateofavailable(false));
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        GlobleString.ET_Apply_Template,
                                        style:
                                            MyStyles.Medium(14, myColor.black),
                                        textAlign: TextAlign.start,
                                      ),
                                      Text(
                                        GlobleString.Optional,
                                        style: MyStyles.Light(
                                            12, myColor.TA_Border),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Container(
                                  height: 32,
                                  child: DropdownSearch<SystemEnumDetails>(
                                    mode: Mode.MENU,
                                    key: UniqueKey(),
                                    errorcolor: myColor.errorcolor,
                                    isError:
                                        eventtypesState!.error_eventtypestype,
                                    focuscolor: myColor.blue,
                                    focusWidth: 2,
                                    popupBackgroundColor: myColor.white,
                                    items: eventtypesState.eventtypestypelist,
                                    defultHeight: eventtypesState
                                                    .eventtypestypelist.length *
                                                35 >
                                            250
                                        ? 250
                                        : eventtypesState
                                                .eventtypestypelist.length *
                                            35,
                                    textstyle:
                                        MyStyles.Medium(14, myColor.text_color),
                                    itemAsString: (SystemEnumDetails? u) =>
                                        u != null ? u.displayValue : "",
                                    hint: GlobleString.ET_Select_Template,
                                    selectedItem: eventtypesState
                                                .eventtypestypeValue !=
                                            null
                                        ? eventtypesState.eventtypestypeValue
                                        : null,
                                    onChanged: (value) {
                                      /*_changeData();
                                      AddEditEventTypes.isValueUpdate = true;
                                      if (value!.EnumDetailID != 6) {_store.dispatch(UpdateEventTypesTypeOtherValue(""));}
                                      _store.dispatch(UpdateProperTytypeValue(value));
                                      _store.dispatch(UpdateErrorEventTypestype(false));*/
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 30.0),
                          Expanded(child: Container()),
                        ],
                      ),
                      eventtypesState.eventtypestypeValue != null &&
                              eventtypesState
                                      .eventtypestypeValue!.EnumDetailID ==
                                  6
                          ? Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          initialValue: eventtypesState
                                              .eventtypestypeOtherValue,
                                          textAlign: TextAlign.start,
                                          style: MyStyles.Regular(
                                              14, myColor.text_color),
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                25),
                                            FilteringTextInputFormatter.allow(
                                                RegExp("[a-z A-Z]")),
                                          ],
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: eventtypesState
                                                          .error_eventtypestypeOther
                                                      ? myColor.errorcolor
                                                      : myColor.blue,
                                                  width: 2),
                                            ),
                                            hintText: GlobleString
                                                .PS1_enter_your_answer,
                                            hintStyle: MyStyles.Regular(
                                                14, myColor.hintcolor),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: eventtypesState
                                                          .error_eventtypestypeOther
                                                      ? myColor.errorcolor
                                                      : myColor.gray,
                                                  width: 1.0),
                                            ),
                                            isDense: true,
                                            contentPadding:
                                                const EdgeInsets.all(12),
                                            fillColor: myColor.white,
                                            filled: true,
                                          ),
                                          onChanged: (value) {
                                            /*_changeData();
                                            AddEditEventTypes.isValueUpdate =true;
                                            _store.dispatch(UpdateEventTypesTypeOtherValue(value));
                                            _store.dispatch(UpdateErrorEventTypestypeOther(false));*/
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 30.0),
                                  Expanded(child: Container()),
                                ],
                              ),
                            )
                          : Container(),
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
                                      //_changeData();
                                      //AddEditEventTypes.isValueUpdate = true;
                                      //_store.dispatch(UpdateEventTypesName(value));
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
                                          value: "1",
                                          //autofocus: Index == 0 ? true :false,
                                          groupValue: 1,
                                          activeColor: myColor.Circle_main,
                                          onChanged: (value) {
                                            /*AddEditProperty.isValueUpdate = true;
                                            widget._callbackradio(Index, value.toString());
                                            widget.listdata[Index].value = value.toString();
                                            _store.dispatch(UpdatePropertyAmenitiesList(widget.listdata));*/
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
                                          value: "1",
                                          //autofocus: Index == 0 ? true :false,
                                          groupValue: 1,
                                          activeColor: myColor.Circle_main,
                                          onChanged: (value) {
                                            /*AddEditProperty.isValueUpdate = true;
                                            widget._callbackradio(Index, value.toString());
                                            widget.listdata[Index].value = value.toString();
                                            _store.dispatch(UpdatePropertyAmenitiesList(widget.listdata));*/
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
                                        value: true,
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
                                    child: DropdownSearch<SystemEnumDetails>(
                                      mode: Mode.MENU,
                                      errorcolor: myColor.errorcolor,
                                      //isError: eventtypesState.error_minimumleaseduration,
                                      focuscolor: myColor.blue,
                                      focusWidth: 2,
                                      popupBackgroundColor: myColor.white,
                                      items: eventtypesState
                                          .minimumleasedurationlist,
                                      defultHeight: double.parse(
                                          (eventtypesState
                                                      .minimumleasedurationlist
                                                      .length *
                                                  35)
                                              .toString()),
                                      textstyle: MyStyles.Medium(
                                          14, myColor.text_color),
                                      itemAsString: (SystemEnumDetails? u) =>
                                          u != null ? u.displayValue : "",
                                      hint: GlobleString.ET_Select_Property,
                                      showSearchBox: false,
                                      selectedItem: eventtypesState
                                                  .minimumleasedurationValue !=
                                              null
                                          ? eventtypesState
                                              .minimumleasedurationValue
                                          : null,
                                      isFilteredOnline: true,
                                      onChanged: (value) {
                                        //_changeData();
                                        //AddEditEventTypes.isValueUpdate =true;
                                        //_store.dispatch(UpdateMinimumLeasedurationValue(value!));
                                        //_store.dispatch(UpdateErrorMinimumleaseduration(false));
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Checkbox(
                                        activeColor: myColor.Circle_main,
                                        checkColor: myColor.white,
                                        value:
                                            false, //tfAdditionalReferenceState.isAutherize,
                                        onChanged: (value) {
                                          //_store.dispatch(UpdateTFAdditionalReferenceisAutherize(value!));
                                          //_changeData();
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
                                    initialValue: eventtypesState.Province,
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
                                      AddEditEventTypes.isValueUpdate = true;
                                      _store.dispatch(
                                          UpdateEventTypesProvince(value));
                                      _store
                                          .dispatch(UpdateErrorProvince(false));
                                    },
                                  ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Checkbox(
                                        activeColor: myColor.Circle_main,
                                        checkColor: myColor.white,
                                        value:
                                            false, //tfAdditionalReferenceState.isAutherize,
                                        onChanged: (value) {
                                          //_store.dispatch(UpdateTFAdditionalReferenceisAutherize(value!));
                                          //_changeData();
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
                                      //_changeData();
                                      //AddEditEventTypes.isValueUpdate = true;
                                      //_store.dispatch(UpdateEventTypesDescription(value));
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
                                      Weburl.CustomerFeaturedPage,
                                      style: MyStyles.Medium(14, myColor.black),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      //onChanged: (newValue) {
                                      //_store.dispatch(UpdateLandlordProfileCustomerFeatureListingURL_update(newValue));
                                      //},
                                      initialValue:
                                          '/', //profileState.CustomerFeatureListingURL_update,
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
                                  onPressed: () {},
                                  child: Container(), //Icon(Icons.check),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(18),
                                      primary: Colors.grey),
                                ),
                                const SizedBox(width: 1.0),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Container(), //Icon(Icons.check),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(18),
                                      primary: Colors.red),
                                ),
                                const SizedBox(width: 1.0),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Container(), //Icon(Icons.check),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(18),
                                      primary: Colors.orange),
                                ),
                                const SizedBox(width: 1.0),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Container(), //Icon(Icons.check),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(18),
                                      primary: Colors.yellow),
                                ),
                                const SizedBox(width: 1.0),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Container(), //Icon(Icons.check),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(18),
                                      primary: Colors.green),
                                ),
                                const SizedBox(width: 1.0),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Container(), //Icon(Icons.check),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(18),
                                      primary: Colors.cyan),
                                ),
                                const SizedBox(width: 1.0),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Container(), //Icon(Icons.check),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(18),
                                      primary: Colors.blue),
                                ),
                                const SizedBox(width: 1.0),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Container(), //Icon(Icons.check),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(18),
                                      primary: Colors.deepPurple),
                                ),
                                const SizedBox(width: 1.0),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Container(), //Icon(Icons.check),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(18),
                                      primary: Colors.purple),
                                ),
                                const SizedBox(width: 1.0),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Container(), //Icon(Icons.check),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(18),
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
                                          value: "1",
                                          //autofocus: Index == 0 ? true :false,
                                          groupValue: 1,
                                          activeColor: myColor.Circle_main,
                                          onChanged: (value) {
                                            /*AddEditProperty.isValueUpdate = true;
                                              widget._callbackradio(Index, value.toString());
                                              widget.listdata[Index].value = value.toString();
                                              _store.dispatch(UpdatePropertyAmenitiesList(widget.listdata));*/
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 5.0),
                                      const Text(GlobleString.ET_Single_day),
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
                                          value: "1",
                                          //autofocus: Index == 0 ? true :false,
                                          groupValue: 1,
                                          activeColor: myColor.Circle_main,
                                          onChanged: (value) {
                                            /*AddEditProperty.isValueUpdate = true;
                                              widget._callbackradio(Index, value.toString());
                                              widget.listdata[Index].value = value.toString();
                                              _store.dispatch(UpdatePropertyAmenitiesList(widget.listdata));*/
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 5.0),
                                      const Text(GlobleString.ET_Date_Range),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
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
                                                //_selectDate(context, tfPersonalState);
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
                                                            EdgeInsets.only(
                                                                left: 8),
                                                        child: Text(
                                                          'Aca',
                                                          //tfPersonalState.dateofbirth == null ? "" : new DateFormat("dd-MMM-yyyy").format(tfPersonalState.dateofbirth!).toString(),
                                                          style: MyStyles.Medium(
                                                              13,
                                                              myColor
                                                                  .text_color),
                                                        ),
                                                      ),
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8, right: 5),
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
                                                //_selectDate(context, tfPersonalState);
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
                                                            EdgeInsets.only(
                                                                left: 8),
                                                        child: Text(
                                                          'Aca',
                                                          //tfPersonalState.dateofbirth == null ? "" : new DateFormat("dd-MMM-yyyy").format(tfPersonalState.dateofbirth!).toString(),
                                                          style: MyStyles.Medium(
                                                              13,
                                                              myColor
                                                                  .text_color),
                                                        ),
                                                      ),
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8, right: 5),
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
                                          value: "1",
                                          //autofocus: Index == 0 ? true :false,
                                          groupValue: 1,
                                          activeColor: myColor.Circle_main,
                                          onChanged: (value) {
                                            /*AddEditProperty.isValueUpdate = true;
                                              widget._callbackradio(Index, value.toString());
                                              widget.listdata[Index].value = value.toString();
                                              _store.dispatch(UpdatePropertyAmenitiesList(widget.listdata));*/
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 5.0),
                                      const Text(GlobleString.ET_Indefinitely),
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
                                    eventtypesState.minimumleasedurationnumber,
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
                                  AddEditEventTypes.isValueUpdate = true;

                                  _store.dispatch(
                                      UpdateMinimumleasedurationNumber(value));
                                  _store.dispatch(
                                      UpdateErrorMinimumleasedurationnumber(
                                          false));
                                },
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            Container(
                              width: 150,
                              height: 32,
                              // ignore: missing_required_param
                              child: DropdownSearch<SystemEnumDetails>(
                                key: UniqueKey(),
                                mode: Mode.MENU,
                                errorcolor: myColor.errorcolor,
                                isError:
                                    eventtypesState.error_minimumleaseduration,
                                focuscolor: myColor.blue,
                                focusWidth: 2,
                                popupBackgroundColor: myColor.white,
                                items: eventtypesState.minimumleasedurationlist,
                                defultHeight: double.parse((eventtypesState
                                            .minimumleasedurationlist.length *
                                        35)
                                    .toString()),
                                textstyle:
                                    MyStyles.Medium(14, myColor.text_color),
                                itemAsString: (SystemEnumDetails? u) =>
                                    u != null ? u.displayValue : "",
                                hint: "Select Period",
                                showSearchBox: false,
                                selectedItem: eventtypesState
                                            .minimumleasedurationValue !=
                                        null
                                    ? eventtypesState.minimumleasedurationValue
                                    : null,
                                isFilteredOnline: true,
                                onChanged: (value) {
                                  _changeData();
                                  AddEditEventTypes.isValueUpdate = true;

                                  _store.dispatch(
                                      UpdateMinimumLeasedurationValue(value!));

                                  _store.dispatch(
                                      UpdateErrorMinimumleaseduration(false));
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
                                child: Text(GlobleString.ET_Before_event)),
                            Container(
                              width: 100,
                              height: 32,
                              child: TextFormField(
                                initialValue:
                                    eventtypesState.minimumleasedurationnumber,
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
                                  AddEditEventTypes.isValueUpdate = true;

                                  _store.dispatch(
                                      UpdateMinimumleasedurationNumber(value));
                                  _store.dispatch(
                                      UpdateErrorMinimumleasedurationnumber(
                                          false));
                                },
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            Container(
                              width: 150,
                              height: 32,
                              // ignore: missing_required_param
                              child: DropdownSearch<SystemEnumDetails>(
                                key: UniqueKey(),
                                mode: Mode.MENU,
                                errorcolor: myColor.errorcolor,
                                isError:
                                    eventtypesState.error_minimumleaseduration,
                                focuscolor: myColor.blue,
                                focusWidth: 2,
                                popupBackgroundColor: myColor.white,
                                items: eventtypesState.minimumleasedurationlist,
                                defultHeight: double.parse((eventtypesState
                                            .minimumleasedurationlist.length *
                                        35)
                                    .toString()),
                                textstyle:
                                    MyStyles.Medium(14, myColor.text_color),
                                itemAsString: (SystemEnumDetails? u) =>
                                    u != null ? u.displayValue : "",
                                hint: "Select Period",
                                showSearchBox: false,
                                selectedItem: eventtypesState
                                            .minimumleasedurationValue !=
                                        null
                                    ? eventtypesState.minimumleasedurationValue
                                    : null,
                                isFilteredOnline: true,
                                onChanged: (value) {
                                  _changeData();
                                  AddEditEventTypes.isValueUpdate = true;

                                  _store.dispatch(
                                      UpdateMinimumLeasedurationValue(value!));

                                  _store.dispatch(
                                      UpdateErrorMinimumleaseduration(false));
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
                                child: Text(GlobleString.ET_After_event)),
                            Container(
                              width: 100,
                              height: 32,
                              child: TextFormField(
                                initialValue:
                                    eventtypesState.minimumleasedurationnumber,
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
                                  AddEditEventTypes.isValueUpdate = true;

                                  _store.dispatch(
                                      UpdateMinimumleasedurationNumber(value));
                                  _store.dispatch(
                                      UpdateErrorMinimumleasedurationnumber(
                                          false));
                                },
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            Container(
                              width: 150,
                              height: 32,
                              // ignore: missing_required_param
                              child: DropdownSearch<SystemEnumDetails>(
                                key: UniqueKey(),
                                mode: Mode.MENU,
                                errorcolor: myColor.errorcolor,
                                isError:
                                    eventtypesState.error_minimumleaseduration,
                                focuscolor: myColor.blue,
                                focusWidth: 2,
                                popupBackgroundColor: myColor.white,
                                items: eventtypesState.minimumleasedurationlist,
                                defultHeight: double.parse((eventtypesState
                                            .minimumleasedurationlist.length *
                                        35)
                                    .toString()),
                                textstyle:
                                    MyStyles.Medium(14, myColor.text_color),
                                itemAsString: (SystemEnumDetails? u) =>
                                    u != null ? u.displayValue : "",
                                hint: "Select Period",
                                showSearchBox: false,
                                selectedItem: eventtypesState
                                            .minimumleasedurationValue !=
                                        null
                                    ? eventtypesState.minimumleasedurationValue
                                    : null,
                                isFilteredOnline: true,
                                onChanged: (value) {
                                  _changeData();
                                  AddEditEventTypes.isValueUpdate = true;

                                  _store.dispatch(
                                      UpdateMinimumLeasedurationValue(value!));

                                  _store.dispatch(
                                      UpdateErrorMinimumleaseduration(false));
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
                        child: TextFormField(
                          initialValue: eventtypesState.EventTypesDescription,
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
                            //_changeData();
                            //AddEditEventTypes.isValueUpdate = true;
                            //_store.dispatch(UpdateEventTypesDescription(value));
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
  //     if (!firsttime && !AddEditEventTypes.isValueUpdate) {
  //       AddEditEventTypes.isValueUpdate = true;
  //       firsttime = false;
  //     } else if (firsttime) {
  //       AddEditEventTypes.isValueUpdate = false;
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

        _store.dispatch(UpdateEventTypesFormAddress(address));*/

        apiCallAndValidation(eventtypesState);
        //widget._callbackSaveandNext();
      },
      child: CustomeWidget.SaveAndNext(GlobleString.Save_and_next),
    );
  }

  void apiCallAndValidation(EventTypesState eventtypesState) {
    if (eventtypesState.eventtypestypeValue == null) {
      _store.dispatch(UpdateErrorEventTypestype(true));
      //_controller.jumpTo(-1.0);
      //ToastUtils.showCustomToast(context, GlobleString.PS1_EventTypes_type_error, false);
      ToastUtils.showCustomToast(context, 'error', false);
    } else if (eventtypesState.eventtypestypeValue!.EnumDetailID == 6 &&
        eventtypesState.eventtypestypeOtherValue.isEmpty) {
      //_controller.jumpTo(-1.0);
      _store.dispatch(UpdateErrorEventTypestypeOther(true));
      //ToastUtils.showCustomToast(context, GlobleString.PS1_EventTypes_type_value_error, false);
      ToastUtils.showCustomToast(context, 'Error', false);
      //  Se quito la validacion del campo por jcjavier
      //    } else if (eventtypesState.rentalspaceValue == null) {
      //_controller.jumpTo(-1.0);
      //      _store.dispatch(UpdateErrorRentalspace(true));
      //      ToastUtils.showCustomToast(
      //          context, GlobleString.PS1_Rental_space_error, false);
    } else if (eventtypesState.EventTypesName == "") {
      /* setState(() {
        FocusManager.instance.primaryFocus!.unfocus();
        FocusScope.of(context).requestFocus(_focus1);
      });*/

      // _controller.jumpTo(-1.0);
      _store.dispatch(UpdateErrorEventTypesName(true));
      ToastUtils.showCustomToast(
          context, "GlobleString.PS1_EventTypes_name_error", false);
    } else if (eventtypesState.EventTypesAddress == "") {
      // _controller.jumpTo(-1.0);
      _store.dispatch(UpdateErrorEventTypesAddress(true));
      ToastUtils.showCustomToast(
          context, "GlobleString.PS1_EventTypes_address_error", false);
    } else if (eventtypesState.City == "") {
      // _controller.jumpTo(0.0);
      _store.dispatch(UpdateErrorCity(true));
      ToastUtils.showCustomToast(
          context, "GlobleString.PS1_EventTypes_City_error", false);
    } else if (eventtypesState.Province == "") {
      // _controller.jumpTo(0.0);
      _store.dispatch(UpdateErrorProvince(true));
      ToastUtils.showCustomToast(
          context, "GlobleString.PS1_EventTypes_province_error", false);
    } else if (eventtypesState.CountryName == "") {
      //_controller.jumpTo(0.0);
      _store.dispatch(UpdateErrorCountryName(true));
      ToastUtils.showCustomToast(
          context, "GlobleString.PS1_EventTypes_country_error", false);
    } else if (eventtypesState.Postalcode == "") {
      //_controller.jumpTo(0.0);
      _store.dispatch(UpdateErrorPostalcode(true));
      ToastUtils.showCustomToast(
          context, "GlobleString.PS1_EventTypes_postalcode_error", false);
    } else if (eventtypesState.RentAmount == "") {
      // _controller.jumpTo(1.0);
      _store.dispatch(UpdateErrorRentAmount(true));
      ToastUtils.showCustomToast(
          context, "GlobleString.PS1_EventTypes_rentamount_error", false);
    } else if (eventtypesState.rentpaymentFrequencyValue == null) {
      // _controller.jumpTo(1.0);
      _store.dispatch(UpdateErrorRentpaymentFrequency(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS1_Rent_payment_frequency_error, false);
    } else if (eventtypesState.leasetypeValue == null) {
      //_controller.jumpTo(1.0);
      _store.dispatch(UpdateErrorLeasetype(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS1_Lease_type_error, false);
    } else if (eventtypesState.dateofavailable == null) {
      //_controller.jumpTo(1.0);
      _store.dispatch(UpdateErrorDateofavailable(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS1_Date_available_error, false);
    } else if (eventtypesState.minimumleasedurationnumber == "") {
      // _controller.jumpTo(1.0);
      _store.dispatch(UpdateErrorMinimumleasedurationnumber(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS1_Minimum_lease_duration_value_error, false);
    } else if (eventtypesState.minimumleasedurationValue == null) {
      //_controller.jumpTo(1.0);
      _store.dispatch(UpdateErrorMinimumleaseduration(true));
      ToastUtils.showCustomToast(
          context, GlobleString.PS1_Minimum_lease_duration_error, false);
    } else {
      EventTypesInsert eventtypesInsert = new EventTypesInsert();
      eventtypesInsert.Property_Type =
          eventtypesState.eventtypestypeValue!.EnumDetailID.toString();
      eventtypesInsert.Rental_Space =
          eventtypesState.rentalspaceValue!.EnumDetailID.toString();
      eventtypesInsert.Rent_Payment_Frequency =
          eventtypesState.rentpaymentFrequencyValue!.EnumDetailID.toString();
      eventtypesInsert.Lease_Type =
          eventtypesState.leasetypeValue!.EnumDetailID.toString();
      eventtypesInsert.Min_Lease_Duration =
          eventtypesState.minimumleasedurationValue!.EnumDetailID.toString();
      eventtypesInsert.PropertyName = eventtypesState.EventTypesName.toString();
      eventtypesInsert.Property_Address =
          eventtypesState.EventTypesAddress.toString();
      eventtypesInsert.Property_Description =
          eventtypesState.EventTypesDescription.toString();
      eventtypesInsert.City = eventtypesState.City.toString();
      eventtypesInsert.Province = eventtypesState.Province.toString();
      eventtypesInsert.Country = eventtypesState.CountryName.toString();
      eventtypesInsert.Country_Code = eventtypesState.CountryCode.toString();
      eventtypesInsert.Postal_Code = eventtypesState.Postalcode.toString();
      eventtypesInsert.Suite_Unit = eventtypesState.Suiteunit.toString();
      eventtypesInsert.Building_Name = eventtypesState.Buildingname.toString();
      eventtypesInsert.Property_Type =
          eventtypesState.eventtypestypeOtherValue.toString();
      eventtypesInsert.Min_Lease_Number =
          eventtypesState.minimumleasedurationnumber.toString();
      eventtypesInsert.Rent_Amount = eventtypesState.RentAmount.toString();
      eventtypesInsert.Date_Available =
          eventtypesState.dateofavailable.toString();
      eventtypesInsert.Owner_ID = Prefs.getString(PrefsName.OwnerID);
      eventtypesInsert.Vacancy = eventtypesState.PropVacancy;

      updateSummeryData(eventtypesState);

      if (Prefs.getBool(PrefsName.EventTypesEdit)) {
        EventTypesUpdate ceventtypesUpdate = new EventTypesUpdate();
        ceventtypesUpdate.ID = Prefs.getString(PrefsName.EventTypesID);
        ceventtypesUpdate.Owner_ID = Prefs.getString(PrefsName.OwnerID);

        if (eventtypesState.PropDrafting == 1 ||
            eventtypesState.PropDrafting == 0) {
          eventtypesInsert.PropDrafting = 1;
        } else {
          eventtypesInsert.PropDrafting = eventtypesState.PropDrafting;
        }

        ApiManager().UpdateEventTypesDetails(
            context, ceventtypesUpdate, eventtypesInsert,
            (error, respoce) async {
          if (error) {
            await Prefs.setBool(PrefsName.EventTypesStep1, true);

            String address = eventtypesState.EventTypesName +
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
            _store.dispatch(
                UpdateEventTypesDrafting(eventtypesInsert.PropDrafting!));
            _store.dispatch(UpdateSummeryEventTypesDrafting(
                eventtypesInsert.PropDrafting!));

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
        eventtypesInsert.PropDrafting = eventtypesState.PropDrafting;

        ApiManager().InsertEventTypesDetails(context, eventtypesInsert,
            (error, respoce) async {
          if (error) {
            await Prefs.setBool(PrefsName.EventTypesEdit, true);
            await Prefs.setBool(PrefsName.EventTypesStep1, true);
            await Prefs.setString(PrefsName.EventTypesID, respoce.toString());

            String address = eventtypesState.EventTypesName +
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
            _store.dispatch(UpdateEventTypesDrafting(1));
            _store.dispatch(UpdateSummeryEventTypesDrafting(1));

            //widget._callbackSaveandNext();

            ToastUtils.showCustomToast(
                context, "GlobleString.EventTypes_creation", true);

            if (!isGotoback) {
              widget._callbackSaveandNext();
            } else {
              _store.dispatch(UpdatePortalPage(1, GlobleString.NAV_Properties));
            }
          } else {
            ToastUtils.showCustomToast(context, respoce, false);
          }
        });
      }
    }
  }

  void updateSummeryData(EventTypesState eventtypesState) {
    _store.dispatch(
        UpdateSummeryProperTytypeValue(eventtypesState.eventtypestypeValue));
    _store.dispatch(UpdateSummeryEventTypesTypeOtherValue(
        eventtypesState.eventtypestypeOtherValue));
    _store.dispatch(
        UpdateSummeryDateofavailable(eventtypesState.dateofavailable));
    _store.dispatch(
        UpdateSummeryRentalSpaceValue(eventtypesState.rentalspaceValue));
    _store
        .dispatch(UpdateSummeryEventTypesName(eventtypesState.EventTypesName));
    _store.dispatch(
        UpdateSummeryEventTypesAddress(eventtypesState.EventTypesAddress));
    _store.dispatch(UpdateSummeryEventTypesDescription(
        eventtypesState.EventTypesDescription));
    _store.dispatch(UpdateSummerySuiteunit(eventtypesState.Suiteunit));
    _store.dispatch(UpdateSummeryBuildingname(eventtypesState.Buildingname));
    _store.dispatch(UpdateSummeryEventTypesCity(eventtypesState.City));
    _store.dispatch(
        UpdateSummeryEventTypesCountryCode(eventtypesState.CountryCode));
    _store.dispatch(
        UpdateSummeryEventTypesCountryName(eventtypesState.CountryName));
    _store.dispatch(UpdateSummeryEventTypesProvince(eventtypesState.Province));
    _store.dispatch(
        UpdateSummeryEventTypesPostalcode(eventtypesState.Postalcode));
    _store.dispatch(
        UpdateSummeryEventTypesRentAmount(eventtypesState.RentAmount));
    _store.dispatch(UpdateSummeryRentPaymentFrequencyValue(
        eventtypesState.rentpaymentFrequencyValue));
    _store
        .dispatch(UpdateSummeryLeaseTypeValue(eventtypesState.leasetypeValue));
    _store.dispatch(UpdateSummeryMinimumLeasedurationValue(
        eventtypesState.minimumleasedurationValue));
    _store.dispatch(UpdateSummeryMinimumleasedurationNumber(
        eventtypesState.minimumleasedurationnumber.toString()));
  }
}
