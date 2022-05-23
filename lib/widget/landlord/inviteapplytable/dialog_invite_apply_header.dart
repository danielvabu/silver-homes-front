import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

class DailogInviteApplyHeader extends StatefulWidget {
  final String name;
  final String email;
  final String phonenumber;

  DailogInviteApplyHeader({
    required String name,
    required String email,
    required String phonenumber,
  })  : name = name,
        email = email,
        phonenumber = phonenumber;

  @override
  _DailogInviteApplyHeaderState createState() =>
      _DailogInviteApplyHeaderState();
}

class _DailogInviteApplyHeaderState extends State<DailogInviteApplyHeader> {
  double height = 0, width = 0;

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
    result.add(_headerTitle(widget.name, 150));
    result.add(_headerTitle(widget.email, 250));
    result.add(_headerTitle(widget.phonenumber, 150));
    result.add(_headerTitle1());
    ;
    return result;
  }

  Widget _headerTitle(String text, double width1) {
    return Container(
      height: 40,
      width: width1,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.SemiBold(12, myColor.text_color),
      ),
    );
  }

  Widget _headerTitle1() {
    return Container(
      height: 40,
      width: 30,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        "",
        textAlign: TextAlign.start,
        style: MyStyles.SemiBold(12, myColor.text_color),
      ),
    );
  }
}
