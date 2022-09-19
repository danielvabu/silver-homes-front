import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/entities/eventtypeslist.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/widget/Landlord/customewidget.dart';
import 'package:silverhome/widget/landlord/scheduling/list_of_attendeesEvent.dart';

typedef VoidCallName = void Function(EventTypesDataList eventtypesData);
typedef VoidCallDetails = void Function(EventTypesDataList eventtypesData);
typedef VoidCallEdit = void Function(EventTypesDataList eventtypesData);
typedef VoidCallDuplicat = void Function(EventTypesDataList eventtypesData);
typedef VoidCallSaveTemp = void Function(EventTypesDataList eventtypesData);
typedef VoidCallDelete = void Function(EventTypesDataList eventtypesData);
typedef VoidCallActive = void Function(
    EventTypesDataList eventtypesData, int pos);
typedef VoidCallInActive = void Function(
    EventTypesDataList eventtypesData, int pos);
typedef VoidCallIsPublish = void Function(
    EventTypesDataList eventtypesData, int pos, bool flag);

class EventTypesItem extends StatefulWidget {
  final VoidCallName _callbackEventTypesName;
  final VoidCallDetails _callbackDetails;
  final VoidCallEdit _callbackEdit;
  final VoidCallDuplicat _callbackDuplicat;
  final VoidCallSaveTemp _callbackSaveTemp;
  final VoidCallActive _callbackActive;
  final VoidCallDelete _callbackDelete;
  final VoidCallInActive _callbackInActive;
  final VoidCallIsPublish _callbackIsPublish;
  List<EventTypesDataList> listdata;

  EventTypesItem({
    required List<EventTypesDataList> listdata1,
    required VoidCallName onPressName,
    required VoidCallDetails onPressDetails,
    required VoidCallEdit onPresseEdit,
    required VoidCallDuplicat onPresseDuplicat,
    required VoidCallSaveTemp onPresseSaveTemp,
    required VoidCallActive onPresseActive,
    required VoidCallDelete onPresseDelete,
    required VoidCallInActive onPresseInActive,
    required VoidCallIsPublish onPresseIsPublish,
  })  : listdata = listdata1,
        _callbackEventTypesName = onPressName,
        _callbackDetails = onPressDetails,
        _callbackEdit = onPresseEdit,
        _callbackDuplicat = onPresseDuplicat,
        _callbackSaveTemp = onPresseSaveTemp,
        _callbackActive = onPresseActive,
        _callbackDelete = onPresseDelete,
        _callbackInActive = onPresseInActive,
        _callbackIsPublish = onPresseIsPublish;

  @override
  _EventTypesItemState createState() => _EventTypesItemState();
}

class _EventTypesItemState extends State<EventTypesItem> {
  double height = 0, width = 0, parte = 0;

  final _store = getIt<AppStore>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 230;
    parte = width / 100;

