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
import 'package:silverhome/domain/actions/basictenant_action/tenant_add_maintenance_action.dart';
import 'package:silverhome/domain/entities/fileobject.dart';
import 'package:silverhome/domain/entities/maintenace_notification.dart';
import 'package:silverhome/presentation/models/basic_tenant/tenant_add_maintenance_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

import '../alert/alert_dialogbox.dart';

class AddNewRequestDialogBox extends StatefulWidget {
  final VoidCallback _callbackSave;
  final VoidCallback _callbackClose;
  static bool changeData = false;

  AddNewRequestDialogBox({
    required VoidCallback onPressedSave,
    required VoidCallback onPressedClose,
  })  : _callbackSave = onPressedSave,
        _callbackClose = onPressedClose;

  @override
  _AddNewRequestDialogBoxState createState() => _AddNewRequestDialogBoxState();
}

class _AddNewRequestDialogBoxState extends State<AddNewRequestDialogBox> {
  late OverlayEntry loader;
  final _store = getIt<AppStore>();

  bool isfirstload = true;
  int oldPriority = 0;
  bool change = false;

  @override
  void initState() {
    apimanager();
    AddNewRequestDialogBox.changeData = false;
    super.initState();
  }

  _changeData() {
    if (!change) {
      change = true;
      AddNewRequestDialogBox.changeData = true;
    }
  }

