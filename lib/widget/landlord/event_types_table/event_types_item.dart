import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/entities/event_typesdata.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';

typedef VoidCallView = void Function(EventTypesData data, int pos);
typedef VoidCallEdit = void Function(EventTypesData data, int pos);
typedef VoidCallDuplicat = void Function(EventTypesData data, int pos);
typedef VoidCallDelete = void Function(EventTypesData data, int pos);
typedef VoidCallArchive = void Function(EventTypesData data, int pos);

class EventTypesItem extends StatefulWidget {
  final VoidCallView _callbackView;
  final VoidCallEdit _callbackEdit;
  final VoidCallDuplicat _callbackDuplicat;
  final VoidCallDelete _callbackDelete;
  final VoidCallArchive _callbackArchive;
  List<EventTypesData> listdata;

  EventTypesItem({
    required List<EventTypesData> listdata1,
    required VoidCallView onPressView,
    required VoidCallEdit onPresseEdit,
    required VoidCallDuplicat onPresseDuplicat,
    required VoidCallDelete onPresseDelete,
    required VoidCallArchive onPresseArchive,
  })  : listdata = listdata1,
        _callbackView = onPressView,
        _callbackEdit = onPresseEdit,
        _callbackDuplicat = onPresseDuplicat,
        _callbackDelete = onPresseDelete,
        _callbackArchive = onPresseArchive;

  @override
  _EventTypesItemState createState() => _EventTypesItemState();
}

class _EventTypesItemState extends State<EventTypesItem> {
  double height = 0, width = 0;

  final _store = getIt<AppStore>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 230;

    return Container(
      width: width,
      height: height - 249,
      child: ListviewBuid(widget.listdata),
    );
  }

  Widget ListviewBuid(List<EventTypesData> listdata) {
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

  List<Widget> _tableData(EventTypesData model, int index) {
    var result = <Widget>[];
    result.add(_datavalueCompanyName(model, index));
    result.add(_datavalueCity(model));
    result.add(_datavalueContactName(model));
    result.add(_datavalueEmail(model));
    result.add(_datavaluePhone(model));
    result.add(_datavalueCategory(model));
    result.add(_datavalueRating(model));
    result.add(_actionPopup(model, index));
    return result;
  }

  Widget _datavalueCompanyName(EventTypesData model, int index) {
    return InkWell(
      onTap: () {
        widget._callbackView(model, index);
      },
      child: Container(
        height: 40,
        width: width / 7,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Text(
          model.companyName!,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: MyStyles.Medium(12, myColor.blue),
        ),
      ),
    );
  }

  Widget _datavalueCity(EventTypesData model) {
    return Container(
      height: 40,
      width: width / 10,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.city != null ? model.city!.CityName! : "",
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueContactName(EventTypesData model) {
    return Container(
      height: 40,
      width: width / 8,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.firstName! + " " + model.lastName!,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueEmail(EventTypesData model) {
    return Container(
      height: 40,
      width: width / 5,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.email!,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavaluePhone(EventTypesData model) {
    return Container(
      height: 40,
      width: width / 10,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.mobileNumber!,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueCategory(EventTypesData model) {
    return Container(
      height: 40,
      width: width / 10,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.category != null ? model.category!.displayValue : "",
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueRating(EventTypesData model) {
    return Container(
      height: 40,
      width: width / 12,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: RatingBarIndicator(
        rating: model.rating!,
        itemBuilder: (context, index) => Icon(
          Icons.star,
          color: myColor.blue,
        ),
        itemCount: 5,
        itemSize: 15.0,
        direction: Axis.horizontal,
      ),
    );
  }

  Widget _actionPopup(EventTypesData model, int index) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 28,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: PopupMenuButton(
          onSelected: (value) {
            if (value == 1) {
              widget._callbackView(model, index);
            } else if (value == 2) {
              widget._callbackEdit(model, index);
            } else if (value == 3) {
              widget._callbackDuplicat(model, index);
            } else if (value == 4) {
              widget._callbackDelete(model, index);
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
                GlobleString.Mant_action_View,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: Text(
                GlobleString.Mant_action_Edit,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            PopupMenuItem(
              value: 3,
              child: Text(
                GlobleString.Mant_action_Duplicate,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            PopupMenuItem(
              value: 4,
              child: Text(
                GlobleString.Mant_action_Delete,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            /*PopupMenuItem(
              value: 4,
              child: Text(
                GlobleString.Mant_action_Archive,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
