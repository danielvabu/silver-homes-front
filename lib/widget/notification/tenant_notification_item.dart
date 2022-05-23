import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/notification_type.dart';
import 'package:silverhome/domain/entities/notificationdata.dart';

typedef CallbackItem = void Function();

class TenantNotificationItem extends StatefulWidget {
  NotificationData notification;
  CallbackItem _callbackItem;

  TenantNotificationItem({
    required NotificationData itemdata,
    required CallbackItem onPressNotification,
  })  : notification = itemdata,
        _callbackItem = onPressNotification;

  @override
  _TenantNotificationItemState createState() => _TenantNotificationItemState();
}

class _TenantNotificationItemState extends State<TenantNotificationItem> {
  double height = 0, width = 0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget._callbackItem();
      },
      child: Container(
        height: 55,
        //width: 260,
        margin: EdgeInsets.only(top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: widget.notification.isRead!
                      ? myColor.TA_header
                      : myColor.fnl_status),
            ),
            SizedBox(
              width: 15,
            ),
            /*if (widget.notification.typeOfNotification ==
                NotificationType().getNotificationType(
                    NotificationName.Tenant_Maintenance_Requests))*/

            Container(
              child: Image.asset(
                "assets/images/ic_nav_maintainance.png",
                height: 22,
                width: 25,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Container(
              width: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.notification.typeOfNotification ==
                            NotificationType().getNotificationType(
                                NotificationName
                                    .Tenant_Maintenance_Change_Priority)
                        ? GlobleString.NT_status_Maintenance_Priority_Changed
                        : widget.notification.typeOfNotification ==
                                NotificationType().getNotificationType(
                                    NotificationName
                                        .Tenant_Maintenance_Change_Status)
                            ? GlobleString.NT_status_Maintenance_Status_Changed
                            : GlobleString.NT_status_Maintenance_Requests,
                    style: MyStyles.Medium(15, myColor.text_color),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          widget.notification.propertyName! +
                              (widget.notification.suiteUnit!.isNotEmpty
                                  ? " - " + widget.notification.suiteUnit!
                                  : ""),
                          overflow: TextOverflow.ellipsis,
                          style:
                              MyStyles.Medium(12, myColor.noti_count_subtitle),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          widget.notification.notificationDate != null &&
                                  widget.notification.notificationDate != ""
                              ? new DateFormat("dd MMM")
                                  .format(DateTime.parse(
                                      widget.notification.notificationDate!))
                                  .toString()
                              : "",
                          style:
                              MyStyles.Medium(12, myColor.noti_count_subtitle),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
