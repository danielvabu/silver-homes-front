class BulkProperty {
  String? Name;
  String? Mandatory;
  String? Invalid;

  BulkProperty({
    this.Name,
    this.Mandatory,
    this.Invalid,
  });

  factory BulkProperty.fromJson(Map<String, dynamic> json) => BulkProperty(
        Name: json["Name"] != null ? json["Name"] : "",
        Mandatory: json["Mandatory"] != null ? json["Mandatory"] : "",
        Invalid: json["Invalid"] != null ? json["Invalid"] : "",
      );

  Map toJson() => {
        "Name": Name,
        "Mandatory": Mandatory,
        "Invalid": Invalid,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["Name"] = Name;
    map["Mandatory"] = Mandatory;
    map["Invalid"] = Invalid;
    return map;
  }
}
