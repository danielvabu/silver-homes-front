import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

typedef CallbackCheck = void Function(bool check);

class DailogCheckReferenceHeader extends StatefulWidget {
  final CallbackCheck _callbackCheck;

  DailogCheckReferenceHeader({
    required CallbackCheck onPressedCehck,
  }) : _callbackCheck = onPressedCehck;

  @override
  _DailogCheckReferenceHeaderState createState() =>
      _DailogCheckReferenceHeaderState();
}

class _DailogCheckReferenceHeaderState
    extends State<DailogCheckReferenceHeader> {
  double height = 0, width = 0;
  bool ischeck = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width;

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
    //result.add(_headerCheckBox());
    result.add(_headerTitle(GlobleString.DCR_Reference_Name));
    result.add(_headerRelation(GlobleString.DCR_Relationship));
    result.add(_headerPhone(GlobleString.DCR_Phone_Number));
    result.add(_headerEmail(GlobleString.DCR_Email));
    result.add(_headerButton(""));
    return result;
  }

  Widget _headerCheckBox() {
    return Container(
      height: 40,
      width: 50,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Checkbox(
        activeColor: myColor.Circle_main,
        checkColor: myColor.white,
        value: ischeck,
        onChanged: (value) {
          ischeck = value!;
          widget._callbackCheck(value);
          setState(() {});
        },
      ),
    );
  }

  Widget _headerTitle(String text) {
    return Container(
      height: 40,
      width: 175,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.SemiBold(12, myColor.text_color),
      ),
    );
  }

  Widget _headerRelation(String text) {
    return Container(
      height: 40,
      width: 130,
      padding: EdgeInsets.only(left: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.SemiBold(12, myColor.text_color),
      ),
    );
  }

  Widget _headerPhone(String text) {
    return Container(
      height: 40,
      width: 120,
      padding: EdgeInsets.only(left: 20),
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
      width: 190,
      padding: EdgeInsets.only(left: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.SemiBold(12, myColor.text_color),
      ),
    );
  }

  Widget _headerButton(String text) {
    return Container(
      height: 40,
      width: 150,
      margin: EdgeInsets.only(left: 20),
      padding: EdgeInsets.only(left: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.SemiBold(12, myColor.text_color),
      ),
    );
  }
}
