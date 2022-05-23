class NewLead {
  int? id;
  String? firstname;
  String? lastname;
  String? phoneNumber;
  String? Email;
  String? PrivateNotes;
  String? CountryCode;
  String? CountrydialCode;

  NewLead({
    this.id,
    this.firstname,
    this.lastname,
    this.phoneNumber,
    this.Email,
    this.PrivateNotes,
    this.CountryCode,
    this.CountrydialCode,
  });

  factory NewLead.fromJson(Map<String, dynamic> json) => NewLead(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        phoneNumber: json["phoneNumber"],
        Email: json["Email"],
        PrivateNotes: json["PrivateNotes"],
        CountryCode: json["CountryCode"],
        CountrydialCode: json["CountrydialCode"],
      );

  Map toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "phoneNumber": phoneNumber,
        "Email": Email,
        "PrivateNotes": PrivateNotes,
        "CountryCode": CountryCode,
        "CountrydialCode": CountrydialCode,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["firstname"] = firstname;
    map["lastname"] = lastname;
    map["phoneNumber"] = phoneNumber;
    map["Email"] = Email;
    map["PrivateNotes"] = PrivateNotes;
    map["CountryCode"] = CountryCode;
    map["CountrydialCode"] = CountrydialCode;
    return map;
  }
}
