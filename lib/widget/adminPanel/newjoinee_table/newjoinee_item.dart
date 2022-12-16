import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/entities/admin_class/db_tenant_owner_data.dart';

class NewJoineeItem extends StatefulWidget {
  List<DbTenantOwnerData> listdata;

  NewJoineeItem({
    required List<DbTenantOwnerData> listdata1,
  }) : listdata = listdata1;

  @override
  _NewJoineeItemState createState() => _NewJoineeItemState();
}

class _NewJoineeItemState extends State<NewJoineeItem> {
  double height = 0, width = 0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 230;

    return Container(
      width: width,
      height: height - 230,
      child: ListviewBuid(widget.listdata),
    );
  }

  Widget ListviewBuid(List<DbTenantOwnerData> listdata) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: myColor.TA_table_header,
        thickness: 0,
        height: 0,
      ),
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

  List<Widget> _tableData(DbTenantOwnerData model, int Index) {
    var result = <Widget>[];
    result.add(_datavalueID(model.id.toString()));
    result.add(_datavalueName(model.name!));
    result.add(_datavalueEmail(model.email!));
    return result;
  }

  Widget _datavalueID(String text) {
    return Container(
      height: 40,
      width: width / 14,
      padding: EdgeInsets.only(left: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueName(String text) {
    return Container(
      height: 40,
      width: width / 9,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.Medium(12, myColor.blue),
      ),
    );
  }

  Widget _datavalueEmail(String text) {
    return Container(
      height: 40,
      width: width / 7,
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
