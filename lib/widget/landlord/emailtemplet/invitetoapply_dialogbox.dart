import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
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
import 'package:silverhome/widget/Landlord/customewidget.dart';
import 'package:silverhome/widget/Landlord/inviteapplytable/dialog_invite_apply_header.dart';
import 'package:silverhome/widget/Landlord/inviteapplytable/dialog_invite_apply_item.dart';

class InviteToApplyDialogbox extends StatefulWidget {
  final List<TenancyApplication> _tenancyleadlist;
  final VoidCallback _callbackSave;
  final VoidCallback _callbackClose;
  List<Map> fields = [];

  InviteToApplyDialogbox({
    required List<TenancyApplication> tenancyleadlist,
    required VoidCallback onPressedSave,
    required VoidCallback onPressedClose,
  })  : _callbackSave = onPressedSave,
        _tenancyleadlist = tenancyleadlist,
        _callbackClose = onPressedClose;

  @override
  _InviteToApplyDialogboxState createState() => _InviteToApplyDialogboxState();
}

class _InviteToApplyDialogboxState extends State<InviteToApplyDialogbox> {
  final _store = getIt<AppStore>();
  HtmlEditorController controller = HtmlEditorController();
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
                BoxConstraints(minWidth: 950, maxWidth: 950, maxHeight: 700),
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
                                GlobleString.DIA_Invite_to_Apply,
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
                                name: GlobleString.DIA_Recipient_Name,
                                phonenumber: GlobleString.DIA_Phone_Number,
                                email: GlobleString.DIA_Email,
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
                                child: Row(
                                  children: [
                                    Text(GlobleString.DIA_R_Documents,
                                        style: MyStyles.SemiBold(
                                            20, myColor.Circle_main)),
                                    Text(
                                      GlobleString.Optional,
                                      style:
                                          MyStyles.Medium(10, myColor.optional),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  GlobleString.DIA_Invite_to_Apply_List,
                                  style:
                                      MyStyles.Medium(14, myColor.text_color),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              for (int i = 0; i < widget.fields.length; i++)
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Document #" + (i + 1).toString(),
                                      style: MyStyles.Medium(14, myColor.black),
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 500,
                                          child: TextFormField(
                                            textAlign: TextAlign.start,
                                            style: MyStyles.Regular(
                                                14, myColor.text_color),
                                            decoration: InputDecoration(
                                                //border: InputBorder.none,
                                                focusedBorder:
                                                    OutlineInputBorder(),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(width: 1.0),
                                                ),
                                                isDense: true,
                                                contentPadding:
                                                    const EdgeInsets.all(12),
                                                fillColor: myColor.white,
                                                filled: true),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                activeColor:
                                                    myColor.Circle_main,
                                                checkColor: myColor.white,
                                                value:
                                                    true, //tfAdditionalReferenceState.isAutherize,
                                                onChanged: (value) {
                                                  if (value == true) {}
                                                },
                                              ),
                                              const Text(GlobleString.Required),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                          child: GestureDetector(
                                            child: Icon(Icons.delete_outline),
                                            onTap: () {
                                              setState(() {
                                                widget.fields.removeAt(i);
                                              });

                                              // eventtypesState.overrrides
                                              //     .removeAt(i);
                                              // _store.dispatch(
                                              //     UpdateRentalSpaceList1(
                                              //         eventtypesState.overrrides));
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    Map doc1 = {"name": "", "required": true};
                                    widget.fields.add(doc1);
                                  });

                                  //_selectDate1(context, eventtypesState);
                                },
                                child: CustomeWidget.NewDoc(),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  GlobleString.DIA_Invite_to_Apply_title,
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
                                          GlobleString.DIA_Subject,
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
                                                GlobleString.DIA_Subject_msg,
                                                style: MyStyles.Regular(
                                                    14, myColor.black),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                " @propertyName - @Unit/Suite-@PropertyAddress, @City, @Province/State, @PostalCode/ZipCode",
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
                                    HtmlEditor(
                                      plugins: [
                                        SummernoteAtMention(

                                            //returns the dropdown items on mobile
                                            getSuggestionsMobile:
                                                (String value) {
                                              List<String> mentions = [
                                                'NameApplicant',
                                                'PropertyName',
                                                'PropertyAddress',
                                                'LandlordFirstName',
                                                'LandlordLastName',
                                                'City',
                                                'CompanyName'
                                              ];
                                              return mentions
                                                  .where((element) =>
                                                      element.contains(value))
                                                  .toList();
                                            },
                                            //returns the dropdown items on web
                                            mentionsWeb: [
                                              'NameApplicant',
                                              'PropertyName',
                                              'PropertyAddress',
                                              'LandlordFirstName',
                                              'LandlordLastName',
                                              'City',
                                              'CompanyName'
                                            ],
                                            onSelect: (String value) {
                                              print(value);
                                            }),
                                      ],
                                      htmlToolbarOptions:
                                          const HtmlToolbarOptions(
                                              // toolbarItemHeight: 10.0,

                                              toolbarPosition:
                                                  ToolbarPosition.belowEditor,
                                              toolbarType:
                                                  ToolbarType.nativeGrid),
                                      controller: controller, //required
                                      htmlEditorOptions: HtmlEditorOptions(
                                        initialText:
                                            "<p style='color:#1f1f1f'>Hi <span style='color:#5454ff'> @NameApplicant</span></p> <p style='color:#1f1f1f'> This is <span style='color:#5454ff'>@LandlordFirstName @LandlordLastname</span>. Click on the button below to access the tenant application form for: <span style='color:#5454ff'>@PropertyName</span> - <span style='color:#5454ff'>@Unit/Suite</span>-<span style='color:#5454ff'>@PropertyAddress</span>, <span style='color:#5454ff'>@City</span>,<span style='color:#5454ff'> @Province/State</span>, <span style='color:#5454ff'>@PostalCode/ZipCode</span>.<br><br><p style='style='color:#1f1f1f''>I will reach out to you once your application has been reviewed.</p><p style='color:#1f1f1f'>Thank you,</P><p style='color:#5454ff'>@landlordFirstname @landlordLastname</p><p style='color:#5454ff'>@CompanyName</p>",
                                        autoAdjustHeight: false,
                                        adjustHeightForKeyboard: false,

                                        //initalText: "text content initial, if any",
                                      ),
                                      otherOptions: OtherOptions(
                                        height: 400,
                                      ),
                                    ),
                                    // Column(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.start,
                                    //   crossAxisAlignment:
                                    //       CrossAxisAlignment.start,
                                    //   children: [
                                    //     RichText(
                                    //       text: TextSpan(
                                    //         text: 'Hi ',
                                    //         style: MyStyles.Regular(
                                    //             14, myColor.black),
                                    //         children: const <TextSpan>[
                                    //           TextSpan(
                                    //             text:
                                    //                 '{First name of the applicant}',
                                    //             style: TextStyle(
                                    //                 fontFamily:
                                    //                     FontName.avenirnext,
                                    //                 color: myColor.email_color,
                                    //                 fontWeight: FontWeight.w400,
                                    //                 fontSize: 14),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //     SizedBox(
                                    //       height: 25,
                                    //     ),
                                    //     RichText(
                                    //       text: TextSpan(
                                    //         text: 'This is ',
                                    //         style: MyStyles.Regular(
                                    //             14, myColor.black),
                                    //         children: const <TextSpan>[
                                    //           TextSpan(
                                    //             text:
                                    //                 '{landlord first name} {landlord last name}',
                                    //             style: TextStyle(
                                    //                 fontFamily:
                                    //                     FontName.avenirnext,
                                    //                 color: myColor.email_color,
                                    //                 fontWeight: FontWeight.w400,
                                    //                 fontSize: 14),
                                    //           ),
                                    //           TextSpan(
                                    //             text: '. ',
                                    //             style: TextStyle(
                                    //                 fontFamily:
                                    //                     FontName.avenirnext,
                                    //                 color: myColor.black,
                                    //                 fontWeight: FontWeight.w400,
                                    //                 fontSize: 14),
                                    //           ),
                                    //           TextSpan(
                                    //             text:
                                    //                 'Click on the button below to access the tenant application form for: ',
                                    //             style: TextStyle(
                                    //                 fontFamily:
                                    //                     FontName.avenirnext,
                                    //                 color: myColor.black,
                                    //                 fontWeight: FontWeight.w400,
                                    //                 fontSize: 14),
                                    //           ),
                                    //           TextSpan(
                                    //             text:
                                    //                 '{property name} - {Unit/Suite}-{Property Address}, {City}, {Province/State}, {Postal Code/Zip Code}.',
                                    //             style: TextStyle(
                                    //                 fontFamily:
                                    //                     FontName.avenirnext,
                                    //                 color: myColor.email_color,
                                    //                 fontWeight: FontWeight.w400,
                                    //                 fontSize: 14),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //     SizedBox(
                                    //       height: 20,
                                    //     ),
                                    //     Container(
                                    //       width: 156,
                                    //       height: 38,
                                    //       padding: EdgeInsets.only(
                                    //           left: 15, right: 15),
                                    //       alignment: Alignment.center,
                                    //       decoration: BoxDecoration(
                                    //         borderRadius: BorderRadius.all(
                                    //             Radius.circular(5)),
                                    //         color: myColor.Circle_main,
                                    //       ),
                                    //       child: Text(
                                    //         "Access Form",
                                    //         style: MyStyles.Regular(
                                    //             14, myColor.white),
                                    //       ),
                                    //     ),
                                    //     SizedBox(
                                    //       height: 20,
                                    //     ),

                                    //     SizedBox(
                                    //       height: 20,
                                    //     ),
                                    //     Text(
                                    //       "I will reach out to you once your application has been reviewed.",
                                    //       style: MyStyles.Regular(
                                    //           14, myColor.black),
                                    //       maxLines: 1,
                                    //       overflow: TextOverflow.ellipsis,
                                    //     ),
                                    //     SizedBox(
                                    //       height: 30,
                                    //     ),
                                    //     Text(
                                    //       "Thank you,",
                                    //       style: MyStyles.Regular(
                                    //           14, myColor.black),
                                    //       maxLines: 1,
                                    //       overflow: TextOverflow.ellipsis,
                                    //     ),
                                    //     SizedBox(
                                    //       height: 10,
                                    //     ),
                                    //     Text(
                                    //       "{landlord first name}{landlord last name}",
                                    //       style: MyStyles.Regular(
                                    //           14, myColor.email_color),
                                    //       maxLines: 1,
                                    //       overflow: TextOverflow.ellipsis,
                                    //     ),
                                    //     SizedBox(
                                    //       height: 2,
                                    //     ),
                                    //     Text(
                                    //       "{Company Name}",
                                    //       style: MyStyles.Regular(
                                    //           14, myColor.email_color),
                                    //       maxLines: 1,
                                    //       overflow: TextOverflow.ellipsis,
                                    //     ),
                                    //     SizedBox(
                                    //       height: 20,
                                    //     ),
                                    //     Row(
                                    //       children: [
                                    //         Text(
                                    //           "Powered by ",
                                    //           style: MyStyles.Regular(
                                    //               12, myColor.TA_Border),
                                    //           maxLines: 1,
                                    //           overflow: TextOverflow.ellipsis,
                                    //         ),
                                    //         Text(
                                    //           "silverhomes.ai",
                                    //           style: MyStyles.Regular(
                                    //               12, myColor.blue),
                                    //           maxLines: 1,
                                    //           overflow: TextOverflow.ellipsis,
                                    //         ),
                                    //       ],
                                    //     )
                                    //   ],
                                    // )
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
                                            GlobleString.DIA_Preview,
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
                                            GlobleString.DIA_Back,
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
                                          _callInviteWorkFlow();
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
                                            GlobleString.DIA_Send,
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

  _callInviteWorkFlow() {
    InviteWorkFlowReqtokens reqtokens = new InviteWorkFlowReqtokens();

    for (int i = 0; i < widget._tenancyleadlist.length; i++) {
      TenancyApplication invitelead = widget._tenancyleadlist[i];
      reqtokens.id = invitelead.id.toString();
      reqtokens.ToEmail = invitelead.email.toString();
      reqtokens.applicationSentDate = new DateFormat("yyyy-MM-dd HH:mm:ss")
          .format(DateTime.now())
          .toString();
      reqtokens.HostURL = Weburl.Email_URL;
      reqtokens.DbAppCode = Weburl.API_CODE;
    }

    InviteWorkFlow inviteWorkFlow = new InviteWorkFlow();
    inviteWorkFlow.workFlowId = Weburl.Lead_Invitation_workflow.toString();
    inviteWorkFlow.reqtokens = reqtokens;

    String jsondata = jsonEncode(inviteWorkFlow);

    ApiManager().Emailworkflow(context, inviteWorkFlow, (error, respoce) {
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
                                  GlobleString.DIA_Preview_email,
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
                          "assets/sample_invitetoapply.jpg",
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
