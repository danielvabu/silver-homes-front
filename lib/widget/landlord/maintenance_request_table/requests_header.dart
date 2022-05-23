import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

class RequestsHeader extends StatefulWidget {
  final VoidCallback _callbackSortProperty;
  final VoidCallback _callbackSortRequestName;
  final VoidCallback _callbackSortCategory;
  final VoidCallback _callbackSortPriority;
  final VoidCallback _callbackSortDateCreated;
  final VoidCallback _callbackSortCreatedBy;
  final VoidCallback _callbackSortStatus;
  final VoidCallback _callbackSortLock;

  RequestsHeader({
    required VoidCallback onPressedSortProperty,
    required VoidCallback onPressedSortRequestName,
    required VoidCallback onPressedSortCategory,
    required VoidCallback onPressedSortPriority,
    required VoidCallback onPressedSortDateCreated,
    required VoidCallback onPressedSortCreatedBy,
    required VoidCallback onPressedSortStatus,
    required VoidCallback onPressedSortLock,
  })  : _callbackSortProperty = onPressedSortProperty,
        _callbackSortRequestName = onPressedSortRequestName,
        _callbackSortCategory = onPressedSortCategory,
        _callbackSortPriority = onPressedSortPriority,
        _callbackSortDateCreated = onPressedSortDateCreated,
        _callbackSortCreatedBy = onPressedSortCreatedBy,
        _callbackSortStatus = onPressedSortStatus,
        _callbackSortLock = onPressedSortLock;

  @override
  _RequestsHeaderState createState() => _RequestsHeaderState();
}

class _RequestsHeaderState extends State<RequestsHeader> {
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
    result.add(_headerPropertyName(GlobleString.LMR_Property_Name));
    result.add(_headerRequestName(GlobleString.LMR_RequestName));
    result.add(_headerCategory(GlobleString.LMR_Category));
    result.add(_headerPriority(GlobleString.LMR_Priority));
    result.add(_headerDateCreated(GlobleString.LMR_DateCreated));
    result.add(_headerCreatedBy(GlobleString.LMR_CreatedBy));
    result.add(_headerStatus(GlobleString.LMR_Status));
    result.add(_headerLock(GlobleString.LMR_Lock));
    result.add(_headerTextAction(GlobleString.ACH_Action));
    return result;
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

  Widget _headerRequestName(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortRequestName();
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

  Widget _headerCategory(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortCategory();
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

  Widget _headerPriority(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortPriority();
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

  Widget _headerDateCreated(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortDateCreated();
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

  Widget _headerCreatedBy(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortCreatedBy();
      },
      child: Container(
        height: 40,
        width: width / 9,
        margin: EdgeInsets.only(left: 10),
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

  Widget _headerStatus(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortStatus();
      },
      child: Container(
        height: 40,
        width: width / 7,
        margin: EdgeInsets.only(left: 0),
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

  Widget _headerLock(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortLock();
      },
      child: Container(
        height: 40,
        width: width / 12,
        margin: EdgeInsets.only(left: 10),
        alignment: Alignment.center,
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

  Widget _headerTextAction(String text) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 40,
        margin: EdgeInsets.only(left: 10, right: 20),
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
