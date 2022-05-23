class EmailExit {
  EmailExit({
    this.personId,
    this.email,
    this.id,
    this.ownerId,
    this.applicantId,
    this.propId,
  });

  int? personId;
  String? email;
  int? id;
  int? ownerId;
  int? applicantId;
  String? propId;

  factory EmailExit.fromJson(Map<String, dynamic> json) => EmailExit(
        personId: json["PersonID"] != null ? json["PersonID"] : 0,
        email: json["Email"] != null ? json["Email"] : "",
        id: json["ID"] != null ? json["ID"] : 0,
        ownerId: json["Owner_ID"] != null ? json["Owner_ID"] : 0,
        applicantId: json["Applicant_ID"] != null ? json["Applicant_ID"] : 0,
        propId: json["Prop_ID"] != null ? json["Prop_ID"] : "",
      );

  Map<String, dynamic> toJson() => {
        "PersonID": personId,
        "Email": email,
        "ID": id,
        "Owner_ID": ownerId,
        "Applicant_ID": applicantId,
        "Prop_ID": propId,
      };
}
