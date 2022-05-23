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
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/alert_dialogbox.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';

class VarificationDocumentView extends StatefulWidget {
  final VoidCallback _callbackSaveandNext;

  VarificationDocumentView({
    required VoidCallback onPressedSave,
  }) : _callbackSaveandNext = onPressedSave;

  @override
  _VarificationDocumentViewState createState() =>
      _VarificationDocumentViewState();
}

class _VarificationDocumentViewState extends State<VarificationDocumentView> {
  double height = 0, width = 0;
  final _store = getIt<AppStore>();

  late OverlayEntry loader;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 1200,
      child: ConnectState<TenancyVarificationDocumentState>(
          map: (state) => state.tenancyVarificationDocumentState,
          where: notIdentical,
          builder: (TVDState) {
            return Column(
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
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        GlobleString.TVD_doc1,
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
                              TVDState!.docs1_filename),
                          Container(
                            width: 180,
                          ),
                          InkWell(
                            onTap: () {
                              pickImage(1, TVDState);
                            },
                            child: CustomeWidget.AttechDoc(),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          CustomeWidget.AttechDocFileView(
                              TVDState.docs1_filename),
                          SizedBox(
                            width: 10,
                          ),
                          TVDState.docs1_filename == ""
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
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        GlobleString.TVD_doc2,
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
                              TVDState.docs2_filename),
                          Container(
                            width: 180,
                          ),
                          InkWell(
                            onTap: () {
                              pickImage(2, TVDState);
                            },
                            child: CustomeWidget.AttechDoc(),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          CustomeWidget.AttechDocFileView(
                              TVDState.docs2_filename),
                          SizedBox(
                            width: 10,
                          ),
                          TVDState.docs2_filename == ""
                              ? Container()
                              : InkWell(
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    deleteAttechment(2);
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
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        GlobleString.TVD_doc3,
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
                              TVDState.docs3_filename),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TVDState.docs3_filename == ""
                                    ? Checkbox(
                                        activeColor: myColor.Circle_main,
                                        checkColor: myColor.white,
                                        value: TVDState.notapplicable_doc3,
                                        onChanged: (value) {
                                          if (TVDState.docs1_filename != "" &&
                                              TVDState.docs2_filename != "" &&
                                              (TVDState.docs3_filename != "" ||
                                                  value!) &&
                                              (TVDState.docs4_filename != "" ||
                                                  TVDState
                                                      .notapplicable_doc4)) {
                                            _store.dispatch(
                                                UpdateTVDIsbuttonActive(true));
                                          } else {
                                            _store.dispatch(
                                                UpdateTVDIsbuttonActive(false));
                                          }

                                          _store.dispatch(
                                              UpdateTVDNotapplicableDoc3(
                                                  value!));
                                        },
                                      )
                                    : Checkbox(
                                        activeColor: myColor.Circle_main,
                                        checkColor: myColor.white,
                                        value: false,
                                        onChanged: (value) {},
                                      ),
                                Text(
                                  GlobleString.TVD_Not_Applicable,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      MyStyles.Medium(12, myColor.text_color),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          TVDState.notapplicable_doc3
                              ? CustomeWidget.DesebleAttechDoc()
                              : InkWell(
                                  onTap: () {
                                    pickImage(3, TVDState);
                                  },
                                  child: CustomeWidget.AttechDoc(),
                                ),
                          SizedBox(
                            width: 30,
                          ),
                          CustomeWidget.AttechDocFileView(
                              TVDState.docs3_filename),
                          SizedBox(
                            width: 10,
                          ),
                          TVDState.docs3_filename == ""
                              ? Container()
                              : InkWell(
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    deleteAttechment(3);
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
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                            text: GlobleString.TVD_doc4,
                            style: MyStyles.Medium(14, myColor.text_color),
                            children: [
                              TextSpan(
                                  text: GlobleString.TVD_doc4_2,
                                  style: MyStyles.Medium(14, myColor.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Helper.launchURL(
                                          Weburl.verification_document_url);
                                    }),
                              TextSpan(
                                  text: GlobleString.TVD_doc4_3,
                                  style:
                                      MyStyles.Medium(14, myColor.text_color)),
                            ]),
                      ),
                      // child: Text(
                      //   GlobleString.TVD_doc4,
                      //   style: MyStyles.Medium(14, myColor.text_color),
                      //   textAlign: TextAlign.start,
                      // ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          CustomeWidget.AttechDocFileCheck(
                              TVDState.docs4_filename),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TVDState.docs4_filename == ""
                                    ? Checkbox(
                                        activeColor: myColor.Circle_main,
                                        checkColor: myColor.white,
                                        value: TVDState.notapplicable_doc4,
                                        onChanged: (value) {
                                          if (TVDState.docs1_filename != "" &&
                                              TVDState.docs2_filename != "" &&
                                              (TVDState.docs3_filename != "" ||
                                                  TVDState
                                                      .notapplicable_doc3) &&
                                              (TVDState.docs4_filename != "" ||
                                                  value!)) {
                                            _store.dispatch(
                                                UpdateTVDIsbuttonActive(true));
                                          } else {
                                            _store.dispatch(
                                                UpdateTVDIsbuttonActive(false));
                                          }

                                          _store.dispatch(
                                              UpdateTVDNotapplicableDoc4(
                                                  value!));
                                        },
                                      )
                                    : Checkbox(
                                        activeColor: myColor.Circle_main,
                                        checkColor: myColor.white,
                                        value: false,
                                        onChanged: (value) {},
                                      ),
                                Text(
                                  GlobleString.TVD_Not_Applicable,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      MyStyles.Medium(12, myColor.text_color),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          TVDState.notapplicable_doc4
                              ? CustomeWidget.DesebleAttechDoc()
                              : InkWell(
                                  onTap: () {
                                    pickImage(4, TVDState);
                                  },
                                  child: CustomeWidget.AttechDoc(),
                                ),
                          SizedBox(
                            width: 30,
                          ),
                          CustomeWidget.AttechDocFileView(
                              TVDState.docs4_filename),
                          SizedBox(
                            width: 10,
                          ),
                          TVDState.docs4_filename == ""
                              ? Container()
                              : InkWell(
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    deleteAttechment(4);
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
                SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [_submitButton(TVDState)],
                ),
              ],
            );
          }),
    );
  }

  Widget _submitButton(TenancyVarificationDocumentState? TVDState) {
    return InkWell(
      onTap: () {
        if (TVDState!.isbuttonActive) {
          final String id = '__file_picker_web-file-input';
          var element = html.document.getElementById(id);
          if (element != null) {
            element.remove();
          }

          validation(TVDState);
        }

        //widget._callbackSaveandNext();
      },
      child: CustomeWidget.FillButton(
          35, GlobleString.TVD_Submit, TVDState!.isbuttonActive),
    );
  }

  pickImage(int docs, TenancyVarificationDocumentState? TVDState) async {
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
        if (docs == 1) {
          if (file.name.contains("pdf") || file.name.contains("PDF")) {
            _store.dispatch(UpdateTVDDocs1FileExtension("pdf"));
          } else if (file.name.contains("jpg") || file.name.contains("JPG")) {
            _store.dispatch(UpdateTVDDocs1FileExtension("jpg"));
          } else if (file.name.contains("png") || file.name.contains("PNG")) {
            _store.dispatch(UpdateTVDDocs1FileExtension("png"));
          } else if (file.name.contains("jpeg") || file.name.contains("JPEG")) {
            _store.dispatch(UpdateTVDDocs1FileExtension("jpeg"));
          } else if (file.name.contains("doc") || file.name.contains("DOC")) {
            _store.dispatch(UpdateTVDDocs1FileExtension("doc"));
          }

          _store.dispatch(UpdateTVDDocs1FileName(file.name.toString()));
          _store.dispatch(UpdateTVDUint8ListDocs1File(file.bytes));

          if (file.name.toString() != "" &&
              TVDState!.docs2_filename != "" &&
              (TVDState.docs3_filename != "" || TVDState.notapplicable_doc3) &&
              (TVDState.docs4_filename != "" || TVDState.notapplicable_doc4)) {
            _store.dispatch(UpdateTVDIsbuttonActive(true));
          } else {
            _store.dispatch(UpdateTVDIsbuttonActive(false));
          }
        } else if (docs == 2) {
          if (file.name.contains("pdf") || file.name.contains("PDF")) {
            _store.dispatch(UpdateTVDDocs2FileExtension("pdf"));
          } else if (file.name.contains("jpg") || file.name.contains("JPG")) {
            _store.dispatch(UpdateTVDDocs2FileExtension("jpg"));
          } else if (file.name.contains("png") || file.name.contains("PNG")) {
            _store.dispatch(UpdateTVDDocs2FileExtension("png"));
          } else if (file.name.contains("jpeg") || file.name.contains("JPEG")) {
            _store.dispatch(UpdateTVDDocs2FileExtension("jpeg"));
          } else if (file.name.contains("doc") || file.name.contains("DOC")) {
            _store.dispatch(UpdateTVDDocs2FileExtension("doc"));
          }

          _store.dispatch(UpdateTVDDocs2FileName(file.name.toString()));
          _store.dispatch(UpdateTVDUint8ListDocs2File(file.bytes));

          if (file.name.toString() != "" &&
              TVDState!.docs1_filename != "" &&
              (TVDState.docs3_filename != "" || TVDState.notapplicable_doc3) &&
              (TVDState.docs4_filename != "" || TVDState.notapplicable_doc4)) {
            _store.dispatch(UpdateTVDIsbuttonActive(true));
          } else {
            _store.dispatch(UpdateTVDIsbuttonActive(false));
          }
        } else if (docs == 3) {
          if (file.name.contains("pdf") || file.name.contains("PDF")) {
            _store.dispatch(UpdateTVDDocs3FileExtension("pdf"));
          } else if (file.name.contains("jpg") || file.name.contains("JPG")) {
            _store.dispatch(UpdateTVDDocs3FileExtension("jpg"));
          } else if (file.name.contains("png") || file.name.contains("PNG")) {
            _store.dispatch(UpdateTVDDocs3FileExtension("png"));
          } else if (file.name.contains("jpeg") || file.name.contains("JPEG")) {
            _store.dispatch(UpdateTVDDocs3FileExtension("jpeg"));
          } else if (file.name.contains("doc") || file.name.contains("DOC")) {
            _store.dispatch(UpdateTVDDocs3FileExtension("doc"));
          }

          _store.dispatch(UpdateTVDDocs3FileName(file.name.toString()));
          _store.dispatch(UpdateTVDUint8ListDocs3File(file.bytes));
          _store.dispatch(UpdateTVDNotapplicableDoc3(false));

          if (TVDState!.docs1_filename != "" &&
              TVDState.docs2_filename != "" &&
              file.name.toString() != "" &&
              (TVDState.docs4_filename != "" || TVDState.notapplicable_doc4)) {
            _store.dispatch(UpdateTVDIsbuttonActive(true));
          } else {
            _store.dispatch(UpdateTVDIsbuttonActive(false));
          }
        } else if (docs == 4) {
          if (file.name.contains("pdf") || file.name.contains("PDF")) {
            _store.dispatch(UpdateTVDDocs4FileExtension("pdf"));
          } else if (file.name.contains("jpg") || file.name.contains("JPG")) {
            _store.dispatch(UpdateTVDDocs4FileExtension("jpg"));
          } else if (file.name.contains("png") || file.name.contains("PNG")) {
            _store.dispatch(UpdateTVDDocs4FileExtension("png"));
          } else if (file.name.contains("jpeg") || file.name.contains("JPEG")) {
            _store.dispatch(UpdateTVDDocs4FileExtension("jpeg"));
          } else if (file.name.contains("doc") || file.name.contains("DOC")) {
            _store.dispatch(UpdateTVDDocs4FileExtension("doc"));
          }

          _store.dispatch(UpdateTVDDocs4FileName(file.name.toString()));
          _store.dispatch(UpdateTVDUint8ListDocs4File(file.bytes));
          _store.dispatch(UpdateTVDNotapplicableDoc4(false));

          if (TVDState!.docs1_filename != "" &&
              TVDState.docs2_filename != "" &&
              (TVDState.docs3_filename != "" || TVDState.notapplicable_doc3) &&
              file.name.toString() != "") {
            _store.dispatch(UpdateTVDIsbuttonActive(true));
          } else {
            _store.dispatch(UpdateTVDIsbuttonActive(false));
          }
        }
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

  validation(TenancyVarificationDocumentState? TVDState) {
    if (TVDState!.docs1_file == null) {
      ToastUtils.showCustomToast(
          context, GlobleString.TVD_Document1_error, false);
    } else if (TVDState.docs2_file == null) {
      ToastUtils.showCustomToast(
          context, GlobleString.TVD_Document2_error, false);
    } else if (!TVDState.notapplicable_doc3 && TVDState.docs3_file == null) {
      ToastUtils.showCustomToast(
          context, GlobleString.TVD_Document3_error, false);
    } else if (!TVDState.notapplicable_doc4 && TVDState.docs4_file == null) {
      ToastUtils.showCustomToast(
          context, GlobleString.TVD_Document4_error, false);
    } else {
      ApiCallDocument(TVDState);
    }
  }

  ApiCallDocument(TenancyVarificationDocumentState? TVDState) {
    if (TVDState!.IsDocAvailable) {
      loader = Helper.overlayLoader(context);
      Overlay.of(context)!.insert(loader);

      CommonID? mediadoc1 = null;
      if (TVDState.MediaDoc1 != null) {
        mediadoc1 = new CommonID();
        mediadoc1.ID = TVDState.MediaDoc1!.id.toString();
      }

      CommonID? mediadoc2 = null;
      if (TVDState.MediaDoc2 != null) {
        mediadoc2 = new CommonID();
        mediadoc2.ID = TVDState.MediaDoc2!.id.toString();
      }

      CommonID? mediadoc3 = null;
      if (TVDState.MediaDoc3 != null) {
        mediadoc3 = new CommonID();
        mediadoc3.ID = TVDState.MediaDoc3!.id.toString();
      }

      CommonID? mediadoc4 = null;
      if (TVDState.MediaDoc4 != null) {
        mediadoc4 = new CommonID();
        mediadoc4.ID = TVDState.MediaDoc4!.id.toString();
      }

      DeleteApplicationDocument applicantDoc = new DeleteApplicationDocument();
      applicantDoc.Application_ID =
          Prefs.getString(PrefsName.TCF_ApplicationID);

      ApiManager().TVDMediaInfoDelete(
          context, mediadoc1, mediadoc2, mediadoc3, mediadoc4, applicantDoc,
          (status, responce) {
        if (status) {
          loader.remove();
          insertApiCall(TVDState);
        } else {
          loader.remove();
          ToastUtils.showCustomToast(context, responce, false);
        }
      });
    } else {
      insertApiCall(TVDState);
    }
  }

  insertApiCall(TenancyVarificationDocumentState? TVDState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().VarificationDocumentUpload(
        context,
        Prefs.getString(PrefsName.TCF_ApplicantID),
        TVDState!.docs1_filename,
        TVDState.docs1_file,
        TVDState.docs1_fileextension,
        TVDState.docs2_filename,
        TVDState.docs2_file,
        TVDState.docs2_fileextension,
        TVDState.docs3_filename,
        TVDState.docs3_file,
        TVDState.docs3_fileextension,
        TVDState.docs4_filename,
        TVDState.docs4_file,
        TVDState.docs4_fileextension, (status, listString, responce) {
      if (status) {
        if (listString.length > 0) {
          List<InsertApplicationDocument> appdoclist =
              <InsertApplicationDocument>[];

          for (int i = 0; i < listString.length; i++) {
            appdoclist.add(new InsertApplicationDocument(
                Media_ID: listString[i],
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
