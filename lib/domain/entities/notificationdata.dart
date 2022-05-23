class NotificationData {
  String? applicantName;
  int? ownerId;
  int? applicantId;
  String? notificationDate;
  bool? isRead;
  int? typeOfNotification;
  int? id;
  int? applicationId;
  int? MaintenanceID;
  String? PropID;
  String? propertyName;
  String? suiteUnit;

  NotificationData({
    this.applicantName,
    this.ownerId,
    this.applicantId,
    this.notificationDate,
    this.isRead,
    this.typeOfNotification,
    this.id,
    this.applicationId,
    this.MaintenanceID,
    this.PropID,
    this.propertyName,
    this.suiteUnit,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
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
        id: json["ID"] != null ? json["ID"] : "",
        applicationId: json["Application_ID"] != null ? json["Application_ID"] : "",
        MaintenanceID: json["MaintenanceID"] != null ? json["MaintenanceID"] : 0,
        PropID: json["PropID"] != null ? json["PropID"] : "",
        propertyName: json["PropertyName"] != null ? json["PropertyName"] : "",
        suiteUnit: json["Suite_Unit"] != null ? json["Suite_Unit"] : "",
      );

  Map<String, dynamic> toJson() => {
        "ApplicantName": applicantName,
        "Owner_ID": ownerId,
        "Applicant_ID": applicantId,
        "NotificationDate": notificationDate,
        "IsRead": isRead,
        "TypeOfNotification": typeOfNotification,
        "ID": id,
        "Application_ID": applicationId,
        "MaintenanceID": MaintenanceID,
        "PropID": PropID,
        "PropertyName": propertyName,
        "Suite_Unit": suiteUnit,
      };
}
