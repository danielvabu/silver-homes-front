import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

class CheckReferenceConfirmDialog extends StatefulWidget {
  final VoidCallback _callbackSendQuestionnaire;
  final VoidCallback _callbackFillOutManually;
  final VoidCallback _callbackClose;

  CheckReferenceConfirmDialog({
    required VoidCallback onPressedSendQuestionnaire,
    required VoidCallback onPressedFillOutManually,
    required VoidCallback onPressedClose,
  })  : _callbackSendQuestionnaire = onPressedSendQuestionnaire,
        _callbackFillOutManually = onPressedFillOutManually,
        _callbackClose = onPressedClose;

  @override
  _CheckReferenceConfirmDialogState createState() =>
      _CheckReferenceConfirmDialogState();
}

class _CheckReferenceConfirmDialogState
    extends State<CheckReferenceConfirmDialog> {
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
                minWidth: 350, maxWidth: 350, minHeight: 140, maxHeight: 140),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  color: Colors.white),
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(),
                      InkWell(
                        onTap: () {
                          widget._callbackClose();
                        },
                        child: Icon(Icons.clear, size: 25),
                      )
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            GlobleString.DCR_Check_References,
                            style: MyStyles.Medium(18, myColor.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            GlobleString.DCR_Would_you_liketo,
                            style: MyStyles.Medium(14, myColor.text_color),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                widget._callbackSendQuestionnaire();
                              },
                              child: Container(
                                height: 30,
                                padding: EdgeInsets.only(left: 15, right: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2)),
                                  color: myColor.Circle_main,
                                ),
                                child: Text(
                                  GlobleString.DCR_Send_Questionnaire,
                                  style: MyStyles.Medium(12, myColor.white),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                widget._callbackFillOutManually();
                              },
                              child: Container(
                                height: 30,
                                padding: EdgeInsets.only(left: 15, right: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2)),
                                    border: Border.all(
                                        color: myColor.Circle_main, width: 1)),
                                child: Text(
                                  GlobleString.DCR_FillOut_Manually,
                                  style:
                                      MyStyles.Medium(12, myColor.Circle_main),
                                ),
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
