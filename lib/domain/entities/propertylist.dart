import 'package:silverhome/tablayer/tablePOJO.dart';

class PropertyDataList {
  PropertyDataList({
    this.propertyType,
    this.isActive,
    this.id,
    this.isPublished,
    this.isAgreedTandC,
    this.propDrafting,
    this.city,
    this.propertyName,
    this.otherPropertyType,
    this.country,
    this.suiteUnit,
    this.vacancy,
    this.createdOn,
    this.updatedOn,
  });

  SystemEnumDetails? propertyType;
  bool? isActive;
  String? id;
  bool? isPublished;
  bool? isAgreedTandC;
  int? propDrafting;
  String? city;
  String? propertyName;
  String? otherPropertyType;
  String? country;
  String? suiteUnit;
  bool? vacancy;
  String? createdOn;
  String? updatedOn;

  factory PropertyDataList.fromJson(Map<String, dynamic> json) =>
      PropertyDataList(
        propertyType: SystemEnumDetails.fromJson(json["Property_Type"]),
        isActive: json["IsActive"],
        id: json["ID"],
        isPublished: json["IsPublished"],
        isAgreedTandC: json["IsAgreed_TandC"],
        propDrafting: json["PropDrafting"],
        city: json["City"],
        propertyName: json["PropertyName"],
        otherPropertyType: json["otherPropertyType"],
        country: json["Country"],
        suiteUnit: json["Suite_Unit"],
        vacancy: json["Vacancy"],
        createdOn: json["CreatedOn"],
        updatedOn: json["UpdatedOn"],
      );

  Map<String, dynamic> toJson() => {
        "Property_Type": propertyType!.toJson(),
        "IsActive": isActive,
        "ID": id,
        "IsPublished": isPublished,
        "IsAgreed_TandC": isAgreedTandC,
        "PropDrafting": propDrafting,
        "City": city,
        "PropertyName": propertyName,
        "otherPropertyType": otherPropertyType,
        "Country": country,
        "Suite_Unit": suiteUnit,
        "Vacancy": vacancy,
        "CreatedOn": createdOn,
        "UpdatedOn": updatedOn,
      };
}
