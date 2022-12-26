class TenancyAdditionalOccupant {
  String? id;
  String? firstname;
  String? lastname;
  String? email;
  String? mobilenumber;
  String? primaryApplicant;
  String? OccupantID;
  bool? errro_firstname = false;
  bool? errro_lastname = false;
  bool? errro_email = false;
  bool? errro_mobilenumber = false;
  bool? errro_primaryApplicant = false;

  TenancyAdditionalOccupant({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.mobilenumber,
    this.primaryApplicant,
    this.OccupantID,
    this.errro_firstname,
    this.errro_lastname,
    this.errro_email,
    this.errro_mobilenumber,
    this.errro_primaryApplicant,
  });

  TenancyAdditionalOccupant.clone(TenancyAdditionalOccupant source)
      : this.id = source.id,
        this.firstname = source.firstname,
        this.lastname = source.lastname,
        this.email = source.email,
        this.mobilenumber = source.mobilenumber,
        this.primaryApplicant = source.primaryApplicant,
        this.OccupantID = source.OccupantID,
        this.errro_firstname = source.errro_firstname,
        this.errro_lastname = source.errro_lastname,
        this.errro_email = source.errro_email,
        this.errro_mobilenumber = source.errro_mobilenumber,
        this.errro_primaryApplicant = source.errro_primaryApplicant;

  factory TenancyAdditionalOccupant.fromJson(Map<String, dynamic> json) =>
      TenancyAdditionalOccupant(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        mobilenumber: json["mobilenumber"],
        primaryApplicant: json["primaryApplicant"],
        OccupantID: json["OccupantID"],
        errro_firstname: json["errro_firstname"],
        errro_lastname: json["errro_lastname"],
        errro_email: json["errro_email"],
        errro_mobilenumber: json["errro_mobilenumber"],
        errro_primaryApplicant: json["errro_primaryApplicant"],
      );

  Map toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "mobilenumber": mobilenumber,
        "primaryApplicant": primaryApplicant,
        "OccupantID": OccupantID,
        "errro_firstname": errro_firstname,
        "errro_lastname": errro_lastname,
        "errro_mobilenumber": errro_mobilenumber,
        "errro_primaryApplicant": errro_primaryApplicant
      };
}
