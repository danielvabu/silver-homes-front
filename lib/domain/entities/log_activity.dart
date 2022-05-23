class LogActivity {
  int? id;
  int? Owner_ID;
  int? Maintenance_ID;
  String? LogText;
  String? Date_Created;

  LogActivity({
    this.id,
    this.Owner_ID,
    this.Maintenance_ID,
    this.LogText,
    this.Date_Created,
  });

  factory LogActivity.fromJson(Map<String, dynamic> json) => LogActivity(
    id: json["ID"],
    Owner_ID: json["Owner_ID"],
    Maintenance_ID: json["Maintenance_ID"],
    LogText: json["LogText"],
    Date_Created: json["Date_Created"],
  );

  Map toJson() => {
    "ID": id,
    "Owner_ID": Owner_ID,
    "Maintenance_ID": Maintenance_ID,
    "LogText": LogText,
    "Date_Created": Date_Created,
  };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["Owner_ID"] = Owner_ID;
    map["Maintenance_ID"] = Maintenance_ID;
    map["LogText"] = LogText;
    map["Date_Created"] = Date_Created;
    return map;
  }
}
