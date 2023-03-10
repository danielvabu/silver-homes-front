import 'package:silverhome/tablayer/tablePOJO.dart';

class EventTypesDataList {
  EventTypesDataList({
    this.id,
    this.name,
    this.ispublished,
    this.property_name,
    this.propId,
    this.color,
    this.relationship,
    this.duration,
    this.slots,
    this.url,
    this.createdon,
    this.updatedon,
  });
  String? id;
  String? name;
  bool? ispublished;
  String? property_name;
  String? propId;
  String? color;
  String? relationship;
  String? duration;
  int? slots;
  String? url;
  String? createdon;
  String? updatedon;

  factory EventTypesDataList.fromJson(Map<String, dynamic> json) =>
      EventTypesDataList(
        id: json["id"],
        name: json["name"],
        property_name: json["property_name"],
        propId: json["prop_id"],
        color: json["color"],
        relationship: json["relationship"],
        ispublished: json["ispublished"],
        duration: json["duration"],
        slots: json["slots"],
        url: json["url"],
        createdon: json["createdon"],
        updatedon: json["updatedon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "property_name": property_name,
        "propId": propId,
        "color": color,
        "relationShip": relationship,
        "isPublished": ispublished,
        "duration": duration,
        "slots": slots,
        "url": url,
        "createdon": createdon,
        "updatedon": updatedon,
      };
}
