import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/fontname.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/reference_check_dialog_actions.dart';
import 'package:silverhome/domain/entities/lead_reference.dart';
import 'package:silverhome/presentation/models/landlord_models/reference_check_dialog_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/Landlord/referencechecktabel/dialog_email_check_reference_item1.dart';
import 'package:silverhome/widget/Landlord/referencechecktabel/dialog_emial_check_reference_header.dart';

class ReferenceRequestDialogbox extends StatefulWidget {
  final List<LeadReference> _leadReferenceitems;
  final String applicantionId;
  final String applicantionname;
  final VoidCallback _callbackSave;
  final VoidCallback _callbackClose;

  ReferenceRequestDialogbox({
    required List<LeadReference> leadReferenceitems,
    required String applicantionId,
    required String applicantionname,
    required VoidCallback onPressedSave,
    required VoidCallback onPressedClose,
  })  : _callbackSave = onPressedSave,
        _leadReferenceitems = leadReferenceitems,
        applicantionId = applicantionId,
        applicantionname = applicantionname,
        _callbackClose = onPressedClose;

  @override
  _ReferenceRequestDialogboxState createState() =>
      _ReferenceRequestDialogboxState();
}

class _ReferenceRequestDialogboxState extends State<ReferenceRequestDialogbox> {
  final _store = getIt<AppStore>();

  @override
  void initState() {
    apiManager();
    super.initState();
  }

  apiManager() async {
    _store.dispatch(UpdateRCDLeadReferencelist(widget._leadReferenceitems));
  }

  @override
  Widget build(BuildContext context) {
    return _viewload();
  }

