import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

class ScrollAlertDialogBox extends StatefulWidget {
  final String title;
  final String error;
  final String positiveText;
  final String negativeText;
  final VoidCallback _callbackYes;

  ScrollAlertDialogBox({
    required String title,
    required String error,
    required String positiveText,
    required String negativeText,
    required VoidCallback onPressedYes,
  })  : title = title,
        error = error,
        positiveText = positiveText,
        negativeText = negativeText,
        _callbackYes = onPressedYes;

  @override
  _ScrollAlertDialogBoxState createState() => _ScrollAlertDialogBoxState();
}

class _ScrollAlertDialogBoxState extends State<ScrollAlertDialogBox> {
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
                minWidth: 600, maxWidth: 600, minHeight: 500, maxHeight: 500),
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: MyStyles.SemiBold(20, myColor.text_color),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            widget.error,
                            textAlign: TextAlign.start,
                            style: MyStyles.SemiBold(20, myColor.text_color),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /* InkWell(
                          onTap: () {
                            widget._callbackNo();
                          },
                          child: Container(
                            height: 35,
                            width: 90,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: myColor.white,
                              border: Border.all(
                                  color: myColor.Circle_main, width: 1),
                            ),
                            child: Text(
                              widget.negativeText,
                              style: MyStyles.Medium(14, myColor.Circle_main),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),*/
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
                            widget.positiveText,
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
