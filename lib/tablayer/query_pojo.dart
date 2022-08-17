class AddLead {
  AddLead({
    this.propId,
    this.applicantId,
    this.applicationStatus,
    this.docReviewStatus,
    this.referenceStatus,
    this.leaseStatus,
    this.Owner_ID,
  });

  String? propId;
  ApplicantId? applicantId;
  String? applicationStatus;
  String? docReviewStatus;
  String? referenceStatus;
  String? leaseStatus;
  String? Owner_ID;

  factory AddLead.fromJson(Map<String, dynamic> json) => AddLead(
        propId: json["Prop_ID"],
        applicantId: ApplicantId.fromJson(json["Applicant_ID"]),
        applicationStatus: json["ApplicationStatus"],
        docReviewStatus: json["DocReviewStatus"],
        referenceStatus: json["ReferenceStatus"],
        leaseStatus: json["LeaseStatus"],
        Owner_ID: json["Owner_ID"],
      );

  Map<String, dynamic> toJson() => {
        "Prop_ID": propId,
        "Applicant_ID": applicantId!.toJson(),
        "ApplicationStatus": applicationStatus,
        "DocReviewStatus": docReviewStatus,
        "ReferenceStatus": referenceStatus,
        "LeaseStatus": leaseStatus,
        "Owner_ID": Owner_ID,
      };
}

class ApplicantId {
  ApplicantId({
    this.note,
    this.personId,
  });

  String? note;
  PersonId? personId;

  factory ApplicantId.fromJson(Map<String, dynamic> json) => ApplicantId(
        note: json["Note"],
        personId: PersonId.fromJson(json["Person_ID"]),
      );

  Map<String, dynamic> toJson() => {
        "Note": note,
        "Person_ID": personId!.toJson(),
      };
}

class PersonId {
  PersonId({
    this.firstName,
    this.lastName,
    this.email,
    this.mobileNumber,
    this.Country_Code,
    this.Dial_Code,
  });

  String? firstName;
  String? lastName;
  String? email;
  String? mobileNumber;
  String? Country_Code;
  String? Dial_Code;

  factory PersonId.fromJson(Map<String, dynamic> json) => PersonId(
        firstName: json["FirstName"],
        lastName: json["LastName"],
        email: json["Email"],
        mobileNumber: json["MobileNumber"],
        Country_Code: json["Country_Code"],
        Dial_Code: json["Dial_Code"],
      );

  Map<String, dynamic> toJson() => {
        "FirstName": firstName,
        "LastName": lastName,
        "Email": email,
        "MobileNumber": mobileNumber,
        "Country_Code": Country_Code,
        "Dial_Code": Dial_Code,
      };
}

/*Edit Lead*/

class EditLead {
  EditLead({
    this.propId,
    this.applicantId,
  });

  String? propId;
  EditLeadApplicantId? applicantId;

  factory EditLead.fromJson(Map<String, dynamic> json) => EditLead(
        propId: json["Prop_ID"],
        applicantId: EditLeadApplicantId.fromJson(json["Applicant_ID"]),
      );

  Map<String, dynamic> toJson() => {
        "Prop_ID": propId,
        "Applicant_ID": applicantId!.toJson(),
      };
}

class EditLeadApplicantId {
  EditLeadApplicantId({
    this.ID,
    this.note,
    this.personId,
  });

  String? ID;
  String? note;
  EditLeadPersonId? personId;

  factory EditLeadApplicantId.fromJson(Map<String, dynamic> json) =>
      EditLeadApplicantId(
        ID: json["ID"],
        note: json["Note"],
        personId: EditLeadPersonId.fromJson(json["Person_ID"]),
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "Note": note,
        "Person_ID": personId!.toJson(),
      };
}

class EditLeadPersonId {
  EditLeadPersonId({
    this.ID,
    this.firstName,
    this.lastName,
    this.email,
    this.mobileNumber,
    this.Country_Code,
    this.Dial_Code,
  });

  String? ID;
  String? firstName;
  String? lastName;
  String? email;
  String? mobileNumber;
  String? Country_Code;
  String? Dial_Code;

  factory EditLeadPersonId.fromJson(Map<String, dynamic> json) =>
      EditLeadPersonId(
        ID: json["ID"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        email: json["Email"],
        mobileNumber: json["MobileNumber"],
        Country_Code: json["Country_Code"],
        Dial_Code: json["Dial_Code"],
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "FirstName": firstName,
        "LastName": lastName,
        "Email": email,
        "MobileNumber": mobileNumber,
        "Country_Code": Country_Code,
        "Dial_Code": Dial_Code,
      };
}

class TenancyApplicationTableView {
  String? Owner_ID;

  TenancyApplicationTableView({this.Owner_ID});

  factory TenancyApplicationTableView.fromJson(Map<String, dynamic> json) =>
      TenancyApplicationTableView(
        Owner_ID: json["Owner_ID"],
      );

  Map<String, dynamic> toJson() => {
        "Owner_ID": Owner_ID,
      };
}

class TenancyApplicationUpdateScore {
  String? ApplicationStatus;
  UpdateScoreRatingReview? applicantID;

  TenancyApplicationUpdateScore({
    this.ApplicationStatus,
    this.applicantID,
  });

  factory TenancyApplicationUpdateScore.fromJson(Map<String, dynamic> json) =>
      TenancyApplicationUpdateScore(
        ApplicationStatus: json["ApplicationStatus"],
        applicantID: UpdateScoreRatingReview.fromJson(json["Applicant_ID"]),
      );

  Map<String, dynamic> toJson() =>
      {"ApplicationStatus": ApplicationStatus, "Applicant_ID": applicantID};
}

class UpdateScoreRatingReview {
  String? ID;
  double? Rating;
  String? Note;
  String? RatingReview;

  UpdateScoreRatingReview({
    this.ID,
    this.Rating,
    this.Note,
    this.RatingReview,
  });

  factory UpdateScoreRatingReview.fromJson(Map<String, dynamic> json) =>
      UpdateScoreRatingReview(
        ID: json["ID"],
        Rating: json["Rating"],
        Note: json["Note"],
        RatingReview: json["RatingReview"],
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "Rating": Rating,
        "Note": Note,
        "RatingReview": RatingReview,
      };
}

class TenancyApplicationUpdateStatus {
  String? ApplicationStatus;

  TenancyApplicationUpdateStatus({this.ApplicationStatus});

  factory TenancyApplicationUpdateStatus.fromJson(Map<String, dynamic> json) =>
      TenancyApplicationUpdateStatus(
        ApplicationStatus: json["ApplicationStatus"],
      );

  Map<String, dynamic> toJson() => {
        "ApplicationStatus": ApplicationStatus,
      };
}

class DocumentReviewUpdateStatus {
  String? DocReviewStatus;

  DocumentReviewUpdateStatus({this.DocReviewStatus});

  factory DocumentReviewUpdateStatus.fromJson(Map<String, dynamic> json) =>
      DocumentReviewUpdateStatus(
        DocReviewStatus: json["DocReviewStatus"],
      );

  Map<String, dynamic> toJson() => {
        "DocReviewStatus": DocReviewStatus,
      };
}

class LeaseReviewUpdateStatus {
  String? LeaseStatus;

  LeaseReviewUpdateStatus({this.LeaseStatus});

  factory LeaseReviewUpdateStatus.fromJson(Map<String, dynamic> json) =>
      LeaseReviewUpdateStatus(
        LeaseStatus: json["LeaseStatus"],
      );

  Map<String, dynamic> toJson() => {
        "LeaseStatus": LeaseStatus,
      };
}

class TenancyApplicationFunnelView {
  String? Prop_ID;

  TenancyApplicationFunnelView({this.Prop_ID});

  factory TenancyApplicationFunnelView.fromJson(Map<String, dynamic> json) =>
      TenancyApplicationFunnelView(
        Prop_ID: json["Prop_ID"],
      );

  Map<String, dynamic> toJson() => {
        "Prop_ID": Prop_ID,
      };
}

class TenancyApplicationID {
  String? ID;

  TenancyApplicationID({this.ID});

  factory TenancyApplicationID.fromJson(Map<String, dynamic> json) =>
      TenancyApplicationID(
        ID: json["ID"],
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
      };
}

class TenancyApplicationUpdateArchive {
  String? IsArchived;

  TenancyApplicationUpdateArchive({
    this.IsArchived,
  });

  factory TenancyApplicationUpdateArchive.fromJson(Map<String, dynamic> json) =>
      TenancyApplicationUpdateArchive(
        IsArchived: json["IsArchived"],
      );

  Map<String, dynamic> toJson() => {
        "IsArchived": IsArchived,
      };
}

class TenancyApplicationUpdateRating {
  double? Rating;
  String? Note;

  TenancyApplicationUpdateRating({this.Rating, this.Note});

  factory TenancyApplicationUpdateRating.fromJson(Map<String, dynamic> json) =>
      TenancyApplicationUpdateRating(
        Rating: json["Rating"],
        Note: json["Note"],
      );

  Map<String, dynamic> toJson() => {
        "Rating": Rating,
        "Note": Note,
      };
}

class InviteWorkFlow {
  InviteWorkFlow({
    this.workFlowId,
    this.reqtokens,
  });

  String? workFlowId;
  InviteWorkFlowReqtokens? reqtokens;

  factory InviteWorkFlow.fromJson(Map<String, dynamic> json) => InviteWorkFlow(
        workFlowId: json["WorkFlowID"],
        reqtokens: InviteWorkFlowReqtokens.fromJson(json["Reqtokens"]),
      );

  Map<String, dynamic> toJson() => {
        "WorkFlowID": workFlowId,
        "Reqtokens": reqtokens!.toJson(),
      };
}

class InviteWorkFlowReqtokens {
  InviteWorkFlowReqtokens({
    this.id,
    this.applicationSentDate,
    this.ToEmail,
    this.HostURL,
    this.DbAppCode,
  });

  String? id;
  String? applicationSentDate;
  String? ToEmail;
  String? HostURL;
  String? DbAppCode;

  factory InviteWorkFlowReqtokens.fromJson(Map<String, dynamic> json) =>
      InviteWorkFlowReqtokens(
        id: json["ID"],
        applicationSentDate: json["ApplicationSentDate"],
        ToEmail: json["ToEmail"],
        HostURL: json["HostURL"],
        DbAppCode: json["DbAppCode"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "ApplicationSentDate": applicationSentDate,
        "ToEmail": ToEmail,
        "HostURL": HostURL,
        "DbAppCode": DbAppCode,
      };
}

class DocRequestWorkFlow {
  DocRequestWorkFlow({
    this.workFlowId,
    this.reqtokens,
  });

  String? workFlowId;
  DocRequestReqtokens? reqtokens;

  factory DocRequestWorkFlow.fromJson(Map<String, dynamic> json) =>
      DocRequestWorkFlow(
        workFlowId: json["WorkFlowID"],
        reqtokens: DocRequestReqtokens.fromJson(json["Reqtokens"]),
      );