  Widget _viewload() {
    return Align(
      alignment: Alignment(0, 0),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minWidth: 800, maxWidth: 800, maxHeight: 850),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.white),
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 20, right: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      GlobleString.DCR_Check_References,
                                      style: MyStyles.Medium(
                                          18, myColor.text_color),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        GlobleString.DCR_Applicant,
                                        style: MyStyles.Medium(
                                            16, myColor.text_color),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        widget.applicantionname,
                                        style: MyStyles.Medium(
                                            16, myColor.text_color),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _store.dispatch(UpdateRCDisAllCheck(false));
                                widget._callbackClose();
                              },
                              child: Icon(Icons.clear, size: 25),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 10, right: 10),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                GlobleString.DCR_SendQuestion,
                                style: MyStyles.Medium(14, myColor.text_color),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ConnectState<ReferenceCheckDialogState>(
                                map: (state) => state.referenceCheckDialogState,
                                where: notIdentical,
                                builder: (RCDState) {
                                  return Column(
                                    children: [
                                      DailogEmailCheckReferenceHeader(
                                        onPressedCehck: (bool check) {
                                          for (int i = 0;
                                              i <
                                                  RCDState!
                                                      .leadReferencelist.length;
                                              i++) {
                                            RCDState.leadReferencelist[i]
                                                .check = check;
                                          }
                                          _store.dispatch(
                                              UpdateRCDLeadReferencelist(
                                                  RCDState.leadReferencelist));
                                          _store.dispatch(
                                              UpdateRCDisAllCheck(check));
                                        },
                                        ischeck: RCDState!.isAllCheck,
                                      ),
                                      DailogEmailCheckReferenceItem1(
                                        onPressedCheck: () {
                                          bool ischeck = true;
                                          for (var data in RCDState
                                              .leadReferencelist
                                              .toSet()) {
                                            if (!data.check!) {
                                              ischeck = false;
                                              break;
                                            }
                                          }
                                          _store.dispatch(
                                              UpdateRCDisAllCheck(ischeck));
                                        },
                                        listdata1: RCDState.leadReferencelist,
                                      ),
                                    ],
                                  );
                                }),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                GlobleString.DCR_Preview,
                                style: MyStyles.Medium(14, myColor.text_color),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: myColor.TA_Border, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(1)),
                              ),
                              padding: EdgeInsets.only(
                                  top: 20, bottom: 20, left: 20, right: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        GlobleString.DCR_Subject,
                                        style: MyStyles.Regular(
                                            14, myColor.TA_Border),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: GlobleString
                                                    .DCR_Subject_msg,
                                                style: MyStyles.Regular(
                                                    14, myColor.black),
                                                children: const <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        ' {Applicant First Name} {Applicant Last Name}',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            FontName.avenirnext,
                                                        color:
                                                            myColor.email_color,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    color: myColor.mail_devider,
                                    margin:
                                        EdgeInsets.only(top: 20, bottom: 20),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: 'Hi ',
                                          style: MyStyles.Regular(
                                              14, myColor.black),
                                          children: const <TextSpan>[
                                            TextSpan(
                                              text: '{reference first name}',
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontName.avenirnext,
                                                  color: myColor.email_color,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: 'My name is ',
                                          style: MyStyles.Regular(
                                              14, myColor.black),
                                          children: const <TextSpan>[
                                            TextSpan(
                                              text:
                                                  '{landlord first name}{landlord last name}',
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontName.avenirnext,
                                                  color: myColor.email_color,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14),
                                            ),
                                            TextSpan(
                                              text: '. Your former tenant,',
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontName.avenirnext,
                                                  color: myColor.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14),
                                            ),
                                            TextSpan(
                                              text:
                                                  '{applicant first name, applicant last name}, ',
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontName.avenirnext,
                                                  color: myColor.email_color,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14),
                                            ),
                                            TextSpan(
                                              text:
                                                  ' has included you as a reference as part of the tenancy application for a property that I am renting.',
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontName.avenirnext,
                                                  color: myColor.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "I would appreciate it if you could spare 2 minutes to complete a simple reference check questionnaire following the link below.",
                                        style:
                                            MyStyles.Regular(14, myColor.black),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width: 186,
                                        height: 38,
                                        padding: EdgeInsets.only(
                                            left: 15, right: 15),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          color: myColor.Circle_main,
                                        ),
                                        child: Text(
                                          "Access Questionnaire",
                                          style: MyStyles.Regular(
                                              14, myColor.white),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Thank you in advance for your time.",
                                        style:
                                            MyStyles.Regular(14, myColor.black),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        "Sincerely,",
                                        style:
                                            MyStyles.Regular(14, myColor.black),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "{landlord first name, landlord last name}",
                                        style: MyStyles.Regular(
                                            14, myColor.email_color),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "{Company Name}",
                                        style: MyStyles.Regular(
                                            14, myColor.email_color),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Powered by ",
                                            style: MyStyles.Regular(
                                                12, myColor.TA_Border),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            "silverhomes.ai",
                                            style: MyStyles.Regular(
                                                12, myColor.blue),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        previewEmailTemplate();
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
                                          GlobleString.DDQ_Preview,
                                          style: MyStyles.Medium(
                                              14, myColor.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ConnectState<ReferenceCheckDialogState>(
                                  map: (state) =>
                                      state.referenceCheckDialogState,
                                  where: notIdentical,
                                  builder: (RCDState) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            // Navigator.of(context).pop();
                                            widget._callbackClose();
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
                                              GlobleString.DDQ_Back,
                                              style: MyStyles.Medium(
                                                  14, myColor.Circle_main),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            bool ischeck = false;
                                            for (int i = 0;
                                                i <
                                                    RCDState!.leadReferencelist
                                                        .length;
                                                i++) {
                                              LeadReference lr =
                                                  RCDState.leadReferencelist[i];

                                              if (lr.check!) {
                                                ischeck = true;
                                                _callWorkFlow(RCDState);
                                                break;
                                              } else if (RCDState
                                                              .leadReferencelist
                                                              .length -
                                                          1 ==
                                                      i &&
                                                  !ischeck) {
                                                ToastUtils.showCustomToast(
                                                    context,
                                                    GlobleString
                                                        .DCR_select_reference,
                                                    false);
                                              }
                                            }
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
                                              GlobleString.DDQ_Send,
                                              style: MyStyles.Medium(
                                                  14, myColor.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _callWorkFlow(ReferenceCheckDialogState RCDState) {
    String persionid = "";

    for (int i = 0; i < RCDState.leadReferencelist.length; i++) {
      LeadReference lead = RCDState.leadReferencelist[i];
      if (lead.check!) {
        if (persionid == "") {
          persionid = lead.personId.toString();
        } else {
          persionid = persionid + "," + lead.personId.toString();
        }
      }
    }

    ReferenceRequestReqtokens reqtokens = new ReferenceRequestReqtokens();
    reqtokens.ID = widget.applicantionId;
    reqtokens.ReferenceRequestSentDate =
        new DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();
    reqtokens.PersonID = persionid;
    reqtokens.HostURL = Weburl.Email_URL;
    reqtokens.DbAppCode = Weburl.API_CODE;

    ReferenceRequestWorkFlow requestWorkFlow = new ReferenceRequestWorkFlow();
    requestWorkFlow.workFlowId = Weburl.Reference_Request_workflow.toString();
    requestWorkFlow.reqtokens = reqtokens;

    String jsondata = jsonEncode(requestWorkFlow);

    ApiManager().Emailworkflow(context, requestWorkFlow, (error, respoce) {
      if (error) {
        widget._callbackSave();
      } else {
        ToastUtils.showCustomToast(context, GlobleString.Error1, false);
      }
    });
  }

  void previewEmailTemplate() {
    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment(0, 0),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.all(30),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 700,
                  maxWidth: 700,
                  minHeight: 520,
                  maxHeight: 520,
                ),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      color: Colors.white),
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
                                child: Text(
                                  GlobleString.DDQ_Preview_email,
                                  style:
                                      MyStyles.Medium(18, myColor.text_color),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(Icons.clear, size: 25),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 680,
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        alignment: Alignment.topLeft,
                        child: Image.asset(
                          "assets/sample_reference.jpg",
                          height: 440,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
