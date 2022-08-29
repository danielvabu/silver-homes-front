import 'package:silverhome/tablayer/tablePOJO.dart';

class EventTypesData {
  String? id;
  String? name;
  bool? ispublished;
  String? datefrom;
  String? dateto;
  bool? spa;
  bool? notap;
  bool? relation;
  bool? showing;
  String? location;
  String? description;
  String? link;
  String? color;
  int? range;
  int? duration;
  String? durationmed;
  int? buffer_after;
  String? buffer_after_measure;
  int? buffer_before;
  String? buffer_before_measure;
  String? confirmation_message;
  String? time_zone;
  int? time_scheduling;
  String? time_scheduling_medida;
  int? max_event_per_day;
  String? prop_id;
  int? owner_id;
  bool? sun;
  bool? mon;
  bool? tue;
  bool? wed;
  bool? thu;
  bool? fri;
  bool? sat;
  List? sunh1;
  List? sunh2;
  List? monh1;
  List? monh2;
  List? tueh1;
  List? tueh2;
  List? wedh1;
  List? wedh2;
  List? thuh1;
  List? thuh2;
  List? frih1;
  List? frih2;
  List? sath1;
  List? sath2;

  int? maximum;
  List? overrrides;
  EventTypesData(
      {this.id,
      this.name,
      this.ispublished,
      this.datefrom,
      this.dateto,
      this.spa,
      this.notap,
      this.relation,
      this.showing,
      this.location,
      this.description,
      this.link,
      this.color,
      this.range,
      this.duration,
      this.durationmed,
      this.buffer_after,
      this.buffer_after_measure,
      this.buffer_before,
      this.buffer_before_measure,
      this.confirmation_message,
      this.time_zone,
      this.time_scheduling,
      this.time_scheduling_medida,
      this.max_event_per_day,
      this.prop_id,
      this.owner_id,
      this.sun,
      this.mon,
      this.tue,
      this.wed,
      this.thu,
      this.fri,
      this.sat,
      this.sunh1,
      this.sunh2,
      this.monh1,
      this.monh2,
      this.tueh1,
      this.tueh2,
      this.wedh1,
      this.wedh2,
      this.thuh1,
      this.thuh2,
      this.frih1,
      this.frih2,
      this.sath1,
      this.sath2,
      this.maximum,
      this.overrrides});

  factory EventTypesData.fromJson(Map<String, dynamic> json) => EventTypesData(
      id: json["id"],
      name: json["name"],
      ispublished: json["ispublished"],
      datefrom: json["datefrom"],
      dateto: json["dateto"],
      spa: json["spa"],
      notap: json["notap"],
      relation: json["relation"],
      showing: json["showing"],
      location: json["location"],
      description: json["description"],
      link: json["link"],
      color: json["color"],
      range: json["range"],
      duration: json["duration"],
      durationmed: json["durationmed"],
      buffer_after: json["buffer_after"],
      buffer_after_measure: json["buffer_after_measure"],
      buffer_before: json["buffer_before"],
      buffer_before_measure: json["buffer_before_measure"],
      confirmation_message: json["confirmation_message"],
      time_zone: json["time_zone"],
      time_scheduling: json["time_scheduling"],
      time_scheduling_medida: json["time_scheduling_medida"],
      max_event_per_day: json["max_event_per_day"],
      prop_id: json["prop_id"],
      owner_id: json["owner_id"],
      sun: json["sun"],
      mon: json["mon"],
      tue: json["tue"],
      wed: json["wed"],
      thu: json["thu"],
      fri: json["fri"],
      sat: json["sat"],
      sunh1: json["sunh1"],
      sunh2: json["sunh2"],
      monh1: json["monh1"],
      monh2: json["monh2"],
      tueh1: json["tueh1"],
      tueh2: json["tueh2"],
      wedh1: json["wedh1"],
      wedh2: json["wedh2"],
      thuh1: json["thuh1"],
      thuh2: json["thuh2"],
      frih1: json["frih1"],
      frih2: json["frih2"],
      sath1: json["sath1"],
      sath2: json["sath2"],
      overrrides: json["overrrides"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "ispublished": ispublished,
        "datefrom": datefrom,
        "dateto": dateto,
        "relation": relation,
        "showing": showing,
        "location": location,
        "description": description,
        "link": link,
        "color": color,
        "range": range,
        "duration": duration,
        "durationmed": durationmed,
        "buffer_after": buffer_after,
        "buffer_after_measure": buffer_after_measure,
        "buffer_before": buffer_before,
        "buffer_before_measure": buffer_before_measure,
        "confirmation_message": confirmation_message,
        "time_zone": time_zone,
        "time_scheduling": time_scheduling,
        "time_scheduling_medida": time_scheduling_medida,
        "max_event_per_day": max_event_per_day,
        "prop_id": prop_id,
        "owner_id": owner_id,
        "sun": sun,
        "mon": mon,
        "tue": tue,
        "wed": wed,
        "thu": thu,
        "fri": fri,
        "sat": sat,
        "sunh1": sunh1,
        "sunh2": sunh2,
        "monh1": monh1,
        "monh2": monh2,
        "tueh1": tueh1,
        "tueh2": tueh2,
        "wedh1": wedh1,
        "wedh2": wedh2,
        "thuh1": thuh1,
        "thuh2": thuh2,
        "frih1": frih1,
        "frih2": frih2,
        "sath1": sath1,
        "sath2": sath2,
        "overrrides": overrrides
      };
}
