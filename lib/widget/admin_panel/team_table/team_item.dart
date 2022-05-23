import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/entities/landlorddata.dart';

typedef VoidCallActive = void Function(LandLordData admindata, int pos);
typedef VoidCallInActive = void Function(LandLordData admindata, int pos);
typedef VoidCallEdit = void Function(LandLordData admindata, int pos);
typedef VoidCallDelete = void Function(LandLordData admindata, int pos);

class TeamItem extends StatefulWidget {
  List<LandLordData> listdata;
  final VoidCallActive _callbackActive;
  final VoidCallInActive _callbackInActive;
  final VoidCallEdit _callbackEdit;
  final VoidCallDelete _callbackDelete;

  TeamItem({
    required List<LandLordData> listdata1,
    required VoidCallActive onPresseActive,
    required VoidCallInActive onPresseInActive,
    required VoidCallEdit onPresseEdit,
    required VoidCallDelete onPresseDelete,
  })  : listdata = listdata1,
        _callbackActive = onPresseActive,
        _callbackInActive = onPresseInActive,
        _callbackEdit = onPresseEdit,
        _callbackDelete = onPresseDelete;

  @override
  _TeamItemState createState() => _TeamItemState();
}

class _TeamItemState extends State<TeamItem> {
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

  List<Widget> _tableData(LandLordData model, int index) {
    var result = <Widget>[];
    result.add(_datavalueID(model.id.toString()));
    result.add(_datavalueTitle(model, index));
    result.add(_datavalueEmail(model.email!));
    result.add(_datavaluephoneno(model.phoneNumber!));
    result.add(_datavalueActiveInactive(model, index));
    result.add(_actionPopup(model, index));
    return result;
  }

  Widget _datavalueID(String text) {
    return Container(
      height: 40,
      width: width / 9,
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
        widget._callbackEdit(model, index);
      },
      child: Container(
        height: 40,
        width: width / 5,
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
      width: width / 5,
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
        width: width / 5,
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

  Widget _datavalueActiveInactive(LandLordData model, int index) {
    return Container(
      height: 40,
      width: width / 7,
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: model.IsPrimarySuperAdmin!
          ? Container(
              alignment: Alignment.centerLeft,
              child: Text(
                GlobleString.Default_Admin,
                textAlign: TextAlign.center,
                style: MyStyles.Medium(14, myColor.Circle_main),
              ),
            )
          : Row(
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
              widget._callbackEdit(model, index);
            } else {
              widget._callbackDelete(model, index);
            }
          },
          child: Container(
            height: 40,
            width: 20,
            margin: EdgeInsets.only(right: 5),
            child: Icon(Icons.more_vert),
          ),
          itemBuilder: (context) => model.IsPrimarySuperAdmin!
              ? [
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      GlobleString.TM_Member_action_EditAccount,
                      style: MyStyles.Medium(14, myColor.text_color),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ]
              : [
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      GlobleString.TM_Member_action_EditAccount,
                      style: MyStyles.Medium(14, myColor.text_color),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text(
                      GlobleString.TM_Member_action_DeleteAccount,
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
