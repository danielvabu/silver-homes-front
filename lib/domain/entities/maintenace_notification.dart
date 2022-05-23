class MaintenanceNotificationData {
  String? applicantName;
  String? ownerId;
  String? applicantId;
  String? notificationDate;
  bool? isRead;
  int? typeOfNotification;
  String? applicationId;
  String? mid;
  String? propid;

  MaintenanceNotificationData({
    this.applicantName,
    this.ownerId,
    this.applicantId,
    this.notificationDate,
    this.isRead,
    this.typeOfNotification,
    this.applicationId,
    this.mid,
    this.propid,
  });


  factory MaintenanceNotificationData.fromJson(Map<String, dynamic> json) =>
      MaintenanceNotificationData(
        applicantName:
        json["ApplicantName"] != null ? json["ApplicantName"] : "",
        ownerId: json["Owner_ID"] != null ? json["Owner_ID"] : "",
        applicantId: json["Applicant_ID"] != null ? json["Applicant_ID"] : "",
        notificationDate:
        json["NotificationDate"] != null ? json["NotificationDate"] : "",
        isRead: json["IsRead"] != null ? json["IsRead"] : "",
        typeOfNotification: json["TypeOfNotification"] != null
            ? json["TypeOfNotification"]
            : "",
        applicationId: json["Application_ID"] != null ? json["Application_ID"] : "",
        mid: json["MaintenanceID"] != null ? json["MaintenanceID"] : "",
        propid: json["Prop_ID"] != null ? json["Prop_ID"] : "",
      );

  Map<String, dynamic> toJson() => {
    "ApplicantName": applicantName,
    "Owner_ID": ownerId,
    "Applicant_ID": applicantId,
    "NotificationDate": notificationDate,
    "IsRead": isRead,
    "TypeOfNotification": typeOfNotification,
    "Application_ID": applicationId,
    "MaintenanceID": mid,
    "Prop_ID": propid,
  };
}
