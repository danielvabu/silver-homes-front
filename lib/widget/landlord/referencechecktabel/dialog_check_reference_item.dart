import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/entities/lead_reference.dart';

typedef CallbackFillOut = void Function(int pos);

class DailogCheckReferenceItem extends StatefulWidget {
  final CallbackFillOut _callbackFillwount;
  List<LeadReference> listdata;

  DailogCheckReferenceItem({
    required List<LeadReference> listdata1,
    required CallbackFillOut onPressedFillOut,
  })  : listdata = listdata1,
        _callbackFillwount = onPressedFillOut;

  @override
  _DailogCheckReferenceItemState createState() =>
      _DailogCheckReferenceItemState();
}

class _DailogCheckReferenceItemState extends State<DailogCheckReferenceItem> {
  static List<String> statuslist = [];
  String statusValue = "";

  late ScrollController _scrollController;

  double height = 0, width = 0;

  @override
  void initState() {
    _scrollController = new ScrollController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: height - 280,
      child: ListviewBuid(widget.listdata),
    );
  }

  Widget ListviewBuid(List<LeadReference> listdata) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: myColor.TA_table_header,
        thickness: 0,
        height: 0,
      ),
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      key: UniqueKey(),
      itemCount: listdata.length,
      itemBuilder: (BuildContext ctxt, int Index) {
        return Column(
          children: [
            Container(
              height: 40,
              color: Index % 2 == 0 ? myColor.TA_dark : myColor.TA_light,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: _tableData(listdata[Index], Index),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _tableData(LeadReference model, int Index) {
    var result = <Widget>[];
    //result.add(_dataCheckBox());
    result.add(_datavalueTitle(model.referenceName!));
    result.add(_datavalueRelation(model.relationship!));
    result.add(_datavaluePhone(model.phoneNumber!));
    result.add(_datavalueEmail(model.toEmail!));
    result.add(_datavalueButton(model, Index));

    return result;
  }

  Widget _dataCheckBox() {
    return Container(
      height: 40,
      width: 50,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Checkbox(
        activeColor: myColor.Circle_main,
        checkColor: myColor.white,
        value: false,
        onChanged: (value) {},
      ),
    );
  }

  Widget _datavalueTitle(String text) {
    return Container(
      height: 40,
      width: 175,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueRelation(String text) {
    return Container(
      height: 40,
      width: 130,
      padding: EdgeInsets.only(left: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textAlign: TextAlign.start,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavaluePhone(String text) {
    return Container(
      height: 40,
      width: 120,
      padding: EdgeInsets.only(left: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textAlign: TextAlign.start,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueEmail(String text) {
    return Container(
      height: 40,
      width: 190,
      padding: EdgeInsets.only(left: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueButton(LeadReference model, int Index) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          widget._callbackFillwount(Index);
        },
        child: Container(
          height: 25,
          width: 120,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            color: myColor.Circle_main,
          ),
          child: Text(
            GlobleString.DCR_FillOut_Manually,
            style: MyStyles.Medium(12, myColor.white),
          ),
        ),
      ),
    );
  }
}
