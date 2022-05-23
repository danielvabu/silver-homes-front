import 'package:silverhome/domain/entities/tenancy_employment_information.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class EmployemantDetails {
  EmployemantDetails({
    this.annualIncomeStatus,
    this.empStatusId,
    this.id,
    this.LinkedIn,
    this.otherSourceIncome,
    this.occupation,
  });

  SystemEnumDetails? annualIncomeStatus;
  SystemEnumDetails? empStatusId;
  String? id;
  String? LinkedIn;
  String? otherSourceIncome;
  List<TenancyEmploymentInformation>? occupation;

  factory EmployemantDetails.fromJson(Map<String, dynamic> json) =>
      EmployemantDetails(
        annualIncomeStatus:
            SystemEnumDetails.fromJson(json["Annual_Income_Status"]),
        empStatusId: SystemEnumDetails.fromJson(json["Emp_Status_ID"]),
        id: json["ID"],
        LinkedIn: json["LinkedIn"],
        otherSourceIncome: json["OtherSourceIncome"],
        occupation: List<TenancyEmploymentInformation>.from(json["Occupation"]
            .map((x) => TenancyEmploymentInformation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Annual_Income_Status": annualIncomeStatus!.toJson(),
        "Emp_Status_ID": empStatusId!.toJson(),
        "ID": id,
        "LinkedIn": LinkedIn,
        "OtherSourceIncome": otherSourceIncome,
        "Occupation": List<TenancyEmploymentInformation>.from(
            occupation!.map((x) => x.toJson())),
      };
}

class Occupation {
  Occupation({
    this.employmentId,
    this.annualIncomeStatus,
    this.organization,
    this.occupation,
    this.duration,
    this.id,
    this.isCurrentOccupation,
  });

  SystemEnumDetails? employmentId;
  SystemEnumDetails? annualIncomeStatus;
  String? organization;
  String? occupation;
  String? duration;
  String? id;
  bool? isCurrentOccupation;

  factory Occupation.fromJson(Map<String, dynamic> json) => Occupation(
        employmentId: SystemEnumDetails.fromJson(json["Employment_ID"]),
        annualIncomeStatus:
            SystemEnumDetails.fromJson(json["Annual_Income_Status"]),
        organization: json["Organization"],
        occupation: json["Occupation"],
        duration: json["Duration"],
        id: json["ID"],
        isCurrentOccupation: json["IsCurrentOccupation"],
      );

  Map<String, dynamic> toJson() => {
        "Employment_ID": employmentId!.toJson(),
        "Annual_Income_Status": annualIncomeStatus!.toJson(),
        "Organization": organization,
        "Occupation": occupation,
        "Duration": duration,
        "ID": id,
        "IsCurrentOccupation": isCurrentOccupation,
      };
}