  Map<String, dynamic> toJson() => {
        "WorkFlowID": workFlowId,
        "Reqtokens": reqtokens!.toJson(),
      };
}

class DocRequestReqtokens {
  DocRequestReqtokens({
    this.id,
    this.docRequestSentDate,
    this.ToEmail,
    this.HostURL,
    this.DbAppCode,
  });

  String? id;
  String? docRequestSentDate;
  String? ToEmail;
  String? HostURL;
  String? DbAppCode;

  factory DocRequestReqtokens.fromJson(Map<String, dynamic> json) =>
      DocRequestReqtokens(
        id: json["ID"],
        docRequestSentDate: json["DocRequestSentDate"],
        ToEmail: json["ToEmail"],
        HostURL: json["HostURL"],
        DbAppCode: json["DbAppCode"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "DocRequestSentDate": docRequestSentDate,
        "ToEmail": ToEmail,
        "HostURL": HostURL,
        "DbAppCode": DbAppCode,
      };
}

class LeaseSentWorkFlow {
  LeaseSentWorkFlow({
    this.workFlowId,
    this.reqtokens,
  });

  String? workFlowId;
  LeaseSentWorkFlowReqtokens? reqtokens;

  factory LeaseSentWorkFlow.fromJson(Map<String, dynamic> json) =>
      LeaseSentWorkFlow(
        workFlowId: json["WorkFlowID"],
        reqtokens: LeaseSentWorkFlowReqtokens.fromJson(json["Reqtokens"]),
      );

  Map<String, dynamic> toJson() => {
        "WorkFlowID": workFlowId,
        "Reqtokens": reqtokens!.toJson(),
      };
}

class LeaseSentWorkFlowReqtokens {
  LeaseSentWorkFlowReqtokens({
    this.Prop_ID,
    this.Owner_ID,
    this.Applicant_ID,
    this.IsOwneruploaded,
    this.Media_ID,
    this.AgreementSentDate,
    this.Application_ID,
    this.HostURL,
    this.DbAppCode,
  });

  String? Prop_ID;
  String? Owner_ID;
  String? Applicant_ID;
  bool? IsOwneruploaded;
  String? Media_ID;
  String? AgreementSentDate;
  String? Application_ID;
  String? HostURL;
  String? DbAppCode;

  factory LeaseSentWorkFlowReqtokens.fromJson(Map<String, dynamic> json) =>
      LeaseSentWorkFlowReqtokens(
        Prop_ID: json["Prop_ID"],
        Owner_ID: json["Owner_ID"],
        Applicant_ID: json["Applicant_ID"],
        IsOwneruploaded: json["IsOwneruploaded"],
        Media_ID: json["Media_ID"],
        AgreementSentDate: json["AgreementSentDate"],
        Application_ID: json["Application_ID"],
        HostURL: json["HostURL"],
        DbAppCode: json["DbAppCode"],
      );

  Map<String, dynamic> toJson() => {
        "Prop_ID": Prop_ID,
        "Owner_ID": Owner_ID,
        "Applicant_ID": Applicant_ID,
        "IsOwneruploaded": IsOwneruploaded,
        "Media_ID": Media_ID,
        "AgreementSentDate": AgreementSentDate,
        "Application_ID": Application_ID,
        "HostURL": HostURL,
        "DbAppCode": DbAppCode,
      };
}

class GetPropertyList {
  String? Owner_ID;

  GetPropertyList({
    this.Owner_ID,
  });

  factory GetPropertyList.fromJson(Map<String, dynamic> json) =>
      GetPropertyList(
        Owner_ID: json["Owner_ID"],
      );

  Map<String, dynamic> toJson() => {
        "Owner_ID": Owner_ID,
      };
}

class InsertProperty {
  String? PropertyName;
  String? Owner_ID;
  String? Property_ID;

  InsertProperty({
    this.PropertyName,
    this.Owner_ID,
    this.Property_ID,
  });

  factory InsertProperty.fromJson(Map<String, dynamic> json) => InsertProperty(
        PropertyName: json["PropertyName"],
        Owner_ID: json["Owner_ID"],
        Property_ID: json["Property_ID"],
      );

  Map<String, dynamic> toJson() => {
        "PropertyName": PropertyName,
        "Owner_ID": Owner_ID,
        "Property_ID": Property_ID,
      };
}

/*Tenant Signup Flow*/
class CommonID {
  String? ID;

  CommonID({
    this.ID,
  });

  factory CommonID.fromJson(Map<String, dynamic> json) => CommonID(
        ID: json["ID"],
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
      };
}

class UpdatePersonInfo {
  String? YourStory;
  PersonIdInfo? Person_ID;

  UpdatePersonInfo({
    this.YourStory,
    this.Person_ID,
  });

  factory UpdatePersonInfo.fromJson(Map<String, dynamic> json) =>
      UpdatePersonInfo(
        YourStory: json["YourStory"],
        Person_ID: PersonIdInfo.fromJson(json["Person_ID"]),
      );

  Map<String, dynamic> toJson() => {
        "YourStory": YourStory,
        "Person_ID": Person_ID!.toJson(),
      };
}

class PersonIdInfo {
  String? ID;
  String? FirstName;
  String? LastName;
  String? DOB;
  String? Email;
  String? Country_Code;
  String? Dial_Code;
  String? MobileNumber;

  PersonIdInfo({
    this.ID,
    this.FirstName,
    this.LastName,
    this.DOB,
    this.Email,
    this.Country_Code,
    this.Dial_Code,
    this.MobileNumber,
  });

  factory PersonIdInfo.fromJson(Map<String, dynamic> json) => PersonIdInfo(
        ID: json["ID"],
        FirstName: json["FirstName"],
        LastName: json["LastName"],
        DOB: json["DOB"],
        Email: json["Email"],
        Country_Code: json["Country_Code"],
        Dial_Code: json["Dial_Code"],
        MobileNumber: json["MobileNumber"],
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "FirstName": FirstName,
        "LastName": LastName,
        "DOB": DOB,
        "Email": Email,
        "Country_Code": Country_Code,
        "Dial_Code": Dial_Code,
        "MobileNumber": MobileNumber,
      };
}

class EmpOccupation {
  bool? IsCurrentOccupation;
  String? Occupation;
  String? organization;
  String? duration;
  String? annual_Income_Status;
  String? Employment_ID;

  EmpOccupation({
    this.IsCurrentOccupation,
    this.Occupation,
    this.organization,
    this.duration,
    this.annual_Income_Status,
    this.Employment_ID,
  });

  factory EmpOccupation.fromJson(Map<String, dynamic> json) => EmpOccupation(
        IsCurrentOccupation: json["IsCurrentOccupation"],
        Occupation: json["Occupation"],
        organization: json["Organization"],
        duration: json["Duration"],
        annual_Income_Status: json["Annual_Income_Status"],
        Employment_ID: json["Employment_ID"],
      );

  Map<String, dynamic> toJson() => {
        "IsCurrentOccupation": IsCurrentOccupation,
        "Occupation": Occupation,
        "Organization": organization,
        "Duration": duration,
        "Annual_Income_Status": annual_Income_Status,
        "Employment_ID": Employment_ID,
      };
}

class EmploymentInfo {
  String? Applicant_ID;
  String? Emp_Status_ID;
  String? Annual_Income_Status;
  String? OtherSourceIncome;
  String? LinkedIn;

  EmploymentInfo({
    this.Applicant_ID,
    this.Emp_Status_ID,
    this.Annual_Income_Status,
    this.OtherSourceIncome,
    this.LinkedIn,
  });

  factory EmploymentInfo.fromJson(Map<String, dynamic> json) => EmploymentInfo(
        Applicant_ID: json["Applicant_ID"],
        Emp_Status_ID: json["Emp_Status_ID"],
        Annual_Income_Status: json["Annual_Income_Status"],
        OtherSourceIncome: json["OtherSourceIncome"],
        LinkedIn: json["LinkedIn"],
      );

  Map<String, dynamic> toJson() => {
        "Applicant_ID": Applicant_ID,
        "Emp_Status_ID": Emp_Status_ID,
        "Annual_Income_Status": Annual_Income_Status,
        "OtherSourceIncome": OtherSourceIncome,
        "LinkedIn": LinkedIn,
      };
}

class DeleteOccupation {
  String? Employment_ID;

  DeleteOccupation({
    this.Employment_ID,
  });

  factory DeleteOccupation.fromJson(Map<String, dynamic> json) =>
      DeleteOccupation(
        Employment_ID: json["Employment_ID"],
      );

  Map<String, dynamic> toJson() => {
        "Employment_ID": Employment_ID,
      };
}

class DeleteEmployment {
  String? Applicant_ID;

  DeleteEmployment({
    this.Applicant_ID,
  });

  factory DeleteEmployment.fromJson(Map<String, dynamic> json) =>
      DeleteEmployment(
        Applicant_ID: json["Applicant_ID"],
      );

  Map<String, dynamic> toJson() => {
        "Applicant_ID": Applicant_ID,
      };
}

class InsertCurrentTenancy {
  String? Applicant_ID;
  String? Start_Date;
  String? End_Date;
  String? Suite;
  String? Address;
  String? City;
  String? Province;
  String? PostalCode;
  bool? CurrentLandLordIschecked_As_Reference;
  CurrentLandLord? currentLandLord;

  InsertCurrentTenancy({
    this.Applicant_ID,
    this.Start_Date,
    this.End_Date,
    this.Suite,
    this.Address,
    this.City,
    this.Province,
    this.PostalCode,
    this.CurrentLandLordIschecked_As_Reference,
    this.currentLandLord,
  });

  factory InsertCurrentTenancy.fromJson(Map<String, dynamic> json) =>
      InsertCurrentTenancy(
        Applicant_ID: json["Applicant_ID"],
        Start_Date: json["Start_Date"],
        End_Date: json["End_Date"],
        Suite: json["Suite"],
        Address: json["Address"],
        City: json["City"],
        Province: json["Province"],
        PostalCode: json["PostalCode"],
        CurrentLandLordIschecked_As_Reference:
            json["CurrentLandLordIschecked_As_Reference"],
        currentLandLord: CurrentLandLord.fromJson(json["CurrentLandLord"]),
      );

  Map<String, dynamic> toJson() => {
        "Applicant_ID": Applicant_ID,
        "Start_Date": Start_Date,
        "End_Date": End_Date,
        "Suite": Suite,
        "Address": Address,
        "City": City,
        "Province": Province,
        "PostalCode": PostalCode,
        "CurrentLandLordIschecked_As_Reference":
            CurrentLandLordIschecked_As_Reference,
        "CurrentLandLord": currentLandLord!.toJson(),
      };
}

class CurrentLandLord {
  String? FirstName;
  String? LastName;
  String? Email;
  String? Country_Code;
  String? Dial_Code;
  String? MobileNumber;

  CurrentLandLord({
    this.FirstName,
    this.LastName,
    this.Email,
    this.Country_Code,
    this.Dial_Code,
    this.MobileNumber,
  });

