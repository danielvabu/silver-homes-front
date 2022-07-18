import 'dart:async';
import 'dart:html' as html;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/notification_type.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/maintenance_action/add_maintenance_action.dart';
import 'package:silverhome/domain/entities/basic_tenant/addvendordata.dart';
import 'package:silverhome/domain/entities/citydata.dart';
import 'package:silverhome/domain/entities/countrydata.dart';
import 'package:silverhome/domain/entities/fileobject.dart';
import 'package:silverhome/domain/entities/maintenace_notification.dart';
import 'package:silverhome/domain/entities/property_drop_data.dart';
import 'package:silverhome/domain/entities/statedata.dart';
import 'package:silverhome/presentation/models/maintenance/add_maintenance_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/landlord/maintenance_dialog/add_assigne_vendor_item_widget.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

import '../../alert_dialogbox.dart';

class MaintenanceAddNewRequestDialogBox extends StatefulWidget {
  final VoidCallback _callbackSave;
  final VoidCallback _callbackClose;
  static bool changeData = false;

  MaintenanceAddNewRequestDialogBox({
    required VoidCallback onPressedSave,
    required VoidCallback onPressedClose,
  })  : _callbackSave = onPressedSave,
        _callbackClose = onPressedClose;

  @override
  _MaintenanceAddNewRequestDialogBoxState createState() =>
      _MaintenanceAddNewRequestDialogBoxState();
}

