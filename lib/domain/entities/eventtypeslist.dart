import 'package:silverhome/tablayer/tablePOJO.dart';

class EventTypesDataList {
  EventTypesDataList({
    this.eventtypesType,
    this.isActive,
    this.id,
    this.isPublished,
    this.isAgreedTandC,
    this.propDrafting,
    this.city,
    this.eventtypesName,
    this.otherEventTypesType,
    this.country,
    this.suiteUnit,
    this.vacancy,
    this.createdOn,
    this.updatedOn,
  });

  SystemEnumDetails? eventtypesType;
  bool? isActive;
  String? id;
  bool? isPublished;
  bool? isAgreedTandC;
  int? propDrafting;
  String? city;
  String? eventtypesName;
  String? otherEventTypesType;
  String? country;
  String? suiteUnit;
  bool? vacancy;
  String? createdOn;
  String? updatedOn;

  factory EventTypesDataList.fromJson(Map<String, dynamic> json) =>
      EventTypesDataList(
        eventtypesType: SystemEnumDetails.fromJson(json["EventTypes_Type"]),
        isActive: json["IsActive"],
        id: json["ID"],
        isPublished: json["IsPublished"],
        isAgreedTandC: json["IsAgreed_TandC"],
        propDrafting: json["PropDrafting"],
        city: json["City"],
        eventtypesName: json["EventTypesName"],
        otherEventTypesType: json["otherEventTypesType"],
        country: json["Country"],
        suiteUnit: json["Suite_Unit"],
        vacancy: json["Vacancy"],
        createdOn: json["CreatedOn"],
        updatedOn: json["UpdatedOn"],
      );

  Map<String, dynamic> toJson() => {
        "EventTypes_Type": eventtypesType!.toJson(),
        "IsActive": isActive,
        "ID": id,
        "IsPublished": isPublished,
        "IsAgreed_TandC": isAgreedTandC,
        "PropDrafting": propDrafting,
        "City": city,
        "EventTypesName": eventtypesName,
        "otherEventTypesType": otherEventTypesType,
        "Country": country,
        "Suite_Unit": suiteUnit,
        "Vacancy": vacancy,
        "CreatedOn": createdOn,
        "UpdatedOn": updatedOn,
      };
}
