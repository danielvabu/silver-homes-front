import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/notification_type.dart';
import 'package:silverhome/domain/entities/notificationdata.dart';

typedef CallbackItem = void Function(NotificationData notification);

class NotificationItem extends StatefulWidget {
  NotificationData notification;
  CallbackItem _callbackItem;

  NotificationItem({
    required NotificationData itemdata,
    required CallbackItem onPressNotification,
  })  : notification = itemdata,
        _callbackItem = onPressNotification;

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  double height = 0, width = 0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget._callbackItem(widget.notification);
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
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: widget.notification.isRead!
                      ? myColor.TA_header
                      : myColor.fnl_status),
            ),
            const SizedBox(width: 15.0),
            if (widget.notification.typeOfNotification ==
                NotificationType()
                    .getNotificationType(NotificationName.Lease_Received))
              Container(
                child: Image.asset(
                  "assets/images/ic_fnl_leaseagree.png",
                  height: 22,
                  width: 25,
                  fit: BoxFit.contain,
                ),
              ),
            if (widget.notification.typeOfNotification ==
                NotificationType()
                    .getNotificationType(NotificationName.Reference_Received))
              Container(
                child: Image.asset(
                  "assets/images/ic_fnl_refercheck.png",
                  height: 22,
                  width: 25,
                  fit: BoxFit.contain,
                ),
              ),
            if (widget.notification.typeOfNotification ==
                NotificationType()
                    .getNotificationType(NotificationName.Documents_Received))
              Container(
                child: Image.asset(
                  "assets/images/ic_fnl_docvarif.png",
                  height: 22,
                  width: 25,
                  fit: BoxFit.contain,
                ),
              ),
            if (widget.notification.typeOfNotification ==
                NotificationType()
                    .getNotificationType(NotificationName.Application_Received))
              Container(
                child: Image.asset(
                  "assets/images/ic_fnl_tntapp.png",
                  height: 22,
                  width: 25,
                  fit: BoxFit.contain,
                ),
              ),
            if (widget.notification.typeOfNotification ==
                    NotificationType().getNotificationType(
                        NotificationName.Owner_Maintenance_Requests) ||
                widget.notification.typeOfNotification ==
                    NotificationType().getNotificationType(
                        NotificationName.Owner_Maintenance_Change_Status) ||
                widget.notification.typeOfNotification ==
                    NotificationType().getNotificationType(
                        NotificationName.Owner_Maintenance_Change_Priority))
              Container(
                child: Image.asset(
                  "assets/images/ic_nav_maintainance.png",
                  height: 22,
                  width: 25,
                  fit: BoxFit.contain,
                ),
              ),
            const SizedBox(width: 15.0),
            Container(
              width: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.notification.typeOfNotification ==
                      NotificationType().getNotificationType(
                          NotificationName.Owner_Maintenance_Change_Priority))
                    Text(
                      GlobleString.NT_status_Maintenance_Priority_Changed,
                      style: MyStyles.Medium(15, myColor.text_color),
                    ),
                  if (widget.notification.typeOfNotification ==
                      NotificationType().getNotificationType(
                          NotificationName.Owner_Maintenance_Change_Status))
                    Text(
                      GlobleString.NT_status_Maintenance_Status_Changed,
                      style: MyStyles.Medium(15, myColor.text_color),
                    ),
                  if (widget.notification.typeOfNotification ==
                      NotificationType().getNotificationType(
                          NotificationName.Owner_Maintenance_Requests))
                    Text(
                      GlobleString.NT_status_Maintenance_Requests,
                      style: MyStyles.Medium(15, myColor.text_color),
                    ),
                  if (widget.notification.typeOfNotification ==
                      NotificationType()
                          .getNotificationType(NotificationName.Lease_Received))
                    Text(
                      GlobleString.NT_status_Lease_Received,
                      style: MyStyles.Medium(15, myColor.text_color),
                    ),
                  if (widget.notification.typeOfNotification ==
                      NotificationType().getNotificationType(
                          NotificationName.Reference_Received))
                    Text(
                      GlobleString.NT_status_Reference_Received,
                      style: MyStyles.Medium(15, myColor.text_color),
                    ),
                  if (widget.notification.typeOfNotification ==
                      NotificationType().getNotificationType(
                          NotificationName.Documents_Received))
                    Text(
                      GlobleString.NT_status_Documents_Received,
                      style: MyStyles.Medium(15, myColor.text_color),
                    ),
                  if (widget.notification.typeOfNotification ==
                      NotificationType().getNotificationType(
                          NotificationName.Application_Received))
                    Text(
                      GlobleString.NT_status_Application_Received,
                      style: MyStyles.Medium(15, myColor.text_color),
                    ),
                  const SizedBox(height: 4.0),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          widget.notification.MaintenanceID != null &&
                                  widget.notification.MaintenanceID != 0
                              ? widget.notification.propertyName! +
                                  (widget.notification.suiteUnit!.isNotEmpty
                                      ? " - " + widget.notification.suiteUnit!
                                      : "")
                              : widget.notification.applicantName!,
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
