import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/entities/landlorddata.dart';

typedef VoidCallActive = void Function(LandLordData landLordData, int pos);
typedef VoidCallInActive = void Function(LandLordData landLordData, int pos);
typedef VoidCallViewAccount = void Function(LandLordData landLordData, int pos);
typedef VoidCallDeleteAccount = void Function(
    LandLordData landLordData, int pos);
typedef VoidCallNameClick = void Function(LandLordData landLordData, int pos);

class LandlordItem extends StatefulWidget {
  List<LandLordData> listdata;
  final VoidCallActive _callbackActive;
  final VoidCallInActive _callbackInActive;
  final VoidCallViewAccount _callbackViewAccount;
  final VoidCallDeleteAccount _callbackDeleteAccount;
  final VoidCallNameClick _callbackNameClick;

  LandlordItem({
    required List<LandLordData> listdata1,
    required VoidCallActive onPresseActive,
    required VoidCallInActive onPresseInActive,
    required VoidCallViewAccount onPresseViewAccount,
    required VoidCallDeleteAccount onPresseDeleteAccount,
    required VoidCallNameClick onPresseName,
  })  : listdata = listdata1,
        _callbackActive = onPresseActive,
        _callbackInActive = onPresseInActive,
        _callbackViewAccount = onPresseViewAccount,
        _callbackDeleteAccount = onPresseDeleteAccount,
        _callbackNameClick = onPresseName;

  @override
  _LandlordItemState createState() => _LandlordItemState();
}

class _LandlordItemState extends State<LandlordItem> {
  double height = 0, width = 0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 230;

    return Container(
      width: width,
      height: height - 174,
      child: ListviewBuid(widget.listdata),
    );
  }

  Widget ListviewBuid(List<LandLordData> listdata) {
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

  List<Widget> _tableData(LandLordData model, int Index) {
    var result = <Widget>[];
    result.add(_datavalueID(model.ownerId!.toString()));
    result.add(_datavalueTitle(model, Index));
    result.add(_datavalueEmail(model.email!));
    result.add(_datavaluephoneno(model.phoneNumber!));
    result.add(_datavalueofproperty(model.ofProperties!.toString()));
    result.add(_datavalueActiveInactive(model, Index));
    result.add(_actionPopup(model, Index));
    return result;
  }

  Widget _datavalueID(String text) {
    return Container(
      height: 40,
      width: width / 11,
      padding: EdgeInsets.only(left: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueTitle(LandLordData model, int index) {
    return InkWell(
      onTap: () {
        widget._callbackNameClick(model, index);
      },
      child: Container(
        height: 40,
        width: width / 6,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Text(
          model.landlordName!,
          textAlign: TextAlign.center,
          style: MyStyles.Medium(12, myColor.blue),
        ),
      ),
    );
  }

  Widget _datavalueEmail(String text) {
    return Container(
      height: 40,
      width: width / 6,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavaluephoneno(String text) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 40,
        width: width / 6,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: MyStyles.Medium(12, myColor.Circle_main),
        ),
      ),
    );
  }

  Widget _datavalueofproperty(String text) {
    return Container(
      height: 40,
      width: width / 6,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueActiveInactive(LandLordData model, int index) {
    return Container(
      height: 40,
      width: width / 7,
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FlutterSwitch(
            width: 55.0,
            height: 25.0,
            valueFontSize: 10.0,
            toggleSize: 20.0,
            value: model.activeInactive!,
            borderRadius: 30.0,
            padding: 2.0,
            activeColor: myColor.propertyOn,
            activeText: "ON",
            activeTextColor: myColor.white,
            inactiveColor: myColor.gray,
            inactiveText: "OFF",
            inactiveTextColor: myColor.white,
            showOnOff: true,
            onToggle: (val) {
              if (val) {
                widget._callbackActive(model, index);
              } else {
                widget._callbackInActive(model, index);
              }
            },
          ),
          Expanded(child: Container())
        ],
      ),
    );
  }

  Widget _actionPopup(LandLordData model, int index) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 28,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: PopupMenuButton(
          onSelected: (value) {
            if (value == 1) {
              widget._callbackViewAccount(model, index);
            } else if (value == 2) {
              widget._callbackDeleteAccount(model, index);
            }
          },
          child: Container(
            height: 40,
            width: 20,
            margin: EdgeInsets.only(right: 5),
            child: Icon(Icons.more_vert),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Text(
                GlobleString.ALL_action_ViewAccount,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: Text(
                GlobleString.ALL_action_DeleteAccount,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
