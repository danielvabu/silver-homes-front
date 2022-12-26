import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/fontname.dart';
import 'package:silverhome/domain/entities/LandlordProfile.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:webviewx/webviewx.dart';
import 'package:silverhome/common/globlestring.dart';
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
import 'package:silverhome/widget/Landlord/customewidget.dart';
import 'package:silverhome/widget/Landlord/inviteapplytable/dialog_invite_apply_header.dart';
import 'package:silverhome/widget/Landlord/inviteapplytable/dialog_invite_apply_item.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

class InviteToApplyDialogbox extends StatefulWidget {
  final List<TenancyApplication> _tenancyleadlist;
  final VoidCallback _callbackSave;
  final VoidCallback _callbackClose;
  List<RequestDocuments> fields = [];

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
  bool verlista = false;
  bool guardarlista = false;
  String listname = "";
  String idlista = '0';
  List<Map<String, dynamic>> items = [];
  List<TextEditingController> _controller = [];
  LandlordProfile? landlordProfile1;
  PropertyData? propertyData1;
  var selectvalue;
  late WebViewXController webviewController;
  HtmlEditorController controller = HtmlEditorController();
  @override
  void initState() {
    apiManager();
    traerlistas();
    traerdatalandlord();
    traerdataProperty();
    super.initState();
  }

  apiManager() async {
    await Prefs.init();
  }

  traerlistas() async {
    GetListDocuments querylist =
        GetListDocuments(Prefs.getString(PrefsName.OwnerID));
    // _store.dispatch(UpdateProperTytypeValue1([]));
    await ApiManager().getDocumentList(context, querylist, (status, errorlist) {
      if (status) {
        for (int i = 0; i < errorlist.length; i++) {
          items.add({"name": errorlist[i]["name"], "id": errorlist[i]["id"]});
        }
      } else {
        //  _store.dispatch(UpdateProperTytypeValue1([]));
      }
    });
  }

  traerlistasfields(String id) async {
    GetListDocumentsFields querylistfields = GetListDocumentsFields(id);
    // _store.dispatch(UpdateProperTytypeValue1([]));
    await ApiManager().getDocumentListFields(context, querylistfields,
        (status, errorlist) {
      if (status) {
        widget.fields.clear();
        _controller.clear();
        for (int i = 0; i < errorlist.length; i++) {
          RequestDocuments doc1 = RequestDocuments(
              name: errorlist[i]["name"],
              required: errorlist[i]["required"],
              application_id: widget._tenancyleadlist[0].id.toString(),
              owner_id: Prefs.getString(PrefsName.OwnerID));
          _controller.add(TextEditingController());
          widget.fields.add(doc1);
          _controller[i].text = errorlist[i]["name"];
        }
        setState(() {});
      } else {
        //  _store.dispatch(UpdateProperTytypeValue1([]));
      }
    });
  }

  traerdatalandlord() async {
    await ApiManager()
        .landlord_ProfileDSQCall(context, Prefs.getString(PrefsName.OwnerID),
            (error, respoce2, landlordProfile) {
      if (error) {
        // if (landlordProfile!.companylogo != null &&
        //     landlordProfile.companylogo!.id != null) {
        landlordProfile1 = landlordProfile;

        //   //CompanyLogo = landlordProfile.companylogo!.id.toString();
        // } else {
        //   //CompanyLogo = '1';
        // }
      } else {
        //loader.remove();
        ToastUtils.showCustomToast(context, respoce2, false);
      }
    });
  }