  factory CurrentLandLord.fromJson(Map<String, dynamic> json) =>
      CurrentLandLord(
        FirstName: json["FirstName"],
        LastName: json["LastName"],
        Email: json["Email"],
        Country_Code: json["Country_Code"],
        Dial_Code: json["Dial_Code"],
        MobileNumber: json["MobileNumber"],
      );

  Map<String, dynamic> toJson() => {
        "FirstName": FirstName,
        "LastName": LastName,
        "Email": Email,
        "Country_Code": Country_Code,
        "Dial_Code": Dial_Code,
        "MobileNumber": MobileNumber,
      };
}

class ClauseCurrentTenancy {
  String? Applicant_ID;

  ClauseCurrentTenancy({
    this.Applicant_ID,
  });

  factory ClauseCurrentTenancy.fromJson(Map<String, dynamic> json) =>
      ClauseCurrentTenancy(
        Applicant_ID: json["Applicant_ID"],
      );

  Map<String, dynamic> toJson() => {
        "Applicant_ID": Applicant_ID,
      };
}

class UpdateCurrentTenancy {
  String? Applicant_ID;
  String? Start_Date;
  String? End_Date;
  String? Suite;
  String? Address;
  String? City;
  String? Province;
  String? PostalCode;
  bool? CurrentLandLordIschecked_As_Reference;
  UpdateCurrentLandLord? currentLandLord;

  UpdateCurrentTenancy({
    this.Applicant_ID,
    this.Start_Date,
    this.End_Date,
    this.Suite,
    this.Address,
    this.City,
    this.Province,
    this.PostalCode,
    this.CurrentLandLordIschecked_As_Reference,
    this.currentLandLord,
  });

  factory UpdateCurrentTenancy.fromJson(Map<String, dynamic> json) =>
      UpdateCurrentTenancy(
        Applicant_ID: json["Applicant_ID"],
        Start_Date: json["Start_Date"],
        End_Date: json["End_Date"],
        Suite: json["Suite"],
        Address: json["Address"],
        City: json["City"],
        Province: json["Province"],
        PostalCode: json["PostalCode"],
        CurrentLandLordIschecked_As_Reference:
            json["CurrentLandLordIschecked_As_Reference"],
        currentLandLord:
            UpdateCurrentLandLord.fromJson(json["CurrentLandLord"]),
      );

  Map<String, dynamic> toJson() => {
        "Applicant_ID": Applicant_ID,
        "Start_Date": Start_Date,
        "End_Date": End_Date,
        "Suite": Suite,
        "Address": Address,
        "City": City,
        "Province": Province,
        "PostalCode": PostalCode,
        "CurrentLandLordIschecked_As_Reference":
            CurrentLandLordIschecked_As_Reference,
        "CurrentLandLord": currentLandLord!.toJson(),
      };
}

class UpdateCurrentLandLord {
  String? ID;
  String? FirstName;
  String? LastName;
  String? Email;
  String? Country_Code;
  String? Dial_Code;
  String? MobileNumber;

  UpdateCurrentLandLord({
    this.ID,
    this.FirstName,
    this.LastName,
    this.Email,
    this.Country_Code,
    this.Dial_Code,
    this.MobileNumber,
  });

  factory UpdateCurrentLandLord.fromJson(Map<String, dynamic> json) =>
      UpdateCurrentLandLord(
        ID: json["ID"],
        FirstName: json["FirstName"],
        LastName: json["LastName"],
        Email: json["Email"],
        Country_Code: json["Country_Code"],
        Dial_Code: json["Dial_Code"],
        MobileNumber: json["MobileNumber"],
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "FirstName": FirstName,
        "LastName": LastName,
        "Email": Email,
        "Country_Code": Country_Code,
        "Dial_Code": Dial_Code,
        "MobileNumber": MobileNumber,
      };
}

class DeleteAdditionalOccupant {
  String? Applicantion_ID;

  DeleteAdditionalOccupant({
    this.Applicantion_ID,
  });

  factory DeleteAdditionalOccupant.fromJson(Map<String, dynamic> json) =>
      DeleteAdditionalOccupant(
        Applicantion_ID: json["Applicantion_ID"],
      );

  Map<String, dynamic> toJson() => {
        "Applicantion_ID": Applicantion_ID,
      };
}

class DeleteAdditionalReference {
  String? Applicantion_ID;
  String? QuestionnaireSentDate;
  String? QuestionnaireReceivedDate;

  DeleteAdditionalReference({
    this.Applicantion_ID,
    this.QuestionnaireSentDate,
    this.QuestionnaireReceivedDate,
  });

  factory DeleteAdditionalReference.fromJson(Map<String, dynamic> json) =>
      DeleteAdditionalReference(
        Applicantion_ID: json["Applicantion_ID"],
        QuestionnaireSentDate: json["QuestionnaireSentDate"],
        QuestionnaireReceivedDate: json["QuestionnaireReceivedDate"],
      );

  Map<String, dynamic> toJson() => {
        "Applicantion_ID": Applicantion_ID,
        "QuestionnaireSentDate": QuestionnaireSentDate,
        "QuestionnaireReceivedDate": QuestionnaireReceivedDate,
      };
}

class UpdateAdditionalOccupants {
  bool? IsNotApplicableAddOccupant;

  UpdateAdditionalOccupants({
    this.IsNotApplicableAddOccupant,
  });

  factory UpdateAdditionalOccupants.fromJson(Map<String, dynamic> json) =>
      UpdateAdditionalOccupants(
        IsNotApplicableAddOccupant: json["IsNotApplicableAddOccupant"],
      );

  Map<String, dynamic> toJson() => {
        "IsNotApplicableAddOccupant": IsNotApplicableAddOccupant,
      };
}

class AdditionalOccupants {
  String? Applicantion_ID;
  String? relationWithApplicant;
  Occupant? occupant;

  AdditionalOccupants({
    this.Applicantion_ID,
    this.relationWithApplicant,
    this.occupant,
  });

  factory AdditionalOccupants.fromJson(Map<String, dynamic> json) =>
      AdditionalOccupants(
        Applicantion_ID: json["Applicantion_ID"],
        relationWithApplicant: json["RelationWithApplicant"],
        occupant: Occupant.fromJson(json["Occupant"]),
      );

  Map<String, dynamic> toJson() => {
        "Applicantion_ID": Applicantion_ID,
        "RelationWithApplicant": relationWithApplicant,
        "Occupant": occupant!.toJson(),
      };
}

class Occupant {
  String? FirstName;
  String? LastName;

  Occupant({
    this.FirstName,
    this.LastName,
  });

  factory Occupant.fromJson(Map<String, dynamic> json) => Occupant(
        FirstName: json["FirstName"],
        LastName: json["LastName"],
      );

  Map<String, dynamic> toJson() => {
        "FirstName": FirstName,
        "LastName": LastName,
      };
}

class AdditionalInfo {
  bool? IsPet;
  bool? IsVehicle;
  bool? IsSmoking;
  String? SmokingDesc;
  String? IntendedTenancyStartDate;
  String? IntendedPeriodNo;
  String? IntendedPeriod;

  AdditionalInfo({
    this.IsPet,
    this.IsVehicle,
    this.IsSmoking,
    this.SmokingDesc,
    this.IntendedTenancyStartDate,
    this.IntendedPeriodNo,
    this.IntendedPeriod,
  });

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) => AdditionalInfo(
        IsPet: json["IsPet"],
        IsVehicle: json["IsVehicle"],
        IsSmoking: json["IsSmoking"],
        SmokingDesc: json["SmokingDesc"],
        IntendedTenancyStartDate: json["IntendedTenancyStartDate"],
        IntendedPeriodNo: json["IntendedPeriodNo"],
        IntendedPeriod: json["IntendedPeriod"],
      );

  Map<String, dynamic> toJson() => {
        "IsPet": IsPet,
        "IsVehicle": IsVehicle,
        "IsSmoking": IsSmoking,
        "SmokingDesc": SmokingDesc,
        "IntendedTenancyStartDate": IntendedTenancyStartDate,
        "IntendedPeriodNo": IntendedPeriodNo,
        "IntendedPeriod": IntendedPeriod,
      };
}

class DeletePetVehicle {
  String? Applicant_ID;

  DeletePetVehicle({
    this.Applicant_ID,
  });

  factory DeletePetVehicle.fromJson(Map<String, dynamic> json) =>
      DeletePetVehicle(
        Applicant_ID: json["Applicant_ID"],
      );

  Map<String, dynamic> toJson() => {
        "Applicant_ID": Applicant_ID,
      };
}

class PetInfo {
  String? Applicant_ID;
  String? TypeOfPet;
  String? Size;
  String? Age;

  PetInfo({
    this.Applicant_ID,
    this.TypeOfPet,
    this.Size,
    this.Age,
  });

  factory PetInfo.fromJson(Map<String, dynamic> json) => PetInfo(
        Applicant_ID: json["Applicant_ID"],
        TypeOfPet: json["TypeOfPet"],
        Size: json["Size"],
        Age: json["Age"],
      );

  Map<String, dynamic> toJson() => {
        "Applicant_ID": Applicant_ID,
        "TypeOfPet": TypeOfPet,
        "Size": Size,
        "Age": Age,
      };
}

class VehicleInfo {
  String? Applicant_ID;
  String? Make;
  String? Model;
  String? Year;

  VehicleInfo({
    this.Applicant_ID,
    this.Make,
    this.Model,
    this.Year,
  });

  factory VehicleInfo.fromJson(Map<String, dynamic> json) => VehicleInfo(
        Applicant_ID: json["Applicant_ID"],
        Make: json["Make"],
        Model: json["Model"],
        Year: json["Year"],
      );

  Map<String, dynamic> toJson() => {
        "Applicant_ID": Applicant_ID,
        "Make": Make,
        "Model": Model,
        "Year": Year,
      };
}

class AdditionalReferences {
  bool? IsAuthorized;
  bool? IsAgreedTerms;
  String? ApplicationReceivedDate;

  AdditionalReferences({
    this.IsAuthorized,
    this.IsAgreedTerms,
    this.ApplicationReceivedDate,
  });

  factory AdditionalReferences.fromJson(Map<String, dynamic> json) =>
      AdditionalReferences(
        IsAuthorized: json["IsAuthorized"],
        IsAgreedTerms: json["IsAgreedTerms"],
        ApplicationReceivedDate: json["ApplicationReceivedDate"],
      );

  Map<String, dynamic> toJson() => {
        "IsAuthorized": IsAuthorized,
        "IsAgreedTerms": IsAgreedTerms,
        "ApplicationReceivedDate": ApplicationReceivedDate,
      };
}

class AdditionalReferencesInfo {
  String? Applicantion_ID;
  String? RelationWithApplicant;
  ReferenceID? referenceID;

  AdditionalReferencesInfo({
    this.Applicantion_ID,
    this.RelationWithApplicant,
    this.referenceID,
  });

  factory AdditionalReferencesInfo.fromJson(Map<String, dynamic> json) =>
      AdditionalReferencesInfo(
        Applicantion_ID: json["Applicantion_ID"],
        RelationWithApplicant: json["RelationWithApplicant"],
        referenceID: ReferenceID.fromJson(json["ReferenceID"]),
      );

