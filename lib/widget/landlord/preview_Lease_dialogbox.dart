import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/actions/landlord_action/preview_lease_actions.dart';
import 'package:silverhome/presentation/models/landlord_models/preview_lease_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';

class PreviewLeaseDialogBox extends StatefulWidget {
  final String ApplicantionId;
  final String Applicantid;
  final VoidCallback _callbackYes;
  final VoidCallback _callbackNo;
  final bool? ishide;

  PreviewLeaseDialogBox({
    required String ApplicantionId,
    required String Applicantid,
    required VoidCallback onPressedYes,
    required VoidCallback onPressedNo,
    bool? ishidebtn,
  })  : Applicantid = Applicantid,
        ApplicantionId = ApplicantionId,
        _callbackYes = onPressedYes,
        _callbackNo = onPressedNo,
        ishide = ishidebtn;

  @override
  _PreviewLeaseDialogBoxState createState() => _PreviewLeaseDialogBoxState();
}

class _PreviewLeaseDialogBoxState extends State<PreviewLeaseDialogBox> {
  double height = 0, width = 0;

  final _store = getIt<AppStore>();
  bool isloading = true;

  @override
  void initState() {
    apimanager();
    super.initState();
  }

  apimanager() async {
    await ClearAllState();

    ApiManager().PreviewLeaseAgreement(context, widget.ApplicantionId,
        (status, responce) async {
      if (status) {
        await ApiManager().PreviewLeaseAgreementDoc(
            context, widget.ApplicantionId, (status, responce) {
          updatemethod();
        });
      } else {
        Helper.Log("respoce", responce);
      }
    });
  }

  void updatemethod() {
    setState(() {
      isloading = false;
    });
  }

  ClearAllState() {
    _store.dispatch(UpdatePLApplicantID(""));
    _store.dispatch(UpdatePLApplicantionID(""));
    _store.dispatch(UpdatePLApplicationName(""));
    _store.dispatch(UpdatePLMIDDoc1(""));
    _store.dispatch(UpdatePLMediaInfo1(null));
    _store.dispatch(UpdatePLAgreementReceiveDate(""));
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
                minWidth: 800, maxWidth: 800, minHeight: 265, maxHeight: 265),
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
        : ConnectState<PreviewLeaseState>(
            map: (state) => state.previewLeaseState,
            where: notIdentical,
            builder: (previewLeaseState) {
              return Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.PL_Preview_Lease,
                        style: MyStyles.Medium(20, myColor.text_color),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        previewLeaseState!.applicationName +
                            GlobleString.PL_document_review,
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
                                        width: 150,
                                        padding: EdgeInsets.only(left: 10),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          GlobleString.PL_Document_Type,
                                          textAlign: TextAlign.center,
                                          style: MyStyles.SemiBold(
                                              12, myColor.text_color),
                                        ),
                                      ),
                                      Container(
                                        width: 300,
                                        padding: EdgeInsets.only(left: 10),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          GlobleString.PD_Attachment_Name,
                                          textAlign: TextAlign.center,
                                          style: MyStyles.SemiBold(
                                              12, myColor.text_color),
                                        ),
                                      ),
                                      Container(
                                        width: 150,
                                        padding: EdgeInsets.only(left: 20),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          GlobleString.PL_Date_Uploaded,
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
                                Doc1View(previewLeaseState),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        widget._callbackNo();
                                      },
                                      child: Container(
                                        height: 35,
                                        padding: EdgeInsets.only(
                                            left: 15, right: 15),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            border: Border.all(
                                                color: myColor.Circle_main,
                                                width: 1)),
                                        child: Text(
                                          GlobleString.PL_Close,
                                          style: MyStyles.Medium(
                                              14, myColor.Circle_main),
                                        ),
                                      ),
                                    ),
                                    if (widget.ishide == null)
                                      SizedBox(
                                        width: 10,
                                      ),
                                    if (widget.ishide == null)
                                      InkWell(
                                        onTap: () {
                                          widget._callbackYes();
                                        },
                                        child: Container(
                                          height: 35,
                                          padding: EdgeInsets.only(
                                              left: 15, right: 15),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color: myColor.Circle_main,
                                          ),
                                          child: Text(
                                            GlobleString.PL_Activate_Tenant,
                                            style: MyStyles.Medium(
                                                14, myColor.white),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ],
                            ),
                          ),
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

  Widget Doc1View(PreviewLeaseState previewLeaseState) {
    return Container(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 150,
                  padding: EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    GlobleString.PL_Lease_Agreement,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: MyStyles.Medium(12, myColor.text_color),
                  ),
                ),
                previewLeaseState.MediaDoc1 != null
                    ? InkWell(
                        onTap: () async {
                          Helper.launchURL(
                              previewLeaseState.MediaDoc1!.url.toString());
                        },
                        child: Container(
                          width: 300,
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            Helper.FileName(previewLeaseState.MediaDoc1!.url!),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: MyStyles.Medium(12, myColor.blue),
                          ),
                        ),
                      )
                    : Container(
                        width: 300,
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
                Container(
                  width: 150,
                  padding: EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    previewLeaseState.AgreementReceiveDate != null &&
                            previewLeaseState.AgreementReceiveDate != ""
                        ? new DateFormat("dd-MMM-yyyy")
                            .format(DateTime.parse(
                                previewLeaseState.AgreementReceiveDate))
                            .toString()
                        : "",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: MyStyles.Medium(12, myColor.text_color),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () async {
              if (previewLeaseState.MediaDoc1 != null &&
                  previewLeaseState.MediaDoc1!.url != null &&
                  previewLeaseState.MediaDoc1!.url != "") {
                await Helper.download(
                    context,
                    previewLeaseState.MediaDoc1!.url.toString(),
                    previewLeaseState.MediaDoc1!.id.toString(),
                    Helper.FileNameWithTime(previewLeaseState.MediaDoc1!.url!),
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
                    color: previewLeaseState.MediaDoc1 != null
                        ? myColor.Circle_main
                        : myColor.disablecolor,
                    width: 1.5),
              ),
              child: Text(
                GlobleString.PL_Download,
                style: MyStyles.Medium(
                  12,
                  previewLeaseState.MediaDoc1 != null
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
}
