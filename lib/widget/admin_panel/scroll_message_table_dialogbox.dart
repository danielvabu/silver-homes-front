import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

class ScrollMessageTableDialogBox extends StatefulWidget {
  final String Title;
  final String Mandatory;
  final String Invalid;
  final VoidCallback _callbackYes;

  ScrollMessageTableDialogBox({
    required String Title,
    required String Mandatory,
    required String Invalid,
    required VoidCallback onPressedYes,
  })  : Title = Title,
        Mandatory = Mandatory,
        Invalid = Invalid,
        _callbackYes = onPressedYes;

  @override
  _ScrollMessageTableDialogBoxState createState() =>
      _ScrollMessageTableDialogBoxState();
}

class _ScrollMessageTableDialogBoxState
    extends State<ScrollMessageTableDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, 0),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: 600, maxWidth: 600, minHeight: 400, maxHeight: 400),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.white),
              padding:
                  EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.Title + "- More Information",
                    textAlign: TextAlign.center,
                    style: MyStyles.SemiBold(18, myColor.text_color),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "Mandatory",
                          textAlign: TextAlign.start,
                          style: MyStyles.SemiBold(16, myColor.black),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          "Invalid",
                          textAlign: TextAlign.start,
                          style: MyStyles.SemiBold(16, myColor.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.Mandatory,
                              textAlign: TextAlign.start,
                              style: MyStyles.Regular(15, myColor.text_color),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              widget.Invalid,
                              textAlign: TextAlign.start,
                              style: MyStyles.Regular(15, myColor.text_color),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          widget._callbackYes();
                        },
                        child: Container(
                          height: 35,
                          width: 90,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: myColor.Circle_main,
                            border: Border.all(
                                color: myColor.Circle_main, width: 1),
                          ),
                          child: Text(
                            GlobleString.admin_Member_OK,
                            style: MyStyles.Medium(14, myColor.white),
                          ),
                        ),
                      ),
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