  Map<String, dynamic> toJson() => {
        "Applicantion_ID": Applicantion_ID,
        "RelationWithApplicant": RelationWithApplicant,
        "referenceID": referenceID!.toJson(),
      };
}

class AdditionalReferencesAsCurrentTenancy {
  String? Applicantion_ID;
  String? RelationWithApplicant;
  String? referenceID;

  AdditionalReferencesAsCurrentTenancy({
    this.Applicantion_ID,
    this.RelationWithApplicant,
    this.referenceID,
  });

  factory AdditionalReferencesAsCurrentTenancy.fromJson(
          Map<String, dynamic> json) =>
      AdditionalReferencesAsCurrentTenancy(
        Applicantion_ID: json["Applicantion_ID"],
        RelationWithApplicant: json["RelationWithApplicant"],
        referenceID: json["ReferenceID"],
      );

  Map<String, dynamic> toJson() => {
        "Applicantion_ID": Applicantion_ID,
        "RelationWithApplicant": RelationWithApplicant,
        "referenceID": referenceID,
      };
}

class ReferenceID {
  String? FirstName;
  String? LastName;
  String? Email;
  String? Country_Code;
  String? Dial_Code;
  String? MobileNumber;

  ReferenceID({
    this.FirstName,
    this.LastName,
    this.Email,
    this.Country_Code,
    this.Dial_Code,
    this.MobileNumber,
  });

  factory ReferenceID.fromJson(Map<String, dynamic> json) => ReferenceID(
        FirstName: json["FirstName"],
        LastName: json["LastName"],
        Email: json["Email"],
        Country_Code: json["Country_Code"],
        Dial_Code: json["Dial_Code"],
        MobileNumber: json["MobileNumber"],
      );

  Map<String, dynamic> toJson() => {
        "FirstName": FirstName,
        "LastName": LastName,
        "Email": Email,
        "Country_Code": Country_Code,
        "Dial_Code": Dial_Code,
        "MobileNumber": MobileNumber,
      };
}

/*Register*/

class UserData {
  UserData({
    this.UserID,
    this.Roles,
    this.UserName,
    this.Company_logo,
    this.PersonID,
    this.CustomerFeatureListingURL,
  });

  String? UserID;
  String? Roles;
  String? UserName;
  String? Company_logo;
  PersonId? PersonID;
  String? CustomerFeatureListingURL;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        UserID: json["UserID"],
        Roles: json["Roles"],
        UserName: json["UserName"],
        Company_logo: json["Company_logo"],
        CustomerFeatureListingURL: json["CustomerFeatureListingURL"],
        PersonID: PersonId.fromJson(json["PersonID"]),
      );

  Map<String, dynamic> toJson() => {
        "UserID": UserID,
        "Roles": Roles,
        "UserName": UserName,
        "Company_logo": Company_logo,
        "CustomerFeatureListingURL": CustomerFeatureListingURL,
        "PersonID": PersonID!.toJson(),
      };
}

/*EventTypes*/

class EventTypesActive {
  bool? IsActive;
  bool? IsPublished;

  EventTypesActive({this.IsActive, this.IsPublished});

  factory EventTypesActive.fromJson(Map<String, dynamic> json) =>
      EventTypesActive(
        IsActive: json["IsActive"],
        IsPublished: json["IsPublished"],
      );

  Map<String, dynamic> toJson() => {
        "IsActive": IsActive,
        "IsPublished": IsPublished,
      };
}

class EventTypesUpdate {
  String? ID;
  String? Owner_ID;

  EventTypesUpdate({
    this.ID,
    this.Owner_ID,
  });

  factory EventTypesUpdate.fromJson(Map<String, dynamic> json) =>
      EventTypesUpdate(
        ID: json["ID"],
        Owner_ID: json["Owner_ID"],
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "Owner_ID": Owner_ID,
      };
}

class EventTypesIsPublished {
  bool? IsPublished;

  EventTypesIsPublished({this.IsPublished});

  factory EventTypesIsPublished.fromJson(Map<String, dynamic> json) =>
      EventTypesIsPublished(
        IsPublished: json["IsPublished"],
      );

  Map<String, dynamic> toJson() => {
        "IsPublished": IsPublished,
      };
}

/*Property*/

class PropertyInsert {
  String? PropertyName;
  String? Property_Type;
  String? Rental_Space;
  String? Property_Description;
  String? Property_Address;
  String? Suite_Unit;
  String? Building_Name;
  String? City;
  String? Province;
  String? Country;
  String? Country_Code;
  String? Postal_Code;
  String? Rent_Amount;
  String? Rent_Payment_Frequency;
  String? Lease_Type;
  String? Date_Available;
  String? Min_Lease_Duration;
  String? Other_Property_Type;
  String? Min_Lease_Number;
  String? Owner_ID;
  int? PropDrafting;
  bool? Vacancy;

  PropertyInsert({
    this.PropertyName,
    this.Property_Type,
    this.Rental_Space,
    this.Property_Description,
    this.Property_Address,
    this.Suite_Unit,
    this.Building_Name,
    this.City,
    this.Province,
    this.Country,
    this.Country_Code,
    this.Postal_Code,
    this.Rent_Amount,
    this.Rent_Payment_Frequency,
    this.Lease_Type,
    this.Date_Available,
    this.Min_Lease_Duration,
    this.Other_Property_Type,
    this.Min_Lease_Number,
    this.Owner_ID,
    this.PropDrafting,
    this.Vacancy,
  });

  factory PropertyInsert.fromJson(Map<String, dynamic> json) => PropertyInsert(
        PropertyName: json["PropertyName"],
        Property_Type: json["Property_Type"],
        Rental_Space: json["Rental_Space"],
        Property_Description: json["Property_Description"],
        Property_Address: json["Property_Address"],
        Suite_Unit: json["Suite_Unit"],
        Building_Name: json["Building_Name"],
        City: json["City"],
        Province: json["Province"],
        Country: json["Country"],
        Country_Code: json["Country_Code"],
        Postal_Code: json["Postal_Code"],
        Rent_Amount: json["Rent_Amount"],
        Rent_Payment_Frequency: json["Rent_Payment_Frequency"],
        Lease_Type: json["Lease_Type"],
        Date_Available: json["Date_Available"],
        Min_Lease_Duration: json["Min_Lease_Duration"],
        Other_Property_Type: json["Other_Property_Type"],
        Min_Lease_Number: json["Min_Lease_Number"],
        Owner_ID: json["Owner_ID"],
        PropDrafting: json["PropDrafting"],
        Vacancy: json["Vacancy"],
      );

  Map<String, dynamic> toJson() => {
        "PropertyName": PropertyName,
        "Property_Type": Property_Type,
        "Rental_Space": Rental_Space,
        "Property_Description": Property_Description,
        "Property_Address": Property_Address,
        "Suite_Unit": Suite_Unit,
        "Building_Name": Building_Name,
        "City": City,
        "Province": Province,
        "Country": Country,
        "Country_Code": Country_Code,
        "Postal_Code": Postal_Code,
        "Rent_Amount": Rent_Amount,
        "Rent_Payment_Frequency": Rent_Payment_Frequency,
        "Lease_Type": Lease_Type,
        "Date_Available": Date_Available,
        "Min_Lease_Duration": Min_Lease_Duration,
        "Other_Property_Type": Other_Property_Type,
        "Min_Lease_Number": Min_Lease_Number,
        "Owner_ID": Owner_ID,
        "PropDrafting": PropDrafting,
        "Vacancy": Vacancy,
      };
}

/*event type*/

class EventTypesInsert {
  String? PropertyName;
  String? Property_Type;
  String? Rental_Space;
  String? Property_Description;
  String? Property_Address;
  String? Suite_Unit;
  String? Building_Name;
  String? City;
  String? Province;
  String? Country;
  String? Country_Code;
  String? Postal_Code;
  String? Rent_Amount;
  String? Rent_Payment_Frequency;
  String? Lease_Type;
  String? Date_Available;
  String? Min_Lease_Duration;
  String? Other_Property_Type;
  String? Min_Lease_Number;
  String? Owner_ID;
  int? PropDrafting;
  bool? Vacancy;

  EventTypesInsert({
    this.PropertyName,
    this.Property_Type,
    this.Rental_Space,
    this.Property_Description,
    this.Property_Address,
    this.Suite_Unit,
    this.Building_Name,
    this.City,
    this.Province,
    this.Country,
    this.Country_Code,
    this.Postal_Code,
    this.Rent_Amount,
    this.Rent_Payment_Frequency,
    this.Lease_Type,
    this.Date_Available,
    this.Min_Lease_Duration,
    this.Other_Property_Type,
    this.Min_Lease_Number,
    this.Owner_ID,
    this.PropDrafting,
    this.Vacancy,
  });

  factory EventTypesInsert.fromJson(Map<String, dynamic> json) =>
      EventTypesInsert(
        PropertyName: json["PropertyName"],
        Property_Type: json["Property_Type"],
        Rental_Space: json["Rental_Space"],
        Property_Description: json["Property_Description"],
        Property_Address: json["Property_Address"],
        Suite_Unit: json["Suite_Unit"],
        Building_Name: json["Building_Name"],
        City: json["City"],
        Province: json["Province"],
        Country: json["Country"],
        Country_Code: json["Country_Code"],
        Postal_Code: json["Postal_Code"],
        Rent_Amount: json["Rent_Amount"],
        Rent_Payment_Frequency: json["Rent_Payment_Frequency"],
        Lease_Type: json["Lease_Type"],
        Date_Available: json["Date_Available"],
        Min_Lease_Duration: json["Min_Lease_Duration"],
        Other_Property_Type: json["Other_Property_Type"],
        Min_Lease_Number: json["Min_Lease_Number"],
        Owner_ID: json["Owner_ID"],
        PropDrafting: json["PropDrafting"],
        Vacancy: json["Vacancy"],
      );

  Map<String, dynamic> toJson() => {
        "PropertyName": PropertyName,
        "Property_Type": Property_Type,
        "Rental_Space": Rental_Space,
        "Property_Description": Property_Description,
        "Property_Address": Property_Address,
        "Suite_Unit": Suite_Unit,
        "Building_Name": Building_Name,
        "City": City,
        "Province": Province,
        "Country": Country,
        "Country_Code": Country_Code,
        "Postal_Code": Postal_Code,
        "Rent_Amount": Rent_Amount,
        "Rent_Payment_Frequency": Rent_Payment_Frequency,
        "Lease_Type": Lease_Type,
        "Date_Available": Date_Available,
        "Min_Lease_Duration": Min_Lease_Duration,
        "Other_Property_Type": Other_Property_Type,
        "Min_Lease_Number": Min_Lease_Number,
        "Owner_ID": Owner_ID,
        "PropDrafting": PropDrafting,
        "Vacancy": Vacancy,
      };
}

class PropertyUpdate {
  String? ID;
  String? Owner_ID;

  PropertyUpdate({
    this.ID,
    this.Owner_ID,
  });

