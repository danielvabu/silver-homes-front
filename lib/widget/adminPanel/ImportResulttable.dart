import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/entities/bulk_property.dart';
import 'package:silverhome/widget/adminPanel/scroll_message_table_dialogbox.dart';

class ImportResulttable extends StatefulWidget {
  List<BulkProperty> responcelist;

  ImportResulttable({
    required List<BulkProperty> responcelist1,
  }) : this.responcelist = responcelist1;

  @override
  _ImportResulttableState createState() => _ImportResulttableState();
}

class _ImportResulttableState extends State<ImportResulttable> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      height: 270,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: Column(
        children: [
          ColumnHeader(),
          SizedBox(
            height: 2,
            child: Container(color: Colors.black12),
          ),
          ColumnCenter(widget.responcelist),
        ],
      ),
    );
  }

  Widget ColumnHeader() {
    return Container(
      height: 40,
      color: myColor.Circle_main,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _headerRow(),
      ),
    );
  }

  List<Widget> _headerRow() {
    var result = <Widget>[];
    result.add(_headerNo("No."));
    result.add(_headerName("Name"));
    result.add(_headerMandatory("Mandatory"));
    result.add(_headerInvalid("Invalid"));
    result.add(_headerIcon());
    return result;
  }

  Widget _headerNo(String text) {
    return Container(
      height: 40,
      width: 40,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: MyStyles.Medium(13, myColor.white),
      ),
    );
  }

  Widget _headerName(String text) {
    return Container(
      height: 35,
      width: 150,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.Medium(13, myColor.white),
      ),
    );
  }

  Widget _headerMandatory(String text) {
    return Container(
      height: 35,
      width: 200,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.Medium(13, myColor.white),
      ),
    );
  }

  Widget _headerInvalid(String text) {
    return Container(
      height: 35,
      width: 200,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.Medium(13, myColor.white),
      ),
    );
  }

  Widget _headerIcon() {
    return Container(
      height: 40,
      width: 50,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        "",
        textAlign: TextAlign.center,
        style: MyStyles.Medium(13, myColor.white),
      ),
    );
  }

  Widget ColumnCenter(List<BulkProperty> responcelist) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: 240,
          child: ListView.separated(
              key: UniqueKey(),
              itemCount: responcelist.length,
              separatorBuilder: (context, index) => Divider(
                    color: Colors.black12,
                    thickness: 1,
                    height: 1,
                  ),
              itemBuilder: (BuildContext context, int index) {
                BulkProperty error = responcelist[index];

                int count = index + 1;
                return Container(
                  color: count % 2 == 0 ? Colors.white : myColor.embg,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _tableData(count, error),
                  ),
                );
              }),
        ),
      ),
    );
  }

  List<Widget> _tableData(int pos, BulkProperty bpro) {
    var result = <Widget>[];
    result.add(_datavaluepos(pos.toString()));
    result.add(_datavalue1(bpro.Name!));
    result.add(_datavalue2(bpro.Mandatory!));
    result.add(_datavalue3(bpro.Invalid!));
    result.add(_datavalueIcon(bpro));
    return result;
  }

  Widget _datavaluepos(String text) {
    return Container(
      height: 35,
      width: 35,
      //color: Colors.white,
      padding: EdgeInsets.only(left: 15),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: MyStyles.Medium(13, myColor.text_color),
      ),
    );
  }

  Widget _datavalue1(String text) {
    return Container(
      height: 35,
      width: 150,
      //color: Colors.white,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: MyStyles.Medium(13, myColor.text_color),
      ),
    );
  }

  Widget _datavalue2(String text) {
    return Container(
      height: 35,
      width: 200,
      //color: Colors.white,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: MyStyles.Medium(13, Colors.redAccent),
      ),
    );
  }

  Widget _datavalue3(String text) {
    return Container(
      height: 35,
      width: 200,
      //color: Colors.white,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: MyStyles.Medium(13, Colors.redAccent),
      ),
    );
  }

  Widget _datavalueIcon(BulkProperty bpro) {
    return Container(
      height: 40,
      width: 50,
      padding: EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.center,
      child: IconButton(
        icon: const Icon(Icons.info_outline, color: myColor.black, size: 25),
        onPressed: () {
          errorDialog1(bpro);
        },
      ),
    );
  }

  void errorDialog1(BulkProperty bpro) {
    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return ScrollMessageTableDialogBox(
          Title: bpro.Name!,
          Mandatory: bpro.Mandatory!.replaceAll(", ", "\n\n"),
          Invalid: bpro.Invalid!.replaceAll(", ", "\n\n"),
          onPressedYes: () async {
            Navigator.of(context1).pop();
          },
        );
      },
    );
  }
}
