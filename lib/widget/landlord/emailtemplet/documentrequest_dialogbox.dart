import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/fontname.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/Landlord/inviteapplytable/dialog_invite_apply_header.dart';
import 'package:silverhome/widget/Landlord/inviteapplytable/dialog_invite_apply_item.dart';

class DocumentRequestDialogbox extends StatefulWidget {
  final List<TenancyApplication> _tenancyleadlist;
  final VoidCallback _callbackSave;
  final VoidCallback _callbackClose;

  DocumentRequestDialogbox({
    required List<TenancyApplication> tenancyleadlist,
    required VoidCallback onPressedSave,
    required VoidCallback onPressedClose,
  })  : _callbackSave = onPressedSave,
        _tenancyleadlist = tenancyleadlist,
        _callbackClose = onPressedClose;

  @override
  _DocumentRequestDialogboxState createState() =>
      _DocumentRequestDialogboxState();
}

class _DocumentRequestDialogboxState extends State<DocumentRequestDialogbox> {
  final _store = getIt<AppStore>();

  @override
  void initState() {
    apiManager();
    super.initState();
  }

  apiManager() async {
    await Prefs.init();
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
                BoxConstraints(minWidth: 950, maxWidth: 950, maxHeight: 720),
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
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 20, right: 20),
                              child: Text(
                                GlobleString.DDQ_Request_Documents,
                                style: MyStyles.Medium(18, myColor.text_color),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            InkWell(
                              onTap: () {
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
                    Container(
                      //height: 625,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 10, right: 10),
                          child: Column(
                            children: [
                              DailogInviteApplyHeader(
                                name: GlobleString.DDQ_Applicant_Name,
                                phonenumber: GlobleString.DDQ_Phone_Number,
                                email: GlobleString.DDQ_Email,
                              ),
                              DailogInviteApplyItem(
                                onPressed: () {},
                                listdata1: widget._tenancyleadlist,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  GlobleString.DDQ_Request_Documents_title,
                                  style:
                                      MyStyles.Medium(14, myColor.text_color),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          GlobleString.DDQ_Subject,
                                          style: MyStyles.Regular(
                                              14, myColor.TA_Border),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Text(
                                                GlobleString.DDQ_Subject_msg,
                                                style: MyStyles.Regular(
                                                    14, myColor.black),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                " {property name} - {Unit/Suite}-{Property Address}, {City}, {Province/State}, {Postal Code/Zip Code}",
                                                style: MyStyles.Regular(
                                                    14, myColor.email_color),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                text: '{First name of tenant}',
                                                style: TextStyle(
                                                    fontFamily:
                                                        FontName.avenirnext,
                                                    color: myColor.email_color,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14),
                                              ),
                                              TextSpan(
                                                text: '. ',
                                                style: TextStyle(
                                                    fontFamily:
                                                        FontName.avenirnext,
                                                    color: myColor.text_color,
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
                                            text:
                                                'Thank you for submitting your tenant application for: ',
                                            style: MyStyles.Regular(
                                                14, myColor.black),
                                            children: const <TextSpan>[
                                              TextSpan(
                                                text:
                                                    '{property name} - {Unit/Suite}-{Property Address}, {City}, {Province/State}, {Postal Code/Zip Code}.',
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
                                          height: 20,
                                        ),
                                        Text(
                                          "The next step will be for you to provide supporting documents as indicated in the following link.",
                                          style: MyStyles.Regular(
                                              14, myColor.black),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          width: 156,
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
                                            "Share Documents",
                                            style: MyStyles.Regular(
                                                14, myColor.white),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "I will reach out to you once your documents have been reviewed.",
                                          style: MyStyles.Regular(
                                              14, myColor.black),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          "Thank you,",
                                          style: MyStyles.Regular(
                                              14, myColor.black),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "{landlord first name} {landlord last name}",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  Row(
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
                                          _callWorkFlow();
                                          // widget._callbackSave();
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
                                  ),
                                ],
                              )
                            ],
                          ),
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

  _callWorkFlow() {
    DocRequestReqtokens reqtokens = new DocRequestReqtokens();

    for (int i = 0; i < widget._tenancyleadlist.length; i++) {
      TenancyApplication invitelead = widget._tenancyleadlist[i];
      reqtokens.id = invitelead.id.toString();
      reqtokens.ToEmail = invitelead.email.toString();
      reqtokens.docRequestSentDate = new DateFormat("yyyy-MM-dd HH:mm:ss")
          .format(DateTime.now())
          .toString();
      reqtokens.HostURL = Weburl.Email_URL;
      reqtokens.DbAppCode = Weburl.API_CODE;
    }

    DocRequestWorkFlow docRequestWorkFlow = new DocRequestWorkFlow();
    docRequestWorkFlow.workFlowId = Weburl.Document_Request_workflow.toString();
    docRequestWorkFlow.reqtokens = reqtokens;

    String jsondata = jsonEncode(docRequestWorkFlow);

    ApiManager().Emailworkflow(context, docRequestWorkFlow, (error, respoce) {
      if (error) {
        widget._callbackSave();
      } else {}
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
                          "assets/sample_docrequest.jpg",
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