  factory PropertyUpdate.fromJson(Map<String, dynamic> json) => PropertyUpdate(
        ID: json["ID"],
        Owner_ID: json["Owner_ID"],
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "Owner_ID": Owner_ID,
      };
}

class PropertyActive {
  bool? IsActive;
  bool? IsPublished;

  PropertyActive({this.IsActive, this.IsPublished});

  factory PropertyActive.fromJson(Map<String, dynamic> json) => PropertyActive(
        IsActive: json["IsActive"],
        IsPublished: json["IsPublished"],
      );

  Map<String, dynamic> toJson() => {
        "IsActive": IsActive,
        "IsPublished": IsPublished,
      };
}

class PropertyIsPublished {
  bool? IsPublished;

  PropertyIsPublished({this.IsPublished});

  factory PropertyIsPublished.fromJson(Map<String, dynamic> json) =>
      PropertyIsPublished(
        IsPublished: json["IsPublished"],
      );

  Map<String, dynamic> toJson() => {
        "IsPublished": IsPublished,
      };
}

class PropID {
  String? Prop_ID;

  PropID({this.Prop_ID});

  factory PropID.fromJson(Map<String, dynamic> json) => PropID(
        Prop_ID: json["Prop_ID"],
      );

  Map<String, dynamic> toJson() => {
        "Prop_ID": Prop_ID,
      };
}

class PropertySpecification {
  String? Bedrooms;
  String? Bathrooms;
  String? Max_Occupancy;
  String? Size;
  String? Furnishing;
  String? Other_Partial_Furniture;
  int? PropDrafting;

  PropertySpecification({
    this.Bedrooms,
    this.Bathrooms,
    this.Max_Occupancy,
    this.Size,
    this.Furnishing,
    this.Other_Partial_Furniture,
    this.PropDrafting,
  });

  factory PropertySpecification.fromJson(Map<String, dynamic> json) =>
      PropertySpecification(
        Bedrooms: json["Bedrooms"],
        Bathrooms: json["Bathrooms"],
        Max_Occupancy: json["Max_Occupancy"],
        Size: json["Size"],
        Furnishing: json["Furnishing"],
        Other_Partial_Furniture: json["Other_Partial_Furniture"],
        PropDrafting: json["PropDrafting"],
      );

  Map<String, dynamic> toJson() => {
        "Bedrooms": Bedrooms,
        "Bathrooms": Bathrooms,
        "Max_Occupancy": Max_Occupancy,
        "Size": Size,
        "Furnishing": Furnishing,
        "Other_Partial_Furniture": Other_Partial_Furniture,
        "PropDrafting": PropDrafting,
      };
}

class EventTypesSpecification {
  String? Bedrooms;
  String? Bathrooms;
  String? Max_Occupancy;
  String? Size;
  String? Furnishing;
  String? Other_Partial_Furniture;
  int? PropDrafting;

  EventTypesSpecification({
    this.Bedrooms,
    this.Bathrooms,
    this.Max_Occupancy,
    this.Size,
    this.Furnishing,
    this.Other_Partial_Furniture,
    this.PropDrafting,
  });

  factory EventTypesSpecification.fromJson(Map<String, dynamic> json) =>
      EventTypesSpecification(
        Bedrooms: json["Bedrooms"],
        Bathrooms: json["Bathrooms"],
        Max_Occupancy: json["Max_Occupancy"],
        Size: json["Size"],
        Furnishing: json["Furnishing"],
        Other_Partial_Furniture: json["Other_Partial_Furniture"],
        PropDrafting: json["PropDrafting"],
      );

  Map<String, dynamic> toJson() => {
        "Bedrooms": Bedrooms,
        "Bathrooms": Bathrooms,
        "Max_Occupancy": Max_Occupancy,
        "Size": Size,
        "Furnishing": Furnishing,
        "Other_Partial_Furniture": Other_Partial_Furniture,
        "PropDrafting": PropDrafting,
      };
}

class PropertyRestriction {
  String? Prop_ID;
  String? Restrictions;

  PropertyRestriction({this.Prop_ID, this.Restrictions});

  factory PropertyRestriction.fromJson(Map<String, dynamic> json) =>
      PropertyRestriction(
        Prop_ID: json["Prop_ID"],
        Restrictions: json["Restrictions"],
      );

  Map<String, dynamic> toJson() => {
        "Prop_ID": Prop_ID,
        "Restrictions": Restrictions,
      };
}

class EventTypesRestriction {
  String? Prop_ID;
  String? Restrictions;

  EventTypesRestriction({this.Prop_ID, this.Restrictions});

  factory EventTypesRestriction.fromJson(Map<String, dynamic> json) =>
      EventTypesRestriction(
        Prop_ID: json["Prop_ID"],
        Restrictions: json["Restrictions"],
      );

  Map<String, dynamic> toJson() => {
        "Prop_ID": Prop_ID,
        "Restrictions": Restrictions,
      };
}

class PropertyFeature {
  String? StorageAvailable;
  String? Parking_Stalls;
  int? PropDrafting;

  PropertyFeature({
    this.StorageAvailable,
    this.Parking_Stalls,
    this.PropDrafting,
  });

  factory PropertyFeature.fromJson(Map<String, dynamic> json) =>
      PropertyFeature(
        StorageAvailable: json["StorageAvailable"],
        Parking_Stalls: json["Parking_Stalls"],
        PropDrafting: json["PropDrafting"],
      );

  Map<String, dynamic> toJson() => {
        "StorageAvailable": StorageAvailable,
        "Parking_Stalls": Parking_Stalls,
        "PropDrafting": PropDrafting,
      };
}

class PropertyAminityUtility {
  String? Prop_ID;
  String? Feature_ID;
  String? Feature_Value;

  PropertyAminityUtility({
    this.Prop_ID,
    this.Feature_ID,
    this.Feature_Value,
  });

  factory PropertyAminityUtility.fromJson(Map<String, dynamic> json) =>
      PropertyAminityUtility(
        Prop_ID: json["Prop_ID"],
        Feature_ID: json["Feature_ID"],
        Feature_Value: json["Feature_Value"],
      );

  Map<String, dynamic> toJson() => {
        "Prop_ID": Prop_ID,
        "Feature_ID": Feature_ID,
        "Feature_Value": Feature_Value,
      };
}

class PropertyDisclosure {
  String? Property_Image;
  bool? IsAgreed_TandC;
  bool? IsActive;
  int? PropDrafting;

  PropertyDisclosure({
    this.Property_Image,
    this.IsAgreed_TandC,
    this.IsActive,
    this.PropDrafting,
  });

  factory PropertyDisclosure.fromJson(Map<String, dynamic> json) =>
      PropertyDisclosure(
        Property_Image: json["Property_Image"],
        IsAgreed_TandC: json["IsAgreed_TandC"],
        IsActive: json["IsActive"],
        PropDrafting: json["PropDrafting"],
      );

  Map<String, dynamic> toJson() => {
        "Property_Image": Property_Image,
        "IsAgreed_TandC": IsAgreed_TandC,
        "IsActive": IsActive,
        "PropDrafting": PropDrafting,
      };
}

class EventTypesDisclosure {
  String? Property_Image;
  bool? IsAgreed_TandC;
  bool? IsActive;
  int? PropDrafting;

  EventTypesDisclosure({
    this.Property_Image,
    this.IsAgreed_TandC,
    this.IsActive,
    this.PropDrafting,
  });

  factory EventTypesDisclosure.fromJson(Map<String, dynamic> json) =>
      EventTypesDisclosure(
        Property_Image: json["Property_Image"],
        IsAgreed_TandC: json["IsAgreed_TandC"],
        IsActive: json["IsActive"],
        PropDrafting: json["PropDrafting"],
      );

  Map<String, dynamic> toJson() => {
        "Property_Image": Property_Image,
        "IsAgreed_TandC": IsAgreed_TandC,
        "IsActive": IsActive,
        "PropDrafting": PropDrafting,
      };
}

class PropertyListInDropDown {
  String? IsActive;
  String? Owner_ID;

  PropertyListInDropDown({
    this.IsActive,
    this.Owner_ID,
  });

  factory PropertyListInDropDown.fromJson(Map<String, dynamic> json) =>
      PropertyListInDropDown(
        IsActive: json["IsActive"],
        Owner_ID: json["Owner_ID"],
      );

  Map<String, dynamic> toJson() => {
        "IsActive": IsActive,
        "Owner_ID": Owner_ID,
      };
}

class ForgotPassword {
  String? UserName;

  ForgotPassword({
    this.UserName,
  });

  factory ForgotPassword.fromJson(Map<String, dynamic> json) => ForgotPassword(
        UserName: json["UserName"],
      );

  Map<String, dynamic> toJson() => {
        "UserName": UserName,
      };
}

class UserInfoID {
  String? UserID;

  UserInfoID({
    this.UserID,
  });

  factory UserInfoID.fromJson(Map<String, dynamic> json) => UserInfoID(
        UserID: json["UserID"],
      );

  Map<String, dynamic> toJson() => {
        "UserID": UserID,
      };
}

class DeleteApplicationDocument {
  String? Application_ID;

  DeleteApplicationDocument({
    this.Application_ID,
  });

  factory DeleteApplicationDocument.fromJson(Map<String, dynamic> json) =>
      DeleteApplicationDocument(
        Application_ID: json["Application_ID"],
      );

  Map<String, dynamic> toJson() => {
        "Application_ID": Application_ID,
      };
}

class InsertApplicationDocument {
  String? Media_ID;
  String? Application_ID;

  InsertApplicationDocument({
    this.Media_ID,
    this.Application_ID,
  });

  factory InsertApplicationDocument.fromJson(Map<String, dynamic> json) =>
      InsertApplicationDocument(
        Media_ID: json["Media_ID"],
        Application_ID: json["Application_ID"],
      );

  Map<String, dynamic> toJson() => {
        "Media_ID": Media_ID,
        "Application_ID": Application_ID,
      };
}

class DeletePropertyDocument {
  String? Applicant_ID;
  String? Prop_ID;
  String? IsOwneruploaded;

  DeletePropertyDocument({
    this.Applicant_ID,
    this.Prop_ID,
    this.IsOwneruploaded,
  });

  factory DeletePropertyDocument.fromJson(Map<String, dynamic> json) =>
      DeletePropertyDocument(
        Applicant_ID: json["Applicant_ID"],
        Prop_ID: json["Prop_ID"],
        IsOwneruploaded: json["IsOwneruploaded"],
      );

  Map<String, dynamic> toJson() => {
        "Applicant_ID": Applicant_ID,
        "Prop_ID": Prop_ID,
        "IsOwneruploaded": IsOwneruploaded,
      };
}

class InsertPropertyDocument {
  String? Prop_ID;
  String? Owner_ID;
  String? Applicant_ID;
  bool? IsOwneruploaded;
  String? Media_ID;
  String? Application_ID;

  InsertPropertyDocument({
    this.Prop_ID,
    this.Owner_ID,
    this.Applicant_ID,
    this.IsOwneruploaded,
    this.Media_ID,
    this.Application_ID,
  });

