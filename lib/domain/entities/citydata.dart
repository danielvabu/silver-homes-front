

class CityData {
  int? StateID;
  int? ID;
  String? CityName;

  CityData({
    this.StateID,
    this.ID,
    this.CityName,
  });

  factory CityData.fromJson(Map<String, dynamic> json) =>
      CityData(
        StateID: json["StateID"] != null ? json["StateID"] : 0,
        ID: json["ID"] != null ? json["ID"] : 0,
        CityName: json["CityName"] != null
            ? json["CityName"].toString()
            : "",
      );

  Map toJson() =>
      {
        "StateID": StateID,
        "ID": ID,
        "CityName": CityName,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["StateID"] = StateID;
    map["ID"] = ID;
    map["CityName"] = CityName;
    return map;
  }
}