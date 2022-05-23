import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/entities/maintenance_data.dart';

typedef VoidCallView = void Function(MaintenanceData maintenanceData, int pos);
typedef VoidCallEdit = void Function(MaintenanceData maintenanceData, int pos);
typedef VoidCallExport = void Function(
    MaintenanceData maintenanceData, int pos);
typedef VoidCallDuplicate = void Function(
    MaintenanceData maintenanceData, int pos);
typedef VoidCallArchive = void Function(
    MaintenanceData maintenanceData, int pos);

class TenantMaintenanceItem extends StatefulWidget {
  List<MaintenanceData> listdata;
  final VoidCallView _callbackView;
  final VoidCallEdit _callbackEdit;
  final VoidCallExport _callbackExport;
  final VoidCallDuplicate _callbackDuplicate;
  final VoidCallArchive _callbackArchive;

  TenantMaintenanceItem({
    required List<MaintenanceData> listdata1,
    required VoidCallView onPresseView,
    required VoidCallEdit onPresseEdit,
    required VoidCallExport onPresseExport,
    required VoidCallDuplicate onPresseDuplicate,
    required VoidCallArchive onPresseArchive,
  })  : listdata = listdata1,
        _callbackView = onPresseView,
        _callbackEdit = onPresseEdit,
        _callbackExport = onPresseExport,
        _callbackDuplicate = onPresseDuplicate,
        _callbackArchive = onPresseArchive;

  @override
  _TenantMaintenanceItemState createState() => _TenantMaintenanceItemState();
}

class _TenantMaintenanceItemState extends State<TenantMaintenanceItem> {
  double height = 0, width = 0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 230;

    return Container(
      width: width,
      height: height - 218,
      child: ListviewBuid(widget.listdata),
    );
  }

  Widget ListviewBuid(List<MaintenanceData> listdata) {
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

  List<Widget> _tableData(MaintenanceData model, int index) {
    var result = <Widget>[];
    result.add(_datavalueRequestName(model, index));
    result.add(_datavalueCategory(model));
    result.add(_datavaluePriority(model));
    result.add(_datavalueDateCreated(model));
    result.add(_datavalueCreatedBy(model));
    result.add(_datavalueStatus(model));
    result.add(_datavalueEditRights(model));
    result.add(_actionPopup(model, index));
    return result;
  }

  Widget _datavalueRequestName(MaintenanceData model, int index) {
    return InkWell(
      onTap: () {
        widget._callbackView(model, index);
      },
      child: Container(
        height: 40,
        width: width / 6,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Text(
          model.RequestName!,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: MyStyles.Medium(12, myColor.blue),
        ),
      ),
    );
  }

  Widget _datavalueCategory(MaintenanceData model) {
    return Container(
      height: 40,
      width: width / 8,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.Category != null ? model.Category!.displayValue : "",
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavaluePriority(MaintenanceData model) {
    return Container(
      height: 40,
      width: width / 9,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.Priority != null ? model.Priority!.displayValue : "",
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueDateCreated(MaintenanceData model) {
    return Container(
      height: 40,
      width: width / 8,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.Date_Created != null &&
                model.Date_Created != "0" &&
                model.Date_Created != ""
            ? new DateFormat("dd-MMM-yyyy")
                .format(DateTime.parse(model.Date_Created!))
                .toString()
            : "",
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueCreatedBy(MaintenanceData model) {
    return Container(
      height: 40,
      width: width / 8,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.CreatedBy!,
        //model.Type_User == "1" ? model.OwnerName! : model.ApplicantName!,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueStatus(MaintenanceData model) {
    return Container(
      height: 40,
      width: width / 9,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.Status != null ? model.Status!.displayValue : "",
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueEditRights(MaintenanceData model) {
    return Container(
      height: 40,
      width: width / 10,
      padding: EdgeInsets.only(left: 0),
      alignment: Alignment.center,
      child: Icon(
          model.IsLock != null && model.IsLock! ? Icons.lock : Icons.lock_open,
          size: 20,
          color: myColor.black),
    );
  }

  Widget _actionPopup(MaintenanceData model, int index) {
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
              widget._callbackExport(model, index);
            } else if (value == 4) {
              widget._callbackDuplicate(model, index);
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
            if (model.IsLock != null && !model.IsLock!)
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
                GlobleString.Mant_action_Export,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            PopupMenuItem(
              value: 4,
              child: Text(
                GlobleString.Mant_action_Duplicate,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            /*PopupMenuItem(
              value: 5,
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
