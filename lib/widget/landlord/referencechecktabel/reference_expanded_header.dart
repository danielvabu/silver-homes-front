import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

class ReferenceExpendedHeader extends StatefulWidget {
  final VoidCallback _callbackCheck;

  ReferenceExpendedHeader({
    required VoidCallback onPressedCehck,
  }) : _callbackCheck = onPressedCehck;

  @override
  _ReferenceExpendedHeaderState createState() =>
      _ReferenceExpendedHeaderState();
}

class _ReferenceExpendedHeaderState extends State<ReferenceExpendedHeader> {
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
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _headerRow(),
      ),
    );
  }

  List<Widget> _headerRow() {
    var result = <Widget>[];
    result.add(_headerName(GlobleString.RCH_ReferenceName));
    result.add(_headerRelationShip(GlobleString.RCH_Relationship));
    result.add(_headerPhoneNumber(GlobleString.RCH_Phone_Number));
    result.add(_headerEmail(GlobleString.RCH_Email));
    result.add(_headerSent(GlobleString.RCH_Sent));
    result.add(_headerReceived(GlobleString.RCH_Received));
    result.add(_headerTextWithWidth("", 160));
    result.add(_headerTextWithWidth1("", 50));
    return result;
  }

  Widget _headerTextWithWidth(String text, double widthv) {
    return Container(
      height: 40,
      width: widthv,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.SemiBold(12, myColor.text_color),
      ),
    );
  }

  Widget _headerTextWithWidth1(String text, double widthv) {
    return Container(
      height: 40,
      width: widthv,
      padding: EdgeInsets.only(left: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.SemiBold(12, myColor.text_color),
      ),
    );
  }

  Widget _headerName(String text) {
    return Container(
      height: 40,
      width: width / 8,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.SemiBold(12, myColor.text_color),
      ),
    );
  }

  Widget _headerRelationShip(String text) {
    return Container(
      height: 40,
      width: width / 10,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.SemiBold(12, myColor.text_color),
      ),
    );
  }

  Widget _headerPhoneNumber(String text) {
    return Container(
      height: 40,
      width: width / 10,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.SemiBold(12, myColor.text_color),
      ),
    );
  }

  Widget _headerEmail(String text) {
    return Container(
      height: 40,
      width: width / 8,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.SemiBold(12, myColor.text_color),
      ),
    );
  }

  Widget _headerSent(String text) {
    return Container(
      height: 40,
      width: width / 8,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.SemiBold(12, myColor.text_color),
      ),
    );
  }

  Widget _headerReceived(String text) {
    return Container(
      height: 40,
      width: width / 7,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.SemiBold(12, myColor.text_color),
      ),
    );
  }
}
