import 'package:silverhome/tablayer/tablePOJO.dart';

class EventTypesDataList {
  EventTypesDataList({
    this.id,
    this.name,
    this.ispublished,
    this.property_name,
    this.relationship,
    this.duration,
    this.slots,
    this.createdon,
    this.updatedon,
  });
  String? id;

  String? name;
  bool? ispublished;
  String? property_name;
  String? relationship;
  String? duration;
  int? slots;
  String? createdon;
  String? updatedon;

  factory EventTypesDataList.fromJson(Map<String, dynamic> json) =>
      EventTypesDataList(
        id: json["id"],
        name: json["name"],
        property_name: json["property_name"],
        relationship: json["relationship"],
        ispublished: json["ispublished"],
        duration: json["duration"],
        slots: json["slots"],
        createdon: json["createdon"],
        updatedon: json["updatedon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "property_name": property_name,
        "relationShip": relationship,
        "isPublished": ispublished,
        "duration": duration,
        "slots": slots,
        "createdon": createdon,
        "updatedon": updatedon,
      };
}
