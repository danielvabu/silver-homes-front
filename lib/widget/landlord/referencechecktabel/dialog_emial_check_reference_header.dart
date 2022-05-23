import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

typedef CallbackCheck = void Function(bool check);

class DailogEmailCheckReferenceHeader extends StatefulWidget {
  final CallbackCheck _callbackCheck;
  final bool ischeck;

  DailogEmailCheckReferenceHeader({
    required CallbackCheck onPressedCehck,
    required bool ischeck,
  })  : _callbackCheck = onPressedCehck,
        ischeck = ischeck;

  @override
  _DailogEmailCheckReferenceHeaderState createState() =>
      _DailogEmailCheckReferenceHeaderState();
}

class _DailogEmailCheckReferenceHeaderState
    extends State<DailogEmailCheckReferenceHeader> {
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
    result.add(_headerCheckBox());
    result.add(_headerTitle(GlobleString.DCR_Reference_Name));
    result.add(_headerTitle(GlobleString.DCR_Relationship));
    result.add(_headerTitle(GlobleString.DCR_Phone_Number));
    result.add(_headerTitle(GlobleString.DCR_Email));
    ;
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
        value: widget.ischeck,
        onChanged: (value) {
          widget._callbackCheck(value!);
        },
      ),
    );
  }

  Widget _headerTitle(String text) {
    return Container(
      height: 40,
      width: 150,
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
