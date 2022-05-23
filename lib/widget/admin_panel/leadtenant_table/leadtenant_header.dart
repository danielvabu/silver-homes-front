import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

class LeadTenantHeader extends StatefulWidget {
  final VoidCallback _callbackSortID;
  final VoidCallback _callbackSortName;
  final VoidCallback _callbackSortEmail;
  final VoidCallback _callbackSortPhoneno;
  final VoidCallback _callbackSortRating;
  final VoidCallback _callbackSortStatus;
  final VoidCallback _callbackSortlandlordname;
  final VoidCallback _callbackSortProperty;

  LeadTenantHeader({
    required VoidCallback onPressedSortID,
    required VoidCallback onPressedSortName,
    required VoidCallback onPressedSortEmail,
    required VoidCallback onPressedSortPhoneno,
    required VoidCallback onPressedSortRating,
    required VoidCallback onPressedSortStatus,
    required VoidCallback onPressedSortlandlordname,
    required VoidCallback onPressedSortProperty,
  })  : _callbackSortID = onPressedSortID,
        _callbackSortName = onPressedSortName,
        _callbackSortEmail = onPressedSortEmail,
        _callbackSortPhoneno = onPressedSortPhoneno,
        _callbackSortRating = onPressedSortRating,
        _callbackSortStatus = onPressedSortStatus,
        _callbackSortlandlordname = onPressedSortlandlordname,
        _callbackSortProperty = onPressedSortProperty;

  @override
  _LeadTenantHeaderState createState() => _LeadTenantHeaderState();
}

class _LeadTenantHeaderState extends State<LeadTenantHeader> {
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
    result.add(_headerTitleID(GlobleString.ALT_ID));
    result.add(_headerTitleName(GlobleString.ALT_Tenant));
    result.add(_headerTitleEmail(GlobleString.ALT_Email));
    result.add(_headerTitlePhoneno(GlobleString.ALT_PhoneNumber));
    result.add(_headerTitleRating(GlobleString.ALT_Rating));
    result.add(_headerTitleApplicationStatus(GlobleString.ALT_Status));
    result.add(_headerTitleLandlordName(GlobleString.ALT_LandlordName));
    result.add(_headerTitleProperty(GlobleString.ALT_Property_Name));
    result.add(_headerTextAction(GlobleString.ACH_Action));

    return result;
  }

  Widget _headerTitleID(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortID();
      },
      child: Container(
        height: 40,
        width: width / 14,
        padding: EdgeInsets.only(left: 20),
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

  Widget _headerTitleName(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortName();
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

  Widget _headerTitleEmail(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortEmail();
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

  Widget _headerTitlePhoneno(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortPhoneno();
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

  Widget _headerTitleRating(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortRating();
      },
      child: Container(
        height: 40,
        width: width / 12,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerTitleApplicationStatus(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortStatus();
      },
      child: Container(
        height: 40,
        width: width / 8,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerTitleLandlordName(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortlandlordname();
      },
      child: Container(
        height: 40,
        width: width / 8,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
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
        width: width / 8,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
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
        padding: EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        child: Text(
          "",
          textAlign: TextAlign.end,
          style: MyStyles.SemiBold(12, myColor.text_color),
        ),
      ),
    );
  }
}
