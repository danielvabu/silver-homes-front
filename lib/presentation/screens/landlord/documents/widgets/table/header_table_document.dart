import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

class DocumentTableHeader extends StatefulWidget {
  final VoidCallback _callbackSortName;
  final VoidCallback _callbackSortType;
  final VoidCallback _callbackSortDateCreated;
  final VoidCallback _callbackSortCreatedBy;
  final VoidCallback _callbackSortRestricEditing;

  DocumentTableHeader({
    required VoidCallback onPressedSortName,
    required VoidCallback onPressedSortType,
    required VoidCallback onPressedSortDateCreated,
    required VoidCallback onPressedSortCreatedBy,
    required VoidCallback onPressedSortRestricEditing,
  })  : _callbackSortName = onPressedSortName,
        _callbackSortType = onPressedSortType,
        _callbackSortDateCreated = onPressedSortDateCreated,
        _callbackSortCreatedBy = onPressedSortCreatedBy,
        _callbackSortRestricEditing = onPressedSortRestricEditing;

  @override
  _DocumentTableHeaderState createState() => _DocumentTableHeaderState();
}

class _DocumentTableHeaderState extends State<DocumentTableHeader> {
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
    var result = <Widget>[
      _headerCreatedTitle(
          GlobleString.Table_Header_Document_name, widget._callbackSortName),
      _headerCreatedTitle(
          GlobleString.Table_Header_Document_tpye, widget._callbackSortType),
      _headerCreatedTitle(GlobleString.Table_Header_Document_date_created,
          widget._callbackSortDateCreated),
      _headerCreatedTitle(GlobleString.Table_Header_Document_created_by,
          widget._callbackSortCreatedBy),
      _headerCreatedTitle(GlobleString.Table_Header_Document_private_editing,
          widget._callbackSortRestricEditing),
    ];
    return result;
  }

  Widget _headerCreatedTitle(String text, Function onPressFilter) {
    return InkWell(
      onTap: () {
        onPressFilter();
      },
      child: Container(
        height: 40,
        width: width / 6,
        margin: EdgeInsets.only(left: 10),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.start,
              style: MyStyles.Bold(12, myColor.text_color),
            ),
            /*  SizedBox(
              width: 5,
            ),
            Image.asset(
              'assets/images/ic_sort.png',
              width: 12,
              height: 12,
              fit: BoxFit.contain,
            ), */
          ],
        ),
      ),
    );
  }
}
