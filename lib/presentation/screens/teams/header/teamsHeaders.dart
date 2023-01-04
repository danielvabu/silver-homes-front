import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

class TeamHeader extends StatefulWidget {
  final VoidCallback _callbackSortProperty;
  final VoidCallback _callbackSortUnit;
  final VoidCallback _callbackSortCity;
  final VoidCallback _callbackSortCountry;
  final VoidCallback _callbackSortPropertyType;
  final VoidCallback _callbackSortVacancy;
  final VoidCallback _callbackSortActiveInactive;
  final VoidCallback _callbackSortIsPublished;

  TeamHeader({
    required VoidCallback onPressedSortProperty,
    required VoidCallback onPressedSortUnit,
    required VoidCallback onPressedSortCity,
    required VoidCallback onPressedSortCountry,
    required VoidCallback onPressedSortPropertyType,
    required VoidCallback onPressedSortVacancy,
    required VoidCallback onPressedSortActiveInactive,
    required VoidCallback onPressedSortIsPublished,
  })  : _callbackSortProperty = onPressedSortProperty,
        _callbackSortUnit = onPressedSortUnit,
        _callbackSortCity = onPressedSortCity,
        _callbackSortCountry = onPressedSortCountry,
        _callbackSortPropertyType = onPressedSortPropertyType,
        _callbackSortVacancy = onPressedSortVacancy,
        _callbackSortActiveInactive = onPressedSortActiveInactive,
        _callbackSortIsPublished = onPressedSortIsPublished;

  @override
  _TeamHeaderState createState() => _TeamHeaderState();
}

class _TeamHeaderState extends State<TeamHeader> {
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
    result.add(_headerPropertyName("Team Memmber Name"));
    result.add(_headerUnit("Email"));
    result.add(_headerCity("Role"));
    result.add(_headerCountry("Date Activated"));
    result.add(_headerPropertyType("Last Logged in"));
    result.add(_headerVacancy("Active / Inactive"));
    /*result.add(_headerStatus(GlobleString.PH_Status));
    result.add(_headerActiveInactive(GlobleString.PH_Active_Inactive));
    result.add(_headerIsPublished(GlobleString.PH_IsPublished));
    result.add(_headerTextAction(GlobleString.ACH_Action));*/
    return result;
  }

  Widget _headerPropertyName(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortProperty();
      },
      child: Container(
        height: 40,
        width: width / 8,
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

  Widget _headerUnit(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortUnit();
      },
      child: Container(
        height: 40,
        width: width / 7,
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

  Widget _headerCity(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortCity();
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

  Widget _headerCountry(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortCountry();
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

  Widget _headerPropertyType(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortPropertyType();
      },
      child: Container(
        height: 40,
        width: width / 11,
        margin: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerVacancy(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortVacancy();
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

  Widget _headerStatus(String text) {
    return Container(
      height: 40,
      width: width / 14.5,
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.SemiBold(12, myColor.text_color),
      ),
    );
  }

  Widget _headerActiveInactive(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortActiveInactive();
      },
      child: Container(
        height: 40,
        width: width / 11,
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

  Widget _headerIsPublished(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortIsPublished();
      },
      child: Container(
        height: 40,
        width: width / 13,
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
