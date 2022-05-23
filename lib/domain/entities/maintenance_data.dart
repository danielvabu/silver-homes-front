import 'package:silverhome/tablayer/tablePOJO.dart';

class MaintenanceData {
  String? ID;
  String? RequestName;
  String? Date_Created;
  String? CreatedBy;
  bool? IsLock;
  SystemEnumDetails? Status;
  SystemEnumDetails? Category;
  SystemEnumDetails? Priority;
  String? Type_User;
  String? Describe_Issue;
  String? Owner_ID;
  String? OwnerName;
  String? Applicant_ID;
  String? ApplicantName;
  String? PropertyName;
  String? Prop_ID;

  MaintenanceData({
    this.ID,
    this.RequestName,
    this.Date_Created,
    this.CreatedBy,
    this.IsLock,
    this.Status,
    this.Category,
    this.Priority,
    this.Type_User,
    this.Describe_Issue,
    this.Owner_ID,
    this.OwnerName,
    this.Applicant_ID,
    this.ApplicantName,
    this.PropertyName,
    this.Prop_ID,
  });

  factory MaintenanceData.fromJson(Map<String, dynamic> json) =>
      MaintenanceData(
        ID: json["ID"] != null ? json["ID"] : "",
        RequestName: json["RequestName"] != null ? json["RequestName"] : "",
        Date_Created: json["Date_Created"] != null ? json["Date_Created"] : "",
        CreatedBy: json["CreatedBy"] != null ? json["CreatedBy"] : "",
        IsLock: json["IsLock"] != null ? json["IsLock"] : false,
        Category: SystemEnumDetails.fromJson(json["Category"]),
        Status: SystemEnumDetails.fromJson(json["Status"]),
        Priority: SystemEnumDetails.fromJson(json["Priority"]),
        Type_User: json["Type_User"] != null ? json["Type_User"] : "",
        Describe_Issue:
            json["Describe_Issue"] != null ? json["Describe_Issue"] : "",
        Owner_ID: json["Owner_ID"] != null ? json["Owner_ID"] : "",
        OwnerName: json["OwnerName"] != null ? json["OwnerName"] : "",
        Applicant_ID: json["Applicant_ID"] != null ? json["Applicant_ID"] : "",
        ApplicantName:
            json["ApplicantName"] != null ? json["ApplicantName"] : "",
        PropertyName: json["PropertyName"] != null ? json["PropertyName"] : "",
        Prop_ID: json["Prop_ID"] != null ? json["Prop_ID"] : "",
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "RequestName": RequestName,
        "Date_Created": Date_Created,
        "CreatedBy": CreatedBy,
        "IsLock": IsLock,
        "Category": Category!.toJson(),
        "Status": Status!.toJson(),
        "Priority": Priority!.toJson(),
        "Type_User": Type_User,
        "Describe_Issue": Describe_Issue,
        "Owner_ID": Owner_ID,
        "OwnerName": OwnerName,
        "Applicant_ID": Applicant_ID,
        "ApplicantName": ApplicantName,
        "PropertyName": PropertyName,
        "Prop_ID": Prop_ID,
      };
}
