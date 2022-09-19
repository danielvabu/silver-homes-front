import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

class EventTypesHeader extends StatefulWidget {
  final VoidCallback _callbackSortEventTypes;
  final VoidCallback _callbackSortUnit;
  final VoidCallback _callbackSortCity;
  final VoidCallback _callbackSortCountry;
  final VoidCallback _callbackSortEventTypesType;
  final VoidCallback _callbackSortVacancy;
  final VoidCallback _callbackSortActiveInactive;
  final VoidCallback _callbackSortIsPublished;

  EventTypesHeader({
    required VoidCallback onPressedSortEventTypes,
    required VoidCallback onPressedSortUnit,
    required VoidCallback onPressedSortCity,
    required VoidCallback onPressedSortCountry,
    required VoidCallback onPressedSortEventTypesType,
    required VoidCallback onPressedSortVacancy,
    required VoidCallback onPressedSortActiveInactive,
    required VoidCallback onPressedSortIsPublished,
  })  : _callbackSortEventTypes = onPressedSortEventTypes,
        _callbackSortUnit = onPressedSortUnit,
        _callbackSortCity = onPressedSortCity,
        _callbackSortCountry = onPressedSortCountry,
        _callbackSortEventTypesType = onPressedSortEventTypesType,
        _callbackSortVacancy = onPressedSortVacancy,
        _callbackSortActiveInactive = onPressedSortActiveInactive,
        _callbackSortIsPublished = onPressedSortIsPublished;

  @override
  _EventTypesHeaderState createState() => _EventTypesHeaderState();
}

class _EventTypesHeaderState extends State<EventTypesHeader> {
  double height = 0, width = 0, parte = 0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 230;
    parte = width / 100;
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
    result.add(_headerEventTypesName('Event Types Name'));
    result.add(_headerUnit('Property Name'));
    result.add(_headerCity('Relationship'));
    result.add(_headerCountry('Duration'));
    result.add(_headerEventTypesType('Scheduled Slots'));
    result.add(_headerVacancy('Publish'));
    result.add(_headerTextAction(' '));
    result.add(_headerTextAction(' '));
    return result;
  }

  Widget _headerEventTypesName(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortEventTypes();
      },
      child: Container(
        height: 40,
        width: parte * 25,
        margin: const EdgeInsets.only(left: 10),
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
            const SizedBox(width: 5.0),
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
        width: parte * 20,
        margin: const EdgeInsets.only(left: 10),
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
            const SizedBox(width: 5.0),
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
        width: parte * 10,
        margin: const EdgeInsets.only(left: 10),
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
            const SizedBox(width: 5.0),
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
        width: parte * 10,
        margin: const EdgeInsets.only(left: 10),
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
            const SizedBox(width: 5.0),
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

  Widget _headerEventTypesType(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortEventTypesType();
      },
      child: Container(
        height: 40,
        width: parte * 10,
        margin: const EdgeInsets.only(left: 10),
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
            const SizedBox(width: 5.0),
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
        width: parte * 10,
        margin: const EdgeInsets.only(left: 10),
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
            const SizedBox(width: 5.0),
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
        height: 20,
        margin: const EdgeInsets.only(left: 10, right: 20),
        alignment: Alignment.centerRight,
        child: const Text(""),
      ),
    );
  }
}