  void apimanager() async {
    await Prefs.init();

    /* if (_store.state!.tenantAddMaintenanceState != null) {
      if (_store.state!.tenantAddMaintenanceState.priority != null) {
        oldPriority = _store.state!.tenantAddMaintenanceState.priority;
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
          padding: EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: 700, maxWidth: 700, minHeight: 560, maxHeight: 560),
            child: Container(
              width: 700,
              height: 560,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.white),
              child: ConnectState<TenantAddMaintenanceState>(
                map: (state) => state.tenantAddMaintenanceState,
                where: notIdentical,
                builder: (tntAddMtState) {
                  return Stack(
                    children: [
                      if (isfirstload) updateOldVal(tntAddMtState!),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                CloseDialog(tntAddMtState);
                              },
                              child: Icon(Icons.clear, size: 25),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 40, right: 20, bottom: 20, left: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          style: MyStyles.Medium(
                                              12, myColor.black),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          height: 30,
                                          width: 150,
                                          alignment: Alignment.centerLeft,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            border: Border.all(
                                                color: myColor.TA_Border,
                                                width: 1),
                                            color: myColor.white,
                                          ),
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            tntAddMtState!.selectStatus != null
                                                ? tntAddMtState
                                                    .selectStatus!.displayValue
                                                : "",
                                            style: MyStyles.Medium(
                                                12, myColor.disablecolor),
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
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border.all(
                                            color: myColor.TA_Border, width: 1),
                                        color: myColor.white,
                                      ),
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        Prefs.getString(PrefsName.BT_PropName) +
                                            " - " +
                                            Prefs.getString(
                                                PrefsName.BT_PropAddress),
                                        style: MyStyles.Medium(
                                            12, myColor.disablecolor),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          GlobleString.Mant_DL_Category,
                                          style: MyStyles.Medium(
                                              12, myColor.black),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          height: 30,
                                          // ignore: missing_required_param
                                          child:
                                              DropdownSearch<SystemEnumDetails>(
                                            mode: Mode.MENU,
                                            items: tntAddMtState
                                                .MaintenanceCategorylist,
                                            textstyle: MyStyles.Medium(
                                                12, myColor.black),
                                            itemAsString:
                                                (SystemEnumDetails? u) =>
                                                    u!.displayValue,
                                            hint: GlobleString.Select_Category,
                                            showSearchBox: false,
                                            selectedItem:
                                                tntAddMtState.selectCategory,
                                            defultHeight: tntAddMtState
                                                            .MaintenanceCategorylist
                                                            .length *
                                                        35 >
                                                    250
                                                ? 250
                                                : tntAddMtState
                                                        .MaintenanceCategorylist
                                                        .length *
                                                    35,
                                            isFilteredOnline: true,
                                            focuscolor: myColor.blue,
                                            focusWidth: 2,
                                            onChanged: (value) {
                                              _store.dispatch(
                                                  UpdateTMR_selectCategory(
                                                      value));
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          GlobleString.Mant_DL_Priority,
                                          style: MyStyles.Medium(
                                              12, myColor.black),
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
                                                  _store.dispatch(
                                                      UpdateTMR_priority(1));
                                                  _changeData();
                                                },
                                                child: Container(
                                                  height: 30,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    border: Border.all(
                                                        color:
                                                            myColor.TA_Border,
                                                        width: 1),
                                                    color: tntAddMtState
                                                                .priority ==
                                                            1
                                                        ? myColor.TA_tab_text
                                                        : myColor.white,
                                                  ),
                                                  child: Text(
                                                    GlobleString.Mant_DL_Low,
                                                    style: MyStyles.Medium(
                                                        12,
                                                        tntAddMtState
                                                                    .priority ==
                                                                1
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
                                                  _store.dispatch(
                                                      UpdateTMR_priority(2));
                                                  _changeData();
                                                },
                                                child: Container(
                                                  height: 30,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    border: Border.all(
                                                        color:
                                                            myColor.TA_Border,
                                                        width: 1),
                                                    color: tntAddMtState
                                                                .priority ==
                                                            2
                                                        ? myColor.TA_tab_text
                                                        : myColor.white,
                                                  ),
                                                  child: Text(
                                                    GlobleString.Mant_DL_Medium,
                                                    style: MyStyles.Medium(
                                                        12,
                                                        tntAddMtState
                                                                    .priority ==
                                                                2
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
                                                  _store.dispatch(
                                                      UpdateTMR_priority(3));
                                                  _changeData();
                                                },
                                                child: Container(
                                                  height: 30,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    border: Border.all(
                                                        color:
                                                            myColor.TA_Border,
                                                        width: 1),
                                                    color: tntAddMtState
                                                                .priority ==
                                                            3
                                                        ? myColor.TA_tab_text
                                                        : myColor.white,
                                                  ),
                                                  child: Text(
                                                    GlobleString.Mant_DL_High,
                                                    style: MyStyles.Medium(
                                                        12,
                                                        tntAddMtState
                                                                    .priority ==
                                                                3
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                              GlobleString.Mant_DL_RequestName,
                                              style: MyStyles.Medium(
                                                  12, myColor.black),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              GlobleString.Mant_DL_RequestName1,
                                              style: MyStyles.Medium(
                                                  12, myColor.optional),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          initialValue:
                                              tntAddMtState.requestName,
                                          textAlign: TextAlign.start,
                                          style: MyStyles.Medium(
                                              12, myColor.text_color),
                                          maxLines: 1,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                25),
                                          ],
                                          decoration: InputDecoration(
                                            //border: InputBorder.none,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: myColor.blue,
                                                  width: 2),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: myColor.gray,
                                                  width: 1.0),
                                            ),
                                            isDense: true,
                                            hintText: GlobleString
                                                .Mant_DL_hint_request,
                                            hintStyle: MyStyles.Regular(
                                                12, myColor.hint),
                                            contentPadding: EdgeInsets.all(10),
                                            fillColor: myColor.white,
                                            filled: true,
                                          ),
                                          onChanged: (value) {
                                            _store.dispatch(
                                                UpdateTMR_requestName(value));
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [],
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
                                initialValue: tntAddMtState.description,
                                textAlign: TextAlign.start,
                                style: MyStyles.Medium(12, myColor.text_color),
                                maxLines: 4,
                                maxLength: 10000,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10000)
                                ],
                                decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: myColor.blue, width: 2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: myColor.gray, width: 1.0),
                                    ),
                                    isDense: true,
                                    hintText: GlobleString
                                        .Mant_DL_hint_Describetheissue,
                                    hintStyle:
                                        MyStyles.Regular(12, myColor.hint),
                                    contentPadding: EdgeInsets.all(10),
                                    fillColor: myColor.white,
                                    filled: true),
                                onChanged: (value) {
                                  _store.dispatch(UpdateTMR_description(value));
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
                                    style:
                                        MyStyles.Medium(10, myColor.optional),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                itemCount: tntAddMtState.fileobjectlist.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  FileObject fileObject =
                                      tntAddMtState.fileobjectlist[index];
                                  return Container(
                                    width: 500,
                                    height: 30,
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        fileObject.islocal!
                                            ? Container(
                                                width: 400,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  fileObject.filename != null &&
                                                          fileObject.filename!
                                                              .isNotEmpty
                                                      ? fileObject.filename!
                                                      : "",
                                                  textAlign: TextAlign.start,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: MyStyles.Medium(
                                                      12, myColor.blue),
                                                ),
                                              )
                                            : Container(
                                                width: 400,
                                                alignment: Alignment.centerLeft,
                                                child: InkWell(
                                                  highlightColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    if (fileObject.mediaId !=
                                                            null &&
                                                        fileObject
                                                                .mediaId!.url !=
                                                            null &&
                                                        fileObject.mediaId!.url!
                                                            .isNotEmpty) {
                                                      await Helper.launchURL(
                                                          fileObject
                                                              .mediaId!.url!);
                                                    }
                                                  },
                                                  child: Text(
                                                    fileObject.mediaId != null
                                                        ? Helper.FileName(
                                                            fileObject
                                                                .mediaId!.url!)
                                                        : "",
                                                    textAlign: TextAlign.start,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: MyStyles.Medium(
                                                        12, myColor.blue),
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
                                            if (tntAddMtState.fileobjectlist !=
                                                    null &&
                                                tntAddMtState.fileobjectlist
                                                    .isNotEmpty) {
                                              deleteImage(tntAddMtState, index);
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
                                  PickMultipleImage(tntAddMtState);
                                },
                                child: Container(
                                  height: 30,
                                  width: 100,
                                  padding: EdgeInsets.only(left: 25, right: 25),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(
                                        color: myColor.Circle_main, width: 1),
                                    color: myColor.white,
                                  ),
                                  child: Text(
                                    GlobleString.Mant_DL_Upload,
                                    style: MyStyles.Medium(12, myColor.black),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      CloseDialog(tntAddMtState);
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 100,
                                      padding:
                                          EdgeInsets.only(left: 25, right: 25),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border.all(
                                            color: myColor.Circle_main,
                                            width: 1),
                                        color: myColor.white,
                                      ),
                                      child: Text(
                                        GlobleString.Mant_DL_Cancel,
                                        style: MyStyles.Medium(
                                            12, myColor.Circle_main),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      checkValidation(tntAddMtState);
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 100,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: myColor.Circle_main,
                                      ),
                                      child: Text(
                                        GlobleString.Mant_DL_Save,
                                        style:
                                            MyStyles.Medium(12, myColor.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
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

  Widget updateOldVal(TenantAddMaintenanceState? tntAddMtState) {
    oldPriority = tntAddMtState!.priority;
    isfirstload = false;

    return SizedBox();
  }

  CloseDialog(TenantAddMaintenanceState? tntAddMtState) {
    if (!AddNewRequestDialogBox.changeData) {
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
            checkValidation(tntAddMtState!);
          },
          onPressedNo: () {
            Navigator.of(context1).pop();
            widget._callbackClose();
          },
        );
      },
    );
  }

  void PickMultipleImage(TenantAddMaintenanceState tntAddMtState) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf', 'jpeg', 'heif', 'mp4'],
        allowMultiple: true);
    if (result != null) {
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
              if (tntAddMtState.fileobjectlist != null &&
                  tntAddMtState.fileobjectlist.isNotEmpty)
                fileobjectlist1.addAll(tntAddMtState.fileobjectlist);

              _store.dispatch(UpdateTMR_fileobjectlist(fileobjectlist1));
              _changeData();
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

  checkValidation(TenantAddMaintenanceState tntAddMtState) {
    if (tntAddMtState.selectStatus == null) {
      ToastUtils.showCustomToast(
          context, GlobleString.ADM_error_Select_status, false);
    } else if (tntAddMtState.selectCategory == null) {
      ToastUtils.showCustomToast(
          context, GlobleString.ADM_error_Select_category, false);
    } else if (tntAddMtState.priority == 0) {
      ToastUtils.showCustomToast(
          context, GlobleString.ADM_error_Select_priority, false);
    } else if (tntAddMtState.requestName == null ||
        tntAddMtState.requestName.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.ADM_error_Select_requestname, false);
    } else if (tntAddMtState.description == null ||
        tntAddMtState.description.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.ADM_error_Select_description, false);
    }
    /*else if (tntAddMtState.fileobjectlist == null ||
        tntAddMtState.fileobjectlist.length == 0) {
      ToastUtils.showCustomToast(
          context, GlobleString.ADM_error_Select_uploadfile, false);
    }*/
    else {
      if (tntAddMtState.mid != null && tntAddMtState.mid.isNotEmpty) {
        updateMaintenaceApi(tntAddMtState);
      } else {
        addMaintenaceApi(tntAddMtState);
      }
    }
  }