    return Container(
      width: width,
      height: height - 249,
      child: ListviewBuid(widget.listdata),
    );
  }

  Widget ListviewBuid(List<EventTypesDataList> listdata) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        color: myColor.TA_table_header,
        thickness: 0,
        height: 0,
      ),
      scrollDirection: Axis.vertical,
      key: UniqueKey(),
      itemCount: listdata.length,
      itemBuilder: (BuildContext ctxt, int Index) {
        return Container(
          height: 40,
          color: Index % 2 == 0 ? myColor.TA_dark : myColor.TA_light,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: _tableData(listdata[Index], Index),
          ),
        );
      },
    );
  }

  List<Widget> _tableData(EventTypesDataList model, int Index) {
    var result = <Widget>[];
    result.add(_datavalueEventTypes(model));
    result.add(_datavalueUnit(model));
    result.add(_datavalueCity(model));
    result.add(_datavalueCountry(model));
    result.add(_datavalueEventTypesType(model));
    result.add(_datavalueIsPublished(model, Index));
    result.add(_datavalueAttendees(model, Index));
    result.add(_actionPopup(model));
    return result;
  }

  Widget _datavalueEventTypes(EventTypesDataList model) {
    return InkWell(
      onTap: () {
        widget._callbackEventTypesName(model);
      },
      child: Container(
        height: 40,
        width: parte * 25,
        margin: const EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Tooltip(
          message: model.name!,
          child: Text(
            model.name!,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: MyStyles.Medium(12, myColor.blue),
          ),
        ),
      ),
    );
  }

  Widget _datavalueUnit(EventTypesDataList model) {
    return InkWell(
      onTap: () {
        if (model.prop_id != "") {
          CustomeWidget.getPropertyDetailsByPropertyID(context, model.prop_id!);
        }
      },
      child: Container(
        height: 40,
        width: parte * 20,
        margin: const EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Tooltip(
          message: model.property_name!,
          child: Text(
            model.property_name!,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: MyStyles.Medium(12, myColor.blue),
          ),
        ),
      ),
    );
  }

  Widget _datavalueCity(EventTypesDataList model) {
    return Container(
      height: 40,
      width: parte * 10,
      margin: const EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.relationship!,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueCountry(EventTypesDataList model) {
    return Container(
      height: 40,
      width: parte * 10,
      margin: const EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.duration!,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueEventTypesType(EventTypesDataList model) {
    return Container(
      height: 40,
      width: parte * 10,
      margin: const EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.slots.toString()!,
        textAlign: TextAlign.center,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueIsPublished(EventTypesDataList model, int index) {
    return Container(
      height: 40,
      width: parte * 9,
      margin: const EdgeInsets.only(left: 15),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FlutterSwitch(
            width: 55.0,
            height: 25.0,
            valueFontSize: 10.0,
            toggleSize: 20.0,
            value: model.ispublished!,
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
                widget._callbackIsPublish(model, index, val);
              } else {
                widget._callbackIsPublish(model, index, val);
              }
            },
          ),
          Expanded(child: Container())
        ],
      ),
    );
  }

  Widget _datavalueAttendees(EventTypesDataList model, int index) {
    return (model.slots! > 0)
        ? Container(
            height: 40,
            width: 30,
            margin: const EdgeInsets.only(left: 5, right: 8.0),
            alignment: Alignment.center,
            child: GestureDetector(
                onTap: (model.slots! > 0)
                    ? () {
                        openDialogListAttendees(model.id!);
                      }
                    : null,
                child: const Icon(Icons.groups)),
          )
        : Container(
            height: 40,
            width: 43,
            alignment: Alignment.centerLeft,
            child: Text(
              "Empty",
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: MyStyles.Medium(10, myColor.Circle_main),
            ),
          );
  }

  Widget _actionPopup(EventTypesDataList model) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 28,
        width: 15,
        margin: const EdgeInsets.only(left: 10, right: 20),
        alignment: Alignment.centerRight,
        child: PopupMenuButton(
          onSelected: (value) {
            if (value == 1) {
              widget._callbackDetails(model);
            } else if (value == 2) {
              widget._callbackEdit(model);
            } else if (value == 3) {
              widget._callbackDuplicat(model);
            } else if (value == 4) {
              widget._callbackSaveTemp(model);
            } else if (value == 5) {
              widget._callbackDelete(model);
            } else if (value == 6) {
              openDialogListAttendees(model.id!);
            }
          },
          child: Container(
            height: 40,
            width: 20,
            margin: const EdgeInsets.only(right: 5),
            child: const Icon(Icons.more_vert),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Text(
                GlobleString.PH_ACT_ViewDetails,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: Text(
                GlobleString.ShareEvent,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            if (model.slots! > 0)
              PopupMenuItem(
                value: 6,
                child: Text(
                  GlobleString.CALENDAR_View_Attendees,
                  style: MyStyles.Medium(14, myColor.text_color),
                  textAlign: TextAlign.start,
                ),
              ),
            PopupMenuItem(
              value: 3,
              child: Text(
                GlobleString.PH_ACT_Duplicate,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            PopupMenuItem(
              value: 4,
              child: Text(
                GlobleString.PH_ACT_SaveTemplate,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            PopupMenuItem(
              value: 5,
              child: Text(
                GlobleString.Mant_action_Delete,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openDialogListAttendees(String id) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return ListOfAttendeesEvent(id);
      },
    );
  }
}
