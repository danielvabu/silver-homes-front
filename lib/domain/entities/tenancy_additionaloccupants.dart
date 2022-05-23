class TenancyAdditionalOccupant {
  String? id;
  String? firstname;
  String? lastname;
  String? primaryApplicant;
  String? OccupantID;
  bool? errro_firstname = false;
  bool? errro_lastname = false;
  bool? errro_primaryApplicant = false;

  TenancyAdditionalOccupant({
    this.id,
    this.firstname,
    this.lastname,
    this.primaryApplicant,
    this.OccupantID,
    this.errro_firstname,
    this.errro_lastname,
    this.errro_primaryApplicant,
  });

  TenancyAdditionalOccupant.clone(TenancyAdditionalOccupant source)
      : this.id = source.id,
        this.firstname = source.firstname,
        this.lastname = source.lastname,
        this.primaryApplicant = source.primaryApplicant,
        this.OccupantID = source.OccupantID,
        this.errro_firstname = source.errro_firstname,
        this.errro_lastname = source.errro_lastname,
        this.errro_primaryApplicant = source.errro_primaryApplicant;

  factory TenancyAdditionalOccupant.fromJson(Map<String, dynamic> json) =>
      TenancyAdditionalOccupant(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        primaryApplicant: json["primaryApplicant"],
        OccupantID: json["OccupantID"],
        errro_firstname: json["errro_firstname"],
        errro_lastname: json["errro_lastname"],
        errro_primaryApplicant: json["errro_primaryApplicant"],
      );

  Map toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "primaryApplicant": primaryApplicant,
        "OccupantID": OccupantID,
        "errro_firstname": errro_firstname,
        "errro_lastname": errro_lastname,
        "errro_primaryApplicant": errro_primaryApplicant
      };
}
