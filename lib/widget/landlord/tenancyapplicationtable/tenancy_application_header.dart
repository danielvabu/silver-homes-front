import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

typedef VoidCallbackAllCheck = void Function(bool val);

class TenancyApplicationHeader extends StatefulWidget {
  final VoidCallback _callbackSortName;
  final VoidCallback _callbackSortProperty;
  final VoidCallback _callbackSortRating;
  final VoidCallback _callbackSortDateSent;
  final VoidCallback _callbackSortDateReceive;
  final VoidCallback _callbackSortAppStatus;
  final VoidCallbackAllCheck _callbackAllCheckItem;

  TenancyApplicationHeader({
    required VoidCallback onPressedSortName,
    required VoidCallback onPressedSortProperty,
    required VoidCallback onPressedSortRating,
    required VoidCallback onPressedSortDateSent,
    required VoidCallback onPressedSortDateReceive,
    required VoidCallback onPressedSortAppStatus,
    required VoidCallbackAllCheck onPressedAllCheckItem,
  })  : _callbackSortName = onPressedSortName,
        _callbackSortProperty = onPressedSortProperty,
        _callbackSortRating = onPressedSortRating,
        _callbackSortDateSent = onPressedSortDateSent,
        _callbackSortDateReceive = onPressedSortDateReceive,
        _callbackSortAppStatus = onPressedSortAppStatus,
        _callbackAllCheckItem = onPressedAllCheckItem;

  @override
  _TenancyApplicationHeaderState createState() =>
      _TenancyApplicationHeaderState();
}

class _TenancyApplicationHeaderState extends State<TenancyApplicationHeader> {
  double height = 0, width = 0;
  bool ischeck = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 230;

    return columnHeader();
  }

  Widget columnHeader() {
    return Container(
      height: 40,
      color: myColor.TA_table_header,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _headerRow(),
      ),
    );
  }

  List<Widget> _headerRow() {
    var result = <Widget>[];
    result.add(_headerTitleName(GlobleString.ACH_Applicant_Name));
    result.add(_headerTitleName(GlobleString.ACH_Applicant_Group));
    result.add(_headerTitleProperty(GlobleString.ACH_Property_Name));
    result.add(_headerTitleRating(GlobleString.ACH_Rating));
    result.add(_headerTitleDateSent(GlobleString.ACH_Date_Sent));
    result.add(_headerTitleDateReceived(GlobleString.ACH_Date_Received));
    result.add(_headerTextStatus(GlobleString.ACH_Status));
    result.add(_headerTextAction(GlobleString.ACH_Action));
    result.add(_headerTextWithWidth("", 30));
    return result;
  }

  Widget _headerTitleName(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortName();
      },
      child: Container(
        height: 40,
        width: width / 7.5,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.start,
              style: MyStyles.SemiBold(12, myColor.text_color),
            ),
            SizedBox(
              width: 5,
            ),
            Image.asset(
              'assets/images/ic_sort.png',
              width: 12,
              height: 12,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerTitleProperty(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortProperty();
      },
      child: Container(
        height: 40,
        width: width / 7.5,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.start,
              style: MyStyles.SemiBold(12, myColor.text_color),
            ),
            SizedBox(
              width: 5,
            ),
            Image.asset(
              'assets/images/ic_sort.png',
              width: 12,
              height: 12,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerTitleRating(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortRating();
      },
      child: Container(
        height: 40,
        width: width / 9,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.start,
              style: MyStyles.SemiBold(12, myColor.text_color),
            ),
            SizedBox(
              width: 5,
            ),
            Image.asset(
              'assets/images/ic_sort.png',
              width: 12,
              height: 12,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerTitleDateSent(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortDateSent();
      },
      child: Container(
        height: 40,
        width: width / 7,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.start,
              style: MyStyles.SemiBold(12, myColor.text_color),
            ),
            SizedBox(
              width: 5,
            ),
            Image.asset(
              'assets/images/ic_sort.png',
              width: 12,
              height: 12,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerTitleDateReceived(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortDateReceive();
      },
      child: Container(
        height: 40,
        width: width / 6,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: MyStyles.SemiBold(12, myColor.text_color),
            ),
            SizedBox(
              width: 5,
            ),
            Image.asset(
              'assets/images/ic_sort.png',
              width: 12,
              height: 12,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerTextStatus(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortAppStatus();
      },
      child: Container(
        height: 40,
        width: width / 6,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: MyStyles.SemiBold(12, myColor.text_color),
            ),
            SizedBox(
              width: 5,
            ),
            Image.asset(
              'assets/images/ic_sort.png',
              width: 12,
              height: 12,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerTextAction(String text) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 40,
        padding: EdgeInsets.only(left: 20),
        alignment: Alignment.centerRight,
        child: Text(
          "",
          textAlign: TextAlign.end,
          style: MyStyles.SemiBold(12, myColor.text_color),
        ),
      ),
    );
  }

  Widget _headerTextWithWidth(String text, double widthv) {
    return Container(
      height: 40,
      width: widthv,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerRight,
      child: Text(
        text,
        textAlign: TextAlign.end,
        style: MyStyles.SemiBold(12, myColor.text_color),
      ),
    );
  }
}