class _MaintenanceAddNewRequestDialogBoxState
    extends State<MaintenanceAddNewRequestDialogBox> {
  late OverlayEntry loader;
  final _store = getIt<AppStore>();

  bool isListLoad = false;
  bool change = false;

  @override
  void initState() {
    apimanager();
    MaintenanceAddNewRequestDialogBox.changeData = false;
    super.initState();
  }

  _changeData() {
    if (!change) {
      MaintenanceAddNewRequestDialogBox.changeData = true;
      change = true;
    }
  }

  void apimanager() async {
    await Prefs.init();

    if (_store.state!.addMaintenanceState != null) {
      if (_store.state!.addMaintenanceState.selectStatus == null) {
        for (int i = 0;
            i < _store.state!.addMaintenanceState.MaintenanceStatuslist.length;
            i++) {
          SystemEnumDetails enumdata =
              _store.state!.addMaintenanceState.MaintenanceStatuslist[i];

          if (enumdata.EnumDetailID == 1) {
            _store.dispatch(UpdateMAR_selectStatus(enumdata));
            break;
          }
        }
      }
    }
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
                minWidth: 750, maxWidth: 750, minHeight: 600, maxHeight: 600),
            child: Container(
              height: 600,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                color: Colors.white,
              ),
              child: ConnectState<AddMaintenanceState>(
                map: (state) => state.addMaintenanceState,
                where: notIdentical,
                builder: (addMaintenanceState) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(top: 10, left: 10, right: 10),
                            child: InkWell(
                              onTap: () {
                                closeDialog(addMaintenanceState!);
                              },
                              child: Icon(Icons.clear, size: 25),
                            ),
                          ),
                        ],
                      ),
                      _addNewRequest(addMaintenanceState!),
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

  closeDialog(AddMaintenanceState addMaintenanceState) {
    if (!MaintenanceAddNewRequestDialogBox.changeData) {
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
            checkValidation(addMaintenanceState);
          },
          onPressedNo: () {
            Navigator.of(context1).pop();
            widget._callbackClose();
          },
        );
      },
    );
  }

  Widget _addNewRequest(AddMaintenanceState addMaintenanceState) {
    return Expanded(
      flex: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 500,
            margin: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            GlobleString.Mant_view_MaintenanceRequest,
                            style: MyStyles.Medium(20, myColor.black),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                GlobleString.Mant_DL_Status,
                                style: MyStyles.Medium(12, myColor.black),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 30,
                                width: 150,
                                // ignore: missing_required_param
                                child: DropdownSearch<SystemEnumDetails>(
                                  mode: Mode.MENU,
                                  focuscolor: myColor.blue,
                                  focusWidth: 2,
                                  items:
                                      addMaintenanceState.MaintenanceStatuslist,
                                  textstyle: MyStyles.Medium(12, myColor.black),
                                  itemAsString: (SystemEnumDetails? u) =>
                                      u!.displayValue,
                                  defultHeight: addMaintenanceState
                                                  .MaintenanceStatuslist
                                                  .length *
                                              35 >
                                          250
                                      ? 250
                                      : addMaintenanceState
                                              .MaintenanceStatuslist.length *
                                          35,
                                  hint: GlobleString.Select_Status,
                                  showSearchBox: false,
                                  selectedItem:
                                      addMaintenanceState.selectStatus,
                                  isFilteredOnline: true,
                                  onChanged: (value) {
                                    _store.dispatch(
                                        UpdateMAR_selectStatus(value));
                                    _changeData();
                                  },
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
                    _requestInfo(addMaintenanceState),
                    SizedBox(
                      height: 25,
                    ),
                    if (addMaintenanceState.vendordatalist.length > 0)
                      _vendorInformation(addMaintenanceState),
                    _addNewVendor(addMaintenanceState)
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    closeDialog(addMaintenanceState);
                  },
                  child: Container(
                    height: 30,
                    width: 100,
                    padding: EdgeInsets.only(left: 25, right: 25),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: myColor.Circle_main, width: 1),
                      color: myColor.white,
                    ),
                    child: Text(
                      GlobleString.Mant_DL_Cancel,
                      style: MyStyles.Medium(12, myColor.Circle_main),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    checkValidation(addMaintenanceState);
                    //widget._callbackSave();
                  },
                  child: Container(
                    height: 30,
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: myColor.Circle_main,
                    ),
                    child: Text(
                      GlobleString.Mant_DL_Save,
                      style: MyStyles.Medium(12, myColor.white),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _requestInfo(AddMaintenanceState addMaintenanceState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GlobleString.Mant_DL_RequestInformation,
          style: MyStyles.Medium(16, myColor.black),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          GlobleString.Mant_DL_Property,
          style: MyStyles.Medium(12, myColor.black),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 30,
                child: DropdownSearch<PropertyDropData>(
                  mode: Mode.MENU,
                  items: addMaintenanceState.PropertyDropDatalist,
                  textstyle: MyStyles.Medium(12, myColor.black),
                  itemAsString: (PropertyDropData? u) => u!.propertyName!,
                  hint: GlobleString.Select_Property,
                  showSearchBox: true,
                  defultHeight:
                      addMaintenanceState.PropertyDropDatalist.length * 35 > 400
                          ? 400
                          : (addMaintenanceState.PropertyDropDatalist.length *
                                  35) +
                              50,
                  showClearButton: false,
                  selectedItem: addMaintenanceState.selectproperty,
                  focuscolor: myColor.blue,
                  focusWidth: 2,
                  isFilteredOnline: true,
                  onChanged: (value) {
                    _store.dispatch(UpdateMAR_selectproperty(value));
                    _changeData();
                  },
                ),
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
                        GlobleString.Mant_DL_RequestName,
                        style: MyStyles.Medium(12, myColor.black),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        GlobleString.Mant_DL_RequestName1,
                        style: MyStyles.Medium(12, myColor.optional),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    initialValue: addMaintenanceState.requestName,
                    textAlign: TextAlign.start,
                    style: MyStyles.Medium(12, myColor.text_color),
                    maxLines: 1,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25),
                    ],
                    decoration: InputDecoration(
                      //border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: myColor.blue, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: myColor.gray, width: 1.0),
                      ),
                      isDense: true,
                      hintText: GlobleString.Mant_DL_hint_request,
                      hintStyle: MyStyles.Regular(12, myColor.hint),
                      contentPadding: EdgeInsets.all(10),
                      fillColor: myColor.white,
                      filled: true,
                    ),
                    onChanged: (value) {
                      _store.dispatch(UpdateMAR_requestName(value));
                      _changeData();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
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
                    GlobleString.Mant_DL_Category,
                    style: MyStyles.Medium(12, myColor.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 30,
                    // ignore: missing_required_param
                    child: DropdownSearch<SystemEnumDetails>(
                      mode: Mode.MENU,
                      items: addMaintenanceState.MaintenanceCategorylist,
                      textstyle: MyStyles.Medium(12, myColor.black),
                      itemAsString: (SystemEnumDetails? u) => u!.displayValue,
                      hint: GlobleString.Select_Category,
                      showSearchBox: false,
                      selectedItem: addMaintenanceState.selectCategory,
                      isFilteredOnline: true,
                      focuscolor: myColor.blue,
                      focusWidth: 2,
                      defultHeight: addMaintenanceState
                                      .MaintenanceCategorylist.length *
                                  35 >
                              250
                          ? 250
                          : addMaintenanceState.MaintenanceCategorylist.length *
                              35,
                      onChanged: (value) {
                        _store.dispatch(UpdateMAR_selectCategory(value));
                        _changeData();
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    GlobleString.Mant_DL_Priority,
                    style: MyStyles.Medium(12, myColor.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _store.dispatch(UpdateMAR_priority(1));
                            _changeData();
                          },
                          child: Container(
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color: myColor.TA_Border, width: 1),
                              color: addMaintenanceState.priority == 1
                                  ? myColor.TA_tab_text
                                  : myColor.white,
                            ),
                            child: Text(
                              GlobleString.Mant_DL_Low,
                              style: MyStyles.Medium(
                                  12,
                                  addMaintenanceState.priority == 1
                                      ? myColor.white
                                      : myColor.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _store.dispatch(UpdateMAR_priority(2));
                            _changeData();
                          },
                          child: Container(
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color: myColor.TA_Border, width: 1),
                              color: addMaintenanceState.priority == 2
                                  ? myColor.TA_tab_text
                                  : myColor.white,
                            ),
                            child: Text(
                              GlobleString.Mant_DL_Medium,
                              style: MyStyles.Medium(
                                  12,
                                  addMaintenanceState.priority == 2
                                      ? myColor.white
                                      : myColor.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _store.dispatch(UpdateMAR_priority(3));
                            _changeData();
                          },
                          child: Container(
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color: myColor.TA_Border, width: 1),
                              color: addMaintenanceState.priority == 3
                                  ? myColor.TA_tab_text
                                  : myColor.white,
                            ),
                            child: Text(
                              GlobleString.Mant_DL_High,
                              style: MyStyles.Medium(
                                  12,
                                  addMaintenanceState.priority == 3
                                      ? myColor.white
                                      : myColor.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          GlobleString.Mant_DL_Describetheissue,
          style: MyStyles.Medium(12, myColor.black),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          initialValue: addMaintenanceState.description,
          textAlign: TextAlign.start,
          style: MyStyles.Medium(12, myColor.text_color),
          maxLines: 4,
          maxLength: 10000,
          inputFormatters: [LengthLimitingTextInputFormatter(10000)],
          decoration: InputDecoration(
            //border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: myColor.blue, width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: myColor.gray, width: 1.0),
            ),
            isDense: true,
            hintText: GlobleString.Mant_DL_hint_Describetheissue,
            hintStyle: MyStyles.Regular(12, myColor.hint),
            contentPadding: EdgeInsets.all(10),
            fillColor: myColor.white,
            filled: true,
          ),
          onChanged: (value) {
            _store.dispatch(UpdateMAR_description(value));
            _changeData();
          },
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              GlobleString.Mant_DL_Uploadfiles,
              style: MyStyles.Medium(12, myColor.black),
              textAlign: TextAlign.center,
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
          height: 10,
        ),
        ListView.builder(
          itemCount: addMaintenanceState.fileobjectlist.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            FileObject fileObject = addMaintenanceState.fileobjectlist[index];
            return Container(
              width: 500,
              height: 30,
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 400,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      fileObject.filename != null ? fileObject.filename! : "",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: MyStyles.Medium(12, myColor.black),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onTap: () {
                      if (addMaintenanceState.fileobjectlist != null &&
                          addMaintenanceState.fileobjectlist.isNotEmpty) {
                        ToastUtils.showCustomToast(
                            context, GlobleString.File_deleted, true);

                        List<FileObject> mylist =
                            addMaintenanceState.fileobjectlist;
                        mylist.removeAt(index);

                        _store.dispatch(UpdateMAR_fileobjectlist(mylist));
                        _changeData();
                      }
                    },
                    child: Image.asset(
                      "assets/images/ic_delete.png",
                      height: 15,
                      //width: 20,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            PickMultipleImage(addMaintenanceState);
          },
          child: Container(
            height: 30,
            width: 85,
            padding: EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: myColor.Circle_main, width: 1),
              color: myColor.white,
            ),
            child: Text(
              GlobleString.Mant_DL_Upload,
              style: MyStyles.Medium(12, myColor.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _vendorInformation(AddMaintenanceState addMaintenanceState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GlobleString.Mant_DL_VendorInformation,
          style: MyStyles.Medium(16, myColor.black),
          textAlign: TextAlign.center,
        ),
        /*SizedBox(
          height: 10,
        ),
        Text(
          GlobleString.ADM_assign_vendor_Instruction,
          style: MyStyles.Medium(12, myColor.errorcolor),
          textAlign: TextAlign.center,
        ),*/
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
                    GlobleString.Mant_DL_Country,
                    style: MyStyles.Medium(12, myColor.text_color),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 30,
                    // ignore: missing_required_param
                    child: DropdownSearch<CountryData>(
                      key: UniqueKey(),
                      mode: Mode.MENU,
                      items: addMaintenanceState.countrydatalist,
                      textstyle: MyStyles.Medium(12, myColor.black),
                      itemAsString: (CountryData? u) => u!.CountryName!,
                      hint: GlobleString.Select_Country,
                      showSearchBox: false,
                      defultHeight:
                          addMaintenanceState.countrydatalist.length * 35 > 250
                              ? 250
                              : addMaintenanceState.countrydatalist.length * 35,
                      selectedItem: addMaintenanceState.selectedCountry != null
                          ? addMaintenanceState.selectedCountry
                          : null,
                      isFilteredOnline: true,
                      focuscolor: myColor.blue,
                      focusWidth: 2,
                      onChanged: (value) {
                        _changeData();
                        _store.dispatch(UpdateMAR_selectedCountry(value));

                        _store.dispatch(UpdateMAR_statedatalist([]));
                        _store.dispatch(UpdateMAR_citydatalist([]));
                        _store.dispatch(UpdateMAR_selectedCity([]));
                        _store.dispatch(UpdateMAR_vendordatalist([]));
                        _store.dispatch(UpdateMAR_selectedState(null));

                        addVendorItemList(addMaintenanceState);

                        loader = Helper.overlayLoader(context);
                        Overlay.of(context)!.insert(loader);

                        ApiManager().getStateList(context, value!.ID.toString(),
                            (status, responce, errorlist) {
                          if (status) {
                            loader.remove();
                            _store.dispatch(UpdateMAR_statedatalist(errorlist));
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
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    GlobleString.LMV_AV_Province_State,
                    style: MyStyles.Medium(12, myColor.text_color),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 30,
                    // ignore: missing_required_param
                    child: DropdownSearch<StateData>(
                      key: UniqueKey(),
                      mode: Mode.MENU,
                      items: addMaintenanceState.statedatalist,
                      textstyle: MyStyles.Medium(12, myColor.black),
                      itemAsString: (StateData? u) => u!.StateName!,
                      enabled: addMaintenanceState.selectedCountry != null
                          ? true
                          : false,
                      hint: GlobleString.Select_State,
                      showSearchBox: false,
                      selectedItem: addMaintenanceState.selectedState != null
                          ? addMaintenanceState.selectedState
                          : null,
                      defultHeight:
                          addMaintenanceState.statedatalist.length * 35 > 250
                              ? 250
                              : addMaintenanceState.statedatalist.length * 35,
                      isFilteredOnline: true,
                      focuscolor: myColor.blue,
                      focusWidth: 2,
                      onChanged: (value) {
                        _changeData();
                        _store.dispatch(UpdateMAR_selectedState(value));

                        _store.dispatch(UpdateMAR_citydatalist([]));
                        _store.dispatch(UpdateMAR_selectedCity([]));
                        _store.dispatch(UpdateMAR_vendordatalist([]));

                        addVendorItemList(addMaintenanceState);

                        loader = Helper.overlayLoader(context);
                        Overlay.of(context)!.insert(loader);

                        ApiManager().getCityList(context, value!.ID.toString(),
                            (status, responce, errorlist) {
                          if (status) {
                            loader.remove();
                            _store.dispatch(UpdateMAR_citydatalist(errorlist));
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
        SizedBox(
          height: 15,
        ),
        Text(
          GlobleString.Mant_DL_Vendor_city,
          style: MyStyles.Medium(12, myColor.black),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          //height: 30,
          child: DropdownSearch<CityData>.multiSelection(
            mode: Mode.MENU,
            textstyle: MyStyles.Medium(12, myColor.black),
            compareFn: (item, selectedItem) => item?.ID == selectedItem?.ID,
            itemAsString: (CityData? u) => u!.CityName!,
            selectedItems: addMaintenanceState.selectedCity != null
                ? addMaintenanceState.selectedCity!
                : [],
            hint: GlobleString.Select_City,
            enabled: addMaintenanceState.selectedState != null ? true : false,
            items: addMaintenanceState.citydatalist,
            maxHeight: addMaintenanceState.citydatalist.length == 0
                ? 250
                : addMaintenanceState.citydatalist.length * 35 > 250
                    ? 250
                    : addMaintenanceState.citydatalist.length * 35,
            defultHeight: addMaintenanceState.citydatalist.length == 0
                ? 250
                : addMaintenanceState.citydatalist.length * 35 > 250
                    ? 250
                    : addMaintenanceState.citydatalist.length * 35,
            focuscolor: myColor.blue,
            focusWidth: 2,
            showSearchBox: false,
            isFilteredOnline: true,
            onChange: (value) {
              _changeData();
              _store.dispatch(UpdateMAR_mainvendordatalist([]));
              _store.dispatch(UpdateMAR_filterCategorylist([]));
              _store.dispatch(UpdateMAR_vendordatalist([]));
              addVendorItemList(addMaintenanceState);

              if (value != null && value.isNotEmpty) {
                _store.dispatch(UpdateMAR_selectedCity(value));
                UpdateVendorAPI(addMaintenanceState, value);
              } else {
                _store.dispatch(UpdateMAR_selectedCity([]));
              }
            },
            onRemove: (value) {
              addMaintenanceState.selectedCity!.remove(value);

              _store.dispatch(UpdateMAR_mainvendordatalist([]));
              _store.dispatch(UpdateMAR_filterCategorylist([]));
              _store.dispatch(UpdateMAR_vendordatalist([]));

              addVendorItemList(addMaintenanceState);

              if (addMaintenanceState.selectedCity != null &&
                  addMaintenanceState.selectedCity!.isNotEmpty) {
                _store.dispatch(
                    UpdateMAR_selectedCity(addMaintenanceState.selectedCity));
                UpdateVendorAPI(
                    addMaintenanceState, addMaintenanceState.selectedCity);
              } else {
                _store.dispatch(UpdateMAR_selectedCity([]));
              }
            },
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          height: 1,
          color: myColor.TA_tab_devide,
        ),
        SizedBox(
          height: 15,
        ),
        !isListLoad
            ? ListView.builder(
                itemCount: addMaintenanceState.vendordatalist.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return AddAssigneVendorItemWidget(
                    count: (index + 1),
                    dmodel1: addMaintenanceState.vendordatalist[index],
                    pos: index,
                    onPressedDelete: (pos) {
                      delete_vendorItem(addMaintenanceState, index);
                    },
                    addMaintenanceState: addMaintenanceState,
                  );
                },
              )
            : Container(
                child: AddAssigneVendorItemWidget(
                  count: 1,
                  dmodel1: new AddVendorData(
                      filtervendordatalist: [],
                      id: "1",
                      Instruction: "",
                      selectvendor: null,
                      selectfilterCategory: null),
                  pos: 1,
                  onPressedDelete: (pos) {},
                  addMaintenanceState: addMaintenanceState,
                ),
              ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget _addNewVendor(AddMaintenanceState? addMaintenanceState) {
    return InkWell(
      onTap: () async {
        addNewVendorinValidation(addMaintenanceState);
      },
      child: CustomeWidget.AddNewButtonFillOut(
          GlobleString.Mant_DL_Vendor_AddVendor),
    );
  }

  void PickMultipleImage(AddMaintenanceState addMaintenanceState) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf', 'jpeg', 'heif', 'mp4'],
        allowMultiple: true);
    if (result != null) {
      _changeData();
      List<PlatformFile> files = result.files;

      List<FileObject> fileobjectlist1 = [];

      for (int i = 0; i < files.length; i++) {
        PlatformFile file = files[i];

        if ((file.name.split('.').last).contains("jpg") ||
            (file.name.split('.').last).contains("JPG") ||
            (file.name.split('.').last).contains("png") ||
            (file.name.split('.').last).contains("PNG") ||
            (file.name.split('.').last).contains("jpeg") ||
            (file.name.split('.').last).contains("JPEG") ||
            (file.name.split('.').last).contains("heif") ||
            (file.name.split('.').last).contains("HEIF") ||
            (file.name.split('.').last).contains("pdf") ||
            (file.name.split('.').last).contains("PDF") ||
            (file.name.split('.').last).contains("mp4") ||
            (file.name.split('.').last).contains("MP4")) {
          Helper.Log("file.size >>", file.size.toString());

          double size = 0;

          if ((file.name.split('.').last).contains("mp4")) {
            double size1 = file.size / 1024;
            size = size1 / 1024;
          }

          if ((file.name.split('.').last).contains("mp4") && size > 10) {
            ToastUtils.showCustomToast(
                context, "MP4 file maximum size 10 MB", false);
          } else {
            FileObject fileObject = new FileObject();
            fileObject.appImage = file.bytes;
            fileObject.filename = file.name;
            fileObject.islocal = true;
            fileObject.mediaId = null;
            fileObject.id = 0;
            fileobjectlist1.add(fileObject);

            if (files.length - 1 == i) {
              if (addMaintenanceState.fileobjectlist != null &&
                  addMaintenanceState.fileobjectlist.isNotEmpty)
                fileobjectlist1.addAll(addMaintenanceState.fileobjectlist);

              _store.dispatch(UpdateMAR_fileobjectlist(fileobjectlist1));
            }
          }
        } else {
          ToastUtils.showCustomToast(
              context, GlobleString.Mant_DL_Uploadfiles_error1, false);
          break;
        }
      }
    }

    final String id = '__file_picker_web-file-input';
    var element = html.document.getElementById(id);
    if (element != null) {
      element.remove();
    }
  }

  UpdateVendorAPI(
      AddMaintenanceState? addMaintenanceState, List<CityData>? selectedCity) {
    String city = "";

    for (int i = 0; i < selectedCity!.length; i++) {
      CityData cityData = selectedCity[i];

      if (city.isEmpty) {
        city = city + cityData.ID.toString();
      } else {
        city = city + "," + cityData.ID.toString();
      }
    }

    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().getCityWiseVendorList(context, city,
        (status, responce, errorlist) async {
      if (status) {
        loader.remove();
        _store.dispatch(UpdateMAR_mainvendordatalist(errorlist));
        List<SystemEnumDetails> categorylist =
            await Helper.removeDuplicates(errorlist);
        _store.dispatch(UpdateMAR_filterCategorylist(categorylist));

        Helper.Log(
            "getCityWiseVendorList categorylist", categorylist.toString());
      } else {
        loader.remove();
      }
    });
  }

  addNewVendorinValidation(AddMaintenanceState? addMaintenanceState) {
    if (addMaintenanceState!.vendordatalist.length > 0) {
      if (addMaintenanceState.selectedCountry == null) {
        ToastUtils.showCustomToast(
            context, GlobleString.ADM_error_Select_country, false);
      } else if (addMaintenanceState.selectedCountry == null) {
        ToastUtils.showCustomToast(
            context, GlobleString.ADM_error_Select_state, false);
      } else if (addMaintenanceState.selectedCity == null ||
          addMaintenanceState.selectedCity!.isEmpty) {
        ToastUtils.showCustomToast(
            context, GlobleString.ADM_error_Select_city, false);
      } else {
        bool isAdd = false;

        List checkdupvendor = [];

        for (int i = 0; i < addMaintenanceState.vendordatalist.length; i++) {
          AddVendorData vendor = addMaintenanceState.vendordatalist[i];

          if (vendor.selectfilterCategory == null) {
            isAdd = true;
            ToastUtils.showCustomToast(
                context, GlobleString.ADM_error_Avendor_category, false);
            break;
          } else if (vendor.selectvendor == null) {
            isAdd = true;
            ToastUtils.showCustomToast(
                context, GlobleString.ADM_error_Avendor_vendor, false);
            break;
          } else if (checkdupvendor.contains(vendor.selectvendor!.id)) {
            isAdd = true;
            ToastUtils.showCustomToast(
                context, GlobleString.ADM_error_Avendor_samevendor, false);
            break;
          } else {
            checkdupvendor.add(vendor.selectvendor!.id);

            if ((addMaintenanceState.vendordatalist.length - 1) == i &&
                !isAdd) {
              addVendorFunction(addMaintenanceState);

              break;
            }
          }
        }
      }
    } else {
      addVendorFunction(addMaintenanceState);
    }
  }

  addVendorFunction(AddMaintenanceState? addMaintenanceState) {
    _changeData();
    List<AddVendorData> vendordatalist = [];
    AddVendorData main = new AddVendorData();
    main.id = (addMaintenanceState!.vendordatalist.length + 1).toString();
    main.filtervendordatalist = [];
    main.selectfilterCategory = null;
    main.selectvendor = null;
    main.Instruction = "";

    if (addMaintenanceState.vendordatalist != null &&
        addMaintenanceState.vendordatalist.isNotEmpty) {
      addMaintenanceState.vendordatalist.add(main);
      _store.dispatch(
          UpdateMAR_vendordatalist(addMaintenanceState.vendordatalist));
    } else {
      vendordatalist.add(main);
      _store.dispatch(UpdateMAR_vendordatalist(vendordatalist));
    }
  }

  addVendorItemList(AddMaintenanceState? addMaintenanceState) {
    List<AddVendorData> vendordatalist = [];
    AddVendorData main = new AddVendorData();
    main.id = "1";
    main.filtervendordatalist = [];
    main.selectfilterCategory = null;
    main.selectvendor = null;
    main.Instruction = "";
    vendordatalist.add(main);
    _store.dispatch(UpdateMAR_vendordatalist(vendordatalist));

    isListLoad = true;
    setState(() {});

    new Timer(Duration(milliseconds: 5), () {
      isListLoad = false;
      setState(() {});
    });
  }

  delete_vendorItem(AddMaintenanceState addMaintenanceState, int index) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialogBox(
          title: GlobleString.Mant_DL_Vendor_Delete,
          positiveText: GlobleString.Mant_DL_Vendor_btn_yes,
          negativeText: GlobleString.Mant_DL_Vendor_btn_No,
          onPressedYes: () {
            Navigator.of(context1).pop();

            if (addMaintenanceState.vendordatalist != null &&
                addMaintenanceState.vendordatalist.isNotEmpty) {
              List<AddVendorData> mylist = addMaintenanceState.vendordatalist;
              mylist.removeAt(index);

              _store.dispatch(UpdateMAR_vendordatalist(mylist));
            }
          },
          onPressedNo: () {
            Navigator.of(context1).pop();
          },
        );
      },
    );
  }

  checkValidation(AddMaintenanceState addMaintenanceState) {
    if (addMaintenanceState.selectStatus == null) {
      ToastUtils.showCustomToast(
          context, GlobleString.ADM_error_Select_status, false);
    } else if (addMaintenanceState.selectproperty == null) {
      ToastUtils.showCustomToast(
          context, GlobleString.ADM_error_Select_property, false);
    } else if (addMaintenanceState.requestName == null ||
        addMaintenanceState.requestName.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.ADM_error_Select_requestname, false);
    } else if (addMaintenanceState.selectCategory == null) {
      ToastUtils.showCustomToast(
          context, GlobleString.ADM_error_Select_category, false);
    } else if (addMaintenanceState.priority == 0) {
      ToastUtils.showCustomToast(
          context, GlobleString.ADM_error_Select_priority, false);
    } else if (addMaintenanceState.description == null ||
        addMaintenanceState.description.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.ADM_error_Select_description, false);
    }
    /*else if (addMaintenanceState.fileobjectlist == null ||
        addMaintenanceState.fileobjectlist.length == 0) {
      ToastUtils.showCustomToast(
          context, GlobleString.ADM_error_Select_uploadfile, false);
    }*/
    else {
      if (addMaintenanceState.vendordatalist != null &&
          addMaintenanceState.vendordatalist.length > 0) {
        if (addMaintenanceState.selectedCountry == null) {
          ToastUtils.showCustomToast(
              context, GlobleString.ADM_error_Select_country, false);
        } else if (addMaintenanceState.selectedState == null) {
          ToastUtils.showCustomToast(
              context, GlobleString.ADM_error_Select_state, false);
        } else if (addMaintenanceState.selectedCity == null ||
            addMaintenanceState.selectedCity!.isEmpty) {
          ToastUtils.showCustomToast(
              context, GlobleString.ADM_error_Select_city, false);
        } else {
          bool isAdd = false;

          List checkdupvendor = [];

          for (int i = 0; i < addMaintenanceState.vendordatalist.length; i++) {
            AddVendorData vendor = addMaintenanceState.vendordatalist[i];

            if (vendor.selectfilterCategory == null) {
              isAdd = true;
              ToastUtils.showCustomToast(
                  context, GlobleString.ADM_error_Avendor_category, false);
              break;
            } else if (vendor.selectvendor == null) {
              isAdd = true;
              ToastUtils.showCustomToast(
                  context, GlobleString.ADM_error_Avendor_vendor, false);
              break;
            } else if (checkdupvendor.contains(vendor.selectvendor!.id)) {
              isAdd = true;
              ToastUtils.showCustomToast(
                  context, GlobleString.ADM_error_Avendor_samevendor, false);
              break;
            } else {
              checkdupvendor.add(vendor.selectvendor!.id);

              if ((addMaintenanceState.vendordatalist.length - 1) == i &&
                  !isAdd) {
                addMaintenaceApi(addMaintenanceState);
              }
            }
          }
        }
      } else {
        addMaintenaceApi(addMaintenanceState);
      }
    }
  }

  addMaintenaceApi(AddMaintenanceState addMaintenanceState) async {
    String? Applicant = null;
    String? Applicantion = null;

    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    await ApiManager().getPropertyWiseApplicantID(
        context, addMaintenanceState.selectproperty!.id.toString(),
        (status, responce, Applicant_Id, ApplicantionID) {
      if (status) {
        if (Applicant_Id != null && Applicant_Id.isNotEmpty) {
          Applicant = Applicant_Id;
        } else {
          Applicant = null;
        }

        if (ApplicantionID != null && ApplicantionID.isNotEmpty) {
          Applicantion = ApplicantionID;
        } else {
          Applicantion = null;
        }

        addMiantenanceAPiCall(addMaintenanceState, Applicant, Applicantion);
      }
    });
  }

  addMiantenanceAPiCall(AddMaintenanceState addMaintenanceState,
      String? Applicant, String? Applicantion) {
    AddMaintenanceQuery addmintenance = new AddMaintenanceQuery();
    addmintenance.Prop_ID = addMaintenanceState.selectproperty!.id;
    addmintenance.Category =
        addMaintenanceState.selectCategory!.EnumDetailID.toString();
    addmintenance.Status =
        addMaintenanceState.selectStatus!.EnumDetailID.toString();
    addmintenance.Priority = addMaintenanceState.priority.toString();
    addmintenance.Describe_Issue = addMaintenanceState.description.toString();
    addmintenance.IsLock = false;
    addmintenance.Date_Created =
        new DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
    addmintenance.Applicant_ID = Applicant;
    addmintenance.Type_User = "1";
    addmintenance.RequestName = addMaintenanceState.requestName;
    addmintenance.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    addmintenance.Country = "";
    addmintenance.State = "";
    addmintenance.City = "";

    if (addMaintenanceState.vendordatalist != null &&
        addMaintenanceState.vendordatalist.length > 0) {
      addmintenance.Country =
          addMaintenanceState.selectedCountry!.ID.toString();
      addmintenance.State = addMaintenanceState.selectedState!.ID.toString();

      String city = "";
      for (int i = 0; i < addMaintenanceState.selectedCity!.length; i++) {
        CityData cityData = addMaintenanceState.selectedCity![i];

        if (city.isEmpty) {
          city = cityData.ID.toString();
        } else {
          city = city + "," + cityData.ID.toString();
        }
      }

      addmintenance.City = city;
    }

    ApiManager().InsetNewRequest(context, addmintenance, (error, respoce) {
      if (error) {
        insertNotificationCall(
            addMaintenanceState, respoce, Applicant, Applicantion);
      } else {
        loader.remove();
        ToastUtils.showCustomToast(
            context, GlobleString.NL_error_insertcall, false);
      }
    });
  }

  insertNotificationCall(AddMaintenanceState addMaintenanceState, String mid,
      String? Applicant, String? Applicantion) {
    List<MaintenanceNotificationData> notificationlist = [];

    MaintenanceNotificationData mn = new MaintenanceNotificationData();
    mn.applicantName = "";
    mn.mid = mid.toString();
    mn.propid = addMaintenanceState.selectproperty!.id;
    mn.applicantId = Applicant != null ? Applicant : "";
    mn.applicationId = Applicantion != null ? Applicantion : "";
    mn.ownerId = Prefs.getString(PrefsName.OwnerID);
    mn.notificationDate =
        new DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();
    mn.typeOfNotification = NotificationType()
        .getNotificationType(NotificationName.Owner_Maintenance_Requests);
    mn.isRead = false;

    notificationlist.add(mn);

    if (Applicant != null) {
      MaintenanceNotificationData mn2 = new MaintenanceNotificationData();
      mn2.applicantName = "";
      mn2.mid = mid.toString();
      mn2.propid = addMaintenanceState.selectproperty!.id;
      mn2.applicantId = Applicant;
      mn2.applicationId = Applicantion;
      mn2.ownerId = Prefs.getString(PrefsName.OwnerID);
      mn2.notificationDate = new DateFormat("yyyy-MM-dd HH:mm:ss")
          .format(DateTime.now())
          .toString();
      mn2.typeOfNotification = NotificationType()
          .getNotificationType(NotificationName.Tenant_Maintenance_Requests);
      mn2.isRead = false;

      notificationlist.add(mn2);
    }

    ApiManager().AddMaintenaceNotification(context, notificationlist,
        (error, responce) async {
      if (error) {
        if (addMaintenanceState.fileobjectlist != null &&
            addMaintenanceState.fileobjectlist.length > 0) {
          insertImageCall(addMaintenanceState, mid);
        } else {
          if (addMaintenanceState.vendordatalist != null &&
              addMaintenanceState.vendordatalist.length > 0) {
            AddVendor(addMaintenanceState, mid);
          } else {
            loader.remove();
            ToastUtils.showCustomToast(
                context, GlobleString.maintenace_insert_successfully, true);
            widget._callbackSave();
          }
        }
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
  }

  insertImageCall(AddMaintenanceState addMaintenanceState, String mid) {
    ApiManager()
        .MaintenanceImagesUpload(context, addMaintenanceState.fileobjectlist,
            (status, listString, responce) {
      if (status) {
        if (listString.length > 0) {
          List<InsertMaintenanceImage> imagelist = <InsertMaintenanceImage>[];

          for (int i = 0; i < listString.length; i++) {
            imagelist.add(new InsertMaintenanceImage(
              Media_ID: listString[i],
              MaintenanceID: mid.toString(),
            ));
          }

          ApiManager().InsetMaintenanceImages(context, imagelist,
              (status, responce) async {
            if (status) {
              if (addMaintenanceState.vendordatalist != null &&
                  addMaintenanceState.vendordatalist.length > 0) {
                AddVendor(addMaintenanceState, mid);
              } else {
                loader.remove();
                ToastUtils.showCustomToast(
                    context, GlobleString.maintenace_insert_successfully, true);
                widget._callbackSave();
              }
            } else {
              loader.remove();
              ToastUtils.showCustomToast(context, responce, false);
            }
          });
        }
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
  }

  void AddVendor(AddMaintenanceState addMaintenanceState, String mid) {
    List<AssigneVendor> assignevendorlist = [];

    for (int i = 0; i < addMaintenanceState.vendordatalist.length; i++) {
      AddVendorData avd = addMaintenanceState.vendordatalist[i];

      AssigneVendor assigneVendor = new AssigneVendor();
      assigneVendor.MaintenanceID = mid;
      assigneVendor.VendorID = avd.selectvendor!.id.toString();
      assigneVendor.Instruction = avd.Instruction;

      assignevendorlist.add(assigneVendor);
    }

    ApiManager().InsetAssigneVendorRequest(context, assignevendorlist, null,
        (error, respoce) {
      if (error) {
        loader.remove();
        ToastUtils.showCustomToast(
            context, GlobleString.maintenace_insert_successfully, true);
        widget._callbackSave();
      } else {
        loader.remove();
        ToastUtils.showCustomToast(
            context, GlobleString.NL_error_insertcall, false);
      }
    });
  }
}
