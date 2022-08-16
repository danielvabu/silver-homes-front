import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

class EventTypesHeader extends StatefulWidget {
  final VoidCallback _callbackSortCompanyName;
  final VoidCallback _callbackSortCity;
  final VoidCallback _callbackSortContactName;
  final VoidCallback _callbackSortEmail;
  final VoidCallback _callbackSortPhone;
  final VoidCallback _callbackSortCategory;
  final VoidCallback _callbackSortRating;

  EventTypesHeader({
    required VoidCallback onPressedSortCompanyName,
    required VoidCallback onPressedSortCity,
    required VoidCallback onPressedSortContactName,
    required VoidCallback onPressedSortEmail,
    required VoidCallback onPressedSortPhone,
    required VoidCallback onPressedSortCategory,
    required VoidCallback onPressedSortRating,
  })  : _callbackSortCompanyName = onPressedSortCompanyName,
        _callbackSortCity = onPressedSortCity,
        _callbackSortContactName = onPressedSortContactName,
        _callbackSortEmail = onPressedSortEmail,
        _callbackSortPhone = onPressedSortPhone,
        _callbackSortCategory = onPressedSortCategory,
        _callbackSortRating = onPressedSortRating;

  @override
  _EventTypesHeaderState createState() => _EventTypesHeaderState();
}

class _EventTypesHeaderState extends State<EventTypesHeader> {
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
    result.add(_headerCompanyName(GlobleString.LMV_CompanyName));
    result.add(_headerCity(GlobleString.LMV_City));
    result.add(_headerContactName(GlobleString.LMV_ContactName));
    result.add(_headerEmail(GlobleString.LMV_Email));
    result.add(_headerPhone(GlobleString.LMV_Phone));
    result.add(_headerCategory(GlobleString.LMV_Category));
    result.add(_headerRating(GlobleString.LMV_Rating));
    result.add(_headerTextAction(GlobleString.ACH_Action));
    return result;
  }

  Widget _headerCompanyName(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortCompanyName();
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

  Widget _headerCity(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortCity();
      },
      child: Container(
        height: 40,
        width: width / 10,
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

  Widget _headerContactName(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortContactName();
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

  Widget _headerEmail(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortEmail();
      },
      child: Container(
        height: 40,
        width: width / 5,
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

  Widget _headerPhone(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortPhone();
      },
      child: Container(
        height: 40,
        width: width / 10,
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

  Widget _headerCategory(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortCategory();
      },
      child: Container(
        height: 40,
        width: width / 10,
        //margin: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget _headerRating(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortRating();
      },
      child: Container(
        height: 40,
        width: width / 12,
        //margin: EdgeInsets.only(left: 10),
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
