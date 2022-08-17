import 'package:silverhome/tablayer/tablePOJO.dart';

class Event_typedata {
  String? name;
  bool? relation;
  bool? showing;
  String? location;
  String? description;
  String? link;
  String? color;
  int? range;
  int? duration;
  int? buffer_after;
  int? buffer_after_measure;
  int? buffer_before;
  int? buffer_before_measure;
  String? confirmation_message;
  int? time_zone;
  int? time_scheduling;
  int? time_scheduling_medida;
  int? max_event_per_day;
  String? prop_id;
  int? owner_id;
  Event_typedata(
      {this.name,
      this.relation,
      this.showing,
      this.location,
      this.description,
      this.link,
      this.color,
      this.range,
      this.duration,
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
      this.owner_id});

  factory Event_typedata.fromJson(Map<String, dynamic> json) => Event_typedata(
        name: json["name"],
        relation: json["relation"],
        showing: json["showing"],
        location: json["location"],
        description: json["description"],
        link: json["link"],
        color: json["color"],
        range: json["range"],
        duration: json["duration"],
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
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "relation": relation,
        "showing": showing,
        "location": location,
        "description": description,
        "link": link,
        "color": color,
        "range": range,
        "duration": duration,
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
      };
}
