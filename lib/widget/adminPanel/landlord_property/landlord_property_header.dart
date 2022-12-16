import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

class LandLordPropertyHeader extends StatefulWidget {
  final VoidCallback _callbackSortProperty;
  final VoidCallback _callbackSortUnit;
  final VoidCallback _callbackSortCity;
  final VoidCallback _callbackSortCountry;
  final VoidCallback _callbackSortPropertyType;
  final VoidCallback _callbackSortVacancy;
  final VoidCallback _callbackSortTenantName;
  final VoidCallback _callbackSortActiveInactive;

  LandLordPropertyHeader({
    required VoidCallback onPressedSortProperty,
    required VoidCallback onPressedSortUnit,
    required VoidCallback onPressedSortCity,
    required VoidCallback onPressedSortCountry,
    required VoidCallback onPressedSortPropertyType,
    required VoidCallback onPressedSortVacancy,
    required VoidCallback onPressedSortTenantName,
    required VoidCallback onPressedSortActiveInactive,
  })  : _callbackSortProperty = onPressedSortProperty,
        _callbackSortUnit = onPressedSortUnit,
        _callbackSortCity = onPressedSortCity,
        _callbackSortCountry = onPressedSortCountry,
        _callbackSortPropertyType = onPressedSortPropertyType,
        _callbackSortVacancy = onPressedSortVacancy,
        _callbackSortTenantName = onPressedSortTenantName,
        _callbackSortActiveInactive = onPressedSortActiveInactive;

  @override
  _LandLordPropertyHeaderState createState() => _LandLordPropertyHeaderState();
}

class _LandLordPropertyHeaderState extends State<LandLordPropertyHeader> {
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
    //result.add(_headerPropertyID(GlobleString.ALLD_PH_Property_ID));
    result.add(_headerPropertyName(GlobleString.ALLD_PH_Property_Name));
    result.add(_headerUnit(GlobleString.ALLD_PH_Unit));
    result.add(_headerCity(GlobleString.ALLD_PH_City));
    result.add(_headerCountry(GlobleString.ALLD_PH_Country));
    result.add(_headerPropertyType(GlobleString.ALLD_PH_Property_Type));
    result.add(_headerVacancy(GlobleString.ALLD_PH_Vacancy));
    result.add(_headerApplicantName(GlobleString.ALLD_PH_Applicantname));
    result.add(_headerStatus(GlobleString.ALLD_PH_Status));
    result.add(_headerActiveInactive(GlobleString.ALLD_PH_Active_Inactive));
    result.add(_headerTextAction(""));
    return result;
  }

  Widget _headerPropertyID(String text) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 40,
        width: width / 16,
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

  Widget _headerPropertyName(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortProperty();
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

  Widget _headerUnit(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortUnit();
      },
      child: Container(
        height: 40,
        width: width / 12,
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

  Widget _headerCountry(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortCountry();
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

  Widget _headerApplicantName(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortTenantName();
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
      width: width / 18,
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.center,
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

  Widget _headerTextAction(String text) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 40,
        width: 30,
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
