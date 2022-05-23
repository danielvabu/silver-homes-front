class Demo {
  int? id;
  String? firstname;
  String? lastname;
  bool? ishover;

  Demo({
    this.id,
    this.firstname,
    this.lastname,
    this.ishover,
  });

  factory Demo.fromJson(Map<String, dynamic> json) => Demo(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        ishover: json["ishover"],
      );

  Map toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "ishover": ishover,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["firstname"] = firstname;
    map["lastname"] = lastname;
    map["ishover"] = ishover;
    return map;
  }
}