  addMaintenaceApi(TenantAddMaintenanceState tntAddMtState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    AddMaintenanceQuery addmintenance = new AddMaintenanceQuery();
    addmintenance.Prop_ID = Prefs.getString(PrefsName.BT_PropID);
    addmintenance.Category =
        tntAddMtState.selectCategory!.EnumDetailID.toString();
    addmintenance.Status = tntAddMtState.selectStatus!.EnumDetailID.toString();
    addmintenance.Priority = tntAddMtState.priority.toString();
    addmintenance.Describe_Issue = tntAddMtState.description.toString();
    addmintenance.IsLock = false;
    addmintenance.Date_Created =
        new DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
    addmintenance.Applicant_ID = Prefs.getString(PrefsName.BT_ApplicantID);
    addmintenance.Type_User = "2";
    addmintenance.RequestName = tntAddMtState.requestName;
    addmintenance.Owner_ID = Prefs.getString(PrefsName.BT_OwnerID);
    addmintenance.Country = "";
    addmintenance.State = "";
    addmintenance.City = "";

    ApiManager().InsetNewRequest(context, addmintenance, (error, respoce) {
      if (error) {
        insertNotificationCall(tntAddMtState, respoce);
      } else {
        loader.remove();
        ToastUtils.showCustomToast(
            context, GlobleString.NL_error_insertcall, false);
      }
    });
  }

