import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/widget/alert/alert_dialogbox.dart';

class DailogInviteApplyItem extends StatefulWidget {
  final VoidCallback _callbackback;
  List<TenancyApplication> listdata;

  DailogInviteApplyItem({
    required List<TenancyApplication> listdata1,
    required VoidCallback onPressed,
  })  : listdata = listdata1,
        _callbackback = onPressed;

  @override
  __DailogInviteApplyItemState createState() => __DailogInviteApplyItemState();
}

class __DailogInviteApplyItemState extends State<DailogInviteApplyItem> {
  double height = 0, width = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListviewBuid(widget.listdata),
    );
  }

  Widget ListviewBuid(List<TenancyApplication> listdata) {
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
      itemBuilder: (BuildContext ctxt, int Index) {
        return Column(
          children: [
            Container(
              height: 40,
              color: Index % 2 == 0 ? myColor.TA_dark : myColor.TA_light,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: _tableData(listdata[Index], Index, listdata.length),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _tableData(TenancyApplication model, int Index, int count) {
    var result = <Widget>[];
    result.add(_datavalueTitle(model.applicantName!, 150));
    result.add(_datavalueTitle(model.email!, 250));
    result.add(_datavalueTitle(
        model.mobileNumber != null && model.mobileNumber!.isNotEmpty ? model.dialCode! + " " + model.mobileNumber! : "", 150));
    result.add(count > 1 ? _datavalueDelete("assets/images/ic_delete.png", 30, Index) : _datavalueBlank(30));

    return result;
  }

  Widget _datavalueTitle(String text, double width1) {
    return Container(
      height: 40,
      width: width1,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueDelete(String iconData, double widthv, int Index) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.black45,
          useSafeArea: true,
          barrierDismissible: false,
          builder: (BuildContext context1) {
            return AlertDialogBox(
              title: GlobleString.dailog_remove_msg,
              positiveText: GlobleString.dailog_yes,
              negativeText: GlobleString.dailog_no,
              onPressedYes: () {
                removeData(Index);
                Navigator.of(context1).pop();
              },
              onPressedNo: () {
                Navigator.of(context1).pop();
              },
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        height: 40,
        width: widthv,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Image.asset(
          iconData,
          height: 20,
          //width: 20,
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }

  removeData(int Index) {
    widget.listdata.removeAt(Index);
    setState(() {});
  }

  Widget _datavalueBlank(double widthv) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(right: 10),
        height: 40,
        width: widthv,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}
