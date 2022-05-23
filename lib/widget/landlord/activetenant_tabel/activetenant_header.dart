import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

class ActiveTenantHeader extends StatefulWidget {
  final VoidCallback _callbackSortName;
  final VoidCallback _callbackSortProperty;
  final VoidCallback _callbackSortRating;
  final VoidCallback _callbackSortLeaseStartDate;
  final VoidCallback _callbackSortLeaseDuration;
  final VoidCallback _callbackSortAppStatus;

  ActiveTenantHeader({
    required VoidCallback onPressedSortName,
    required VoidCallback onPressedSortProperty,
    required VoidCallback onPressedSortRating,
    required VoidCallback onPressedSortLeaseStartDate,
    required VoidCallback onPressedSortLeaseDuration,
    required VoidCallback onPressedSortAppStatus,
  })  : _callbackSortName = onPressedSortName,
        _callbackSortProperty = onPressedSortProperty,
        _callbackSortRating = onPressedSortRating,
        _callbackSortLeaseStartDate = onPressedSortLeaseStartDate,
        _callbackSortLeaseDuration = onPressedSortLeaseDuration,
        _callbackSortAppStatus = onPressedSortAppStatus;

  @override
  _ActiveTenantHeaderState createState() => _ActiveTenantHeaderState();
}

class _ActiveTenantHeaderState extends State<ActiveTenantHeader> {
  double height = 0, width = 0;

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
    result.add(_headerTitleName(GlobleString.ATH_Applicant_Name));
    result.add(_headerPropertyName(GlobleString.ATH_Property_Name));
    result.add(_headerTitleRating(GlobleString.ATH_Rating));
    result.add(_headerLeaseStartDate(GlobleString.ATH_Lease_Start_Date));
    result.add(_headerLeaseDuration(GlobleString.ATH_Lease_Duration));
    result.add(_headerTitleStatus(GlobleString.ATH_Application_Status));
    result.add(_headerTitlePreview());
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

  Widget _headerPropertyName(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortProperty();
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

  Widget _headerTitleRating(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortRating();
      },
      child: Container(
        height: 40,
        width: width / 11,
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

  Widget _headerLeaseStartDate(String text) {
    return InkWell(
      onTap: () {
        //widget._callbackSortLeaseStartDate();
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
            /* Text(
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
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _headerLeaseDuration(String text) {
    return InkWell(
      onTap: () {
        //widget._callbackSortLeaseDuration();
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
            /* Flexible(
              child: Text(
                text,
                textAlign: TextAlign.start,
                style: MyStyles.SemiBold(12, myColor.text_color),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Image.asset(
              'assets/images/ic_sort.png',
              width: 12,
              height: 12,
              fit: BoxFit.contain,
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _headerTitleStatus(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortAppStatus();
      },
      child: Container(
        height: 40,
        width: width / 6.5,
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

  Widget _headerTitlePreview() {
    return Container(
      height: 40,
      width: width / 12,
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerRight,
      child: Text(
        "",
        textAlign: TextAlign.start,
        style: MyStyles.SemiBold(12, myColor.text_color),
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
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerRight,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.SemiBold(12, myColor.text_color),
      ),
    );
  }
}
