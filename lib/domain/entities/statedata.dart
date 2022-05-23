class StateData {
  int? CountryID;
  int? ID;
  String? StateName;

  StateData({
    this.CountryID,
    this.ID,
    this.StateName,
  });

  factory StateData.fromJson(Map<String, dynamic> json) =>
      StateData(
        CountryID: json["CountryID"] != null ? json["CountryID"] : 0,
        ID: json["ID"] != null ? json["ID"] : 0,
        StateName: json["StateName"] != null
            ? json["StateName"].toString()
            : "",
      );

  Map toJson() =>
      {
        "CountryID": CountryID,
        "ID": ID,
        "StateName": StateName,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["CountryID"] = CountryID;
    map["ID"] = ID;
    map["StateName"] = StateName;
    return map;
  }
}