import 'package:silverhome/domain/entities/event_typesdata.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class Slots {
  Slots({
    this.eventTypesData,
    this.eventTypesDataId,
    this.date_start,
    this.date_end,
    this.name,
    this.fname,
    this.lname,
    this.phone,
    this.person_id,
    this.email,
    this.state,
    this.isOpen,
  });
  int? eventTypesDataId;
  String? date_start;
  String? date_end;
  String? name;
  String? fname;
  String? lname;
  String? phone;
  String? person_id;
  String? email;
  int? state;
  EventTypesData? eventTypesData;
  bool? isOpen;

  factory Slots.fromJson(Map<String, dynamic> json) => Slots(
        eventTypesData: json["eventTypesData"],
        eventTypesDataId: json["eventTypesDataId"],
        date_start: json["date_start"],
        date_end: json["date_end"],
        name: json["name"],
        fname: json["fname"],
        lname: json["lname"],
        phone: json["phone"],
        person_id: json["person_id"],
        email: json["email"],
        state: json["state"],
        isOpen: json["isOpen"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "eventTypesData": eventTypesData,
        "eventTypesDataId": eventTypesDataId,
        "date_start": date_start,
        "date_end": date_end,
        "name": name,
        "fname": fname,
        "lname": lname,
        "phone": phone,
        "person_id": person_id,
        "email": email,
        "state": state,
      };
}
