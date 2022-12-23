import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancy_varification_doc_actions.dart';
import 'package:silverhome/presentation/models/landlord_models/tenancy_varification_doc_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/alert/alert_dialogbox.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';

class VarificationDocumentView2 extends StatefulWidget {
  final VoidCallback _callbackSaveandNext;
  final String? id;
  VarificationDocumentView2({
    required VoidCallback onPressedSave,
    required this.id,
  }) : _callbackSaveandNext = onPressedSave;

  @override
  _VarificationDocumentView2State createState() =>
      _VarificationDocumentView2State();
}

class _VarificationDocumentView2State extends State<VarificationDocumentView2> {
  double height = 0, width = 0;
  final _store = getIt<AppStore>();
  List<ApplicationDocumentUploads> fields = [];
  late OverlayEntry loader;
  @override
  void initState() {
    traerfields();
    super.initState();
  }

  traerfields() async {
    GetRequestDocuments querylist =
        GetRequestDocuments(application_id: widget.id);
    // _store.dispatch(UpdateProperTytypeValue1([]));
    await ApiManager().getDocumentRequest(context, querylist,
        (status, errorlist) {
      if (status) {
        setState(() {
          for (int i = 0; i < errorlist.length; i++) {
            ApplicationDocumentUploads objdoc = ApplicationDocumentUploads(
                appImage: null,
                isbuttonActive: false,
                fieldname: errorlist[i]["name"],
                fileName: "",
                notaplicable: false,
                required: errorlist[i]["required"],
                nuevo: false);
            fields.add(objdoc);
          }
        });
      } else {
        //  _store.dispatch(UpdateProperTytypeValue1([]));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        width: 1200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                GlobleString.TVD_title,
                style: MyStyles.Medium(20, myColor.text_color),
                textAlign: TextAlign.center,
              ),
            ),
            for (int i = 0; i < fields.length; i++)
              Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: (fields[i].nuevo!)
                            ? SizedBox(
                                width: 200,
                                child: TextFormField(
                                  // controller: _controller[i],
                                  onChanged: (value) {
                                    fields[i].fieldname = value;
                                  },
                                  textAlign: TextAlign.start,
                                  style:
                                      MyStyles.Regular(14, myColor.text_color),
                                  decoration: InputDecoration(
                                      //border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1.0),
                                      ),
                                      isDense: true,
                                      contentPadding: const EdgeInsets.all(12),
                                      fillColor: myColor.white,
                                      filled: true),
                                ),
                              )
                            : Text(
                                fields[i].fieldname!,
                                style: MyStyles.Medium(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            CustomeWidget.AttechDocFileCheck(
                                fields[i].fileName!),
                            (fields[i].required == false)
                                ? Container(
                                    width: 150,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        fields[i].fileName! == ""
                                            ? Checkbox(
                                                activeColor:
                                                    myColor.Circle_main,
                                                checkColor: myColor.white,
                                                value: fields[i].notaplicable!,
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (fields[i].fileName !=
                                                            "" ||
                                                        value!) {
                                                      fields[i].isbuttonActive =
                                                          true;
                                                    } else {
                                                      fields[i].isbuttonActive =
                                                          false;
                                                    }
                                                    fields[i].notaplicable =
                                                        value!;
                                                  });
                                                },
                                              )
                                            : Checkbox(
                                                activeColor:
                                                    myColor.Circle_main,
                                                checkColor: myColor.white,
                                                value: false,
                                                onChanged: (value) {},
                                              ),
                                        Text(
                                          GlobleString.TVD_Not_Applicable,
                                          overflow: TextOverflow.ellipsis,
                                          style: MyStyles.Medium(
                                              12, myColor.text_color),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    width: 150,
                                  ),
                            fields[i].notaplicable!
                                ? CustomeWidget.DesebleAttechDoc()
                                : InkWell(
                                    onTap: () {
                                      pickImage(1, fields[i]);
                                    },
                                    child: CustomeWidget.AttechDoc(),
                                  ),
                            SizedBox(
                              width: 30,
                            ),
                            CustomeWidget.AttechDocFileView(
                                fields[i].fileName!),
                            SizedBox(
                              width: 10,
                            ),
                            fields[i].fileName == ""
                                ? Container()
                                : InkWell(
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      deleteAttechment(1);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        "assets/images/ic_delete.png",
                                        height: 25,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            SizedBox(
              height: 60,
            ),
            SizedBox(
              width: 170,
              child: InkWell(
                onTap: () {
                  setState(() {
                    ApplicationDocumentUploads objdoc =
                        ApplicationDocumentUploads(
                            appImage: null,
                            isbuttonActive: false,
                            fieldname: "",
                            fileName: "",
                            notaplicable: false,
                            required: false,
                            nuevo: true);
                    fields.add(objdoc);
                  });

                  //_selectDate1(context, eventtypesState);
                },
                child: CustomeWidget.NewDoc(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [_submitButton(fields)],
            ),
          ],
        ));
  }

