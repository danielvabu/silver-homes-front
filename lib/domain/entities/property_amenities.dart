class PropertyAmenitiesUtility {
  int? id;
  String? Feature;
  String? value;
  int? Feature_Type;

  PropertyAmenitiesUtility.clone(PropertyAmenitiesUtility source)
      : this.id = source.id,
        this.Feature = source.Feature,
        this.value = source.value,
        this.Feature_Type = source.Feature_Type;

  PropertyAmenitiesUtility({
    this.id,
    this.Feature,
    this.value,
    this.Feature_Type,
  });

  factory PropertyAmenitiesUtility.fromJson(Map<String, dynamic> json) =>
      PropertyAmenitiesUtility(
        id: json["ID"],
        Feature: json["Feature"],
        value: json["value"],
        Feature_Type: json["Feature_Type"],
      );

  Map toJson() => {
        "ID": id,
        "Feature": Feature,
        "value": value,
        "Feature_Type": Feature_Type,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["ID"] = id;
    map["Feature"] = Feature;
    map["value"] = value;
    map["Feature_Type"] = Feature_Type;
    return map;
  }
}
