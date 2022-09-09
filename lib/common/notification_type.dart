enum NotificationName {
  Lease_Received,
  Reference_Received,
  Documents_Received,
  Application_Received,
  Owner_Maintenance_Requests,
  Owner_Maintenance_Change_Status,
  Owner_Maintenance_Change_Priority,
  Tenant_Maintenance_Requests,
  Tenant_Maintenance_Change_Status,
  Tenant_Maintenance_Change_Priority,
  Attendance_Confirmed
}

class NotificationType {
  /*--------Get tabel name return--------*/
  getNotificationType(value) {
    int name;
    switch (value) {
      case NotificationName.Attendance_Confirmed:
        name = 11;
        break;
      case NotificationName.Tenant_Maintenance_Change_Priority:
        name = 10;
        break;
      case NotificationName.Tenant_Maintenance_Change_Status:
        name = 9;
        break;
      case NotificationName.Owner_Maintenance_Change_Priority:
        name = 8;
        break;
      case NotificationName.Owner_Maintenance_Change_Status:
        name = 7;
        break;
      case NotificationName.Tenant_Maintenance_Requests:
        name = 6;
        break;
      case NotificationName.Owner_Maintenance_Requests:
        name = 5;
        break;
      case NotificationName.Lease_Received:
        name = 4;
        break;
      case NotificationName.Reference_Received:
        name = 3;
        break;
      case NotificationName.Documents_Received:
        name = 2;
        break;
      case NotificationName.Application_Received:
        name = 1;
        break;

      default:
        name = 0;
    }
    return name;
  }
}
