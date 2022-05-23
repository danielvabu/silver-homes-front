class LandLordData {
  bool? activeInactive;
  String? firstName;
  int? ownerId;
  String? dialCode;
  String? countryCode;
  int? ofProperties;
  String? roles;
  String? lastName;
  String? phoneNumber;
  int? id;
  String? landlordName;
  String? email;
  bool? IsPrimarySuperAdmin;

  LandLordData({
    this.activeInactive,
    this.firstName,
    this.ownerId,
    this.dialCode,
    this.countryCode,
    this.ofProperties,
    this.roles,
    this.lastName,
    this.phoneNumber,
    this.id,
    this.landlordName,
    this.email,
    this.IsPrimarySuperAdmin,
  });

  factory LandLordData.fromJson(Map<String, dynamic> json) => LandLordData(
        activeInactive:
            json["Active/Inactive"] != null ? json["Active/Inactive"] : false,
        firstName: json["FirstName"] != null ? json["FirstName"] : "",
        ownerId: json["Owner_ID"] != null ? json["Owner_ID"] : 0,
        dialCode: json["Dial_Code"] != null ? json["Dial_Code"] : "+1",
        countryCode: json["Country_Code"] != null ? json["Country_Code"] : "CA",
        ofProperties:
            json["# of Properties"] != null ? json["# of Properties"] : 0,
        roles: json["Roles"] != null ? json["Roles"] : "",
        lastName: json["LastName"] != null ? json["LastName"] : "",
        phoneNumber: json["Phone Number"] != null ? json["Phone Number"] : "",
        id: json["ID"] != null ? json["ID"] : 0,
        landlordName:
            json["Landlord Name"] != null ? json["Landlord Name"] : "",
        email: json["Email"] != null ? json["Email"] : "",
        IsPrimarySuperAdmin: json["IsPrimarySuperAdmin"] != null
            ? json["IsPrimarySuperAdmin"]
            : false,
      );

  Map<String, dynamic> toJson() => {
        "Active/Inactive": activeInactive,
        "FirstName": firstName,
        "Owner_ID": ownerId,
        "Dial_Code": dialCode,
        "Country_Code": countryCode,
        "# of Properties": ofProperties,
        "Roles": roles,
        "LastName": lastName,
        "Phone Number": phoneNumber,
        "ID": id,
        "Landlord Name": landlordName,
        "Email": email,
        "IsPrimarySuperAdmin": IsPrimarySuperAdmin,
      };
}
