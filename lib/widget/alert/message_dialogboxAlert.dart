import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

class MessageDialogBoxAlert extends StatefulWidget {
  final String title;
  final String buttontitle;
  final VoidCallback _callbackback;

  MessageDialogBoxAlert(
      {required String title,
      required String buttontitle,
      required VoidCallback onPressed})
      : title = title,
        buttontitle = buttontitle,
        _callbackback = onPressed;

  @override
  _MessageDialogBoxAlertState createState() => _MessageDialogBoxAlertState();
}

class _MessageDialogBoxAlertState extends State<MessageDialogBoxAlert> {
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
                minWidth: 800, maxWidth: 800, minHeight: 230, maxHeight: 230),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.white),
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      "assets/images/ic_alert.png",
                      //width: 70,
                      height: 35,
                      alignment: Alignment.center,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: MyStyles.SemiBold(20, myColor.text_color),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      widget._callbackback();
                    },
                    child: Container(
                      height: 35,
                      width: 90,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        color: myColor.Circle_main,
                      ),
                      child: Text(
                        widget.buttontitle,
                        style: MyStyles.Medium(14, myColor.white),
                      ),
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