  factory InsertPropertyDocument.fromJson(Map<String, dynamic> json) =>
      InsertPropertyDocument(
        Prop_ID: json["Prop_ID"],
        Owner_ID: json["Owner_ID"],
        Applicant_ID: json["Applicant_ID"],
        IsOwneruploaded: json["IsOwneruploaded"],
        Media_ID: json["Media_ID"],
        Application_ID: json["Application_ID"],
      );

  Map<String, dynamic> toJson() => {
        "Prop_ID": Prop_ID,
        "Owner_ID": Owner_ID,
        "Applicant_ID": Applicant_ID,
        "IsOwneruploaded": IsOwneruploaded,
        "Media_ID": Media_ID,
        "Application_ID": Application_ID,
      };
}

class TenancyScoreVarification {
  String? ApplicationStatus;
  String? DocReviewStatus;
  TenancyScoreApplicantIDVarification? Applicant_ID;

  TenancyScoreVarification({
    this.ApplicationStatus,
    this.DocReviewStatus,
    this.Applicant_ID,
  });

  factory TenancyScoreVarification.fromJson(Map<String, dynamic> json) =>
      TenancyScoreVarification(
        ApplicationStatus: json["ApplicationStatus"],
        DocReviewStatus: json["DocReviewStatus"],
        Applicant_ID:
            TenancyScoreApplicantIDVarification.fromJson(json["Applicant_ID"]),
      );

  Map<String, dynamic> toJson() => {
        "ApplicationStatus": ApplicationStatus,
        "DocReviewStatus": DocReviewStatus,
        "Applicant_ID": Applicant_ID!.toJson(),
      };
}

class TenancyScoreApplicantIDVarification {
  String? ID;
  String? Rating;
  String? Note;

  TenancyScoreApplicantIDVarification({
    this.ID,
    this.Rating,
    this.Note,
  });

  factory TenancyScoreApplicantIDVarification.fromJson(
          Map<String, dynamic> json) =>
      TenancyScoreApplicantIDVarification(
        ID: json["ID"],
        Rating: json["Rating"],
        Note: json["Note"],
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "Rating": Rating,
        "Note": Note,
      };
}

class ReferenceRequestWorkFlow {
  ReferenceRequestWorkFlow({
    this.workFlowId,
    this.reqtokens,
  });

  String? workFlowId;
  ReferenceRequestReqtokens? reqtokens;

  factory ReferenceRequestWorkFlow.fromJson(Map<String, dynamic> json) =>
      ReferenceRequestWorkFlow(
        workFlowId: json["WorkFlowID"],
        reqtokens: ReferenceRequestReqtokens.fromJson(json["Reqtokens"]),
      );

  Map<String, dynamic> toJson() => {
        "WorkFlowID": workFlowId,
        "Reqtokens": reqtokens!.toJson(),
      };
}

class ReferenceRequestReqtokens {
  ReferenceRequestReqtokens({
    this.ID,
    this.ReferenceRequestSentDate,
    this.PersonID,
    this.HostURL,
    this.DbAppCode,
  });

  String? ID;
  String? ReferenceRequestSentDate;
  String? PersonID;
  String? HostURL;
  String? DbAppCode;

  factory ReferenceRequestReqtokens.fromJson(Map<String, dynamic> json) =>
      ReferenceRequestReqtokens(
        ID: json["ID"],
        ReferenceRequestSentDate: json["ReferenceRequestSentDate"],
        PersonID: json["PersonID"],
        HostURL: json["HostURL"],
        DbAppCode: json["DbAppCode"],
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "ReferenceRequestSentDate": ReferenceRequestSentDate,
        "PersonID": PersonID,
        "HostURL": HostURL,
        "DbAppCode": DbAppCode,
      };
}

class CheckReferenceExit {
  String? ReferenceID;

  CheckReferenceExit({
    this.ReferenceID,
  });

  factory CheckReferenceExit.fromJson(Map<String, dynamic> json) =>
      CheckReferenceExit(
        ReferenceID: json["ReferenceID"],
      );

  Map<String, dynamic> toJson() => {
        "ReferenceID": ReferenceID,
      };
}

class UpdateReferenceAnswersID {
  String? AdditionalReferencesID;

  UpdateReferenceAnswersID({
    this.AdditionalReferencesID,
  });

  factory UpdateReferenceAnswersID.fromJson(Map<String, dynamic> json) =>
      UpdateReferenceAnswersID(
        AdditionalReferencesID: json["AdditionalReferencesID"],
      );

  Map<String, dynamic> toJson() => {
        "AdditionalReferencesID": AdditionalReferencesID,
      };
}

class InsertReferenceAnswers {
  String? additionalReferencesID;
  String? lengthOfTenancy;
  String? reasonForDeparture;
  String? cleanliness;
  String? communication;
  String? respectfulness;
  String? paymentPunctuality;
  bool? isRecommendedTenant;
  String? otherComments;

  InsertReferenceAnswers({
    this.additionalReferencesID,
    this.lengthOfTenancy,
    this.reasonForDeparture,
    this.cleanliness,
    this.communication,
    this.respectfulness,
    this.paymentPunctuality,
    this.isRecommendedTenant,
    this.otherComments,
  });

  factory InsertReferenceAnswers.fromJson(Map<String, dynamic> json) =>
      InsertReferenceAnswers(
        additionalReferencesID: json["AdditionalReferencesID"],
        lengthOfTenancy: json["Length_Of_Tenancy"],
        reasonForDeparture: json["Reason_For_Departure"],
        cleanliness: json["Cleanliness"],
        communication: json["Communication"],
        respectfulness: json["Respectfulness"],
        paymentPunctuality: json["PaymentPunctuality"],
        isRecommendedTenant: json["IsRecommendedTenant"],
        otherComments: json["OtherComments"],
      );

  Map toJson() => {
        "AdditionalReferencesID": additionalReferencesID,
        "Length_Of_Tenancy": lengthOfTenancy,
        "Reason_For_Departure": reasonForDeparture,
        "Cleanliness": cleanliness,
        "Communication": communication,
        "Respectfulness": respectfulness,
        "PaymentPunctuality": paymentPunctuality,
        "IsRecommendedTenant": isRecommendedTenant,
        "OtherComments": otherComments,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["AdditionalReferencesID"] = additionalReferencesID;
    map["Length_Of_Tenancy"] = lengthOfTenancy;
    map["Reason_For_Departure"] = reasonForDeparture;
    map["Cleanliness"] = cleanliness;
    map["Communication"] = communication;
    map["Respectfulness"] = respectfulness;
    map["PaymentPunctuality"] = paymentPunctuality;
    map["IsRecommendedTenant"] = isRecommendedTenant;
    map["OtherComments"] = otherComments;
    return map;
  }
}

class InsertDocReceiveDate {
  String? DocReceivedDate;

  InsertDocReceiveDate({
    this.DocReceivedDate,
  });

  factory InsertDocReceiveDate.fromJson(Map<String, dynamic> json) =>
      InsertDocReceiveDate(
        DocReceivedDate: json["DocReceivedDate"],
      );

  Map toJson() => {
        "DocReceivedDate": DocReceivedDate,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["DocReceivedDate"] = DocReceivedDate;
    return map;
  }
}

class InsertAgreementReceivedDate {
  String? AgreementReceivedDate;

  InsertAgreementReceivedDate({
    this.AgreementReceivedDate,
  });

  factory InsertAgreementReceivedDate.fromJson(Map<String, dynamic> json) =>
      InsertAgreementReceivedDate(
        AgreementReceivedDate: json["AgreementReceivedDate"],
      );

  Map toJson() => {
        "AgreementReceivedDate": AgreementReceivedDate,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["AgreementReceivedDate"] = AgreementReceivedDate;
    return map;
  }
}

class CheckUserData {
  CheckUserData({
    this.UserID,
  });

  String? UserID;

  factory CheckUserData.fromJson(Map<String, dynamic> json) => CheckUserData(
        UserID: json["UserID"],
      );

  Map<String, dynamic> toJson() => {
        "UserID": UserID,
      };
}

class UpdateUserData {
  UpdateUserData({
    this.IsActive,
  });

  bool? IsActive;

  factory UpdateUserData.fromJson(Map<String, dynamic> json) => UpdateUserData(
        IsActive: json["IsActive"],
      );

  Map<String, dynamic> toJson() => {
        "IsActive": IsActive,
      };
}

class OwnerActiveProperty {
  bool? IsActive;
  String? Owner_ID;

  OwnerActiveProperty({
    this.IsActive,
    this.Owner_ID,
  });

  factory OwnerActiveProperty.fromJson(Map<String, dynamic> json) =>
      OwnerActiveProperty(
        IsActive: json["IsActive"],
        Owner_ID: json["Owner_ID"],
      );

  Map<String, dynamic> toJson() => {
        "IsActive": IsActive,
        "Owner_ID": Owner_ID,
      };
}

class OwnerCityProperty {
  String? Owner_ID;

  OwnerCityProperty({
    this.Owner_ID,
  });

  factory OwnerCityProperty.fromJson(Map<String, dynamic> json) =>
      OwnerCityProperty(
        Owner_ID: json["Owner_ID"],
      );

  Map<String, dynamic> toJson() => {
        "Owner_ID": Owner_ID,
      };
}

class CheckPropertyActiveTenant {
  String? ApplicationStatus;
  String? Prop_ID;

  CheckPropertyActiveTenant({
    this.ApplicationStatus,
    this.Prop_ID,
  });

  factory CheckPropertyActiveTenant.fromJson(Map<String, dynamic> json) =>
      CheckPropertyActiveTenant(
        ApplicationStatus: json["ApplicationStatus"],
        Prop_ID: json["Prop_ID"],
      );

  Map<String, dynamic> toJson() => {
        "ApplicationStatus": ApplicationStatus,
        "Prop_ID": Prop_ID,
      };
}

class PropVacancyUpdateStatus {
  String? Vacancy;

  PropVacancyUpdateStatus({this.Vacancy});

  factory PropVacancyUpdateStatus.fromJson(Map<String, dynamic> json) =>
      PropVacancyUpdateStatus(
        Vacancy: json["Vacancy"],
      );

  Map<String, dynamic> toJson() => {
        "Vacancy": Vacancy,
      };
}

/*Tenant Signup Flow*/
class NotificationIsRead {
  String? IsRead;

  NotificationIsRead({
    this.IsRead,
  });

  factory NotificationIsRead.fromJson(Map<String, dynamic> json) =>
      NotificationIsRead(
        IsRead: json["IsRead"],
      );

  Map<String, dynamic> toJson() => {
        "IsRead": IsRead,
      };
}

class AdminsideIsActive {
  bool? adminsideIsActive;

  AdminsideIsActive({
    this.adminsideIsActive,
  });

  factory AdminsideIsActive.fromJson(Map<String, dynamic> json) =>
      AdminsideIsActive(
        adminsideIsActive: json["AdminsideIsActive"],
      );