  Widget _submitButton(List<ApplicationDocumentUploads>? TVDState) {
    return InkWell(
      onTap: () {
        final String id = '__file_picker_web-file-input';
        var element = html.document.getElementById(id);
        if (element != null) {
          element.remove();
        }

        validation(TVDState);

        //widget._callbackSaveandNext();
      },
      child: CustomeWidget.FillButton(35, GlobleString.TVD_Submit, true),
    );
  }

  pickImage(int docs, ApplicationDocumentUploads? TVDState) async {
    /* FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
      allowMultiple: false,
      withData: true,
    );*/
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['jpg', 'png', 'pdf', "doc", "jpeg"],
      type: FileType.custom,
    );

    if (result != null) {
      PlatformFile file = result.files.first as PlatformFile;

      Helper.Log("file size", file.size.toString());

      if ((file.size / 1024) < 0) {
        ToastUtils.showCustomToast(
            context, GlobleString.TVD_Document_Image_Size_0_error, false);
      } else if ((file.size / 1024) > 10240) {
        ToastUtils.showCustomToast(
            context, GlobleString.TVD_Document_Image_Size_error, false);
      } else if ((file.name.split('.').last).contains("jpg") ||
          (file.name.split('.').last).contains("JPG") ||
          (file.name.split('.').last).contains("png") ||
          (file.name.split('.').last).contains("PNG") ||
          (file.name.split('.').last).contains("pdf") ||
          (file.name.split('.').last).contains("PDF") ||
          (file.name.split('.').last).contains("jpeg") ||
          (file.name.split('.').last).contains("JPEG") ||
          (file.name.split('.').last).contains("doc") ||
          (file.name.split('.').last).contains("DOC")) {
        setState(() {
          TVDState!.fileName = file.name.toString();
          TVDState.appImage = file.bytes;
          if (file.name.toString() != "" && TVDState.fileName != "") {
            TVDState.isbuttonActive = true;
          } else {
            TVDState.isbuttonActive = false;
          }
        });
      } else {
        ToastUtils.showCustomToast(
            context, GlobleString.TVD_Document_Image_error, false);
      }
    }