  traerdataProperty() async {
    String propId = widget._tenancyleadlist[0].propId.toString();
    await ApiManager().getPropertyDetails(context, propId,
        (status, responce, propertyData) async {
      if (status) {
        propertyData1 = propertyData;
      } else {}
    });
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
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Checkbox(
                                      activeColor: myColor.Circle_main,
                                      checkColor: myColor.white,
                                      value:
                                          verlista, //tfAdditionalReferenceState.isAutherize,
                                      onChanged: (value) {
                                        setState(() {
                                          verlista = value!;
                                        });
                                      },
                                    ),
                                    Text(
                                      GlobleString.DIA_Invite_to_Apply_ListDco,
                                      style: MyStyles.Medium(
                                          14, myColor.text_color),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              if (verlista == true)
                                Container(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      width: 400,
                                      child:
                                          DropdownButton<Map<String, dynamic>>(
                                        value: selectvalue,
                                        hint: Text(
                                            "Select documents request list"),
                                        items: items.map((item) {
                                          return DropdownMenuItem(
                                            value: item,
                                            child: Text(item['name']),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectvalue = value!;
                                          });
                                          traerlistasfields(
                                              value!["id"].toString());
                                          // Do something with the selected value
                                        },
                                      ),
                                    )),
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
                                            controller: _controller[i],
                                            onChanged: (value) {
                                              widget.fields[i].name = value;
                                            },
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
                                                value: widget.fields[i]
                                                    .required, //tfAdditionalReferenceState.isAutherize,
                                                onChanged: (value) {
                                                  setState(() {
                                                    widget.fields[i].required =
                                                        value!;
                                                  });
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
                                    RequestDocuments doc1 = RequestDocuments(
                                        name: "",
                                        required: false,
                                        application_id: widget
                                            ._tenancyleadlist[0].id
                                            .toString(),
                                        owner_id:
                                            Prefs.getString(PrefsName.OwnerID));
                                    widget.fields.add(doc1);
                                    _controller.add(TextEditingController());
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
                                child: Row(
                                  children: [
                                    Checkbox(
                                      activeColor: myColor.Circle_main,
                                      checkColor: myColor.white,
                                      value:
                                          guardarlista, //tfAdditionalReferenceState.isAutherize,
                                      onChanged: (value) {
                                        setState(() {
                                          guardarlista = value!;
                                        });
                                      },
                                    ),
                                    Text(
                                      GlobleString.DIA_Invite_to_save_ListDco,
                                      style: MyStyles.Medium(
                                          14, myColor.text_color),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              if (guardarlista == true)
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        GlobleString
                                            .DIA_Invite_to_save_ListDcore,
                                        style:
                                            MyStyles.Medium(14, myColor.black),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(height: 5.0),
                                      SizedBox(
                                        width: 500,
                                        child: TextFormField(
                                          onChanged: (value) {
                                            listname = value;
                                          },
                                          textAlign: TextAlign.start,
                                          style: MyStyles.Regular(
                                              14, myColor.text_color),
                                          decoration: InputDecoration(
                                              //border: InputBorder.none,
                                              focusedBorder:
                                                  OutlineInputBorder(),
                                              enabledBorder: OutlineInputBorder(
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
                                    ],
                                  ),
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
                                                'LandlordEmail',
                                                'LandlordPhonenumber',
                                                'LandlordCompanyName',
                                                'LandlordWebsite',
                                                'LandlordListingsPage',
                                                'CurrentDate',
                                                'propertyDescription',
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
                                              'LandlordEmail',
                                              'LandlordPhonenumber',
                                              'LandlordCompanyName',
                                              'LandlordWebsite',
                                              'LandlordListingsPage',
                                              'CurrentDate',
                                              'propertyDescription',
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
                                            "<p style='color:#1f1f1f'>Hi <span style='color:#5454ff'> @NameApplicant</span></p> <p style='color:#1f1f1f'> This is <span style='color:#5454ff'>@LandlordFirstName @LandlordLastName</span>. Click on the button below to access the tenant application form for: <span style='color:#5454ff'>@PropertyName</span>-<span style='color:#5454ff'>@PropertyAddress</span>.<br><br><p style='style='color:#1f1f1f''>I will reach out to you once your application has been reviewed.</p><p style='color:#1f1f1f'>Thank you,</P><p style='color:#5454ff'>@landlordFirstname @LandlordLastname</p><p style='color:#5454ff'>@LandlordCompanyName</p>",
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
                                        onTap: () async {
                                          String html =
                                              await controller.getText();
                                          previewEmailTemplate(html);
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

  _callInviteWorkFlow() async {
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
    ListDocuments listaobj = ListDocuments(
        name: listname, owner_id: Prefs.getString(PrefsName.OwnerID));
    //guardamos el nombre de la lista y retornamos el id
    if (guardarlista == true) {
      ApiManager().AddRequestDocumentList(context, listaobj,
          (error, responce) async {
        if (error) {
        } else {
          // loader.remove();
          ToastUtils.showCustomToast(context, responce, false);
        }

        idlista = responce;

// insertar fields
        for (int i = 0; i < widget.fields.length; i++) {
          RequestDocumentsFields fieldsguardarobj = RequestDocumentsFields(
              listdocument_id: idlista,
              name: widget.fields[i].name,
              required: widget.fields[i].required,
              owner_id: Prefs.getString(PrefsName.OwnerID));
          ApiManager().AddRequestDocumentFields(context, fieldsguardarobj,
              (error, responce) async {
            if (error) {
            } else {
              // loader.remove();
              ToastUtils.showCustomToast(context, responce, false);
            }
          });
        }
      });
    }
    //guardamos los campos de documentos a solicitar
    for (int i = 0; i < widget.fields.length; i++) {
      ApiManager().AddRequestDocument(context, widget.fields[i],
          (error, responce) async {
        if (error) {
        } else {
          // loader.remove();
          ToastUtils.showCustomToast(context, responce, false);
        }
      });
    }

    String templatehtml = await GenerateTemplate();
    var content = '''$templatehtml''';
    String encoded = base64Url.encode(utf8.encode(content));
    RequestHtml reqhtml = RequestHtml(
        htmltemplate: encoded,
        application_id: widget._tenancyleadlist[0].id.toString());
    ApiManager().AddRequestHtml(context, reqhtml, (error, responce) async {
      if (error) {
        ApiManager().Emailworkflow(context, inviteWorkFlow, (error, respoce) {
          if (error) {
            widget._callbackSave();
          } else {}
        });
      } else {
        // loader.remove();
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
  }

  void previewEmailTemplate(String html) async {
    String template1 = await GenerateTemplate();
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
                        child: WebViewX(
                          initialContent: template1,
                          initialSourceType: SourceType.html,
                          onWebViewCreated: (controller) =>
                              webviewController = controller,
                          height: 400,
                          width: 680,
                        ),
                        // child: Image.asset(
                        //   "assets/sample_invitetoapply.jpg",
                        //   height: 440,
                        // ),
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

  Future<String> GenerateTemplate() async {
    int idapplication = widget._tenancyleadlist[0].id!;
    DateTime dateToday =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    String propiedaddata = propertyData1!.propertyAddress! +
        "," +
        propertyData1!.suiteUnit! +
        "," +
        propertyData1!.city! +
        "," +
        propertyData1!.province! +
        "," +
        propertyData1!.country! +
        "," +
        propertyData1!.postalCode!;
    String propdesc = propertyData1!.propertyDescription!;
    String landfn = landlordProfile1!.firstname!;
    String landln = landlordProfile1!.lastname!;
    String landem = landlordProfile1!.email!;
    String landph = landlordProfile1!.phonenumber!;
    String landcn = landlordProfile1!.companyname!;
    String landlinkweb = landlordProfile1!.homepagelink!;
    String landllistweb = landlordProfile1!.CustomerFeatureListingURL!;
    String html = await controller.getText();
    String? html1 = html.replaceAll(
        '@NameApplicant', widget._tenancyleadlist[0].applicantName!);
    html1 = html1.replaceAll(
        '@PropertyName', widget._tenancyleadlist[0].propertyName!);
    //html1 = html1.replaceAll('@PropertyAddress', propiedaddata);
    html1 = html1.replaceAll('@CurrentDate', dateToday.toString());
    html1 = html1.replaceAll('@LandlordFirstName', landfn);
    html1 = html1.replaceAll('@LandlordLastName', landln);
    html1 = html1.replaceAll('@LandlordEmail', landem);
    html1 = html1.replaceAll('@LandlordPhonenumber', landph);
    html1 = html1.replaceAll('@LandlordCompanyName', landcn);
    html1 = html1.replaceAll('@LandlordWebsite', landlinkweb);
    html1 = html1.replaceAll('@LandlordListingsPage', landllistweb);
    html1 = html1.replaceAll('@PropertyAddress', propiedaddata);
    html1 = html1.replaceAll('@propertyDescription', propdesc);

    String html2 =
        '<br><p style="margin:15px;"><a href="http://localhost:51975/#/tenancy_application_form/$idapplication" style="padding:8px 20px;border:none;border-radius:5px;background-color:#010B32;color:white;text-decoration:none;">Click here to access the tenancy application</a></p>';
    String html0 =
        '<p><img src="https://danivargas.co/silverhome.png" width="277" border="0" /></p>';
    return html0 + html1 + html2;
  }
}
