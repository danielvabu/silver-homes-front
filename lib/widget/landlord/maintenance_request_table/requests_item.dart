import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/notification_type.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/entities/maintenace_notification.dart';
import 'package:silverhome/domain/entities/maintenance_data.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_filter.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/tabclass.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

typedef VoidCallView = void Function(MaintenanceData maintenanceData, int pos);
typedef VoidCallShare = void Function(MaintenanceData maintenanceData, int pos);
typedef VoidCallEdit = void Function(MaintenanceData maintenanceData, int pos);
typedef VoidCallExport = void Function(
    MaintenanceData maintenanceData, int pos);
typedef VoidCallDuplicat = void Function(
    MaintenanceData maintenanceData, int pos);
typedef VoidCallCallApi = void Function();
typedef VoidCallDelete = void Function(
    MaintenanceData maintenanceData, int pos);

class RequestsItem extends StatefulWidget {
  final VoidCallView _callbackView;
  final VoidCallShare _callbackShare;
  final VoidCallEdit _callbackEdit;
  final VoidCallExport _callbackExport;
  final VoidCallDuplicat _callbackDuplicat;
  final VoidCallCallApi _callbackcallApi;
  final VoidCallDelete _callbackDelete;
  List<MaintenanceData> listdata;

  RequestsItem({
    required List<MaintenanceData> listdata1,
    required VoidCallView onPressView,
    required VoidCallShare onPressShare,
    required VoidCallEdit onPresseEdit,
    required VoidCallExport onPresseExport,
    required VoidCallDuplicat onPresseDuplicat,
    required VoidCallCallApi onPresseCallApi,
    required VoidCallDelete onPresseDelete,
  })  : listdata = listdata1,
        _callbackView = onPressView,
        _callbackShare = onPressShare,
        _callbackEdit = onPresseEdit,
        _callbackExport = onPresseExport,
        _callbackDuplicat = onPresseDuplicat,
        _callbackcallApi = onPresseCallApi,
        _callbackDelete = onPresseDelete;

  @override
  _RequestsItemState createState() => _RequestsItemState();
}

class _RequestsItemState extends State<RequestsItem> {
  double height = 0, width = 0;

  late OverlayEntry loader;
  final _store = getIt<AppStore>();
  static List<SystemEnumDetails> MaintenanceStatuslist = [];

