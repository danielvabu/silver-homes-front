import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/fontname.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/Landlord/inviteapplytable/dialog_invite_apply_header.dart';
import 'package:silverhome/widget/Landlord/inviteapplytable/dialog_invite_apply_item.dart';

class LeaseSendDialogbox extends StatefulWidget {
  final List<TenancyApplication> _tenancyleadlist;
  final VoidCallback _callbackSave;
  final VoidCallback _callbackClose;

  LeaseSendDialogbox({
    required List<TenancyApplication> tenancyleadlist,
    required VoidCallback onPressedSave,
    required VoidCallback onPressedClose,
  })  : _callbackSave = onPressedSave,
        _tenancyleadlist = tenancyleadlist,
        _callbackClose = onPressedClose;

  @override
  _LeaseSendDialogboxState createState() => _LeaseSendDialogboxState();
}

class _LeaseSendDialogboxState extends State<LeaseSendDialogbox> {
  final _store = getIt<AppStore>();

  //String htmlfileText;

  Uint8List? appfile;
  String appfileextension = "", filename = "";
  late OverlayEntry loader;

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
                BoxConstraints(minWidth: 950, maxWidth: 950, maxHeight: 850),
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
                                    top: 10, bottom: 5, left: 15, right: 15),
                                child: Text(
                                  GlobleString.DLS_SendLease,
                                  style:
                                      MyStyles.Medium(18, myColor.text_color),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  final String id =
                                      '__file_picker_web-file-input';
                                  var element =
                                      html.document.getElementById(id);
                                  if (element != null) {
                                    element.remove();
                                  }

                                  widget._callbackClose();
                                },
                                child: Icon(Icons.clear, size: 25),
                              )
                            ],
                          )
                        ],
                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 5, bottom: 5, left: 5, right: 5),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    GlobleString.DLS_SendLease_title,
                                    style:
                                        MyStyles.Medium(14, myColor.text_color),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                DailogInviteApplyHeader(
                                  name: GlobleString.DLS_Applicant_Name,
                                  phonenumber: GlobleString.DLS_Phone_Number,
                                  email: GlobleString.DLS_Email,
                                ),
                                DailogInviteApplyItem(
                                  onPressed: () {},
                                  listdata1: widget._tenancyleadlist,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    GlobleString.DLS_LeaseUpload_title,
                                    style:
                                        MyStyles.Medium(14, myColor.text_color),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        pickImage();
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
                                          GlobleString.DLS_LeaseUpload,
                                          style: MyStyles.Medium(
                                              14, myColor.Circle_main),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    filename == ""
                                        ? Text(
                                            "",
                                            style: MyStyles.Medium(
                                                12, myColor.blue),
                                            textAlign: TextAlign.start,
                                          )
                                        : Text(
                                            filename,
                                            style: MyStyles.Medium(
                                                12, myColor.blue),
                                            textAlign: TextAlign.start,
                                          ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    filename == ""
                                        ? Container()
                                        : InkWell(
                                            hoverColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () {
                                              appfile = null;
                                              appfileextension = "";
                                              filename = "";
                                              setState(() {});
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                "assets/images/ic_delete.png",
                                                height: 25,
                                                alignment: Alignment.center,
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    GlobleString.DLS_SendLease_email_title,
                                    style:
                                        MyStyles.Medium(14, myColor.text_color),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString.DLS_Subject,
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
                                                  GlobleString.DLS_Subject_msg,
                                                  style: MyStyles.Regular(
                                                      14, myColor.text_color),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  " {property name} - {Unit/Suite}-{Property Address}, {City}, {Province/State}, {Postal Code/Zip Code}",
                                                  style: MyStyles.Regular(
                                                      14, myColor.email_color),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        height: 1,
                                        color: myColor.mail_devider,
                                        margin: EdgeInsets.only(
                                            top: 20, bottom: 20),
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
                                                  text: '{tenant first name},',
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
                                          SizedBox(
                                            height: 25,
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text:
                                                  'Congratulations! I am reaching out to notify you that you have been awarded the tenancy at: ',
                                              style: MyStyles.Regular(
                                                  14, myColor.black),
                                              children: const <TextSpan>[
                                                TextSpan(
                                                  text:
                                                      '{property name} - {Unit/Suite}-{Property Address}, {City}, {Province/State}, {Postal Code/Zip Code}.',
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
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "Click the button below to see a copy of the lease agreement for your review and signature:",
                                            style: MyStyles.Regular(
                                                14, myColor.black),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
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
                                              "Access Lease",
                                              style: MyStyles.Regular(
                                                  14, myColor.white),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          RichText(
                                              text: TextSpan(
                                                  text:
                                                      "Let me know if you have any questions by emailing me at",
                                                  style: MyStyles.Regular(
                                                      14, myColor.black),
                                                  children: [
                                                TextSpan(
                                                    text:
                                                        " {landlord's email address}.",
                                                    style: MyStyles.Regular(14,
                                                        myColor.email_color))
                                              ])),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                              GlobleString.DLS_Preview,
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
                                              GlobleString.DLS_Back,
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
                                            validation();
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
                                              GlobleString.DLS_Send,
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
                )),
          ),
        ),
      ),
    );
  }

  validation() {
    if (appfile == null) {
      ToastUtils.showCustomToast(
          context, GlobleString.DLS_Document_lease_error, false);
    } else {
      ApiCallDocument();
    }
  }

  ApiCallDocument() {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().AddLeaseDocument(context, appfile!, filename,
        (status, responce) {
      if (status) {
        loader.remove();
        _callInviteWorkFlow(responce);
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
  }

  _callInviteWorkFlow(String mediaId) {
    LeaseSentWorkFlowReqtokens reqtokens = new LeaseSentWorkFlowReqtokens();

    for (int i = 0; i < widget._tenancyleadlist.length; i++) {
      TenancyApplication invitelead = widget._tenancyleadlist[i];
      reqtokens.Prop_ID = invitelead.propId.toString();
      reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
      reqtokens.Applicant_ID = invitelead.applicantId.toString();
      reqtokens.IsOwneruploaded = true;
      reqtokens.Media_ID = mediaId;
      reqtokens.Application_ID = invitelead.id.toString();
      reqtokens.AgreementSentDate = new DateFormat("yyyy-MM-dd HH:mm:ss")
          .format(DateTime.now())
          .toString();
      reqtokens.HostURL = Weburl.Email_URL;
      reqtokens.DbAppCode = Weburl.API_CODE;
    }

    LeaseSentWorkFlow leaseSentWorkFlow = new LeaseSentWorkFlow();
    leaseSentWorkFlow.workFlowId = Weburl.Leasesent_workflow.toString();
    leaseSentWorkFlow.reqtokens = reqtokens;

    String jsondata = jsonEncode(leaseSentWorkFlow);

    ApiManager().Emailworkflow(context, leaseSentWorkFlow, (error, responce) {
      if (error) {
        final String id = '__file_picker_web-file-input';
        var element = html.document.getElementById(id);
        if (element != null) {
          element.remove();
        }

        widget._callbackSave();
      } else {
        ToastUtils.showCustomToast(context, responce, false);
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
                          "assets/sample_leasesend.jpg",
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

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      if ((file.size / 1024) > 10240) {
        ToastUtils.showCustomToast(
            context, GlobleString.DLS_Document_Image_Size_error, false);
      } else if ((file.name.split('.').last).contains("pdf") ||
          (file.name.split('.').last).contains("PDF")) {
        appfile = null;
        appfileextension = "";

        appfileextension = "pdf";
        appfile = file.bytes;
        filename = file.name.toString();

        setState(() {});
      } else {
        ToastUtils.showCustomToast(
            context, GlobleString.DLS_Document_Image_error, false);
      }
    }
  }
}
