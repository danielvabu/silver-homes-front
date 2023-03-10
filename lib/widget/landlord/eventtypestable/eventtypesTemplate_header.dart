import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

class EventTypesTemplateHeader extends StatefulWidget {
  final VoidCallback _callbackSortEventTypes;
  final VoidCallback _callbackSortUnit;
  final VoidCallback _callbackSortCity;
  final VoidCallback _callbackSortCountry;
  final VoidCallback _callbackSortEventTypesType;
  final VoidCallback _callbackSortVacancy;
  final VoidCallback _callbackSortActiveInactive;
  final VoidCallback _callbackSortIsPublished;

  EventTypesTemplateHeader({
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
  _EventTypesTemplateHeaderState createState() =>
      _EventTypesTemplateHeaderState();
}

class _EventTypesTemplateHeaderState extends State<EventTypesTemplateHeader> {
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
    result.add(_headerTextEmpty(" ", 2));
    result.add(_headerTemplateName('Template Name', 25));
    result.add(_headerRelation('Relationship', 10));
    result.add(_headerDuration('Duration', 9));
    result.add(_headerTextAction('# of Questions', 18));
/*     result.add(_headerTextAction('Routing Logic', 9)); */
    result.add(_headerTextAction('Notifications', 20));
/*     result.add(_headerTextAction('Reconfirmations', 9)); */
    result.add(_headerTextEmpty("", 4));
    result.add(_headerTextEmpty(" ", 1));
    return result;
  }

  Widget _headerTextEmpty(String text, int porcent) {
    return Container(
      height: 40,
      width: parte * porcent,
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
        ],
      ),
    );
  }

  Widget _headerTemplateName(String text, int porcent) {
    return InkWell(
      onTap: () {
        widget._callbackSortEventTypes();
      },
      child: Container(
        height: 40,
        width: parte * porcent,
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

  Widget _headerRelation(String text, int porcent) {
    return InkWell(
      onTap: () {
        widget._callbackSortCity();
      },
      child: Container(
        height: 40,
        width: parte * porcent,
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

  Widget _headerDuration(String text, int porcent) {
    return InkWell(
      onTap: () {
        widget._callbackSortCountry();
      },
      child: Container(
        height: 40,
        width: parte * porcent,
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

  Widget _headerTextAction(String text, int porcent) {
    return InkWell(
      onTap: () {
        widget._callbackSortEventTypesType();
      },
      child: Container(
        height: 40,
        width: parte * porcent,
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
}
