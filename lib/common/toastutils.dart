import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silverhome/common/mycolor.dart';

import 'helper.dart';
import '../animation/toast_message_animation.dart';

class ToastUtils {
  static Timer? toastTimer;
  static late OverlayEntry _overlayEntry;

  static void showCustomToast(BuildContext context, String message, bool flag) {
    if (toastTimer == null || !toastTimer!.isActive) {
      _overlayEntry = createOverlayEntry(context, message, flag);
      Overlay.of(context)!.insert(_overlayEntry);
      toastTimer = Timer(Duration(seconds: 5), () {
        if (_overlayEntry != null) {
          _overlayEntry.remove();
        }
      });
    }
  }

  static OverlayEntry createOverlayEntry(
      BuildContext context, String message, bool flag) {
    final textStyle = TextStyle(fontSize: 18, color: Color(0xFFFFFFFF));

    final Size txtSize = Helper.textSize(message, textStyle);

    double widthmsg = txtSize.width + 100;
    return OverlayEntry(
      builder: (context) => Container(
        margin: EdgeInsets.only(top: 100),
        alignment: Alignment.topCenter,
        child: Material(
          elevation: 10.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: widthmsg > 900 ? 900 : widthmsg,
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: flag ? myColor.link_copy : Colors.redAccent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
            ),
            child: Row(
              children: [
                flag
                    ? Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 10),
                        width: 30,
                        height: 30,
                        child: Image.asset(
                          "assets/images/success.png",
                          width: 20,
                          height: 20,
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 10),
                        width: 30,
                        height: 30,
                        child: Image.asset(
                          "assets/images/error.png",
                          width: 25,
                          height: 25,
                        ),
                      ),
                const SizedBox(width: 10.0),
                Flexible(
                  child: Text(
                    message,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    maxLines: 6,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showCustomToastWithColor(
      BuildContext context, String message, Color mycolor) {
    if (toastTimer == null || !toastTimer!.isActive) {
      _overlayEntry = createOverlayEntryWithColor(context, message, mycolor);
      Overlay.of(context)!.insert(_overlayEntry);
      toastTimer = Timer(Duration(seconds: 5), () {
        if (_overlayEntry != null) {
          _overlayEntry.remove();
        }
      });
    }
  }

  static OverlayEntry createOverlayEntryWithColor(
      BuildContext context, String message, Color mycolor) {
    final textStyle = TextStyle(fontSize: 18, color: Color(0xFFFFFFFF));

    final Size txtSize = Helper.textSize(message, textStyle);

    double widthmsg = txtSize.width + 100;

    return OverlayEntry(
      builder: (context) => Container(
        margin: EdgeInsets.only(top: 100),
        alignment: Alignment.topCenter,
        child: Material(
          elevation: 10.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: widthmsg > 900 ? 900 : widthmsg,
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: mycolor,
              borderRadius: BorderRadius.circular(10),
              /* border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),*/
            ),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 10),
                  width: 30,
                  height: 30,
                  child: Image.asset(
                    "assets/images/success.png",
                    width: 20,
                    height: 20,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    message,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