  Map<String, dynamic> toJson() => {
        "AdminsideIsActive": adminsideIsActive,
      };
}

class AdminUserData {
  AdminUserData({
    this.UserID,
    this.Roles,
    this.UserName,
    this.IsActive,
    this.PersonID,
  });

  String? UserID;
  String? Roles;
  String? UserName;
  bool? IsActive;
  PersonId? PersonID;

  factory AdminUserData.fromJson(Map<String, dynamic> json) => AdminUserData(
        UserID: json["UserID"],
        Roles: json["Roles"],
        UserName: json["UserName"],
        IsActive: json["IsActive"],
        PersonID: PersonId.fromJson(json["PersonID"]),
      );

  Map<String, dynamic> toJson() => {
        "UserID": UserID,
        "Roles": Roles,
        "UserName": UserName,
        "IsActive": IsActive,
        "PersonID": PersonID!.toJson(),
      };
}

class InsertPropertyImage {
  String? Media_ID;
  String? Property_ID;
  String? Owner_ID;

  InsertPropertyImage({
    this.Media_ID,
    this.Property_ID,
    this.Owner_ID,
  });

  factory InsertPropertyImage.fromJson(Map<String, dynamic> json) =>
      InsertPropertyImage(
        Media_ID: json["Media_ID"],
        Property_ID: json["Property_ID"],
        Owner_ID: json["Owner_ID"],
      );

  Map<String, dynamic> toJson() => {
        "Media_ID": Media_ID,
        "Property_ID": Property_ID,
        "Owner_ID": Owner_ID,
      };
}

class SelectPropertyImage {
  String? Property_ID;
  String? Owner_ID;

  SelectPropertyImage({
    this.Property_ID,
    this.Owner_ID,
  });

  factory SelectPropertyImage.fromJson(Map<String, dynamic> json) =>
      SelectPropertyImage(
        Property_ID: json["Property_ID"],
        Owner_ID: json["Owner_ID"],
      );

  Map<String, dynamic> toJson() => {
        "Property_ID": Property_ID,
        "Owner_ID": Owner_ID,
      };
}

class ProfileData {
  ProfileData({
    this.Company_logo,
    this.CompanyName,
    this.CustomerFeatureListingURL,
    this.HomePageLink,
    this.personId,
  });

  String? Company_logo;
  String? CompanyName;
  String? CustomerFeatureListingURL;
  String? HomePageLink;
  PersonDataId? personId;

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        Company_logo: json["Company_logo"],
        CompanyName: json["CompanyName"],
        CustomerFeatureListingURL: json["CustomerFeatureListingURL"],
        HomePageLink: json["HomePageLink"],
        personId: PersonDataId.fromJson(json["PersonID"]),
      );

  Map<String, dynamic> toJson() => {
        "Company_logo": Company_logo,
        "CompanyName": CompanyName,
        "CustomerFeatureListingURL": CustomerFeatureListingURL,
        "HomePageLink": HomePageLink,
        "PersonID": personId!.toJson(),
      };
}

class PersonDataId {
  PersonDataId({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.mobileNumber,
    this.Country_Code,
    this.Dial_Code,
  });

  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? mobileNumber;
  String? Country_Code;
  String? Dial_Code;

