import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/preview_document_actions.dart';
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
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

import '../../presentation/models/landlord_models/preview_document_state.dart';
import '../alert_dialogbox.dart';

class PreviewDocumentsDialogBox extends StatefulWidget {
  final String ApplicantionId;
  final String Applicantid;
  final VoidCallback _callbackYes;
  final VoidCallback _callbackNo;

  PreviewDocumentsDialogBox({
    required String ApplicantionId,
    required String Applicantid,
    required VoidCallback onPressedYes,
    required VoidCallback onPressedNo,
  })  : Applicantid = Applicantid,
        ApplicantionId = ApplicantionId,
        _callbackYes = onPressedYes,
        _callbackNo = onPressedNo;

  @override
  _PreviewDocumentsDialogBoxState createState() =>
      _PreviewDocumentsDialogBoxState();
}

class _PreviewDocumentsDialogBoxState extends State<PreviewDocumentsDialogBox> {
  double height = 0, width = 0;
  static List<SystemEnumDetails> statuslist = [];
  static List<SystemEnumDetails> reviewstatuslist = [];

  final _store = getIt<AppStore>();
  bool isloading = true;

  @override
  void initState() {
    apimanager();
    super.initState();
  }

  apimanager() async {
    await ClearAllState();

    statuslist.clear();
    statuslist =
        await QueryFilter().PlainValues(eSystemEnums().ApplicationStatus);

    reviewstatuslist.clear();
    reviewstatuslist =
        await QueryFilter().PlainValues(eSystemEnums().DocReviewStatus);

    ApiManager().getPriviewDocumentData(context, widget.Applicantid,
        (status, responce) {
      if (status) {
        ApiManager().getPriviewDocumentList(context, widget.Applicantid,
            (status, responce) {
          setState(() {
            isloading = false;
          });
        });
      } else {
        isloading = true;
        Helper.Log("respoce", responce);
      }
    });
  }

