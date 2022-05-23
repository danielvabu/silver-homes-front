import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

class ReferenceHeader extends StatefulWidget {
  final VoidCallback _callbackSortName;
  final VoidCallback _callbackSortProperty;
  final VoidCallback _callbackSortRating;
  final VoidCallback _callbackSortQuesSent;
  final VoidCallback _callbackSortQuesReceive;
  final VoidCallback _callbackSortAppStatus;
  final VoidCallback _callbackSortReferences;

  ReferenceHeader({
    required VoidCallback onPressedSortName,
    required VoidCallback onPressedSortProperty,
    required VoidCallback onPressedSortRating,
    required VoidCallback onPressedSortQuesSent,
    required VoidCallback onPressedSortQuesReceive,
    required VoidCallback onPressedSortAppStatus,
    required VoidCallback onPressedSortReferences,
  })  : _callbackSortName = onPressedSortName,
        _callbackSortProperty = onPressedSortProperty,
        _callbackSortRating = onPressedSortRating,
        _callbackSortQuesSent = onPressedSortQuesSent,
        _callbackSortQuesReceive = onPressedSortQuesReceive,
        _callbackSortAppStatus = onPressedSortAppStatus,
        _callbackSortReferences = onPressedSortReferences;

  @override
  _ReferenceHeaderState createState() => _ReferenceHeaderState();
}

class _ReferenceHeaderState extends State<ReferenceHeader> {
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
    result.add(_headerTitleName(GlobleString.RCH_Applicant_Name));
    result.add(_headerTitleProperty(GlobleString.RCH_Property_Name));
    result.add(_headerTitleRating(GlobleString.RCH_Rating));
    result.add(_headerTitleReferences(GlobleString.RCH_References));
    result.add(
        _headerTitleQuestionnairesSent(GlobleString.RCH_Questionnaires_Sent));
    result.add(_headerTitleQuestionnairesReceived(
        GlobleString.RCH_Questionnaires_Received));
    result.add(_headerStatus(GlobleString.RCH_Status));
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

  Widget _headerTitleReferences(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortReferences();
      },
      child: Container(
        height: 40,
        width: width / 8.5,
        padding: EdgeInsets.only(left: 10),
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

  Widget _headerTitleQuestionnairesSent(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortQuesSent();
      },
      child: Container(
        height: 40,
        width: width / 8.5,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.center,
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

  Widget _headerTitleQuestionnairesReceived(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortQuesReceive();
      },
      child: Container(
        height: 40,
        width: width / 8.5,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.center,
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

  Widget _headerStatus(String text) {
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
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerRight,
      child: Text(
        text,
        textAlign: TextAlign.end,
        style: MyStyles.SemiBold(12, myColor.text_color),
      ),
    );
  }
}
