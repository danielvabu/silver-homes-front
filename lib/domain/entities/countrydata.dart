
class CountryData {
  int? ID;
  String? CountryName;

  CountryData({
    this.ID,
    this.CountryName,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) =>
      CountryData(
        ID: json["ID"] != null ? json["ID"] : 0,
        CountryName: json["CountryName"] != null
            ? json["CountryName"].toString()
            : "",
      );

  Map toJson() =>
      {
        "ID": ID,
        "CountryName": CountryName,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["ID"] = ID;
    map["CountryName"] = CountryName;
    return map;
  }
}