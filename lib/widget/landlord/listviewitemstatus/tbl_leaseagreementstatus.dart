import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

import '../customewidget.dart';

class TBLLeaseAgreementStatus extends StatefulWidget {
  final VoidCallback _callbackicon;
  String sentdate1;
  String receivedate1;

  TBLLeaseAgreementStatus({
    required String sentdate,
    required String receivedate,
    required VoidCallback onPressedIcon,
  })  : _callbackicon = onPressedIcon,
        sentdate1 = sentdate,
        receivedate1 = receivedate;

  @override
  _TBLLeaseAgreementStatusState createState() =>
      _TBLLeaseAgreementStatusState();
}

class _TBLLeaseAgreementStatusState extends State<TBLLeaseAgreementStatus> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: myColor.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: myColor.TA_status_Border, width: 2),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
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
                    padding: EdgeInsets.only(left: 5),
                    child: Image.asset(
                      "assets/images/ic_fnl_leaseagree.png",
                      width: 20,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                SizedBox(
                  width: 4,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          GlobleString.FL_Lease_Agreement,
                          style: MyStyles.Medium(13, myColor.text_color),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(
                    widget.receivedate1 != null && widget.receivedate1 != ""
                        ? new DateFormat("dd-MMM")
                            .format(DateTime.parse(widget.receivedate1))
                            .toString()
                        : widget.sentdate1 != null && widget.sentdate1 != ""
                            ? new DateFormat("dd-MMM")
                                .format(DateTime.parse(widget.sentdate1))
                                .toString()
                            : "",
                    style: MyStyles.Regular(12, myColor.fnl_status_date),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            widget.receivedate1 != null && widget.receivedate1 != ""
                ? CustomeWidget.TBL_STATUS_RECEIVE()
                : widget.sentdate1 != null && widget.sentdate1 != ""
                    ? CustomeWidget.TBL_STATUS_SENT()
                    : CustomeWidget.TBL_STATUS_NOTSTART(),
          ],
        ),
      ),
    );
  }
}
