import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/entities/lead_reference.dart';
import 'package:silverhome/widget/Landlord/referencechecktabel/dialog_check_reference_header.dart';
import 'package:silverhome/widget/Landlord/referencechecktabel/dialog_check_reference_item.dart';

import '../customewidget.dart';

class CheckReferenceListDialog extends StatefulWidget {
  final VoidCallback _callbackClose;
  final List<LeadReference> referencelist;
  final String applicantionname;

  CheckReferenceListDialog({
    required VoidCallback onPressedClose,
    required String applicantionname,
    required List<LeadReference> referencelist,
  })  : _callbackClose = onPressedClose,
        referencelist = referencelist,
        applicantionname = applicantionname;

  @override
  _CheckReferenceListDialogState createState() =>
      _CheckReferenceListDialogState();
}

class _CheckReferenceListDialogState extends State<CheckReferenceListDialog> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Align(
      alignment: Alignment(0, 0),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 850,
              maxWidth: 850,
              minHeight: double.parse(
                  ((widget.referencelist.length * 40) + 205).toString()),
              maxHeight: double.parse(
                  ((widget.referencelist.length * 40) + 205).toString()),
            ),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.white),
              padding:
                  EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          GlobleString.DCR_Check_References,
                          style: MyStyles.Medium(18, myColor.text_color),
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
                            style: MyStyles.Medium(16, myColor.text_color),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            widget.applicantionname,
                            style: MyStyles.Medium(16, myColor.text_color),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          GlobleString.DCR_Select_the_reference,
                          style: MyStyles.Medium(14, myColor.text_color),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: double.parse(
                            ((widget.referencelist.length * 40) + 40)
                                .toString()),
                        child: Column(
                          children: [
                            DailogCheckReferenceHeader(
                              onPressedCehck: (bool check) {},
                            ),
                            Expanded(
                              child: DailogCheckReferenceItem(
                                listdata1: widget.referencelist,
                                onPressedFillOut: (int pos) {
                                  widget._callbackClose();
                                  CustomeWidget.FillQuestion(
                                      context,
                                      widget.referencelist[pos].referenceId
                                          .toString());
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
