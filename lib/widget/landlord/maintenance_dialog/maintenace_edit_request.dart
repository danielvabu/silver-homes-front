import 'dart:async';
import 'dart:html' as html;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/notification_type.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/maintenance_action/edit_maintenance_action.dart';
import 'package:silverhome/domain/entities/basic_tenant/addvendordata.dart';
import 'package:silverhome/domain/entities/citydata.dart';
import 'package:silverhome/domain/entities/countrydata.dart';
import 'package:silverhome/domain/entities/fileobject.dart';
import 'package:silverhome/domain/entities/log_activity.dart';
import 'package:silverhome/domain/entities/maintenace_notification.dart';
import 'package:silverhome/domain/entities/property_drop_data.dart';
import 'package:silverhome/domain/entities/statedata.dart';
import 'package:silverhome/presentation/models/maintenance/edit_maintenance_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

import '../../alert_dialogbox.dart';
import 'edit_assigne_vendor_item_widget.dart';

class MaintenanceEditRequestDialogBox extends StatefulWidget {
  final VoidCallback _callbackSave;
  final VoidCallback _callbackClose;
  static bool changeData = false;

  MaintenanceEditRequestDialogBox({
    required VoidCallback onPressedSave,
    required VoidCallback onPressedClose,
  })  : _callbackSave = onPressedSave,
        _callbackClose = onPressedClose;

  @override
  _MaintenanceEditRequestDialogBoxState createState() =>
      _MaintenanceEditRequestDialogBoxState();
}