    final String id = '__file_picker_web-file-input';
    var element = html.document.getElementById(id);
    if (element != null) {
      element.remove();
    }
  }

  deleteAttechment(int flag) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialogBox(
          title: GlobleString.TVD_Document_Delet,
          positiveText: GlobleString.TVD_Document_btn_yes,
          negativeText: GlobleString.TVD_Document_btn_No,
          onPressedYes: () {
            Navigator.of(context1).pop();

            if (flag == 1) {
              _store.dispatch(UpdateTVDDocs1FileName(""));
              _store.dispatch(UpdateTVDDocs1FileExtension(""));
              _store.dispatch(UpdateTVDUint8ListDocs1File(null));
              _store.dispatch(UpdateTVDIsbuttonActive(false));
            } else if (flag == 2) {
              _store.dispatch(UpdateTVDDocs2FileName(""));
              _store.dispatch(UpdateTVDDocs2FileExtension(""));
              _store.dispatch(UpdateTVDUint8ListDocs2File(null));
              _store.dispatch(UpdateTVDIsbuttonActive(false));
            } else if (flag == 3) {
              _store.dispatch(UpdateTVDDocs3FileName(""));
              _store.dispatch(UpdateTVDDocs3FileExtension(""));
              _store.dispatch(UpdateTVDUint8ListDocs3File(null));
              _store.dispatch(UpdateTVDIsbuttonActive(false));
            } else if (flag == 4) {
              _store.dispatch(UpdateTVDDocs4FileName(""));
              _store.dispatch(UpdateTVDDocs4FileExtension(""));
              _store.dispatch(UpdateTVDUint8ListDocs4File(null));
              _store.dispatch(UpdateTVDIsbuttonActive(false));
            }
          },
          onPressedNo: () {
            Navigator.of(context1).pop();
          },
        );
      },
    );
  }

  validation(List<ApplicationDocumentUploads>? TVDState) {
    // if (TVDState!.docs1_file == null) {
    //   ToastUtils.showCustomToast(
    //       context, GlobleString.TVD_Document1_error, false);
    // } else if (TVDState.docs2_file == null) {
    //   ToastUtils.showCustomToast(
    //       context, GlobleString.TVD_Document2_error, false);
    // } else if (!TVDState.notapplicable_doc3 && TVDState.docs3_file == null) {
    //   ToastUtils.showCustomToast(
    //       context, GlobleString.TVD_Document3_error, false);
    // } else if (!TVDState.notapplicable_doc4 && TVDState.docs4_file == null) {
    //   ToastUtils.showCustomToast(
    //       context, GlobleString.TVD_Document4_error, false);
    // } else {

    // }
    ApiCallDocument(TVDState);
  }

  ApiCallDocument(List<ApplicationDocumentUploads>? TVDState) {
    // if (TVDState!.IsDocAvailable) {
    //   loader = Helper.overlayLoader(context);
    //   Overlay.of(context)!.insert(loader);

    //   CommonID? mediadoc1 = null;
    //   if (TVDState.MediaDoc1 != null) {
    //     mediadoc1 = new CommonID();
    //     mediadoc1.ID = TVDState.MediaDoc1!.id.toString();
    //   }

    //   CommonID? mediadoc2 = null;
    //   if (TVDState.MediaDoc2 != null) {
    //     mediadoc2 = new CommonID();
    //     mediadoc2.ID = TVDState.MediaDoc2!.id.toString();
    //   }

    //   CommonID? mediadoc3 = null;
    //   if (TVDState.MediaDoc3 != null) {
    //     mediadoc3 = new CommonID();
    //     mediadoc3.ID = TVDState.MediaDoc3!.id.toString();
    //   }

    //   CommonID? mediadoc4 = null;
    //   if (TVDState.MediaDoc4 != null) {
    //     mediadoc4 = new CommonID();
    //     mediadoc4.ID = TVDState.MediaDoc4!.id.toString();
    //   }

    //   DeleteApplicationDocument applicantDoc = new DeleteApplicationDocument();
    //   applicantDoc.Application_ID =
    //       Prefs.getString(PrefsName.TCF_ApplicationID);

    //   ApiManager().TVDMediaInfoDelete(
    //       context, mediadoc1, mediadoc2, mediadoc3, mediadoc4, applicantDoc,
    //       (status, responce) {
    //     if (status) {
    //       loader.remove();
    //       insertApiCall(TVDState);
    //     } else {
    //       loader.remove();
    //       ToastUtils.showCustomToast(context, responce, false);
    //     }
    //   });
    // } else {
    //   insertApiCall(TVDState);
    // }
    insertApiCall(TVDState);
  }

  insertApiCall(List<ApplicationDocumentUploads>? TVDState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    // ApiManager().VarificationDocumentUpload(
    //     context,
    //     Prefs.getString(PrefsName.TCF_ApplicantID),
    //     TVDState!.docs1_filename,
    //     TVDState.docs1_file,
    //     TVDState.docs1_fileextension,
    //     TVDState.docs2_filename,
    //     TVDState.docs2_file,
    //     TVDState.docs2_fileextension,
    //     TVDState.docs3_filename,
    //     TVDState.docs3_file,
    //     TVDState.docs3_fileextension,
    //     TVDState.docs4_filename,
    //     TVDState.docs4_file,
    //     TVDState.docs4_fileextension, (status, listString, responce) {
    //   if (status) {
    //     if (listString.length > 0) {
    //       List<InsertApplicationDocument> appdoclist =
    //           <InsertApplicationDocument>[];

    //       for (int i = 0; i < listString.length; i++) {
    //         appdoclist.add(new InsertApplicationDocument(
    //             Media_ID: listString[i],
    //             Application_ID: Prefs.getString(PrefsName.TCF_ApplicationID)));
    //       }

    //       ApiManager().InsetApplicantDocument(context, appdoclist,
    //           (status, responce) {
    //         if (status) {
    //           NotificationCall();
    //         } else {
    //           loader.remove();
    //           ToastUtils.showCustomToast(context, responce, false);
    //         }
    //       });
    //     }
    //   } else {
    //     loader.remove();
    //     ToastUtils.showCustomToast(context, responce, false);
    //   }

    // });

    ApiManager().DocumentsUpload(context, TVDState!,
        (status, listString, responce) {
      if (status) {
        if (listString.length > 0) {
          List<InsertApplicationDocument> appdoclist =
              <InsertApplicationDocument>[];

          for (int i = 0; i < listString.length; i++) {
            appdoclist.add(new InsertApplicationDocument(
                Media_ID: listString[i],
                field: TVDState[i].fieldname,
                Application_ID: Prefs.getString(PrefsName.TCF_ApplicationID)));
          }

          ApiManager().InsetApplicantDocument(context, appdoclist,
              (status, responce) {
            if (status) {
              NotificationCall();
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

  NotificationCall() {
    ApiManager().NotificationDocReceive(
        context, Prefs.getString(PrefsName.TCF_ApplicationID),
        (status, responce) async {
      if (status) {
        loader.remove();
        widget._callbackSaveandNext();
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, GlobleString.Error1, false);
      }
    });
  }

  UpdateReceiveDate() {
    CommonID commonID = new CommonID();
    commonID.ID = Prefs.getString(PrefsName.TCF_ApplicationID);

    String date =
        new DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();

    InsertDocReceiveDate insertDocReceiveDate = new InsertDocReceiveDate();
    insertDocReceiveDate.DocReceivedDate = date;

    ApiManager().UapdateApplicantDocumentReceiveDate(
        context, commonID, insertDocReceiveDate, (error, respoce) async {
      if (error) {
        loader.remove();
        widget._callbackSaveandNext();
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
