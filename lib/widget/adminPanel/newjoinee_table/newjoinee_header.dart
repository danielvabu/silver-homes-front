import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

class NewJoineeHeader extends StatefulWidget {
  @override
  _NewJoineeHeaderState createState() => _NewJoineeHeaderState();
}

class _NewJoineeHeaderState extends State<NewJoineeHeader> {
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
    result.add(_headerTitleID(GlobleString.ADB_TNJ_ID));
    result.add(_headerTitleName(GlobleString.ADB_TNJ_Name));
    result.add(_headerTitleEmail(GlobleString.ADB_TNJ_Email));
    return result;
  }

  Widget _headerTitleID(String text) {
    return Container(
      height: 40,
      width: width / 14,
      padding: EdgeInsets.only(left: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.SemiBold(12, myColor.text_color),
      ),
    );
  }

  Widget _headerTitleName(String text) {
    return Container(
      height: 40,
      width: width / 9,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.SemiBold(12, myColor.text_color),
      ),
    );
  }

  Widget _headerTitleEmail(String text) {
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