class _MaintenanceEditRequestDialogBoxState
    extends State<MaintenanceEditRequestDialogBox> {
  late OverlayEntry loader;
  final _store = getIt<AppStore>();

  final _textlog = TextEditingController();
  bool isListLoad = false;

  bool isfirstload = true;
  int oldStatusid = 0;
  int oldPriority = 0;
  String oldPropid = "";
  bool change = false;

  @override
  void initState() {
    apimanager();
    MaintenanceEditRequestDialogBox.changeData = false;
    super.initState();
  }

  _changeData() {
    if (!change) {
      MaintenanceEditRequestDialogBox.changeData = true;
      change = true;
    }
  }

  void apimanager() async {
    await Prefs.init();

    /* if (_store.state!.editMaintenanceState != null) {
      if (_store.state!.editMaintenanceState.selectStatus != null) {
        oldStatusid =
            _store.state!.editMaintenanceState.selectStatus!.EnumDetailID;
      }

      if (_store.state!.editMaintenanceState.priority != null) {
        oldPriority = _store.state!.editMaintenanceState.priority;
      }

      if (_store.state!.editMaintenanceState.selectproperty != null) {
        oldPropid = _store.state!.editMaintenanceState.selectproperty!.id.toString();
      }
    }*/
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
                minWidth: 900, maxWidth: 900, minHeight: 600, maxHeight: 600),
            child: Container(
              height: 600,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                color: Colors.white,
              ),
              child: ConnectState<EditMaintenanceState>(
                  map: (state) => state.editMaintenanceState,
                  where: notIdentical,
                  builder: (editMaintenanceState) {
                    return Row(
                      children: [
                        if (isfirstload) updateOldVal(editMaintenanceState!),
                        _addNewRequest(editMaintenanceState!),
                        SizedBox(
                          width: 1,
                          child: Container(
                            color: myColor.fnl_status_date,
                          ),
                        ),
                        _logActivity(editMaintenanceState),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Widget updateOldVal(EditMaintenanceState editMaintenanceState) {
    oldStatusid = editMaintenanceState.selectStatus!.EnumDetailID;
    oldPriority = editMaintenanceState.priority;
    oldPropid = editMaintenanceState.selectproperty!.id.toString();

    isfirstload = false;

    return SizedBox();
  }

  Widget _addNewRequest(EditMaintenanceState editMaintenanceState) {
    return Expanded(
      flex: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 535,
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
                                  items: editMaintenanceState
                                      .MaintenanceStatuslist,
                                  textstyle: MyStyles.Medium(12, myColor.black),
                                  itemAsString: (SystemEnumDetails? u) =>
                                      u!.displayValue,
                                  hint: GlobleString.Select_Status,
                                  showSearchBox: false,
                                  defultHeight: editMaintenanceState
                                                  .MaintenanceStatuslist
                                                  .length *
                                              35 >
                                          250
                                      ? 250
                                      : editMaintenanceState
                                              .MaintenanceStatuslist.length *
                                          35,
                                  selectedItem:
                                      editMaintenanceState.selectStatus,
                                  isFilteredOnline: true,
                                  onChanged: (value) {
                                    _store.dispatch(
                                        UpdateMER_selectStatus(value));
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
                    _requestInfo(editMaintenanceState),
                    SizedBox(
                      height: 25,
                    ),
                    if (editMaintenanceState.vendordatalist.length > 0)
                      _vendorInformation(editMaintenanceState),
                    _addNewVendor(editMaintenanceState)
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
                    if (!MaintenanceEditRequestDialogBox.changeData) {
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
                            checkValidation(editMaintenanceState);
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
                    checkValidation(editMaintenanceState);
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

  Widget _requestInfo(EditMaintenanceState editMaintenanceState) {
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
                  items: editMaintenanceState.PropertyDropDatalist,
                  textstyle: MyStyles.Medium(12, myColor.black),
                  itemAsString: (PropertyDropData? u) => u!.propertyName!,
                  hint: GlobleString.Select_Property,
                  showSearchBox: true,
                  defultHeight:
                      editMaintenanceState.PropertyDropDatalist.length * 35 >
                              300
                          ? 300
                          : (editMaintenanceState.PropertyDropDatalist.length *
                                  35) +
                              50,
                  showClearButton: false,
                  selectedItem: editMaintenanceState.selectproperty,
                  focuscolor: myColor.blue,
                  focusWidth: 2,
                  isFilteredOnline: true,
                  onChanged: (value) {
                    _store.dispatch(UpdateMER_selectproperty(value));
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
                    initialValue: editMaintenanceState.requestName,
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
                      _store.dispatch(UpdateMER_requestName(value));
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
                      items: editMaintenanceState.MaintenanceCategorylist,
                      textstyle: MyStyles.Medium(12, myColor.black),
                      itemAsString: (SystemEnumDetails? u) => u!.displayValue,
                      hint: GlobleString.Select_Category,
                      showSearchBox: false,
                      selectedItem: editMaintenanceState.selectCategory,
                      isFilteredOnline: true,
                      defultHeight:
                          editMaintenanceState.MaintenanceCategorylist.length *
                                      35 >
                                  250
                              ? 250
                              : editMaintenanceState
                                      .MaintenanceCategorylist.length *
                                  35,
                      focuscolor: myColor.blue,
                      focusWidth: 2,
                      onChanged: (value) {
                        _store.dispatch(UpdateMER_selectCategory(value));
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
                            _store.dispatch(UpdateMER_priority(1));
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
                              color: editMaintenanceState.priority == 1
                                  ? myColor.TA_tab_text
                                  : myColor.white,
                            ),
                            child: Text(
                              GlobleString.Mant_DL_Low,
                              style: MyStyles.Medium(
                                  12,
                                  editMaintenanceState.priority == 1
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
                            _store.dispatch(UpdateMER_priority(2));
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
                              color: editMaintenanceState.priority == 2
                                  ? myColor.TA_tab_text
                                  : myColor.white,
                            ),
                            child: Text(
                              GlobleString.Mant_DL_Medium,
                              style: MyStyles.Medium(
                                  12,
                                  editMaintenanceState.priority == 2
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
                            _store.dispatch(UpdateMER_priority(3));
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
                              color: editMaintenanceState.priority == 3
                                  ? myColor.TA_tab_text
                                  : myColor.white,
                            ),
                            child: Text(
                              GlobleString.Mant_DL_High,
                              style: MyStyles.Medium(
                                  12,
                                  editMaintenanceState.priority == 3
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
          initialValue: editMaintenanceState.description,
          textAlign: TextAlign.start,
          style: MyStyles.Medium(12, myColor.text_color),
          maxLines: 4,
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
            _store.dispatch(UpdateMER_description(value));
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
          itemCount: editMaintenanceState.fileobjectlist.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            FileObject fileObject = editMaintenanceState.fileobjectlist[index];
            return Container(
              width: 500,
              height: 30,
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  fileObject.islocal!
                      ? Container(
                          width: 400,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            fileObject.filename != null &&
                                    fileObject.filename!.isNotEmpty
                                ? fileObject.filename!
                                : "",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: MyStyles.Medium(12, myColor.black),
                          ),
                        )
                      : Container(
                          width: 400,
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            onTap: () async {
                              if (fileObject.mediaId != null &&
                                  fileObject.mediaId!.url != null &&
                                  fileObject.mediaId!.url!.isNotEmpty) {
                                await Helper.launchURL(
                                    fileObject.mediaId!.url!);
                              }
                            },
                            child: Text(
                              fileObject.mediaId != null
                                  ? Helper.FileName(fileObject.mediaId!.url!)
                                  : "",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: MyStyles.Medium(12, myColor.blue),
                            ),
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
                      if (editMaintenanceState.fileobjectlist != null &&
                          editMaintenanceState.fileobjectlist.isNotEmpty) {
                        deleteImage(editMaintenanceState, index);
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
            PickMultipleImage(editMaintenanceState);
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

  deleteImage(EditMaintenanceState editMaintenanceState, int index) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialogBox(
          title: GlobleString.maintenance_Delete_image_title,
          negativeText: GlobleString.maintenance_Delete_image_NO,
          positiveText: GlobleString.maintenance_Delete_image_yes,
          onPressedYes: () {
            Navigator.of(context1).pop();
            _changeData();
            FileObject fileObject = editMaintenanceState.fileobjectlist[index];

            if (fileObject.islocal!) {
              List<FileObject> mylist = editMaintenanceState.fileobjectlist;
              mylist.removeAt(index);
              ToastUtils.showCustomToast(
                  context, GlobleString.File_deleted, true);
              _store.dispatch(UpdateMER_fileobjectlist(mylist));
            } else {
              CommonID commonID = new CommonID(ID: fileObject.id.toString());

              ApiManager().deleteMaintenanceImage(context, commonID,
                  (error, respoce) async {
                if (error) {
                  List<FileObject> mylist = editMaintenanceState.fileobjectlist;
                  mylist.removeAt(index);
                  ToastUtils.showCustomToast(
                      context, GlobleString.File_deleted, true);
                  _store.dispatch(UpdateMER_fileobjectlist(mylist));
                } else {
                  ToastUtils.showCustomToast(context, respoce, false);
                  Helper.Log("respoce", respoce);
                }
              });
            }
          },
          onPressedNo: () {
            Navigator.of(context1).pop();
          },
        );
      },
    );
  }

  void PickMultipleImage(EditMaintenanceState editMaintenanceState) async {
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
              if (editMaintenanceState.fileobjectlist != null &&
                  editMaintenanceState.fileobjectlist.isNotEmpty)
                fileobjectlist1.addAll(editMaintenanceState.fileobjectlist);

              _store.dispatch(UpdateMER_fileobjectlist(fileobjectlist1));
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

  Widget _vendorInformation(EditMaintenanceState editMaintenanceState) {
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
                      items: editMaintenanceState.countrydatalist,
                      textstyle: MyStyles.Medium(12, myColor.black),
                      itemAsString: (CountryData? u) => u!.CountryName!,
                      hint: GlobleString.Select_Country,
                      showSearchBox: false,
                      defultHeight:
                          editMaintenanceState.countrydatalist.length * 35 > 250
                              ? 250
                              : editMaintenanceState.countrydatalist.length *
                                  35,
                      selectedItem: editMaintenanceState.selectedCountry,
                      isFilteredOnline: true,
                      focuscolor: myColor.blue,
                      focusWidth: 2,
                      onChanged: (value) {
                        _changeData();
                        _store.dispatch(UpdateMER_selectedCountry(value));

                        _store.dispatch(UpdateMER_statedatalist([]));
                        _store.dispatch(UpdateMER_citydatalist([]));
                        _store.dispatch(UpdateMER_selectedCity([]));
                        _store.dispatch(UpdateMER_vendordatalist([]));
                        _store.dispatch(UpdateMER_selectedState(null));

                        addVendorItemList(editMaintenanceState);

                        loader = Helper.overlayLoader(context);
                        Overlay.of(context)!.insert(loader);

                        ApiManager().getStateList(context, value!.ID.toString(),
                            (status, responce, errorlist) {
                          if (status) {
                            loader.remove();
                            _store.dispatch(UpdateMER_statedatalist(errorlist));
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
                      items: editMaintenanceState.statedatalist,
                      textstyle: MyStyles.Medium(12, myColor.black),
                      itemAsString: (StateData? u) => u!.StateName!,
                      hint: GlobleString.Select_State,
                      showSearchBox: false,
                      selectedItem: editMaintenanceState.selectedState != null
                          ? editMaintenanceState.selectedState
                          : null,
                      defultHeight:
                          editMaintenanceState.statedatalist.length * 35 > 250
                              ? 250
                              : editMaintenanceState.statedatalist.length * 35,
                      isFilteredOnline: true,
                      focuscolor: myColor.blue,
                      focusWidth: 2,
                      onChanged: (value) {
                        _changeData();
                        _store.dispatch(UpdateMER_selectedState(value));

                        _store.dispatch(UpdateMER_citydatalist([]));
                        _store.dispatch(UpdateMER_selectedCity([]));
                        _store.dispatch(UpdateMER_vendordatalist([]));

                        addVendorItemList(editMaintenanceState);

                        loader = Helper.overlayLoader(context);
                        Overlay.of(context)!.insert(loader);

                        ApiManager().getCityList(context, value!.ID.toString(),
                            (status, responce, errorlist) {
                          if (status) {
                            loader.remove();
                            _store.dispatch(UpdateMER_citydatalist(errorlist));
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
            selectedItems: editMaintenanceState.selectedCity != null
                ? editMaintenanceState.selectedCity!
                : [],
            items: editMaintenanceState.citydatalist,
            defultHeight: editMaintenanceState.citydatalist.length == 0
                ? 100
                : editMaintenanceState.citydatalist.length * 35 > 250
                    ? 250
                    : editMaintenanceState.citydatalist.length * 35,
            focuscolor: myColor.blue,
            focusWidth: 2,
            hint: GlobleString.Select_City,
            showSearchBox: false,
            isFilteredOnline: true,
            onChange: (value) {
              _changeData();
              _store.dispatch(UpdateMER_mainvendordatalist([]));
              _store.dispatch(UpdateMER_filterCategorylist([]));
              _store.dispatch(UpdateMER_vendordatalist([]));
              addVendorItemList(editMaintenanceState);

              if (value != null && value.isNotEmpty) {
                _store.dispatch(UpdateMER_selectedCity(value));
                UpdateVendorAPI(editMaintenanceState, value);
              } else {
                _store.dispatch(UpdateMER_selectedCity([]));
              }
            },
            onRemove: (value) {
              _changeData();
              editMaintenanceState.selectedCity!.remove(value);

              _store.dispatch(UpdateMER_mainvendordatalist([]));
              _store.dispatch(UpdateMER_filterCategorylist([]));
              _store.dispatch(UpdateMER_vendordatalist([]));

              addVendorItemList(editMaintenanceState);

              if (editMaintenanceState.selectedCity != null &&
                  editMaintenanceState.selectedCity!.isNotEmpty) {
                _store.dispatch(
                    UpdateMER_selectedCity(editMaintenanceState.selectedCity));
                UpdateVendorAPI(
                    editMaintenanceState, editMaintenanceState.selectedCity);
              } else {
                _store.dispatch(UpdateMER_selectedCity([]));
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
                itemCount: editMaintenanceState.vendordatalist.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return EditAssigneVendorItemWidget(
                    count: (index + 1),
                    dmodel1: editMaintenanceState.vendordatalist[index],
                    pos: index,
                    onPressedDelete: (pos) {
                      delete_vendorItem(editMaintenanceState, index);
                    },
                    editMaintenanceState: editMaintenanceState,
                  );
                },
              )
            : Container(
                child: EditAssigneVendorItemWidget(
                  count: 1,
                  dmodel1: new AddVendorData(
                      filtervendordatalist: [],
                      id: "1",
                      Instruction: "",
                      selectvendor: null,
                      selectfilterCategory: null),
                  pos: 1,
                  onPressedDelete: (pos) {},
                  editMaintenanceState: editMaintenanceState,
                ),
              ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  UpdateVendorAPI(
      EditMaintenanceState editMaintenanceState, List<CityData>? selectedCity) {
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
        _store.dispatch(UpdateMER_mainvendordatalist(errorlist));
        List<SystemEnumDetails> categorylist =
            await Helper.removeDuplicates(errorlist);
        _store.dispatch(UpdateMER_filterCategorylist(categorylist));

        Helper.Log(
            "getCityWiseVendorList categorylist", categorylist.toString());
      } else {
        loader.remove();
      }
    });
  }

  Widget _addNewVendor(EditMaintenanceState editMaintenanceState) {
    return InkWell(
      onTap: () async {
        addNewVendorinValidation(editMaintenanceState);
      },
      child: CustomeWidget.AddNewButtonFillOut(
          GlobleString.Mant_DL_Vendor_AddVendor),
    );
  }

  addVendorItemList(EditMaintenanceState editMaintenanceState) {
    List<AddVendorData> vendordatalist = [];
    AddVendorData main = new AddVendorData();
    main.id = "1";
    main.filtervendordatalist = [];
    main.selectfilterCategory = null;
    main.selectvendor = null;
    main.Instruction = "";
    vendordatalist.add(main);
    _store.dispatch(UpdateMER_vendordatalist(vendordatalist));

    isListLoad = true;
    setState(() {});

    new Timer(Duration(milliseconds: 5), () {
      isListLoad = false;
      setState(() {});
    });
  }

  addNewVendorinValidation(EditMaintenanceState? editMaintenanceState) {
    if (editMaintenanceState!.vendordatalist.length > 0) {
      if (editMaintenanceState.selectedCountry == null) {
        ToastUtils.showCustomToast(
            context, GlobleString.ADM_error_Select_country, false);
      } else if (editMaintenanceState.selectedCountry == null) {
        ToastUtils.showCustomToast(
            context, GlobleString.ADM_error_Select_state, false);
      } else if (editMaintenanceState.selectedCity == null ||
          editMaintenanceState.selectedCity!.isEmpty) {
        ToastUtils.showCustomToast(
            context, GlobleString.ADM_error_Select_city, false);
      } else {
        bool isAdd = false;

        List checkdupvendor = [];

        for (int i = 0; i < editMaintenanceState.vendordatalist.length; i++) {
          AddVendorData vendor = editMaintenanceState.vendordatalist[i];

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

            if ((editMaintenanceState.vendordatalist.length - 1) == i &&
                !isAdd) {
              addVendorFunction(editMaintenanceState);

              break;
            }
          }
        }
      }
    } else {
      addVendorFunction(editMaintenanceState);
    }
  }

  addVendorFunction(EditMaintenanceState? editMaintenanceState) {
    _changeData();
    List<AddVendorData> vendordatalist = [];
    AddVendorData main = new AddVendorData();
    main.id = (editMaintenanceState!.vendordatalist.length + 1).toString();
    main.filtervendordatalist = [];
    main.selectfilterCategory = null;
    main.selectvendor = null;
    main.Instruction = "";

    if (editMaintenanceState.vendordatalist != null &&
        editMaintenanceState.vendordatalist.isNotEmpty) {
      editMaintenanceState.vendordatalist.add(main);
      _store.dispatch(
          UpdateMER_vendordatalist(editMaintenanceState.vendordatalist));
    } else {
      vendordatalist.add(main);
      _store.dispatch(UpdateMER_vendordatalist(vendordatalist));
    }
  }

  delete_vendorItem(EditMaintenanceState editMaintenanceState, int index) {
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
            _changeData();
            if (editMaintenanceState.vendordatalist != null &&
                editMaintenanceState.vendordatalist.isNotEmpty) {
              List<AddVendorData> mylist = editMaintenanceState.vendordatalist;
              mylist.removeAt(index);

              _store.dispatch(UpdateMER_vendordatalist(mylist));
            }
          },
          onPressedNo: () {
            Navigator.of(context1).pop();
          },
        );
      },
    );
  }

  Widget _logActivity(EditMaintenanceState editMaintenanceState) {
    return Container(
      width: 250,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: InkWell(
                  onTap: () {
                    if (!MaintenanceEditRequestDialogBox.changeData) {
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
                            checkValidation(editMaintenanceState);
                          },
                          onPressedNo: () {
                            Navigator.of(context1).pop();
                            widget._callbackClose();
                          },
                        );
                      },
                    );
                  },
                  child: Icon(Icons.clear, size: 25),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                Container(
                  height: 388,
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: ListView.builder(
                    itemCount: editMaintenanceState.logActivitylist.length,
                    itemBuilder: (context, index) {
                      LogActivity logactivity =
                          editMaintenanceState.logActivitylist[index];
                      return Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: myColor.log_activity_bg, width: 1.0),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                            color: myColor.log_activity_bg,
                          ),
                          padding: EdgeInsets.all(5),
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 5, top: 10, bottom: 5, right: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              logactivity.LogText!,
                                              textAlign: TextAlign.start,
                                              style: MyStyles.Medium(
                                                  12, myColor.Circle_main),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      logactivity.Date_Created != null &&
                                              logactivity.Date_Created != "0" &&
                                              logactivity.Date_Created != ""
                                          ? new DateFormat("dd-MMM-yyyy")
                                              .format(DateTime.parse(
                                                  logactivity.Date_Created!))
                                              .toString()
                                          : "",
                                      textAlign: TextAlign.start,
                                      style: MyStyles.Regular(
                                          10, myColor.Circle_main),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: InkWell(
                                    onTap: () {
                                      deleteLogActivityDialog(
                                          editMaintenanceState,
                                          logactivity,
                                          index);
                                    },
                                    child: FaIcon(
                                      FontAwesomeIcons.trashAlt,
                                      color: myColor.black,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5, left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        GlobleString.Mant_DL_Logactivities,
                        style: MyStyles.Medium(14, myColor.black),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _textlog,
                        textAlign: TextAlign.start,
                        style: MyStyles.Medium(14, myColor.text_color),
                        maxLines: 4,
                        decoration: InputDecoration(
                            //border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: myColor.blue, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: myColor.gray, width: 1.0),
                            ),
                            isDense: true,
                            /* hintText: GlobleString
                                        .Mant_DL_hint_Describetheissue,
                                    hintStyle:
                                        MyStyles.Regular(12, myColor.hint),*/
                            contentPadding: EdgeInsets.all(10),
                            fillColor: myColor.white,
                            filled: true),
                        onChanged: (value) {},
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              if (_textlog.text != null &&
                                  _textlog.text.isNotEmpty)
                                addLogActivity(editMaintenanceState);
                              else
                                ToastUtils.showCustomToast(context,
                                    GlobleString.LogActivity_enter, false);
                            },
                            child: Container(
                              height: 30,
                              width: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: myColor.Circle_main,
                              ),
                              child: Text(
                                GlobleString.Mant_DL_Submit,
                                style: MyStyles.Medium(12, myColor.white),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  checkValidation(EditMaintenanceState editMaintenanceState) {
    if (editMaintenanceState.selectStatus == null) {
      ToastUtils.showCustomToast(
          context, GlobleString.ADM_error_Select_status, false);
    } else if (editMaintenanceState.selectproperty == null) {
      ToastUtils.showCustomToast(
          context, GlobleString.ADM_error_Select_property, false);
    } else if (editMaintenanceState.requestName == null ||
        editMaintenanceState.requestName.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.ADM_error_Select_requestname, false);
    } else if (editMaintenanceState.selectCategory == null) {
      ToastUtils.showCustomToast(
          context, GlobleString.ADM_error_Select_category, false);
    } else if (editMaintenanceState.priority == 0) {
      ToastUtils.showCustomToast(
          context, GlobleString.ADM_error_Select_priority, false);
    } else if (editMaintenanceState.description == null ||
        editMaintenanceState.description.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.ADM_error_Select_description, false);
    }
    /*else if (editMaintenanceState.fileobjectlist == null ||
        editMaintenanceState.fileobjectlist.length == 0) {
      ToastUtils.showCustomToast(
          context, GlobleString.ADM_error_Select_uploadfile, false);
    } */
    else {
      if (editMaintenanceState.vendordatalist != null &&
          editMaintenanceState.vendordatalist.length > 0) {
        if (editMaintenanceState.selectedCountry == null) {
          ToastUtils.showCustomToast(
              context, GlobleString.ADM_error_Select_country, false);
        } else if (editMaintenanceState.selectedState == null) {
          ToastUtils.showCustomToast(
              context, GlobleString.ADM_error_Select_state, false);
        } else if (editMaintenanceState.selectedCity == null ||
            editMaintenanceState.selectedCity!.isEmpty) {
          ToastUtils.showCustomToast(
              context, GlobleString.ADM_error_Select_city, false);
        } else {
          bool isAdd = false;

          List checkdupvendor = [];

          for (int i = 0; i < editMaintenanceState.vendordatalist.length; i++) {
            AddVendorData vendor = editMaintenanceState.vendordatalist[i];

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

              if ((editMaintenanceState.vendordatalist.length - 1) == i &&
                  !isAdd) {
                updateMaintenaceApi(editMaintenanceState);
              }
            }
          }
        }
      } else {
        updateMaintenaceApi(editMaintenanceState);
      }
    }
  }

  updateMaintenaceApi(EditMaintenanceState editMaintenanceState) async {
    String? Applicant = null;
    String? Applicantion = null;

    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    await ApiManager().getPropertyWiseApplicantID(
        context, editMaintenanceState.selectproperty!.id.toString(),
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

        updateMaintenaceApiCall(editMaintenanceState, Applicant, Applicantion);
      }
    });
  }

  updateMaintenaceApiCall(EditMaintenanceState editMaintenanceState,
      String? Applicant, String? Applicantion) {
    UpdateMaintenanceQuery addmintenance = new UpdateMaintenanceQuery();
    addmintenance.Prop_ID = editMaintenanceState.selectproperty!.id;
    addmintenance.Category =
        editMaintenanceState.selectCategory!.EnumDetailID.toString();
    addmintenance.Status =
        editMaintenanceState.selectStatus!.EnumDetailID.toString();
    addmintenance.Priority = editMaintenanceState.priority.toString();
    addmintenance.Describe_Issue = editMaintenanceState.description.toString();
    addmintenance.IsLock = editMaintenanceState.IsLock;
    addmintenance.Applicant_ID = Applicant;
    addmintenance.Type_User = editMaintenanceState.Type_User.toString();
    addmintenance.RequestName = editMaintenanceState.requestName;
    addmintenance.Owner_ID = Prefs.getString(PrefsName.OwnerID);

    if (editMaintenanceState.vendordatalist != null &&
        editMaintenanceState.vendordatalist.length > 0) {
      addmintenance.Country =
          editMaintenanceState.selectedCountry!.ID.toString();
      addmintenance.State = editMaintenanceState.selectedState!.ID.toString();

      String city = "";
      for (int i = 0; i < editMaintenanceState.selectedCity!.length; i++) {
        CityData cityData = editMaintenanceState.selectedCity![i];

        if (city.isEmpty) {
          city = cityData.ID.toString();
        } else {
          city = city + "," + cityData.ID.toString();
        }
      }

      addmintenance.City = city;
    } else {
      addmintenance.Country = "";
      addmintenance.State = "";
      addmintenance.City = "";
    }

    PropertyUpdate Update = new PropertyUpdate();
    Update.ID = editMaintenanceState.mid.toString();
    Update.Owner_ID = Prefs.getString(PrefsName.OwnerID);

    ApiManager().UpdateMaintenanceRequest(context, Update, addmintenance,
        (error, respoce) {
      if (error) {
        if (oldStatusid == editMaintenanceState.selectStatus!.EnumDetailID &&
            oldPriority == editMaintenanceState.priority &&
            oldPropid == editMaintenanceState.selectproperty!.id) {
          ImageVendorUpdate(editMaintenanceState);
        } else {
          insertNotification_Priority_Status(
              editMaintenanceState, Applicant, Applicantion);
        }
      } else {
        loader.remove();
        ToastUtils.showCustomToast(
            context, GlobleString.NL_error_insertcall, false);
      }
    });
  }

  insertNotification_Priority_Status(EditMaintenanceState editMaintenanceState,
      String? Applicant, String? Applicantion) {
    List<MaintenanceNotificationData> notificationlist = [];

    if (oldStatusid != editMaintenanceState.selectStatus!.EnumDetailID) {
      MaintenanceNotificationData mn = new MaintenanceNotificationData();
      mn.applicantName = "";
      mn.mid = editMaintenanceState.mid;
      mn.propid = editMaintenanceState.selectproperty!.id;
      mn.applicantId = Applicant != null ? Applicant : "";
      mn.applicationId = Applicantion != null ? Applicantion : "";
      mn.ownerId = Prefs.getString(PrefsName.OwnerID);
      mn.notificationDate = new DateFormat("yyyy-MM-dd HH:mm:ss")
          .format(DateTime.now())
          .toString();
      mn.typeOfNotification = NotificationType().getNotificationType(
          NotificationName.Owner_Maintenance_Change_Status);
      mn.isRead = false;

      notificationlist.add(mn);

      if (Applicant != null) {
        MaintenanceNotificationData mn2 = new MaintenanceNotificationData();
        mn2.applicantName = "";
        mn2.mid = editMaintenanceState.mid;
        mn2.propid = editMaintenanceState.selectproperty!.id;
        mn2.applicantId = Applicant;
        mn2.applicationId = Applicantion;
        mn2.ownerId = Prefs.getString(PrefsName.OwnerID);
        mn2.notificationDate = new DateFormat("yyyy-MM-dd HH:mm:ss")
            .format(DateTime.now())
            .toString();
        mn2.typeOfNotification = NotificationType().getNotificationType(
            NotificationName.Tenant_Maintenance_Change_Status);
        mn2.isRead = false;

        notificationlist.add(mn2);
      }
    }

    if (oldPriority != editMaintenanceState.priority) {
      MaintenanceNotificationData mn3 = new MaintenanceNotificationData();
      mn3.applicantName = "";
      mn3.mid = editMaintenanceState.mid;
      mn3.propid = editMaintenanceState.selectproperty!.id;
      mn3.applicantId = Applicant != null ? Applicant : "";
      mn3.applicationId = Applicantion != null ? Applicantion : "";
      mn3.ownerId = Prefs.getString(PrefsName.OwnerID);
      mn3.notificationDate = new DateFormat("yyyy-MM-dd HH:mm:ss")
          .format(DateTime.now())
          .toString();
      mn3.typeOfNotification = NotificationType().getNotificationType(
          NotificationName.Owner_Maintenance_Change_Priority);
      mn3.isRead = false;

      notificationlist.add(mn3);

      if (Applicant != null) {
        MaintenanceNotificationData mn4 = new MaintenanceNotificationData();
        mn4.applicantName = "";
        mn4.mid = editMaintenanceState.mid;
        mn4.propid = editMaintenanceState.selectproperty!.id;
        mn4.applicantId = Applicant;
        mn4.applicationId = Applicantion;
        mn4.ownerId = Prefs.getString(PrefsName.OwnerID);
        mn4.notificationDate = new DateFormat("yyyy-MM-dd HH:mm:ss")
            .format(DateTime.now())
            .toString();
        mn4.typeOfNotification = NotificationType().getNotificationType(
            NotificationName.Tenant_Maintenance_Change_Priority);
        mn4.isRead = false;

        notificationlist.add(mn4);
      }
    }

    if (oldPropid != editMaintenanceState.selectproperty!.id) {
      MaintenanceNotificationData mn5 = new MaintenanceNotificationData();
      mn5.applicantName = "";
      mn5.mid = editMaintenanceState.mid;
      mn5.propid = editMaintenanceState.selectproperty!.id;
      mn5.applicantId = Applicant != null ? Applicant : "";
      mn5.applicationId = Applicantion != null ? Applicantion : "";
      mn5.ownerId = Prefs.getString(PrefsName.OwnerID);
      mn5.notificationDate = new DateFormat("yyyy-MM-dd HH:mm:ss")
          .format(DateTime.now())
          .toString();
      mn5.typeOfNotification = NotificationType()
          .getNotificationType(NotificationName.Owner_Maintenance_Requests);
      mn5.isRead = false;

      notificationlist.add(mn5);

      if (Applicant != null) {
        MaintenanceNotificationData mn6 = new MaintenanceNotificationData();
        mn6.applicantName = "";
        mn6.mid = editMaintenanceState.mid;
        mn6.propid = editMaintenanceState.selectproperty!.id;
        mn6.applicantId = Applicant;
        mn6.applicationId = Applicantion;
        mn6.ownerId = Prefs.getString(PrefsName.OwnerID);
        mn6.notificationDate = new DateFormat("yyyy-MM-dd HH:mm:ss")
            .format(DateTime.now())
            .toString();
        mn6.typeOfNotification = NotificationType()
            .getNotificationType(NotificationName.Tenant_Maintenance_Requests);
        mn6.isRead = false;

        notificationlist.add(mn6);
      }
    }

    if (notificationlist.length > 0) {
      insertNotificationCall(editMaintenanceState, notificationlist);
    } else {
      ImageVendorUpdate(editMaintenanceState);
    }
  }

  insertNotificationCall(EditMaintenanceState editMaintenanceState,
      List<MaintenanceNotificationData> notificationlist) {
    ApiManager().AddMaintenaceNotification(context, notificationlist,
        (error, responce) async {
      if (error) {
        ImageVendorUpdate(editMaintenanceState);
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
  }

  insertImageCall(EditMaintenanceState editMaintenanceState) {
    ApiManager()
        .MaintenanceImagesUpload(context, editMaintenanceState.fileobjectlist,
            (status, listString, responce) {
      if (status) {
        if (listString.length > 0) {
          List<InsertMaintenanceImage> imagelist = <InsertMaintenanceImage>[];

          for (int i = 0; i < listString.length; i++) {
            imagelist.add(new InsertMaintenanceImage(
              Media_ID: listString[i],
              MaintenanceID: editMaintenanceState.mid.toString(),
            ));
          }

          ApiManager().InsetMaintenanceImages(context, imagelist,
              (status, responce) async {
            if (status) {
              loader.remove();
              ToastUtils.showCustomToast(
                  context, GlobleString.maintenace_update_successfully, true);
              widget._callbackSave();
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

  ImageVendorUpdate(EditMaintenanceState editMaintenanceState) {
    if (editMaintenanceState.vendordatalist == null ||
        editMaintenanceState.vendordatalist.isEmpty) {
      DeleteVendor(editMaintenanceState);
    }

    if (editMaintenanceState.fileobjectlist != null &&
        editMaintenanceState.fileobjectlist.length > 0) {
      bool iscall = false;
      for (int i = 0; i < editMaintenanceState.fileobjectlist.length; i++) {
        FileObject file = editMaintenanceState.fileobjectlist[i];

        if (file.islocal!) {
          iscall = true;
        }

        if ((editMaintenanceState.fileobjectlist.length - 1 == i)) {
          if (iscall) {
            insertImageCall(editMaintenanceState);
          } else {
            if (editMaintenanceState.vendordatalist != null &&
                editMaintenanceState.vendordatalist.length > 0) {
              AddVendor(editMaintenanceState);
            } else {
              loader.remove();
              ToastUtils.showCustomToast(
                  context, GlobleString.maintenace_update_successfully, true);
              widget._callbackSave();
            }
          }
        }
      }
    } else {
      if (editMaintenanceState.vendordatalist != null &&
          editMaintenanceState.vendordatalist.length > 0) {
        AddVendor(editMaintenanceState);
      } else {
        loader.remove();
        ToastUtils.showCustomToast(
            context, GlobleString.maintenace_update_successfully, true);
        widget._callbackSave();
      }
    }
  }

  void DeleteVendor(EditMaintenanceState editMaintenanceState) {
    DeleteMaintenanceVendor MaintenanceID =
        new DeleteMaintenanceVendor(MaintenanceID: editMaintenanceState.mid);

    ApiManager().deleteMaintenanceVendor(context, MaintenanceID,
        (error, respoce) async {
      if (error) {
      } else {
        ToastUtils.showCustomToast(context, respoce, false);
        Helper.Log("respoce", respoce);
      }
    });
  }

  void AddVendor(EditMaintenanceState editMaintenanceState) {
    List<AssigneVendor> assignevendorlist = [];

    for (int i = 0; i < editMaintenanceState.vendordatalist.length; i++) {
      AddVendorData avd = editMaintenanceState.vendordatalist[i];

      AssigneVendor assigneVendor = new AssigneVendor();
      assigneVendor.MaintenanceID = editMaintenanceState.mid;
      assigneVendor.VendorID = avd.selectvendor!.id.toString();
      assigneVendor.Instruction = avd.Instruction;

      assignevendorlist.add(assigneVendor);
    }

    DeleteMaintenanceVendor MaintenanceID =
        new DeleteMaintenanceVendor(MaintenanceID: editMaintenanceState.mid);

    ApiManager().InsetAssigneVendorRequest(
        context, assignevendorlist, MaintenanceID, (error, respoce) {
      if (error) {
        loader.remove();
        ToastUtils.showCustomToast(
            context, GlobleString.maintenace_update_successfully, true);
        widget._callbackSave();
      } else {
        loader.remove();
        ToastUtils.showCustomToast(
            context, GlobleString.NL_error_insertcall, false);
      }
    });
  }

  void addLogActivity(EditMaintenanceState editMaintenanceState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    AddLogActivity addmintenance = new AddLogActivity();
    addmintenance.LogText = _textlog.text.trim();
    addmintenance.Maintenance_ID =
        editMaintenanceState.mid != null && editMaintenanceState.mid.isNotEmpty
            ? int.parse(editMaintenanceState.mid.toString())
            : 0;
    addmintenance.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    addmintenance.Date_Created =
        new DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();

    ApiManager().InsetLogActivity(context, addmintenance, (error, respoce) {
      if (error) {
        ApiManager()
            .getLogActivityList(context, editMaintenanceState.mid.toString(),
                (error, respoce) async {
          if (error) {
            loader.remove();
            _textlog.clear();
            setState(() {});
          } else {
            loader.remove();
            Helper.Log("respoce", respoce);
          }
        });
      } else {
        loader.remove();
        ToastUtils.showCustomToast(
            context, GlobleString.NL_error_insertcall, false);
      }
    });
  }

  deleteLogActivityDialog(EditMaintenanceState editMaintenanceState,
      LogActivity logactivity, int index) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialogBox(
          title: GlobleString.logactivity_Delete_title,
          negativeText: GlobleString.logactivity_Delete_NO,
          positiveText: GlobleString.logactivity_Delete_yes,
          onPressedYes: () {
            Navigator.of(context1).pop();

            deleteLogActivity(editMaintenanceState, logactivity, index);
          },
          onPressedNo: () {
            Navigator.of(context1).pop();
          },
        );
      },
    );
  }

  void deleteLogActivity(EditMaintenanceState editMaintenanceState,
      LogActivity logactivity, int index) {
    CommonID id = new CommonID(ID: logactivity.id.toString());

    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().deleteLogActivity(context, id, (error, respoce) async {
      if (error) {
        loader.remove();

        ToastUtils.showCustomToast(
            context, GlobleString.Activity_Log_deleted, true);

        List<LogActivity> activitylist = editMaintenanceState.logActivitylist;
        activitylist.removeAt(index);
        _store.dispatch(UpdateMER_logActivitylist(activitylist));
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
        Helper.Log("respoce", respoce);
      }
    });
  }
}