  factory PersonDataId.fromJson(Map<String, dynamic> json) => PersonDataId(
        id: json["ID"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        email: json["Email"],
        mobileNumber: json["MobileNumber"],
        Country_Code: json["Country_Code"],
        Dial_Code: json["Dial_Code"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "FirstName": firstName,
        "LastName": lastName,
        "Email": email,
        "MobileNumber": mobileNumber,
        "Country_Code": Country_Code,
        "Dial_Code": Dial_Code,
      };
}

class ApplicantIdCustomer {
  ApplicantIdCustomer({
    this.note,
    this.NumberOfOccupant,
    this.NumberOfChildren,
    this.personId,
  });

  String? note;
  String? NumberOfOccupant;
  String? NumberOfChildren;
  PersonId? personId;

  factory ApplicantIdCustomer.fromJson(Map<String, dynamic> json) =>
      ApplicantIdCustomer(
        note: json["Note"],
        NumberOfOccupant: json["NumberOfOccupant"],
        NumberOfChildren: json["NumberOfChildren"],
        personId: PersonId.fromJson(json["Person_ID"]),
      );

  Map<String, dynamic> toJson() => {
        "Note": note,
        "NumberOfOccupant": NumberOfOccupant,
        "NumberOfChildren": NumberOfChildren,
        "Person_ID": personId!.toJson(),
      };
}

class AddLeadCustomer {
  AddLeadCustomer({
    this.propId,
    this.applicantId,
    this.applicationStatus,
    this.docReviewStatus,
    this.referenceStatus,
    this.leaseStatus,
    this.Owner_ID,
  });

  String? propId;
  ApplicantIdCustomer? applicantId;
  String? applicationStatus;
  String? docReviewStatus;
  String? referenceStatus;
  String? leaseStatus;
  String? Owner_ID;

  factory AddLeadCustomer.fromJson(Map<String, dynamic> json) =>
      AddLeadCustomer(
        propId: json["Prop_ID"],
        applicantId: ApplicantIdCustomer.fromJson(json["Applicant_ID"]),
        applicationStatus: json["ApplicationStatus"],
        docReviewStatus: json["DocReviewStatus"],
        referenceStatus: json["ReferenceStatus"],
        leaseStatus: json["LeaseStatus"],
        Owner_ID: json["Owner_ID"],
      );

  Map<String, dynamic> toJson() => {
        "Prop_ID": propId,
        "Applicant_ID": applicantId!.toJson(),
        "ApplicationStatus": applicationStatus,
        "DocReviewStatus": docReviewStatus,
        "ReferenceStatus": referenceStatus,
        "LeaseStatus": leaseStatus,
        "Owner_ID": Owner_ID,
      };
}

class UpdateAdminUserInfo {
  String? UserName;
  PersonIdInfo? PersonID;

  UpdateAdminUserInfo({
    this.UserName,
    this.PersonID,
  });

  factory UpdateAdminUserInfo.fromJson(Map<String, dynamic> json) =>
      UpdateAdminUserInfo(
        UserName: json["UserName"],
        PersonID: PersonIdInfo.fromJson(json["PersonID"]),
      );

  Map<String, dynamic> toJson() => {
        "UserName": UserName,
        "PersonID": PersonID!.toJson(),
      };
}

class WebSiteMaintenance {
  WebSiteMaintenance({
    this.ID,
    this.Status,
    this.Maintenance_Instruction,
    this.Maintenance_Title,
  });

  String? ID;
  bool? Status;
  String? Maintenance_Instruction;
  String? Maintenance_Title;

  factory WebSiteMaintenance.fromJson(Map<String, dynamic> json) =>
      WebSiteMaintenance(
        ID: json["ID"],
        Status: json["Status"],
        Maintenance_Instruction: json["Maintenance_Instruction"],
        Maintenance_Title: json["Maintenance_Title"],
      );

  Map toJson() {
    var map = new Map<String?, dynamic>();
    if (ID != null && ID != "") {
      map["ID"] = ID;
    }
    if (Status != null && Status != "") {
      map["Status"] = Status;
    }
    if (Maintenance_Instruction != null && Maintenance_Instruction != "") {
      map["Maintenance_Instruction"] = Maintenance_Instruction;
    }
    if (Maintenance_Title != null && Maintenance_Title != "") {
      map["Maintenance_Title"] = Maintenance_Title;
    }
    return map;
  }
}

class MainatenanceID {
  String? ID;

  MainatenanceID({this.ID});

  factory MainatenanceID.fromJson(Map<String, dynamic> json) => MainatenanceID(
        ID: json["ID"],
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
      };
}

class MainatenanceStatus {
  String? Status;

  MainatenanceStatus({this.Status});

  factory MainatenanceStatus.fromJson(Map<String, dynamic> json) =>
      MainatenanceStatus(
        Status: json["Status"],
      );

  Map<String, dynamic> toJson() => {
        "Status": Status,
      };
}

class MainatenanceIsLock {
  bool? IsLock;

  MainatenanceIsLock({this.IsLock});

  factory MainatenanceIsLock.fromJson(Map<String, dynamic> json) =>
      MainatenanceIsLock(
        IsLock: json["IsLock"],
      );

  Map<String, dynamic> toJson() => {
        "IsLock": IsLock,
      };
}

class AddMainatenance {
  bool? IsLock;
  String? Prop_ID;
  String? Category;
  String? Priority;
  String? Describe_Issue;
  String? Status;
  String? Date_Created;
  String? Owner_ID;
  String? Type_User;
  String? RequestName;

  AddMainatenance({
    this.IsLock,
    this.Prop_ID,
    this.Category,
    this.Priority,
    this.Describe_Issue,
    this.Status,
    this.Date_Created,
    this.Owner_ID,
    this.Type_User,
    this.RequestName,
  });

  factory AddMainatenance.fromJson(Map<String, dynamic> json) =>
      AddMainatenance(
        IsLock: json["IsLock"],
        Prop_ID: json["Prop_ID"],
        Category: json["Category"],
        Priority: json["Priority"],
        Describe_Issue: json["Describe_Issue"],
        Status: json["Status"],
        Date_Created: json["Date_Created"],
        Owner_ID: json["Owner_ID"],
        Type_User: json["Type_User"],
        RequestName: json["RequestName"],
      );

  Map<String, dynamic> toJson() => {
        "IsLock": IsLock,
        "Prop_ID": Prop_ID,
        "Category": Category,
        "Priority": Priority,
        "Describe_Issue": Describe_Issue,
        "Status": Status,
        "Date_Created": Date_Created,
        "Owner_ID": Owner_ID,
        "Type_User": Type_User,
        "RequestName": RequestName,
      };
}

class VendorPersonId {
  VendorPersonId({
    this.ID,
    this.firstName,
    this.lastName,
    this.email,
    this.mobileNumber,
    this.Country_Code,
    this.Dial_Code,
  });

  String? ID;
  String? firstName;
  String? lastName;
  String? email;
  String? mobileNumber;
  String? Country_Code;
  String? Dial_Code;

  factory VendorPersonId.fromJson(Map<String, dynamic> json) => VendorPersonId(
        ID: json["ID"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        email: json["Email"],
        mobileNumber: json["MobileNumber"],
        Country_Code: json["Country_Code"],
        Dial_Code: json["Dial_Code"],
      );

  /*Map<String, dynamic> toJson() => {
    "ID": ID,
    "FirstName": firstName,
    "LastName": lastName,
    "Email": email,
    "MobileNumber": mobileNumber,
    "Country_Code": Country_Code,
    "Dial_Code": Dial_Code,
  };*/

  Map toJson() {
    var map = new Map<String?, dynamic>();
    if (ID != null && ID != "") {
      map["ID"] = ID;
    }
    map["FirstName"] = firstName;
    map["LastName"] = lastName;
    map["Email"] = email;
    map["MobileNumber"] = mobileNumber;
    map["Country_Code"] = Country_Code;
    map["Dial_Code"] = Dial_Code;

    return map;
  }
}

class VendorDataQuery {
  VendorDataQuery({
    this.note,
    this.CompanyName,
    this.Category,
    this.Address,
    this.Suite,
    this.City,
    this.Province,
    this.PostalCode,
    this.Country,
    this.Rating,
    this.Owner_ID,
    this.personId,
  });

  String? note;
  VendorPersonId? personId;
  String? CompanyName;
  String? Category;
  String? Address;
  String? Suite;
  int? City;
  int? Province;
  String? PostalCode;
  int? Country;
  double? Rating;
  String? Owner_ID;

  factory VendorDataQuery.fromJson(Map<String, dynamic> json) =>
      VendorDataQuery(
        note: json["Note"],
        CompanyName: json["CompanyName"],
        Category: json["Category"],
        Address: json["Address"],
        Suite: json["Suite"],
        City: json["City"],
        Province: json["Province"],
        PostalCode: json["PostalCode"],
        Country: json["Country"],
        Rating: json["Rating"],
        Owner_ID: json["Owner_ID"],
        personId: VendorPersonId.fromJson(json["PersonID"]),
      );

  Map<String, dynamic> toJson() => {
        "Note": note,
        "CompanyName": CompanyName,
        "Category": Category,
        "Address": Address,
        "Suite": Suite,
        "City": City,
        "Province": Province,
        "PostalCode": PostalCode,
        "Country": Country,
        "Rating": Rating,
        "Owner_ID": Owner_ID,
        "PersonID": personId!.toJson(),
      };
}

class AddMaintenanceQuery {
  AddMaintenanceQuery({
    this.ID,
    this.Prop_ID,
    this.Owner_ID,
    this.Category,
    this.Priority,
    this.Describe_Issue,
    this.Status,
    this.IsLock,
    this.Date_Created,
    this.Applicant_ID,
    this.Type_User,
    this.RequestName,
    this.City,
    this.State,
    this.Country,
  });

  String? ID;
  String? Prop_ID;
  String? Owner_ID;
  String? Category;
  String? Priority;
  String? Describe_Issue;
  String? Status;
  bool? IsLock;
  String? Date_Created;
  String? Applicant_ID;
  String? Type_User;
  String? RequestName;
  String? City;
  String? State;
  String? Country;

  factory AddMaintenanceQuery.fromJson(Map<String, dynamic> json) =>
      AddMaintenanceQuery(
        ID: json["ID"],
        Prop_ID: json["Prop_ID"],
        Owner_ID: json["Owner_ID"],
        Category: json["Category"],
        Priority: json["Priority"],
        Describe_Issue: json["Describe_Issue"],
        Status: json["Status"],
        IsLock: json["IsLock"],
        Date_Created: json["Date_Created"],
        Applicant_ID: json["Applicant_ID"],
        Type_User: json["Type_User"],
        RequestName: json["RequestName"],
        City: json["City"],
        State: json["State"],
        Country: json["Country"],
      );

  /* Map<String, dynamic> toJson() => {
    "Prop_ID": Prop_ID,
    "Owner_ID": Owner_ID,
    "Category": Category,
    "Priority": Priority,
    "Describe_Issue": Describe_Issue,
    "Status": Status,
    "IsLock": IsLock,
    "Date_Created": Date_Created,
    "Applicant_ID": Applicant_ID,
    "Type_User": Type_User,
    "RequestName": RequestName,
    "City": City,
    "State": State,
    "Country": Country,
  };*/

  Map toJson() {
    var map = new Map<String?, dynamic>();
    if (ID != null && ID != "") {
      map["ID"] = ID;
    }
    map["Prop_ID"] = Prop_ID;
    map["Owner_ID"] = Owner_ID;
    map["Category"] = Category;
    map["Priority"] = Priority;
    map["Describe_Issue"] = Describe_Issue;
    map["Status"] = Status;
    map["IsLock"] = IsLock;

    if (Date_Created != null && Date_Created != "") {
      map["Date_Created"] = Date_Created;
    }

    if (Applicant_ID != null && Applicant_ID != "") {
      map["Applicant_ID"] = Applicant_ID;
    }

    map["Type_User"] = Type_User;
    map["RequestName"] = RequestName;
    map["City"] = City;
    map["State"] = State;
    map["Country"] = Country;

    return map;
  }
}

class UpdateMaintenanceQuery {
  UpdateMaintenanceQuery({
    this.ID,
    this.Prop_ID,
    this.Owner_ID,
    this.Category,
    this.Priority,
    this.Describe_Issue,
    this.Status,
    this.IsLock,
    this.Date_Created,
    this.Applicant_ID,
    this.Type_User,
    this.RequestName,
    this.City,
    this.State,
    this.Country,
  });

  String? ID;
  String? Prop_ID;
  String? Owner_ID;
  String? Category;
  String? Priority;
  String? Describe_Issue;
  String? Status;
  bool? IsLock;
  String? Date_Created;
  String? Applicant_ID;
  String? Type_User;
  String? RequestName;
  String? City;
  String? State;
  String? Country;

  factory UpdateMaintenanceQuery.fromJson(Map<String, dynamic> json) =>
      UpdateMaintenanceQuery(
        ID: json["ID"],
        Prop_ID: json["Prop_ID"],
        Owner_ID: json["Owner_ID"],
        Category: json["Category"],
        Priority: json["Priority"],
        Describe_Issue: json["Describe_Issue"],
        Status: json["Status"],
        IsLock: json["IsLock"],
        Date_Created: json["Date_Created"],
        Applicant_ID: json["Applicant_ID"],
        Type_User: json["Type_User"],
        RequestName: json["RequestName"],
        City: json["City"],
        State: json["State"],
        Country: json["Country"],
      );

  /* Map<String, dynamic> toJson() => {
    "Prop_ID": Prop_ID,
    "Owner_ID": Owner_ID,
    "Category": Category,
    "Priority": Priority,
    "Describe_Issue": Describe_Issue,
    "Status": Status,
    "IsLock": IsLock,
    "Date_Created": Date_Created,
    "Applicant_ID": Applicant_ID,
    "Type_User": Type_User,
    "RequestName": RequestName,
    "City": City,
    "State": State,
    "Country": Country,
  };*/

  Map toJson() {
    var map = new Map<String?, dynamic>();
    if (ID != null && ID != "") {
      map["ID"] = ID;
    }
    map["Prop_ID"] = Prop_ID;
    map["Owner_ID"] = Owner_ID;
    map["Category"] = Category;
    map["Priority"] = Priority;
    map["Describe_Issue"] = Describe_Issue;
    map["Status"] = Status;
    map["IsLock"] = IsLock;

    if (Date_Created != null && Date_Created != "") {
      map["Date_Created"] = Date_Created;
    }

    map["Applicant_ID"] = Applicant_ID;
    map["Type_User"] = Type_User;
    map["RequestName"] = RequestName;
    map["City"] = City;
    map["State"] = State;
    map["Country"] = Country;

    return map;
  }
}

class InsertMaintenanceImage {
  String? Media_ID;
  String? MaintenanceID;

  InsertMaintenanceImage({
    this.Media_ID,
    this.MaintenanceID,
  });

  factory InsertMaintenanceImage.fromJson(Map<String, dynamic> json) =>
      InsertMaintenanceImage(
        Media_ID: json["Media_ID"],
        MaintenanceID: json["MaintenanceID"],
      );

  Map<String, dynamic> toJson() => {
        "Media_ID": Media_ID,
        "MaintenanceID": MaintenanceID,
      };
}

class DeleteMaintenanceVendor {
  String? MaintenanceID;

  DeleteMaintenanceVendor({
    this.MaintenanceID,
  });

  factory DeleteMaintenanceVendor.fromJson(Map<String, dynamic> json) =>
      DeleteMaintenanceVendor(
        MaintenanceID: json["MaintenanceID"],
      );

  Map toJson() {
    var map = new Map<String, dynamic>();
    map["MaintenanceID"] = MaintenanceID;
    return map;
  }
}

class AssigneVendor {
  String? ID;
  String? MaintenanceID;
  String? VendorID;
  String? Instruction;

  AssigneVendor({
    this.ID,
    this.MaintenanceID,
    this.VendorID,
    this.Instruction,
  });

  factory AssigneVendor.fromJson(Map<String, dynamic> json) => AssigneVendor(
        ID: json["ID"],
        MaintenanceID: json["MaintenanceID"],
        VendorID: json["VendorID"],
        Instruction: json["Instruction"],
      );

  Map toJson() {
    var map = new Map<String, dynamic>();
    if (ID != null && ID != "") {
      map["ID"] = ID;
    }
    map["MaintenanceID"] = MaintenanceID;
    map["VendorID"] = VendorID;
    map["Instruction"] = Instruction;
    return map;
  }
}

class AddLogActivity {
  String? Owner_ID;
  int? Maintenance_ID;
  String? LogText;
  String? Date_Created;

  AddLogActivity({
    this.Owner_ID,
    this.Maintenance_ID,
    this.LogText,
    this.Date_Created,
  });

  factory AddLogActivity.fromJson(Map<String, dynamic> json) => AddLogActivity(
        Owner_ID: json["Owner_ID"],
        Maintenance_ID: json["Maintenance_ID"],
        LogText: json["LogText"],
        Date_Created: json["Date_Created"],
      );

  Map toJson() => {
        "Owner_ID": Owner_ID,
        "Maintenance_ID": Maintenance_ID,
        "LogText": LogText,
        "Date_Created": Date_Created,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["Owner_ID"] = Owner_ID;
    map["Maintenance_ID"] = Maintenance_ID;
    map["LogText"] = LogText;
    map["Date_Created"] = Date_Created;
    return map;
  }
}

class ApplicantProfileData {
  ApplicantProfileData({
    this.profile,
    this.personId,
  });

  String? profile;
  PersonDataId? personId;

  factory ApplicantProfileData.fromJson(Map<String, dynamic> json) =>
      ApplicantProfileData(
        profile: json["profile"],
        personId: PersonDataId.fromJson(json["Person_ID"]),
      );

  Map<String, dynamic> toJson() => {
        "profile": profile,
        "Person_ID": personId!.toJson(),
      };
}

class CheckMaintenanceExitOrNot {
  String? ID;
  String? Applicant_ID;

  CheckMaintenanceExitOrNot({
    this.ID,
    this.Applicant_ID,
  });

  factory CheckMaintenanceExitOrNot.fromJson(Map<String, dynamic> json) =>
      CheckMaintenanceExitOrNot(
        ID: json["ID"],
        Applicant_ID: json["Applicant_ID"],
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "Applicant_ID": Applicant_ID,
      };
}

class CheckMaintenanceExitOrNotOwner_ID {
  String? ID;
  String? Owner_ID;

  CheckMaintenanceExitOrNotOwner_ID({
    this.ID,
    this.Owner_ID,
  });

  factory CheckMaintenanceExitOrNotOwner_ID.fromJson(
          Map<String, dynamic> json) =>
      CheckMaintenanceExitOrNotOwner_ID(
        ID: json["ID"],
        Owner_ID: json["Owner_ID"],
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "Owner_ID": Owner_ID,
      };
}