  ClearAllState() {
    _store.dispatch(UpdatePDApplicantID(""));
    _store.dispatch(UpdatePDApplicantionID(""));
    _store.dispatch(UpdatePDApplicationName(""));
    _store.dispatch(UpdatePDApplicationStatus(null));
    _store.dispatch(UpdatePDDocReviewStatus(null));
    _store.dispatch(UpdatePDRatingReview(""));
    _store.dispatch(UpdatePDRating(0));

    _store.dispatch(UpdatePDMIDDoc1(""));
    _store.dispatch(UpdatePDMIDDoc2(""));
    _store.dispatch(UpdatePDMIDDoc3(""));
    _store.dispatch(UpdatePDMIDDoc4(""));

    _store.dispatch(UpdatePDMediaInfo1(null));
    _store.dispatch(UpdatePDMediaInfo2(null));
    _store.dispatch(UpdatePDMediaInfo3(null));
    _store.dispatch(UpdatePDMediaInfo4(null));
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 230;

    return Align(
      alignment: Alignment(0, 0),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: 1200, maxWidth: 1200, minHeight: 540, maxHeight: 540),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.white),
              padding:
                  EdgeInsets.only(top: 15, bottom: 15, left: 30, right: 30),
              child: _initialview(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _initialview() {
    return isloading
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /*Image.asset(
                  "assets/images/silverhome.png",
                  height: 100,
                  //width: 180,
                ),*/
                CircularProgressIndicator()
              ],
            ),
          )
        : ConnectState<PreviewDocumentState>(
            map: (state) => state.previewDocumentState,
            where: notIdentical,
            builder: (previewDocumentState) {
              return Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.PD_Preview_Documents,
                        style: MyStyles.Medium(20, myColor.text_color),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        previewDocumentState!.applicationName +
                            GlobleString.PD_document_review,
                        style: MyStyles.Medium(14, myColor.text_color),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 40,
                                  color: myColor.TA_table_header,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 200,
                                        padding: EdgeInsets.only(left: 10),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          GlobleString.PD_Document_Type,
                                          textAlign: TextAlign.center,
                                          style: MyStyles.SemiBold(
                                              12, myColor.text_color),
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        padding: EdgeInsets.only(left: 10),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          GlobleString.PD_Attachment_Name,
                                          textAlign: TextAlign.center,
                                          style: MyStyles.SemiBold(
                                              12, myColor.text_color),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Doc1View(previewDocumentState),
                                SizedBox(
                                  height: 10,
                                ),
                                Doc2View(previewDocumentState),
                                SizedBox(
                                  height: 10,
                                ),
                                Doc3View(previewDocumentState),
                                SizedBox(
                                  height: 10,
                                ),
                                Doc4View(previewDocumentState),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          TenantView(previewDocumentState)
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          widget._callbackNo();
                        },
                        child: Icon(Icons.clear, size: 25),
                      )
                    ],
                  )
                ],
              );
            },
          );
  }

  Widget Doc1View(PreviewDocumentState previewDocumentState) {
    return Container(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 200,
                  padding: EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    GlobleString.PD_doc1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: MyStyles.Medium(12, myColor.text_color),
                  ),
                ),
                previewDocumentState.MediaDoc1 != null
                    ? InkWell(
                        onTap: () {
                          if (previewDocumentState.MediaDoc1 != null) {
                            Helper.launchURL(
                                previewDocumentState.MediaDoc1!.url.toString());
                          }
                        },
                        child: Container(
                          width: 200,
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            Helper.FileName(
                                previewDocumentState.MediaDoc1!.url!),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: MyStyles.Medium(12, myColor.blue),
                          ),
                        ),
                      )
                    : Container(
                        width: 200,
                        padding: EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          GlobleString.PD_doc_NotApplicable,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: MyStyles.Medium(12, myColor.errorcolor),
                        ),
                      ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              if (previewDocumentState.MediaDoc1 != null) {
                Helper.launchURL(
                    previewDocumentState.MediaDoc1!.url.toString());
              }
            },
            child: Container(
              height: 30,
              width: 100,
              padding: EdgeInsets.only(left: 15, right: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                    color: previewDocumentState.MediaDoc1 != null
                        ? myColor.Circle_main
                        : myColor.disablecolor,
                    width: 1.5),
              ),
              child: Text(
                GlobleString.PD_Preview,
                style: MyStyles.Medium(
                  12,
                  previewDocumentState.MediaDoc1 != null
                      ? myColor.text_color
                      : myColor.disablecolor,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () async {
              if (previewDocumentState.MediaDoc1 != null &&
                  previewDocumentState.MediaDoc1!.url != null &&
                  previewDocumentState.MediaDoc1!.url != "") {
                // String filename = Helper.fileextension(
                //     "copy_of_id",
                //     previewDocumentState.MediaDoc1!.fileType,
                //     previewDocumentState.MediaDoc1!.url.toString());

                await Helper.download(
                    context,
                    previewDocumentState.MediaDoc1!.url.toString(),
                    previewDocumentState.MediaDoc1!.id.toString(),
                    Helper.FileNameWithTime(
                        previewDocumentState.MediaDoc1!.url!),
                    1);
              }
            },
            child: Container(
              height: 30,
              width: 100,
              padding: EdgeInsets.only(left: 15, right: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                    color: previewDocumentState.MediaDoc1 != null
                        ? myColor.Circle_main
                        : myColor.disablecolor,
                    width: 1.5),
              ),
              child: Text(
                GlobleString.PD_Download,
                style: MyStyles.Medium(
                  12,
                  previewDocumentState.MediaDoc1 != null
                      ? myColor.text_color
                      : myColor.disablecolor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget Doc2View(PreviewDocumentState previewDocumentState) {
    return Container(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 200,
                  padding: EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    GlobleString.PD_doc2,
                    textAlign: TextAlign.center,
                    style: MyStyles.Medium(12, myColor.text_color),
                  ),
                ),
                previewDocumentState.MediaDoc2 != null
                    ? InkWell(
                        onTap: () {
                          if (previewDocumentState.MediaDoc2 != null) {
                            Helper.launchURL(
                                previewDocumentState.MediaDoc2!.url.toString());
                          }
                        },
                        child: Container(
                          width: 200,
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            Helper.FileName(
                                previewDocumentState.MediaDoc2!.url!),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: MyStyles.Medium(12, myColor.blue),
                          ),
                        ),
                      )
                    : Container(
                        width: 200,
                        padding: EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          GlobleString.PD_doc_NotApplicable,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: MyStyles.Medium(12, myColor.errorcolor),
                        ),
                      )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              if (previewDocumentState.MediaDoc2 != null) {
                Helper.launchURL(
                    previewDocumentState.MediaDoc2!.url.toString());
              }
            },
            child: Container(
              height: 30,
              width: 100,
              padding: EdgeInsets.only(left: 15, right: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                    color: previewDocumentState.MediaDoc2 != null
                        ? myColor.Circle_main
                        : myColor.disablecolor,
                    width: 1.5),
              ),
              child: Text(
                GlobleString.PD_Preview,
                style: MyStyles.Medium(
                  12,
                  previewDocumentState.MediaDoc2 != null
                      ? myColor.text_color
                      : myColor.disablecolor,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () async {
              if (previewDocumentState.MediaDoc2 != null &&
                  previewDocumentState.MediaDoc2!.url != null &&
                  previewDocumentState.MediaDoc2!.url != "") {
                // String filename = Helper.fileextension(
                //     "proof_of_funds",
                //     previewDocumentState.MediaDoc2!.fileType,
                //     previewDocumentState.MediaDoc2!.url.toString());

                await Helper.download(
                    context,
                    previewDocumentState.MediaDoc2!.url.toString(),
                    previewDocumentState.MediaDoc2!.id.toString(),
                    Helper.FileNameWithTime(
                        previewDocumentState.MediaDoc2!.url!),
                    1);
              }
            },
            child: Container(
              height: 30,
              width: 100,
              padding: EdgeInsets.only(left: 15, right: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                    color: previewDocumentState.MediaDoc2 != null
                        ? myColor.Circle_main
                        : myColor.disablecolor,
                    width: 1.5),
              ),
              child: Text(
                GlobleString.PD_Download,
                style: MyStyles.Medium(
                  12,
                  previewDocumentState.MediaDoc2 != null
                      ? myColor.text_color
                      : myColor.disablecolor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget Doc3View(PreviewDocumentState previewDocumentState) {
    return Container(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 200,
                  padding: EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    GlobleString.PD_doc3,
                    textAlign: TextAlign.center,
                    style: MyStyles.Medium(12, myColor.text_color),
                  ),
                ),
                previewDocumentState.MediaDoc3 != null
                    ? InkWell(
                        onTap: () {
                          if (previewDocumentState.MediaDoc3 != null) {
                            Helper.launchURL(
                                previewDocumentState.MediaDoc3!.url.toString());
                          }
                        },
                        child: Container(
                          width: 200,
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            Helper.FileName(
                                previewDocumentState.MediaDoc3!.url!),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: MyStyles.Medium(12, myColor.blue),
                          ),
                        ),
                      )
                    : Container(
                        width: 200,
                        padding: EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          GlobleString.PD_doc_NotApplicable,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: MyStyles.Medium(12, myColor.errorcolor),
                        ),
                      ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              if (previewDocumentState.MediaDoc3 != null) {
                Helper.launchURL(
                    previewDocumentState.MediaDoc3!.url.toString());
              }
            },
            child: Container(
              height: 30,
              width: 100,
              padding: EdgeInsets.only(left: 15, right: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                    color: previewDocumentState.MediaDoc3 != null
                        ? myColor.Circle_main
                        : myColor.disablecolor,
                    width: 1.5),
              ),
              child: Text(
                GlobleString.PD_Preview,
                style: MyStyles.Medium(
                  12,
                  previewDocumentState.MediaDoc3 != null
                      ? myColor.text_color
                      : myColor.disablecolor,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () async {
              if (previewDocumentState.MediaDoc3 != null &&
                  previewDocumentState.MediaDoc3!.url != null &&
                  previewDocumentState.MediaDoc3!.url != "") {
                // String filename = Helper.fileextension(
                //     "employment_verification",
                //     previewDocumentState.MediaDoc3!.fileType,
                //     previewDocumentState.MediaDoc3!.url.toString());

                await Helper.download(
                    context,
                    previewDocumentState.MediaDoc3!.url.toString(),
                    previewDocumentState.MediaDoc3!.id.toString(),
                    Helper.FileNameWithTime(
                        previewDocumentState.MediaDoc3!.url!),
                    1);
              }
            },
            child: Container(
              height: 30,
              width: 100,
              padding: EdgeInsets.only(left: 15, right: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                    color: previewDocumentState.MediaDoc3 != null
                        ? myColor.Circle_main
                        : myColor.disablecolor,
                    width: 1.5),
              ),
              child: Text(
                GlobleString.PD_Download,
                style: MyStyles.Medium(
                  12,
                  previewDocumentState.MediaDoc3 != null
                      ? myColor.text_color
                      : myColor.disablecolor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget Doc4View(PreviewDocumentState previewDocumentState) {
    return Container(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 200,
                  padding: EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    GlobleString.PD_doc4,
                    textAlign: TextAlign.center,
                    style: MyStyles.Medium(12, myColor.text_color),
                  ),
                ),
                previewDocumentState.MediaDoc4 != null
                    ? InkWell(
                        onTap: () {
                          if (previewDocumentState.MediaDoc4 != null) {
                            Helper.launchURL(
                                previewDocumentState.MediaDoc4!.url.toString());
                          }
                        },
                        child: Container(
                          width: 200,
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            Helper.FileName(
                                previewDocumentState.MediaDoc4!.url!),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: MyStyles.Medium(12, myColor.blue),
                          ),
                        ),
                      )
                    : Container(
                        width: 200,
                        padding: EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          GlobleString.PD_doc_NotApplicable,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: MyStyles.Medium(12, myColor.errorcolor),
                        ),
                      ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              if (previewDocumentState.MediaDoc4 != null) {
                Helper.launchURL(
                    previewDocumentState.MediaDoc4!.url.toString());
              }
            },
            child: Container(
              height: 30,
              width: 100,
              padding: EdgeInsets.only(left: 15, right: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                    color: previewDocumentState.MediaDoc4 != null
                        ? myColor.Circle_main
                        : myColor.disablecolor,
                    width: 1.5),
              ),
              child: Text(
                GlobleString.PD_Preview,
                style: MyStyles.Medium(
                    12,
                    previewDocumentState.MediaDoc4 != null
                        ? myColor.text_color
                        : myColor.disablecolor),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () async {
              if (previewDocumentState.MediaDoc4 != null &&
                  previewDocumentState.MediaDoc4!.url != null &&
                  previewDocumentState.MediaDoc4!.url != "") {
                // String filename = Helper.fileextension(
                //     "credit_record",
                //     previewDocumentState.MediaDoc4!.fileType,
                //     previewDocumentState.MediaDoc4!.url.toString());

                await Helper.download(
                    context,
                    previewDocumentState.MediaDoc4!.url.toString(),
                    previewDocumentState.MediaDoc4!.id.toString(),
                    Helper.FileNameWithTime(
                        previewDocumentState.MediaDoc4!.url!),
                    1);
              }
            },
            child: Container(
              height: 30,
              width: 100,
              padding: EdgeInsets.only(left: 15, right: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                    color: previewDocumentState.MediaDoc4 != null
                        ? myColor.Circle_main
                        : myColor.disablecolor,
                    width: 1.5),
              ),
              child: Text(
                GlobleString.PD_Download,
                style: MyStyles.Medium(
                    12,
                    previewDocumentState.MediaDoc4 != null
                        ? myColor.text_color
                        : myColor.disablecolor),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget TenantView(PreviewDocumentState previewDocumentState) {
    return Expanded(
      flex: 2,
      child: Container(
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            border: Border.all(color: myColor.TA_Border, width: 1.5),
            color: myColor.white),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                GlobleString.PD_TenantScoring,
                style: MyStyles.Medium(20, myColor.text_color),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                GlobleString.TA_General_Rating,
                style: MyStyles.Medium(14, myColor.text_color),
              ),
              SizedBox(
                height: 10,
              ),
              RatingBar.builder(
                initialRating: previewDocumentState.Rating,
                allowHalfRating: false,
                glow: false,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: myColor.blue,
                ),
                onRatingUpdate: (rating) {
                  _store.dispatch(UpdatePDRating(rating));
                },
                itemCount: 5,
                itemSize: 25.0,
                unratedColor: myColor.TA_Border,
                direction: Axis.horizontal,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.TA_Application_Status,
                        style: MyStyles.Medium(14, myColor.text_color),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 35,
                        width: 180,
                        // ignore: missing_required_param
                        child: DropdownSearch<SystemEnumDetails>(
                          mode: Mode.MENU,
                          items: statuslist,
                          textstyle: MyStyles.Medium(12, myColor.Circle_main),
                          itemAsString: (SystemEnumDetails? u) =>
                              u != null ? u.displayValue : "",
                          hint: "Select Status",
                          showSearchBox: false,
                          selectedItem:
                              previewDocumentState.ApplicationStatus != null
                                  ? previewDocumentState.ApplicationStatus
                                  : null,
                          isFilteredOnline: true,
                          onChanged: (data) {
                            _store.dispatch(UpdatePDApplicationStatus(data));
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.TA_Docs_Review_Status,
                        style: MyStyles.Medium(14, myColor.text_color),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 35,
                        width: 180,
                        // ignore: missing_required_param
                        child: DropdownSearch<SystemEnumDetails>(
                          mode: Mode.MENU,
                          items: reviewstatuslist,
                          textstyle: MyStyles.Medium(12, myColor.Circle_main),
                          itemAsString: (SystemEnumDetails? u) =>
                              u!.displayValue,
                          hint: "Unverified",
                          showSearchBox: false,
                          selectedItem:
                              previewDocumentState.DocReviewStatus != null
                                  ? previewDocumentState.DocReviewStatus
                                  : null,
                          isFilteredOnline: true,
                          onChanged: (data) {
                            _store.dispatch(UpdatePDDocReviewStatus(data));
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                GlobleString.Notes,
                style: MyStyles.Medium(14, myColor.text_color),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                textAlign: TextAlign.start,
                maxLines: 4,
                maxLength: 150,
                initialValue: previewDocumentState.RatingReview,
                style: MyStyles.Medium(12, myColor.text_color),
                decoration: InputDecoration(
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: myColor.TA_Border, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: myColor.TA_Border, width: 1.0),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    fillColor: myColor.white,
                    filled: true),
                onChanged: (value) {
                  _store.dispatch(UpdatePDRatingReview(value));
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      SavaData(previewDocumentState);
                    },
                    child: Container(
                      height: 35,
                      width: 80,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: myColor.Circle_main,
                      ),
                      child: Text(
                        GlobleString.TA_Save,
                        style: MyStyles.Medium(12, myColor.white),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  SavaData(PreviewDocumentState previewDocumentState) {
    if (previewDocumentState.Rating == 0) {
      ToastUtils.showCustomToast(
          context, GlobleString.TA_General_Rating_error, false);
    } else if (previewDocumentState.ApplicationStatus == null) {
      ToastUtils.showCustomToast(
          context, GlobleString.TA_Application_Status_error, false);
    }
    /*else if (previewDocumentState.DocReviewStatus == null) {
      ToastUtils.showCustomToast(
          context, GlobleString.TA_Docs_Review_Status_error, false);
    }*/
    else if (previewDocumentState.RatingReview == null ||
        previewDocumentState.RatingReview.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.TA_Additional_Notes_error, false);
    } else {
      if (previewDocumentState.ApplicationStatus!.EnumDetailID.toString() ==
          eApplicationStatus().ActiveTenent.toString()) {
        _dailogSetActiveTenant(previewDocumentState);
      } else {
        ApiCall(previewDocumentState);
      }
    }
  }

  _dailogSetActiveTenant(PreviewDocumentState previewDocumentState) async {
    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialogBox(
          title: GlobleString.activeTenant_msg,
          positiveText: GlobleString.activeTenant_yes,
          negativeText: GlobleString.activeTenant_NO,
          onPressedYes: () async {
            Navigator.of(context1).pop();

            await ApiManager().CheckTenantActiveOrNot(
                context,
                previewDocumentState.Prop_ID.toString(),
                previewDocumentState.ApplicantID.toString(),
                (status, responce) async {
              if (status) {
                ApiManager().updateTenancyStatusCount(context);
                ApiCall(previewDocumentState);
              } else {
                if (responce == "1") {
                  ToastUtils.showCustomToast(
                      context, GlobleString.already_active_tenant, false);
                } else {
                  ToastUtils.showCustomToast(context, responce, false);
                }
              }
            });
          },
          onPressedNo: () {
            Navigator.of(context1).pop();
          },
        );
      },
    );
  }

  ApiCall(PreviewDocumentState previewDocumentState) async {
    TenancyApplicationID updateid = new TenancyApplicationID();
    updateid.ID = widget.ApplicantionId;

    TenancyScoreApplicantIDVarification tav =
        new TenancyScoreApplicantIDVarification();
    tav.ID = widget.Applicantid;
    tav.Rating = previewDocumentState.Rating.toString();
    tav.Note = previewDocumentState.RatingReview;

    TenancyScoreVarification updatepojo = new TenancyScoreVarification();
    updatepojo.ApplicationStatus =
        previewDocumentState.ApplicationStatus!.EnumDetailID.toString();

    if (previewDocumentState.DocReviewStatus == null) {
      updatepojo.DocReviewStatus = "2";
    } else {
      updatepojo.DocReviewStatus =
          previewDocumentState.DocReviewStatus!.EnumDetailID.toString();
    }

    updatepojo.Applicant_ID = tav;

    await ApiManager().UpdateTenancyVarificationDoc(
        context, updateid, updatepojo, (status, responce) async {
      if (status) {
        widget._callbackYes();
      } else {}
    });
  }
}