  @override
  void initState() {
    MaintenanceStatuslist.clear();
    MaintenanceStatuslist =
        QueryFilter().PlainValues(eSystemEnums().Maintenance_Status);

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

  List<Widget> _tableData(MaintenanceData model, int index) {
    var result = <Widget>[];
    result.add(_datavaluePropertyName(model, index));
    result.add(_datavalueRequestName(model, index));
    result.add(_datavalueCategory(model));
    result.add(_datavaluePriority(model));
    result.add(_datavalueDateCreated(model));
    result.add(_datavalueCreatedBy(model));
    result.add(_datavalueStatus(model));
    result.add(_datavalueLock(model));
    result.add(_actionPopup(model, index));
    return result;
  }

  Widget _datavaluePropertyName(MaintenanceData model, int index) {
    return InkWell(
      onTap: () {
        CustomeWidget.getPropertyDetailsByPropertyID(context, model.Prop_ID!);
      },
      child: Container(
        height: 40,
        width: width / 7,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Tooltip(
          message: model.PropertyName!,
          child: Text(
            model.PropertyName!,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: MyStyles.Medium(12, myColor.blue),
          ),
        ),
      ),
    );
  }

  Widget _datavalueRequestName(MaintenanceData model, int index) {
    return InkWell(
      onTap: () {
        widget._callbackView(model, index);
      },
      child: Container(
        height: 40,
        width: width / 9,
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
      width: width / 9,
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
      width: width / 12,
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
      width: width / 11,
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
      width: width / 9,
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
      height: 28,
      width: width / 7,
      padding: EdgeInsets.only(left: 2),
      alignment: Alignment.centerLeft,
      child: DropdownSearch<SystemEnumDetails>(
        mode: Mode.MENU,
        items: MaintenanceStatuslist,
        textstyle: MyStyles.Medium(12, myColor.black),
        itemAsString: (SystemEnumDetails? u) => u!.displayValue,
        hint: "Select Status",
        defultHeight: MaintenanceStatuslist.length * 33 > 250
            ? 250
            : MaintenanceStatuslist.length * 33,
        showSearchBox: false,
        selectedItem: model.Status != null ? model.Status! : null,
        isFilteredOnline: true,
        onChanged: (data) {
          if (data != model.Status) {
            MainatenanceID updateid = new MainatenanceID();
            updateid.ID = model.ID.toString();
            MainatenanceStatus updatestatus = new MainatenanceStatus();
            updatestatus.Status = data!.EnumDetailID.toString();

            loader = Helper.overlayLoader(context);
            Overlay.of(context)!.insert(loader);

            ApiManager().updateMaintenanceStatus(
                context, updateid, updatestatus, (status, responce) async {
              if (status) {
                insertNotificationCall(model);
                loader.remove();
                widget._callbackcallApi();
              } else {
                loader.remove();
              }
            });
          }
        },
      ),
    );
  }

  Widget _datavalueLock(MaintenanceData model) {
    return Container(
      height: 40,
      width: width / 12,
      margin: EdgeInsets.only(left: 25),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FlutterSwitch(
            width: 50.0,
            height: 25.0,
            valueFontSize: 10.0,
            toggleSize: 20.0,
            value: model.IsLock != null ? model.IsLock! : false,
            borderRadius: 30.0,
            padding: 2.0,
            activeColor: myColor.propertyOn,
            activeTextColor: Colors.transparent,
            inactiveColor: myColor.CM_Lead_border,
            inactiveTextColor: Colors.transparent,
            switchBorder: Border.all(
              color: myColor.TA_tab_devide,
              width: 2.0,
            ),
            activeIcon: FaIcon(
              FontAwesomeIcons.lock,
              color: myColor.CM_Lead_border,
              size: 15,
            ),
            inactiveIcon: FaIcon(
              FontAwesomeIcons.unlock,
              color: myColor.CM_Lead_border,
              size: 15,
            ),
            showOnOff: true,
            onToggle: (val) {
              MainatenanceID updateid = new MainatenanceID();
              updateid.ID = model.ID.toString();

              MainatenanceIsLock updateIsLock = new MainatenanceIsLock();
              updateIsLock.IsLock = val;

              loader = Helper.overlayLoader(context);
              Overlay.of(context)!.insert(loader);

              ApiManager().updateMaintenanceStatus(
                  context, updateid, updateIsLock, (status, responce) async {
                if (status) {
                  loader.remove();
                  widget._callbackcallApi();
                } else {
                  loader.remove();
                }
              });
            },
          ),
          Expanded(child: Container())
        ],
      ),
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
              widget._callbackShare(model, index);
            } else if (value == 3) {
              widget._callbackEdit(model, index);
            } else if (value == 4) {
              widget._callbackExport(model, index);
            } else if (value == 5) {
              widget._callbackDuplicat(model, index);
            } else if (value == 6) {
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
                GlobleString.Mant_action_Share,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            PopupMenuItem(
              value: 3,
              child: Text(
                GlobleString.Mant_action_Edit,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            PopupMenuItem(
              value: 4,
              child: Text(
                GlobleString.Mant_action_Export,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            PopupMenuItem(
              value: 5,
              child: Text(
                GlobleString.Mant_action_Duplicate,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            PopupMenuItem(
              value: 6,
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

  insertNotificationCall(MaintenanceData model) {
    List<MaintenanceNotificationData> notificationlist = [];

    MaintenanceNotificationData mn = new MaintenanceNotificationData();
    mn.applicantName = "";
    mn.mid = model.ID.toString();
    mn.propid = model.Prop_ID;
    mn.applicantId = model.Applicant_ID != null ? model.Applicant_ID : "";
    mn.applicationId = "";
    mn.ownerId = Prefs.getString(PrefsName.OwnerID);
    mn.notificationDate =
        new DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();
    mn.typeOfNotification = NotificationType()
        .getNotificationType(NotificationName.Owner_Maintenance_Change_Status);
    mn.isRead = false;

    notificationlist.add(mn);

    if (model.Applicant_ID != null) {
      MaintenanceNotificationData mn2 = new MaintenanceNotificationData();
      mn2.applicantName = "";
      mn2.mid = model.ID.toString();
      mn2.propid = model.Prop_ID;
      mn2.applicantId = model.Applicant_ID != null ? model.Applicant_ID : "";
      mn2.applicationId = "";
      mn2.ownerId = Prefs.getString(PrefsName.OwnerID);
      mn2.notificationDate = new DateFormat("yyyy-MM-dd HH:mm:ss")
          .format(DateTime.now())
          .toString();
      mn2.typeOfNotification = NotificationType().getNotificationType(
          NotificationName.Tenant_Maintenance_Change_Status);
      ;
      mn2.isRead = false;

      notificationlist.add(mn2);
    }

    ApiManager().AddMaintenaceNotification(context, notificationlist,
        (error, responce) async {
      if (error) {
      } else {
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
  }
}
