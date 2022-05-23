class TenancyAdditionalReference {
  String? id;
  String? firstname;
  String? lastname;
  String? reletionshipprimaryApplicant;
  String? phonenumber;
  String? email;
  String? countrycode;
  String? dailcode;
  String? ReferenceID;
  String? QuestionnaireReceivedDate;
  String? QuestionnaireSentDate;
  bool? isEditable = false;
  bool? isLive = false;
  bool? error_firstname = false;
  bool? error_lastname = false;
  bool? error_reletionshipprimaryApplicant = false;
  bool? error_phonenumber = false;
  bool? error_email = false;

  TenancyAdditionalReference({
    this.id,
    this.firstname,
    this.lastname,
    this.reletionshipprimaryApplicant,
    this.phonenumber,
    this.email,
    this.countrycode,
    this.dailcode,
    this.ReferenceID,
    this.QuestionnaireReceivedDate,
    this.QuestionnaireSentDate,
    this.isEditable,
    this.isLive,
    this.error_firstname,
    this.error_lastname,
    this.error_reletionshipprimaryApplicant,
    this.error_phonenumber,
    this.error_email,
  });

  TenancyAdditionalReference.clone(TenancyAdditionalReference source)
      : this.id = source.id,
        this.firstname = source.firstname,
        this.lastname = source.lastname,
        this.reletionshipprimaryApplicant = source.reletionshipprimaryApplicant,
        this.phonenumber = source.phonenumber,
        this.email = source.email,
        this.countrycode = source.countrycode,
        this.dailcode = source.dailcode,
        this.ReferenceID = source.ReferenceID,
        this.QuestionnaireReceivedDate = source.QuestionnaireReceivedDate,
        this.QuestionnaireSentDate = source.QuestionnaireSentDate,
        this.isEditable = source.isEditable,
        this.isLive = source.isLive,
        this.error_firstname = source.error_firstname,
        this.error_lastname = source.error_lastname,
        this.error_reletionshipprimaryApplicant =
            source.error_reletionshipprimaryApplicant,
        this.error_phonenumber = source.error_phonenumber,
        this.error_email = source.error_email;

  factory TenancyAdditionalReference.fromJson(Map<String, dynamic> json) =>
      TenancyAdditionalReference(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        reletionshipprimaryApplicant: json["ReletionshipprimaryApplicant"],
        phonenumber: json["phonenumber"],
        email: json["email"],
        countrycode: json["countrycode"],
        dailcode: json["dailcode"],
        ReferenceID: json["ReferenceID"],
        QuestionnaireReceivedDate: json["QuestionnaireReceivedDate"],
        QuestionnaireSentDate: json["QuestionnaireSentDate"],
        isEditable: json["isEditable"],
        isLive: json["isLive"],
        error_firstname: json["error_firstname"],
        error_lastname: json["error_lastname"],
        error_reletionshipprimaryApplicant:
            json["error_reletionshipprimaryApplicant"],
        error_phonenumber: json["error_phonenumber"],
        error_email: json["error_email"],
      );

  Map toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "ReletionshipprimaryApplicant": reletionshipprimaryApplicant,
        "phonenumber": phonenumber,
        "email": email,
        "countrycode": countrycode,
        "dailcode": dailcode,
        "ReferenceID": ReferenceID,
        "QuestionnaireReceivedDate": QuestionnaireReceivedDate,
        "QuestionnaireSentDate": QuestionnaireSentDate,
        "isEditable": isEditable,
        "isLive": isLive,
        "error_firstname": error_firstname,
        "error_lastname": error_lastname,
        "error_reletionshipprimaryApplicant":
            error_reletionshipprimaryApplicant,
        "error_phonenumber": error_phonenumber,
        "error_email": error_email,
      };
}
