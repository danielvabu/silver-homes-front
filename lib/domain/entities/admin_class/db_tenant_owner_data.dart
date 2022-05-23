class DbTenantOwnerData {
  DbTenantOwnerData({
    this.email,
    this.userType,
    this.id,
    this.name,
    this.landlordname,
    this.PropertyName,
  });

  String? email;
  int? userType;
  int? id;
  String? name;
  String? landlordname;
  String? PropertyName;

  factory DbTenantOwnerData.fromJson(Map<String, dynamic> json) =>
      DbTenantOwnerData(
        email: json["Email"] != null ? json["Email"] : "",
        userType: json["UserType"] != null ? json["UserType"] : 0,
        id: json["ID"] != null ? json["ID"] : 0,
        name: json["Name"] != null ? json["Name"] : "",
        landlordname: json["Landlord"] != null ? json["Landlord"] : "",
        PropertyName:
            json["Property Name"] != null ? json["Property Name"] : "",
      );

  Map<String, dynamic> toJson() => {
        "Email": email,
        "UserType": userType,
        "ID": id,
        "Name": name,
        "Landlord": landlordname,
        "Property Name": PropertyName,
      };
}
