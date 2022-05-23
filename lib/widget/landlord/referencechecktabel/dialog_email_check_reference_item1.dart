import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/entities/lead_reference.dart';

class DailogEmailCheckReferenceItem1 extends StatefulWidget {
  final VoidCallback _callbackCheck;
  List<LeadReference> listdata;

  DailogEmailCheckReferenceItem1({
    required List<LeadReference> listdata1,
    required VoidCallback onPressedCheck,
  })  : listdata = listdata1,
        _callbackCheck = onPressedCheck;

  @override
  _DailogEmailCheckReferenceItemState1 createState() =>
      _DailogEmailCheckReferenceItemState1();
}

class _DailogEmailCheckReferenceItemState1
    extends State<DailogEmailCheckReferenceItem1> {
  static List<String> statuslist = [];
  String statusValue = "";

  double height = 0, width = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: listviewBuid(widget.listdata),
    );
  }

  Widget listviewBuid(List<LeadReference> listdata) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: myColor.TA_table_header,
        thickness: 0,
        height: 0,
      ),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      key: UniqueKey(),
      itemCount: listdata.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return Column(
          children: [
            Container(
              height: 40,
              color: index % 2 == 0 ? myColor.TA_dark : myColor.TA_light,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: _tableData(listdata[index], index),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _tableData(LeadReference model, int index) {
    var result = <Widget>[];
    result.add(_dataCheckBox(model, index));
    result.add(_datavalueTitle(model.referenceName!));
    result.add(_datavalueTitle(model.relationship!));
    result.add(_datavalueTitle(model.phoneNumber!));
    result.add(_datavalueTitle(model.toEmail!));

    return result;
  }

  Widget _dataCheckBox(LeadReference model, int index) {
    return Container(
      height: 40,
      width: 50,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Checkbox(
        activeColor: myColor.Circle_main,
        checkColor: myColor.white,
        value: model.check,
        onChanged: (value) {
          widget.listdata[index].check = value;
          //setState(() {});
          widget._callbackCheck();
        },
      ),
    );
  }

  Widget _datavalueTitle(String text) {
    return Container(
      height: 40,
      width: 150,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }
}
