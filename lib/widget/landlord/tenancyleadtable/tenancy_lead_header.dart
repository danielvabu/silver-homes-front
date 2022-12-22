import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

typedef VoidCallbackAllCheck = void Function(bool val);

class TenancyLeadHeader extends StatefulWidget {
  final VoidCallback _callbackSortName;
  final VoidCallback _callbackSortProperty;
  final VoidCallback _callbackSortRating;
  final VoidCallback _callbackSortemail;
  final VoidCallback _callbackSortphone;
  final VoidCallback _callbackSortdatecreate;
  final VoidCallback _callbackSortAppStatus;
  final VoidCallbackAllCheck _callbackAllCheckItem;

  TenancyLeadHeader({
    required VoidCallback onPressedSortName,
    required VoidCallback onPressedSortProperty,
    required VoidCallback onPressedSortRating,
    required VoidCallback onPressedSortemail,
    required VoidCallback onPressedSortphone,
    required VoidCallback onPressedSortDatecreate,
    required VoidCallback onPressedSortAppStatus,
    required VoidCallbackAllCheck onPressedAllCheckItem,
  })  : _callbackSortName = onPressedSortName,
        _callbackSortProperty = onPressedSortProperty,
        _callbackSortRating = onPressedSortRating,
        _callbackSortemail = onPressedSortemail,
        _callbackSortphone = onPressedSortphone,
        _callbackSortdatecreate = onPressedSortDatecreate,
        _callbackSortAppStatus = onPressedSortAppStatus,
        _callbackAllCheckItem = onPressedAllCheckItem;

  @override
  _TenancyLeadHeaderState createState() => _TenancyLeadHeaderState();
}

class _TenancyLeadHeaderState extends State<TenancyLeadHeader> {
  double height = 0, width = 0;
  bool ischeck = false;

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
    result.add(_headerTitleName(GlobleString.TLH_Applicant_Name));
    result.add(_headerTitleName(GlobleString.TLH_Group_Id));
    result.add(_headerTitleProperty(GlobleString.TLH_Property_Name));
    result.add(_headerTitleRating(GlobleString.TLH_Rating));
    result.add(_headerTitleEmailAddress(GlobleString.TLH_Email_Address));
    result.add(_headerTitlePhoneNumber(GlobleString.TLH_Phone_Number));
    result.add(_headerTitleDateCreate(GlobleString.TLH_Date_Created));
    result.add(_headerTextStatus(GlobleString.TLH_Status));
    result.add(_headerTextAction(GlobleString.TLH_Action));
    result.add(_headerTextWithWidth("", 30));
    return result;
  }

  Widget _headerTitleName(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortName();
      },
      child: Container(
        height: 40,
        width: width / 8,
        padding: const EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.start,
              style: MyStyles.SemiBold(12, myColor.text_color),
            ),
            const SizedBox(width: 5.0),
            Image.asset(
              'assets/images/ic_sort.png',
              width: 12,
              height: 12,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerTitleProperty(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortProperty();
      },
      child: Container(
        height: 40,
        width: width / 8,
        padding: const EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.start,
              style: MyStyles.SemiBold(12, myColor.text_color),
            ),
            const SizedBox(width: 5.0),
            Image.asset(
              'assets/images/ic_sort.png',
              width: 12,
              height: 12,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerTitleRating(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortRating();
      },
      child: Container(
        height: 40,
        width: width / 12,
        padding: const EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.start,
              style: MyStyles.SemiBold(12, myColor.text_color),
            ),
            const SizedBox(width: 5.0),
            Image.asset(
              'assets/images/ic_sort.png',
              width: 12,
              height: 12,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerTitleEmailAddress(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortemail();
      },
      child: Container(
        height: 40,
        width: width / 7,
        padding: const EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.start,
              style: MyStyles.SemiBold(12, myColor.text_color),
            ),
            const SizedBox(width: 5.0),
            Image.asset(
              'assets/images/ic_sort.png',
              width: 12,
              height: 12,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerTitlePhoneNumber(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortphone();
      },
      child: Container(
        height: 40,
        width: width / 9,
        padding: const EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: MyStyles.SemiBold(12, myColor.text_color),
            ),
            const SizedBox(width: 5.0),
            Image.asset(
              'assets/images/ic_sort.png',
              width: 12,
              height: 12,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerTitleDateCreate(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortdatecreate();
      },
      child: Container(
        height: 40,
        width: width / 9,
        padding: const EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: MyStyles.SemiBold(12, myColor.text_color),
            ),
            const SizedBox(width: 5.0),
            Image.asset(
              'assets/images/ic_sort.png',
              width: 12,
              height: 12,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerTextStatus(String text) {
    return InkWell(
      onTap: () {
        widget._callbackSortAppStatus();
      },
      child: Container(
        height: 40,
        width: width / 6,
        padding: const EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: MyStyles.SemiBold(12, myColor.text_color),
            ),
            const SizedBox(width: 5.0),
            Image.asset(
              'assets/images/ic_sort.png',
              width: 12,
              height: 12,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerTextAction(String text) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 40,
        padding: const EdgeInsets.only(left: 20),
        alignment: Alignment.centerRight,
        child: Text(
          "",
          textAlign: TextAlign.end,
          style: MyStyles.SemiBold(12, myColor.text_color),
        ),
      ),
    );
  }

  Widget _headerTextWithWidth(String text, double widthv) {
    return Container(
      height: 40,
      width: widthv,
      padding: const EdgeInsets.only(left: 10),
      alignment: Alignment.centerRight,
      child: Text(
        text,
        textAlign: TextAlign.end,
        style: MyStyles.SemiBold(12, myColor.text_color),
      ),
    );
  }
}