  insertNotificationCall(TenantAddMaintenanceState tntAddMtState, String mid) {
    List<MaintenanceNotificationData> notificationlist = [];

    MaintenanceNotificationData mn = new MaintenanceNotificationData();
    mn.applicantName = "";
    mn.mid = mid.toString();
    mn.propid = Prefs.getString(PrefsName.BT_PropID);
    mn.applicantId = Prefs.getString(PrefsName.BT_ApplicantID);
    mn.applicationId = Prefs.getString(PrefsName.BT_ApplicationId);
    mn.ownerId = Prefs.getString(PrefsName.BT_OwnerID);
    mn.notificationDate =
        new DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();
    mn.typeOfNotification = NotificationType()
        .getNotificationType(NotificationName.Owner_Maintenance_Requests);
    mn.isRead = false;

    notificationlist.add(mn);

    MaintenanceNotificationData mn2 = new MaintenanceNotificationData();
    mn2.applicantName = "";
    mn2.mid = mid.toString();
    mn2.propid = Prefs.getString(PrefsName.BT_PropID);
    mn2.applicantId = Prefs.getString(PrefsName.BT_ApplicantID);
    mn2.applicationId = Prefs.getString(PrefsName.BT_ApplicationId);
    mn2.ownerId = Prefs.getString(PrefsName.BT_OwnerID);
    mn2.notificationDate =
        new DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();
    mn2.typeOfNotification = NotificationType()
        .getNotificationType(NotificationName.Tenant_Maintenance_Requests);
    mn2.isRead = false;

    notificationlist.add(mn2);

    ApiManager().AddMaintenaceNotification(context, notificationlist,
        (error, responce) async {
      if (error) {
        if (tntAddMtState.fileobjectlist != null &&
            tntAddMtState.fileobjectlist.length > 0) {
          insertImageCall(tntAddMtState, mid);
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

  updateMaintenaceApi(TenantAddMaintenanceState tntAddMtState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    AddMaintenanceQuery addmintenance = new AddMaintenanceQuery();
    addmintenance.Prop_ID = Prefs.getString(PrefsName.BT_PropID);
    addmintenance.Category =
        tntAddMtState.selectCategory!.EnumDetailID.toString();
    addmintenance.Status = tntAddMtState.selectStatus!.EnumDetailID.toString();
    addmintenance.Priority = tntAddMtState.priority.toString();
    addmintenance.Describe_Issue = tntAddMtState.description.toString();
    addmintenance.IsLock = tntAddMtState.IsLock;
    addmintenance.Applicant_ID = Prefs.getString(PrefsName.BT_ApplicantID);
    addmintenance.Type_User = tntAddMtState.Type_User.toString();
    addmintenance.RequestName = tntAddMtState.requestName;
    addmintenance.Owner_ID = Prefs.getString(PrefsName.BT_OwnerID);

    CommonID Update = new CommonID();
    Update.ID = tntAddMtState.mid.toString();

    ApiManager().UpdateMaintenanceRequest(context, Update, addmintenance,
        (error, respoce) {
      if (error) {
        if (oldPriority == tntAddMtState.priority) {
          Updatecall(tntAddMtState);
        } else {
          insertNotificationCall2(tntAddMtState);
        }
      } else {
        loader.remove();
        ToastUtils.showCustomToast(
            context, GlobleString.NL_error_insertcall, false);
      }
    });
  }

  Updatecall(TenantAddMaintenanceState tntAddMtState) {
    if (tntAddMtState.fileobjectlist != null &&
        tntAddMtState.fileobjectlist.length > 0) {
      bool iscall = false;
      for (int i = 0; i < tntAddMtState.fileobjectlist.length; i++) {
        FileObject file = tntAddMtState.fileobjectlist[i];

        if (file.islocal!) {
          iscall = true;
        }

        if ((tntAddMtState.fileobjectlist.length - 1 == i)) {
          if (iscall) {
            insertImageCall(tntAddMtState, tntAddMtState.mid.toString());
          } else {
            loader.remove();
            ToastUtils.showCustomToast(
                context, GlobleString.maintenace_update_successfully, true);
            widget._callbackSave();
          }
        }
      }
    } else {
      loader.remove();
      ToastUtils.showCustomToast(
          context, GlobleString.maintenace_update_successfully, true);
      widget._callbackSave();
    }
  }

  insertNotificationCall2(TenantAddMaintenanceState tntAddMtState) {
    List<MaintenanceNotificationData> notificationlist = [];

    if (oldPriority != tntAddMtState.priority) {
      MaintenanceNotificationData mn3 = new MaintenanceNotificationData();
      mn3.applicantName = "";
      mn3.mid = tntAddMtState.mid;
      mn3.propid = Prefs.getString(PrefsName.BT_PropID);
      mn3.applicantId = Prefs.getString(PrefsName.BT_ApplicantID);
      mn3.applicationId = Prefs.getString(PrefsName.BT_ApplicationId);
      mn3.ownerId = Prefs.getString(PrefsName.BT_OwnerID);
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
        mn4.mid = tntAddMtState.mid;
        mn4.propid = Prefs.getString(PrefsName.BT_PropID);
        mn4.applicantId = Prefs.getString(PrefsName.BT_ApplicantID);
        mn4.applicationId = Prefs.getString(PrefsName.BT_ApplicationId);
        mn4.ownerId = Prefs.getString(PrefsName.BT_OwnerID);
        mn4.notificationDate = new DateFormat("yyyy-MM-dd HH:mm:ss")
            .format(DateTime.now())
            .toString();
        mn4.typeOfNotification = NotificationType().getNotificationType(
            NotificationName.Tenant_Maintenance_Change_Priority);
        mn4.isRead = false;

        notificationlist.add(mn4);
      }
    }

    ApiManager().AddMaintenaceNotification(context, notificationlist,
        (error, responce) async {
      if (error) {
        Updatecall(tntAddMtState);
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
  }

  insertImageCall(TenantAddMaintenanceState tntAddMtState, String mid) {
    ApiManager().MaintenanceImagesUpload(context, tntAddMtState.fileobjectlist,
        (status, listString, responce) {
      if (status) {
        if (listString.length > 0) {
          List<InsertMaintenanceImage> imagelist = <InsertMaintenanceImage>[];

          for (int i = 0; i < listString.length; i++) {
            imagelist.add(new InsertMaintenanceImage(
              Media_ID: listString[i],
              MaintenanceID: mid,
            ));
          }

          ApiManager().InsetMaintenanceImages(context, imagelist,
              (status, responce) async {
            if (status) {
              loader.remove();

              if (tntAddMtState.mid != null && tntAddMtState.mid.isNotEmpty) {
                ToastUtils.showCustomToast(
                    context, GlobleString.maintenace_update_successfully, true);
              } else {
                ToastUtils.showCustomToast(
                    context, GlobleString.maintenace_insert_successfully, true);
              }
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

  deleteImage(TenantAddMaintenanceState tntAddMtState, int index) {
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
            FileObject fileObject = tntAddMtState.fileobjectlist[index];

            if (fileObject.islocal!) {
              List<FileObject> mylist = tntAddMtState.fileobjectlist;
              mylist.removeAt(index);
              ToastUtils.showCustomToast(
                  context, GlobleString.File_deleted, true);
              _store.dispatch(UpdateTMR_fileobjectlist(mylist));
            } else {
              CommonID commonID = new CommonID(ID: fileObject.id.toString());

              ApiManager().deleteMaintenanceImage(context, commonID,
                  (error, respoce) async {
                if (error) {
                  ToastUtils.showCustomToast(
                      context, GlobleString.File_deleted, true);

                  List<FileObject> mylist = tntAddMtState.fileobjectlist;
                  mylist.removeAt(index);

                  _store.dispatch(UpdateTMR_fileobjectlist(mylist));
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
}
