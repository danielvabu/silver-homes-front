import 'dart:html' as html;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/entities/bulk_property.dart';
import 'package:silverhome/tablayer/api_manager_admin.dart';
import 'package:silverhome/tablayer/weburl.dart';

import 'ImportResulttable.dart';

class ImportPropertyDialogBox extends StatefulWidget {
  final VoidCallback _callbackYes;
  final VoidCallback _callbackNo;

  ImportPropertyDialogBox({
    required VoidCallback onPressedYes,
    required VoidCallback onPressedNo,
  })  : _callbackYes = onPressedYes,
        _callbackNo = onPressedNo;

  @override
  _ImportPropertyDialogBoxState createState() =>
      _ImportPropertyDialogBoxState();
}

class _ImportPropertyDialogBoxState extends State<ImportPropertyDialogBox> {
  late OverlayEntry loader;

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
              minWidth: 300,
              maxWidth: 700,
              minHeight: 300,
              maxHeight: 300,
            ),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.white),
              padding:
                  EdgeInsets.only(top: 20, bottom: 10, left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    GlobleString.Property_Import,
                    textAlign: TextAlign.center,
                    style: MyStyles.SemiBold(20, myColor.text_color),
                  ),
                  new SizedBox(
                    height: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.Property_Import_Note,
                        style: MyStyles.SemiBold(18, myColor.text_color),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        GlobleString.Property_Import_title1,
                        style: MyStyles.Medium(15, myColor.text_color),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        GlobleString.Property_Import_title2,
                        style: MyStyles.Medium(15, myColor.text_color),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        GlobleString.Property_Import_title3,
                        style: MyStyles.Medium(15, myColor.text_color),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          Helper.launchURL(Weburl.Sample_property_value_file);
                        },
                        hoverColor: Colors.transparent,
                        child: Text(
                          GlobleString.Property_Import_note_csv,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: MyStyles.Medium(15, myColor.blue),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          Helper.launchURL(Weburl.Sample_Properties_csv);
                        },
                        hoverColor: Colors.transparent,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                GlobleString.Property_Import_sample_csv,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: MyStyles.Medium(16, myColor.blue),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  new SizedBox(
                    height: 15,
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          widget._callbackNo();
                        },
                        child: Container(
                          height: 35,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: myColor.white,
                            border: Border.all(
                                color: myColor.Circle_main, width: 1),
                          ),
                          child: Text(
                            'Close',
                            style: MyStyles.Medium(14, myColor.Circle_main),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          PickCSV();
                        },
                        child: Container(
                          height: 35,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: myColor.Circle_main,
                            border: Border.all(
                                color: myColor.Circle_main, width: 1),
                          ),
                          child: Text(
                            'Upload File',
                            style: MyStyles.Medium(14, myColor.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void PickCSV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['CSV'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;

      if ((file.name.split('.').last).contains("csv") ||
          (file.name.split('.').last).contains("CSV")) {
        Uint8List? procsv = file.bytes;

        final String id = '__file_picker_web-file-input';
        var element = html.document.getElementById(id);
        if (element != null) {
          element.remove();
        }

        UploadCSVFileCall(procsv);
      } else {
        ToastUtils.showCustomToast(
            context, GlobleString.Admin_Property_CSV_error, false);
      }
    }

    final String id = '__file_picker_web-file-input';
    var element = html.document.getElementById(id);
    if (element != null) {
      element.remove();
    }
  }

  UploadCSVFileCall(Uint8List? procsv) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManagerAdmin().AddCSVFile(
      context,
      procsv!,
      (status, responce) {
        if (status) {
          //loader.remove();
          PropertyWorkflowCall(responce);
        } else {
          loader.remove();
          ToastUtils.showCustomToast(context, responce, false);
        }
      },
    );
  }

  PropertyWorkflowCall(String id) {
    ApiManagerAdmin()
        .WorkFlowPropertyUpload(context, id, Prefs.getString(PrefsName.OwnerID),
            (status, title, titlelist) {
      if (status) {
        loader.remove();
        ToastUtils.showCustomToast(
            context, GlobleString.Property_Import_successfully, true);
        widget._callbackYes();
      } else {
        loader.remove();
        if (title == "1") {
          errorDialog(titlelist);
        } else if (title == "2") {
          ToastUtils.showCustomToast(
              context, GlobleString.Property_Import_fail, false);
        } else {
          ToastUtils.showCustomToast(context, GlobleString.Error, false);
        }
      }
    });
  }

  void errorDialog(List<BulkProperty> bulkPropertylist) {
    showDialog(
      barrierColor: Colors.black26,
      context: context,
      useSafeArea: true,
      builder: (BuildContext context1) {
        return StatefulBuilder(builder: (context1, setState) {
          return Align(
            alignment: Alignment(0, 0),
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 500,
                    maxWidth: 700,
                    minHeight: 300,
                    maxHeight: 400,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1.0),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        color: Colors.white),
                    padding: EdgeInsets.only(
                        top: 20, bottom: 10, left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          GlobleString.Property_Import_Result,
                          textAlign: TextAlign.center,
                          style: MyStyles.SemiBold(20, myColor.text_color),
                        ),
                        new SizedBox(
                          height: 10,
                        ),
                        ImportResulttable(
                          responcelist1: bulkPropertylist,
                        ),
                        new SizedBox(
                          height: 15,
                        ),
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.of(context1).pop();
                                widget._callbackYes();
                              },
                              child: Container(
                                height: 35,
                                width: 90,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: myColor.Circle_main,
                                  border: Border.all(
                                      color: myColor.Circle_main, width: 1),
                                ),
                                child: Text(
                                  GlobleString.Property_Import_OK,
                                  style: MyStyles.Medium(14, myColor.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
