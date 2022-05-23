import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

import '../customewidget.dart';

class FNLLeaseAgreementStatus extends StatefulWidget {
  final VoidCallback _callbackicon;
  String sentdate1;
  String receivedate1;

  FNLLeaseAgreementStatus({
    required String sentdate,
    required String receivedate,
    required VoidCallback onPressedIcon,
  })  : _callbackicon = onPressedIcon,
        sentdate1 = sentdate,
        receivedate1 = receivedate;

  @override
  _FNLLeaseAgreementStatusState createState() =>
      _FNLLeaseAgreementStatusState();
}

class _FNLLeaseAgreementStatusState extends State<FNLLeaseAgreementStatus> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            widget._callbackicon();
          },
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Image.asset(
              "assets/images/ic_fnl_leaseagree.png",
              width: 20,
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: InkWell(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              widget._callbackicon();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  GlobleString.FL_Lease_Agreement,
                  style: MyStyles.Medium(13, myColor.text_color),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  widget.receivedate1 != null && widget.receivedate1 != ""
                      ? new DateFormat("dd-MMM")
                          .format(DateTime.parse(widget.receivedate1))
                          .toString()
                      : widget.sentdate1 != null && widget.sentdate1 != ""
                          ? new DateFormat("dd-MMM")
                              .format(DateTime.parse(widget.sentdate1))
                              .toString()
                          : "",
                  style: MyStyles.Medium(11, myColor.fnl_status_date),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
        widget.receivedate1 != null && widget.receivedate1 != ""
            ? CustomeWidget.FNL_STATUS_RECEIVE()
            : widget.sentdate1 != null && widget.sentdate1 != ""
                ? CustomeWidget.FNL_STATUS_SENT()
                : CustomeWidget.FNL_STATUS_NOTSTART(),
      ],
    );
  }
}
