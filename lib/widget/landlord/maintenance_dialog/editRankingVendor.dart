import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/vendor_action/add_vendor_action.dart';
import 'package:silverhome/domain/entities/citydata.dart';
import 'package:silverhome/domain/entities/countrydata.dart';
import 'package:silverhome/domain/entities/statedata.dart';
import 'package:silverhome/presentation/models/vendor/add_vendor_state.dart';
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
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

class EditRankingVendorDialogBox extends StatefulWidget {
  final VoidCallback _callbackSave;
  final VoidCallback _callbackClose;
  static bool changeData = false;

  EditRankingVendorDialogBox({
    required VoidCallback onPressedSave,
    required VoidCallback onPressedClose,
  })  : _callbackSave = onPressedSave,
        _callbackClose = onPressedClose;

  @override
  _EditRankingVendorDialogBoxState createState() => _EditRankingVendorDialogBoxState();
}

class _EditRankingVendorDialogBoxState extends State<EditRankingVendorDialogBox> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  final FocusNode focus = FocusNode();
  late OverlayEntry loader;
  final _store = getIt<AppStore>();
  bool change = false;

  @override
  void initState() {
    apimanager();
    EditRankingVendorDialogBox.changeData = false;
    super.initState();
  }

  _changeData() {
    if (!change) {
      change = true;
      EditRankingVendorDialogBox.changeData = true;
    }
  }

  void apimanager() async {
    await Prefs.init();

    List<SystemEnumDetails> Categorylist = QueryFilter().PlainValues(eSystemEnums().Maintenance_Category);
    _store.dispatch(UpdateADV_Categorylist(Categorylist));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, 0),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 700, maxWidth: 700, minHeight: 620, maxHeight: 620),
            child: Container(
              height: 620,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
                color: Colors.white,
              ),
              child: ConnectState<AddVendorState>(
                map: (state) => state.addVendorState,
                where: notIdentical,
                builder: (addVendorState) {
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                if (!EditRankingVendorDialogBox.changeData) {
                                  widget._callbackClose();
                                  return;
                                }
                                showDialog(
                                  context: context,
                                  barrierColor: Colors.black45,
                                  useSafeArea: true,
                                  barrierDismissible: false,
                                  builder: (BuildContext context1) {
                                    return AlertDialogBox(
                                      title: GlobleString.ADV_back_to_msg,
                                      positiveText: GlobleString.ADV_back_to_msg_yes,
                                      negativeText: GlobleString.ADV_back_to_msg_NO,
                                      onPressedYes: () {
                                        Navigator.of(context1).pop();
                                        checkValidation(context, addVendorState!);
                                      },
                                      onPressedNo: () {
                                        Navigator.of(context1).pop();
                                        widget._callbackClose();
                                      },
                                    );
                                  },
                                );
                              },
                              child: const Icon(Icons.clear, size: 25),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          addVendorState!.vid != 0 ? GlobleString.LMV_Edit_Vendor : GlobleString.LMV_Add_New_Vendor,
                                          style: MyStyles.Medium(20, myColor.text_color),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            GlobleString.LMV_AV_Rating,
                                            style: MyStyles.Medium(14, myColor.text_color),
                                          ),
                                          const SizedBox(width: 10.0),
                                          RatingBar.builder(
                                            initialRating: addVendorState.rating,
                                            allowHalfRating: false,
                                            glow: false,
                                            itemBuilder: (context, index) => const Icon(
                                              Icons.star,
                                              color: myColor.blue,
                                            ),
                                            onRatingUpdate: (rating) {
                                              _store.dispatch(UpdateADV_rating(rating));
                                              _changeData();
                                            },
                                            itemCount: 5,
                                            itemSize: 25.0,
                                            unratedColor: myColor.TA_Border,
                                            direction: Axis.horizontal,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 25.0),
                                Container(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: Text(
                                    GlobleString.LMV_AV_ContactInformation,
                                    style: MyStyles.Medium(17, myColor.text_color),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Container(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: FocusScope(
                                    node: _focusScopeNode,
                                    child: Column(
                                      children: [
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
                                                    GlobleString.LMV_AV_CompanyName,
                                                    style: MyStyles.Medium(14, myColor.text_color),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  const SizedBox(height: 5.0),
                                                  TextFormField(
                                                    initialValue: addVendorState.companyname,
                                                    textAlign: TextAlign.start,
                                                    autofocus: true,
                                                    style: MyStyles.Medium(14, myColor.text_color),
                                                    decoration: const InputDecoration(
                                                        //border: InputBorder.none,
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: myColor.blue, width: 2),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: myColor.gray, width: 1.0),
                                                        ),
                                                        isDense: true,
                                                        contentPadding: EdgeInsets.all(10),
                                                        fillColor: myColor.white,
                                                        filled: true),
                                                    onChanged: (value) {
                                                      _store.dispatch(UpdateADV_companyname(value));
                                                      _changeData();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 7.0),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const SizedBox(width: 8.0),
                                                      Text(
                                                        GlobleString.LMV_AV_Category,
                                                        style: MyStyles.Medium(14, myColor.text_color),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5.0),
                                                  Container(
                                                    height: 30,
                                                    // ignore: missing_required_param
                                                    child: DropdownSearch<SystemEnumDetails>(
                                                      mode: Mode.MENU,
                                                      items: addVendorState.Categorylist,
                                                      textstyle: MyStyles.Medium(12, myColor.black),
                                                      itemAsString: (SystemEnumDetails? u) => u!.displayValue,
                                                      hint: GlobleString.Select_Category,
                                                      showSearchBox: false,
                                                      selectedItem: addVendorState.selectCategory,
                                                      isFilteredOnline: true,
                                                      focuscolor: myColor.blue,
                                                      focusWidth: 2,
                                                      defultHeight: addVendorState.Categorylist.length * 33 > 250
                                                          ? 250
                                                          : addVendorState.Categorylist.length * 33,
                                                      onChanged: (value) {
                                                        _store.dispatch(UpdateADV_selectCategory(value));
                                                        _changeData();
                                                      },
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
                                                  Row(
                                                    children: [
                                                      Text(
                                                        GlobleString.LMV_AV_Contact_FirstName,
                                                        style: MyStyles.Medium(14, myColor.text_color),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                      const SizedBox(width: 10.0),
                                                      Text(
                                                        GlobleString.Optional,
                                                        style: MyStyles.Medium(10, myColor.optional),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5.0),
                                                  TextFormField(
                                                    initialValue: addVendorState.cfirstname,
                                                    focusNode: focus,
                                                    textAlign: TextAlign.start,
                                                    style: MyStyles.Medium(14, myColor.text_color),
                                                    decoration: const InputDecoration(
                                                      //border: InputBorder.none,
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: myColor.blue, width: 2),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: myColor.gray, width: 1.0),
                                                      ),
                                                      isDense: true,
                                                      contentPadding: EdgeInsets.all(10),
                                                      fillColor: myColor.white,
                                                      filled: true,
                                                    ),
                                                    onChanged: (value) {
                                                      _store.dispatch(UpdateADV_cfirstname(value));
                                                      _changeData();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 15.0),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        GlobleString.LMV_AV_Contact_LastName,
                                                        style: MyStyles.Medium(14, myColor.text_color),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                      const SizedBox(width: 10.0),
                                                      Text(
                                                        GlobleString.Optional,
                                                        style: MyStyles.Medium(10, myColor.optional),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5.0),
                                                  TextFormField(
                                                    initialValue: addVendorState.clastname,
                                                    textAlign: TextAlign.start,
                                                    style: MyStyles.Medium(14, myColor.text_color),
                                                    decoration: const InputDecoration(
                                                      //border: InputBorder.none,
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: myColor.blue, width: 2),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: myColor.gray, width: 1.0),
                                                      ),
                                                      isDense: true,
                                                      contentPadding: EdgeInsets.all(10),
                                                      fillColor: myColor.white,
                                                      filled: true,
                                                    ),
                                                    onChanged: (value) {
                                                      _store.dispatch(UpdateADV_clastname(value));
                                                      _changeData();
                                                    },
                                                  ),
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
                                                  Row(
                                                    children: [
                                                      Text(
                                                        GlobleString.LMV_AV_Contact_Email,
                                                        style: MyStyles.Medium(14, myColor.text_color),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                      const SizedBox(width: 10.0),
                                                      Text(
                                                        GlobleString.Optional,
                                                        style: MyStyles.Medium(10, myColor.optional),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5.0),
                                                  TextFormField(
                                                    initialValue: addVendorState.cemail,
                                                    textAlign: TextAlign.start,
                                                    style: MyStyles.Medium(14, myColor.text_color),
                                                    decoration: const InputDecoration(
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: myColor.blue, width: 2),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: myColor.gray, width: 1.0),
                                                      ),
                                                      isDense: true,
                                                      contentPadding: EdgeInsets.all(10),
                                                      fillColor: myColor.white,
                                                      filled: true,
                                                    ),
                                                    onChanged: (value) {
                                                      _store.dispatch(UpdateADV_cemail(value));
                                                      _changeData();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 15.0),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    GlobleString.LMV_AV_Contact_PhoneNumber,
                                                    style: MyStyles.Medium(14, myColor.text_color),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  const SizedBox(height: 5.0),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: myColor.gray,
                                                        width: 1.0,
                                                      ),
                                                      borderRadius: BorderRadius.circular(4.0),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        CountryCodePicker(
                                                          onChanged: (value) {
                                                            _store.dispatch(UpdateADV_cdialcode(value.dialCode.toString()));
                                                            _store.dispatch(UpdateADV_ccountrycode(value.code.toString()));
                                                            _changeData();
                                                          },
                                                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                                          initialSelection:
                                                              addVendorState.ccountrycode.isEmpty ? addVendorState.ccountrycode : "CA",
                                                          showFlag: true,
                                                          textStyle: MyStyles.Medium(14, myColor.text_color),
                                                          dialogTextStyle: MyStyles.Medium(14, myColor.text_color),
                                                          //showDropDownButton: true,
                                                        ),
                                                        Expanded(
                                                          child: TextFormField(
                                                            initialValue: addVendorState.cphone,
                                                            keyboardType: TextInputType.phone,
                                                            inputFormatters: [MaskedInputFormatter("(000) 000 0000")],
                                                            decoration: const InputDecoration(
                                                              border: InputBorder.none,
                                                              hintStyle: TextStyle(color: Colors.grey),
                                                              contentPadding: EdgeInsets.all(10),
                                                              isDense: true,
                                                            ),
                                                            style: MyStyles.Medium(14, myColor.text_color),
                                                            onChanged: (value) {
                                                              _store.dispatch(UpdateADV_cphone(value));
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
                                          ],
                                        ),
                                        const SizedBox(height: 20.0),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            GlobleString.LMV_AV_Address,
                                            style: MyStyles.Medium(17, myColor.text_color),
                                            textAlign: TextAlign.start,
                                          ),
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
                                                  Row(
                                                    children: [
                                                      Text(
                                                        GlobleString.LMV_AV_CompanyAddress,
                                                        style: MyStyles.Medium(14, myColor.text_color),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                      const SizedBox(width: 10.0),
                                                      Text(
                                                        GlobleString.Optional,
                                                        style: MyStyles.Medium(10, myColor.optional),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5.0),
                                                  TextFormField(
                                                    initialValue: addVendorState.address,
                                                    textAlign: TextAlign.start,
                                                    style: MyStyles.Medium(14, myColor.text_color),
                                                    decoration: const InputDecoration(
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: myColor.blue, width: 2),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: myColor.gray, width: 1.0),
                                                      ),
                                                      isDense: true,
                                                      contentPadding: EdgeInsets.all(10),
                                                      fillColor: myColor.white,
                                                      filled: true,
                                                    ),
                                                    onChanged: (value) {
                                                      _store.dispatch(UpdateADV_address(value));
                                                      _changeData();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 20.0),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        GlobleString.LMV_AV_SuiteUnitetc,
                                                        style: MyStyles.Medium(14, myColor.text_color),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                      const SizedBox(width: 10.0),
                                                      Text(
                                                        GlobleString.Optional,
                                                        style: MyStyles.Medium(10, myColor.optional),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5.0),
                                                  TextFormField(
                                                    initialValue: addVendorState.suit,
                                                    textAlign: TextAlign.start,
                                                    style: MyStyles.Medium(14, myColor.text_color),
                                                    decoration: const InputDecoration(
                                                        //border: InputBorder.none,
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: myColor.blue, width: 2.0),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: myColor.gray, width: 1.0),
                                                        ),
                                                        isDense: true,
                                                        contentPadding: EdgeInsets.all(10),
                                                        fillColor: myColor.white,
                                                        filled: true),
                                                    onChanged: (value) {
                                                      _store.dispatch(UpdateADV_suit(value));
                                                      _changeData();
                                                    },
                                                  ),
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
                                                  Row(
                                                    children: [
                                                      Text(
                                                        GlobleString.LMV_AV_PostalCode_ZipCode,
                                                        style: MyStyles.Medium(14, myColor.text_color),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                      const SizedBox(width: 10.0),
                                                      Text(
                                                        GlobleString.Optional,
                                                        style: MyStyles.Medium(10, myColor.optional),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5.0),
                                                  TextFormField(
                                                    initialValue: addVendorState.postalcode,
                                                    textAlign: TextAlign.start,
                                                    style: MyStyles.Medium(14, myColor.text_color),
                                                    decoration: const InputDecoration(
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: myColor.blue, width: 2.0),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: myColor.gray, width: 1.0),
                                                        ),
                                                        isDense: true,
                                                        contentPadding: EdgeInsets.all(10),
                                                        fillColor: myColor.white,
                                                        filled: true),
                                                    onChanged: (value) {
                                                      _store.dispatch(UpdateADV_postalcode(value));
                                                      _changeData();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 7.0),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const SizedBox(width: 8.0),
                                                      Text(
                                                        GlobleString.LMV_AV_Country,
                                                        style: MyStyles.Medium(14, myColor.text_color),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5.0),
                                                  Container(
                                                    height: 30,
                                                    // ignore: missing_required_param
                                                    child: DropdownSearch<CountryData>(
                                                      key: UniqueKey(),
                                                      mode: Mode.MENU,
                                                      items: addVendorState.countrydatalist,
                                                      textstyle: MyStyles.Medium(12, myColor.black),
                                                      itemAsString: (CountryData? u) => u!.CountryName!,
                                                      hint: GlobleString.Select_Country,
                                                      showSearchBox: false,
                                                      defultHeight: addVendorState.countrydatalist.length * 35 > 250
                                                          ? 250
                                                          : addVendorState.countrydatalist.length * 35,
                                                      selectedItem: addVendorState.selectedCountry,
                                                      isFilteredOnline: true,
                                                      focuscolor: myColor.blue,
                                                      focusWidth: 2,
                                                      onChanged: (value) {
                                                        _changeData();
                                                        _store.dispatch(UpdateADV_selectedCountry(value));

                                                        _store.dispatch(UpdateADV_statedatalist([]));
                                                        _store.dispatch(UpdateADV_citydatalist([]));
                                                        _store.dispatch(UpdateADV_selectedCity(null));
                                                        _store.dispatch(UpdateADV_selectedState(null));

                                                        loader = Helper.overlayLoader(context);
                                                        Overlay.of(context)!.insert(loader);

                                                        ApiManager().getStateList(context, value!.ID.toString(),
                                                            (status, responce, errorlist) {
                                                          if (status) {
                                                            loader.remove();
                                                            _store.dispatch(UpdateADV_statedatalist(errorlist));
                                                          } else {
                                                            loader.remove();
                                                          }
                                                        });
                                                      },
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
                                                  Row(
                                                    children: [
                                                      const SizedBox(width: 5.0),
                                                      Text(
                                                        GlobleString.LMV_AV_Province_State,
                                                        style: MyStyles.Medium(14, myColor.text_color),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5.0),
                                                  Container(
                                                    height: 30.0,
                                                    child: DropdownSearch<StateData>(
                                                      key: UniqueKey(),
                                                      mode: Mode.MENU,
                                                      items: addVendorState.statedatalist,
                                                      textstyle: MyStyles.Medium(12, myColor.black),
                                                      itemAsString: (StateData? u) => u!.StateName!,
                                                      hint: GlobleString.Select_State,
                                                      showSearchBox: false,
                                                      selectedItem:
                                                          addVendorState.selectedState != null ? addVendorState.selectedState : null,
                                                      defultHeight: addVendorState.statedatalist.length * 35 > 250
                                                          ? 250
                                                          : addVendorState.statedatalist.length * 35,
                                                      isFilteredOnline: true,
                                                      focuscolor: myColor.blue,
                                                      focusWidth: 2,
                                                      onChanged: (value) {
                                                        _changeData();
                                                        _store.dispatch(UpdateADV_selectedState(value));

                                                        _store.dispatch(UpdateADV_citydatalist([]));
                                                        _store.dispatch(UpdateADV_selectedCity(null));

                                                        loader = Helper.overlayLoader(context);
                                                        Overlay.of(context)!.insert(loader);

                                                        ApiManager().getCityList(context, value!.ID.toString(),
                                                            (status, responce, errorlist) {
                                                          if (status) {
                                                            loader.remove();
                                                            _store.dispatch(UpdateADV_citydatalist(errorlist));
                                                          } else {
                                                            loader.remove();
                                                          }
                                                        });
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 7.0),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(width: 8.0),
                                                      Text(
                                                        GlobleString.LMV_AV_City,
                                                        style: MyStyles.Medium(14, myColor.text_color),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5.0),
                                                  Container(
                                                    height: 30,
                                                    // ignore: missing_required_param
                                                    child: DropdownSearch<CityData>(
                                                      key: UniqueKey(),
                                                      mode: Mode.MENU,
                                                      items: addVendorState.citydatalist,
                                                      textstyle: MyStyles.Medium(12, myColor.black),
                                                      itemAsString: (CityData? u) => u!.CityName!,
                                                      hint: GlobleString.Select_City,
                                                      showSearchBox: false,
                                                      selectedItem:
                                                          addVendorState.selectedCity != null ? addVendorState.selectedCity : null,
                                                      defultHeight: addVendorState.citydatalist.length * 35 > 250
                                                          ? 250
                                                          : addVendorState.citydatalist.length * 35,
                                                      isFilteredOnline: true,
                                                      focuscolor: myColor.blue,
                                                      focusWidth: 2,
                                                      onChanged: (value) {
                                                        _store.dispatch(UpdateADV_selectedCity(value));
                                                        _changeData();
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15.0),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  GlobleString.LMV_AV_Note,
                                                  style: MyStyles.Medium(14, myColor.text_color),
                                                  textAlign: TextAlign.start,
                                                ),
                                                const SizedBox(width: 10.0),
                                                Text(
                                                  GlobleString.Optional,
                                                  style: MyStyles.Medium(10, myColor.optional),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5.0),
                                            TextFormField(
                                              initialValue: addVendorState.Note,
                                              textAlign: TextAlign.start,
                                              style: MyStyles.Medium(14, myColor.text_color),
                                              maxLines: 4,
                                              maxLength: 10000,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(10000),
                                              ],
                                              decoration: const InputDecoration(
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: myColor.blue, width: 2.0),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: myColor.gray, width: 1.0),
                                                  ),
                                                  isDense: true,
                                                  contentPadding: EdgeInsets.all(10),
                                                  fillColor: myColor.white,
                                                  filled: true),
                                              onChanged: (value) {
                                                _store.dispatch(UpdateADV_Note(value));
                                                _changeData();
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          /* if (!EditVendorDialogBox.changeData) {
                                            widget._callbackClose();
                                            return;
                                          }*/
                                          showDialog(
                                            context: context,
                                            barrierColor: Colors.black45,
                                            useSafeArea: true,
                                            barrierDismissible: false,
                                            builder: (BuildContext context1) {
                                              return AlertDialogBox(
                                                title: GlobleString.ADV_back_to_msg,
                                                positiveText: GlobleString.ADV_back_to_msg_yes,
                                                negativeText: GlobleString.ADV_back_to_msg_NO,
                                                onPressedYes: () {
                                                  Navigator.of(context1).pop();
                                                  checkValidation(context, addVendorState);
                                                },
                                                onPressedNo: () {
                                                  Navigator.of(context1).pop();
                                                  widget._callbackClose();
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 35,
                                          padding: const EdgeInsets.only(left: 25, right: 25),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                                              color: myColor.white,
                                              border: Border.all(color: myColor.Circle_main, width: 1)),
                                          child: Text(
                                            GlobleString.NL_Close,
                                            style: MyStyles.Medium(14, myColor.Circle_main),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      InkWell(
                                        onTap: () {
                                          checkValidation(context, addVendorState);
                                          // widget._callbackSave();
                                        },
                                        child: Container(
                                          height: 35,
                                          padding: const EdgeInsets.only(left: 25, right: 25),
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                            color: myColor.Circle_main,
                                          ),
                                          child: Text(
                                            GlobleString.NL_SAVE,
                                            style: MyStyles.Medium(14, myColor.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkValidation(BuildContext context, AddVendorState addVendorState) {
    /*if (addVendorState.rating == 0) {
      ToastUtils.showCustomToast(
          context, GlobleString.ADV_error_insert_rate, false);
    } else*/
    if (addVendorState.companyname == null || addVendorState.companyname.isEmpty) {
      ToastUtils.showCustomToast(context, GlobleString.ADV_error_companyname, false);
    } else if (addVendorState.selectCategory == null) {
      ToastUtils.showCustomToast(context, GlobleString.ADV_error_category, false);
    } else if (addVendorState.cemail != null &&
        addVendorState.cemail.isNotEmpty &&
        Helper.ValidEmail(addVendorState.cemail.trim().toString()) != true) {
      ToastUtils.showCustomToast(context, GlobleString.ADV_error_email, false);
    } else if (addVendorState.cphone == null || addVendorState.cphone.isEmpty) {
      ToastUtils.showCustomToast(context, GlobleString.ADV_error_phone, false);
    } else if (Helper.ValidPhonenumber(addVendorState.cphone.toString())) {
      ToastUtils.showCustomToast(context, GlobleString.ADV_error_phone_valid, false);
    } else if (addVendorState.selectedCountry == null) {
      ToastUtils.showCustomToast(context, GlobleString.ADV_error_country, false);
    } else if (addVendorState.selectedState == null) {
      ToastUtils.showCustomToast(context, GlobleString.ADV_error_state, false);
    } else if (addVendorState.selectedCity == null) {
      ToastUtils.showCustomToast(context, GlobleString.ADV_error_city, false);
    } else {
      if (addVendorState.vid != 0) {
        editVendor(addVendorState);
      } else {
        addVendor(addVendorState);
      }
    }
  }

  void editVendor(AddVendorState addVendorState) {
    VendorPersonId personid = new VendorPersonId();
    personid.ID = addVendorState.personid.toString();
    personid.firstName = addVendorState.cfirstname;
    personid.lastName = addVendorState.clastname;
    personid.email = addVendorState.cemail;
    personid.mobileNumber = addVendorState.cphone;
    personid.Country_Code = addVendorState.ccountrycode;
    personid.Dial_Code = addVendorState.cdialcode;

    VendorDataQuery vendorData = new VendorDataQuery();
    vendorData.note = addVendorState.Note;
    vendorData.CompanyName = addVendorState.companyname;
    vendorData.Category = addVendorState.selectCategory!.EnumDetailID.toString();
    vendorData.Address = addVendorState.address;
    vendorData.Suite = addVendorState.suit;
    vendorData.City = addVendorState.selectedCity!.ID;
    vendorData.Province = addVendorState.selectedState!.ID;
    vendorData.Country = addVendorState.selectedCountry!.ID;
    vendorData.PostalCode = addVendorState.postalcode;
    vendorData.Rating = addVendorState.rating;
    vendorData.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    vendorData.personId = personid;

    PropertyUpdate propertyUpdate = new PropertyUpdate();
    propertyUpdate.ID = addVendorState.vid.toString();
    propertyUpdate.Owner_ID = Prefs.getString(PrefsName.OwnerID);

    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().EditVendor(context, propertyUpdate, vendorData, (error, respoce) {
      if (error) {
        loader.remove();
        ToastUtils.showCustomToast(context, GlobleString.ADV_update_successfully, true);
        widget._callbackSave();
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, GlobleString.NL_error_insertcall, false);
      }
    });
  }

  void addVendor(AddVendorState addVendorState) {
    VendorPersonId personid = new VendorPersonId();
    personid.firstName = addVendorState.cfirstname;
    personid.lastName = addVendorState.clastname;
    personid.email = addVendorState.cemail;
    personid.mobileNumber = addVendorState.cphone;
    personid.Country_Code = addVendorState.ccountrycode;
    personid.Dial_Code = addVendorState.cdialcode;

    VendorDataQuery vendorData = new VendorDataQuery();
    vendorData.note = addVendorState.Note;
    vendorData.CompanyName = addVendorState.companyname;
    vendorData.Category = addVendorState.selectCategory!.EnumDetailID.toString();
    vendorData.Address = addVendorState.address;
    vendorData.Suite = addVendorState.suit;
    vendorData.City = addVendorState.selectedCity!.ID;
    vendorData.Province = addVendorState.selectedState!.ID;
    vendorData.Country = addVendorState.selectedCountry!.ID;
    vendorData.PostalCode = addVendorState.postalcode;
    vendorData.Rating = addVendorState.rating;
    vendorData.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    vendorData.personId = personid;

    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().InsetNewVendor(context, vendorData, (error, respoce) {
      if (error) {
        loader.remove();
        ToastUtils.showCustomToast(context, GlobleString.ADV_insert_successfully, true);
        widget._callbackSave();
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, GlobleString.NL_error_insertcall, false);
      }
    });
  }
}
