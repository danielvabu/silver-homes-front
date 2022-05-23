class LeadReference {
  String? propertyName;
  String? referenceName;
  String? questionnaireReceivedDate;
  String? referenceId;
  String? applicantId;
  String? relationship;
  String? landlordName;
  String? propertyId;
  String? toEmail;
  String? phoneNumber;
  String? applicantName;
  String? applicationid;
  String? questionnaireSentDate;
  String? personId;
  String? propertyAddress;
  String? id;
  bool? check;

  LeadReference({
    this.propertyName,
    this.referenceName,
    this.questionnaireReceivedDate,
    this.referenceId,
    this.applicantId,
    this.relationship,
    this.landlordName,
    this.propertyId,
    this.toEmail,
    this.phoneNumber,
    this.questionnaireSentDate,
    this.personId,
    this.propertyAddress,
    this.applicantName,
    this.applicationid,
    this.id,
    this.check,
  });

  factory LeadReference.fromJson(Map<String, dynamic> json) => LeadReference(
        propertyName: json["PropertyName"],
        referenceName: json["ReferenceName"],
        questionnaireReceivedDate: json["QuestionnaireReceivedDate"],
        referenceId: json["ReferenceID"],
        applicantId: json["Applicant_ID"],
        relationship: json["Relationship"],
        landlordName: json["LandlordName"],
        propertyId: json["PropertyID"],
        toEmail: json["ToEmail"],
        phoneNumber: json["PhoneNumber"],
        applicantName: json["ApplicantName"],
        applicationid: json["applicationid"],
        questionnaireSentDate: json["QuestionnaireSentDate"],
        personId: json["PersonID"],
        propertyAddress: json["Property_Address"],
        id: json["ID"],
        check: json["check"] != null ? json["check"] : false,
      );

  Map<String, dynamic> toJson() => {
        "PropertyName": propertyName,
        "ReferenceName": referenceName,
        "QuestionnaireReceivedDate": questionnaireReceivedDate,
        "ReferenceID": referenceId,
        "Applicant_ID": applicantId,
        "Relationship": relationship,
        "LandlordName": landlordName,
        "PropertyID": propertyId,
        "ToEmail": toEmail,
        "PhoneNumber": phoneNumber,
        "ApplicantName": applicantName,
        "applicationid": applicationid,
        "QuestionnaireSentDate": questionnaireSentDate,
        "PersonID": personId,
        "Property_Address": propertyAddress,
        "ID": id,
        "check": check,
      };
}
