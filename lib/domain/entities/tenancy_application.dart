import 'package:silverhome/domain/entities/lead_reference.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class TenancyApplication {
  String? referenceRequestSentDate;
  String? mobileNumber;
  int? questionnairesSentCount;
  SystemEnumDetails? applicationStatus;
  bool? isAuthorized;
  int? personId;
  int? annualIncome;
  int? referenceStatus;
  int? numberOfOccupants;
  int? isArchived;
  bool? pets;
  int? referencesCount;
  String? docRequestSentDate;
  String? propertyName;
  bool? smoking;
  String? agreementReceivedDate;
  String? note;
  bool? isAgreedTerms;
  SystemEnumDetails? leaseStatus;
  int? id;
  int? ownerId;
  String? applicationSentDate;
  String? countryCode;
  String? city;
  String? applicantName;
  int? employmentStatus;
  String? agreementSentDate;
  String? email;
  String? docReceivedDate;
  int? applicationReceived;
  int? applicantId;
  SystemEnumDetails? docReviewStatus;
  String? referenceRequestReceivedDate;
  int? questionnairesReceivedCount;
  bool? vehicle;
  String? dialCode;
  double? rating;
  String? ratingReview;
  String? propId;
  String? applicationReceivedDate;
  String? CreatedOn;
  String? UpdatedOn;
  bool? ischeck;
  bool? isexpand;
  List<LeadReference>? leadReference;

  TenancyApplication({
    this.referenceRequestSentDate,
    this.mobileNumber,
    this.questionnairesSentCount,
    this.applicationStatus,
    this.isAuthorized,
    this.personId,
    this.annualIncome,
    this.referenceStatus,
    this.numberOfOccupants,
    this.isArchived,
    this.pets,
    this.referencesCount,
    this.docRequestSentDate,
    this.propertyName,
    this.smoking,
    this.agreementReceivedDate,
    this.note,
    this.isAgreedTerms,
    this.leaseStatus,
    this.id,
    this.ownerId,
    this.applicationSentDate,
    this.countryCode,
    this.city,
    this.applicantName,
    this.employmentStatus,
    this.agreementSentDate,
    this.email,
    this.docReceivedDate,
    this.applicationReceived,
    this.applicantId,
    this.docReviewStatus,
    this.referenceRequestReceivedDate,
    this.questionnairesReceivedCount,
    this.vehicle,
    this.dialCode,
    this.rating,
    this.ratingReview,
    this.propId,
    this.applicationReceivedDate,
    this.CreatedOn,
    this.UpdatedOn,
    this.ischeck,
    this.isexpand,
    this.leadReference,
  });

  factory TenancyApplication.fromJson(Map<String, dynamic> json) =>
      TenancyApplication(
        referenceRequestSentDate: json["ReferenceRequestSentDate"],
        mobileNumber: json["MobileNumber"],
        questionnairesSentCount: json["Questionnaires Sent Count"],
        applicationStatus:
            SystemEnumDetails.fromJson(json["ApplicationStatus"]),
        isAuthorized: json["IsAuthorized"],
        personId: json["PersonID"],
        annualIncome: json["Annual Income"],
        referenceStatus: json["ReferenceStatus"],
        numberOfOccupants: json["Number of Occupants"],
        isArchived: json["IsArchived"],
        pets: json["Pets"],
        referencesCount: json["References Count"],
        docRequestSentDate: json["DocRequestSentDate"],
        propertyName: json["Property Name"],
        smoking: json["Smoking"],
        agreementReceivedDate: json["AgreementReceivedDate"],
        note: json["Note"],
        isAgreedTerms: json["IsAgreedTerms"],
        leaseStatus: SystemEnumDetails.fromJson(json["LeaseStatus"]),
        id: json["ID"],
        ownerId: json["Owner_ID"],
        applicationSentDate: json["ApplicationSentDate"],
        countryCode: json["Country_Code"],
        city: json["City"],
        applicantName: json["Applicant Name"],
        employmentStatus: json["Employment Status"],
        agreementSentDate: json["AgreementSentDate"],
        email: json["Email"],
        docReceivedDate: json["DocReceivedDate"],
        applicationReceived: json["Application Received"],
        applicantId: json["Applicant_ID"],
        docReviewStatus: SystemEnumDetails.fromJson(json["DocReviewStatus"]),
        referenceRequestReceivedDate: json["ReferenceRequestReceivedDate"],
        questionnairesReceivedCount: json["Questionnaires Received Count"],
        vehicle: json["Vehicle"],
        dialCode: json["Dial_Code"],
        rating: json["Rating"],
        ratingReview: json["RatingReview"],
        propId: json["Prop_ID"],
        applicationReceivedDate: json["ApplicationReceivedDate"],
        CreatedOn: json["CreatedOn"],
        UpdatedOn: json["UpdatedOn"],
        ischeck: json["ischeck"],
        isexpand: json["isexpand"],
        leadReference: List<LeadReference>.from(
            json["leadReference"].map((x) => LeadReference.fromJson(x))),
      );

  Map toJson() => {
        "ReferenceRequestSentDate": referenceRequestSentDate,
        "MobileNumber": mobileNumber,
        "Questionnaires Sent Count": questionnairesSentCount,
        "ApplicationStatus": applicationStatus!.toJson(),
        "IsAuthorized": isAuthorized,
        "PersonID": personId,
        "Annual Income": annualIncome,
        "ReferenceStatus": referenceStatus,
        "Number of Occupants": numberOfOccupants,
        "IsArchived": isArchived,
        "Pets": pets,
        "References Count": referencesCount,
        "DocRequestSentDate": docRequestSentDate,
        "Property Name": propertyName,
        "Smoking": smoking,
        "AgreementReceivedDate": agreementReceivedDate,
        "Note": note,
        "IsAgreedTerms": isAgreedTerms,
        "LeaseStatus": leaseStatus!.toJson(),
        "ID": id,
        "Owner_ID": ownerId,
        "ApplicationSentDate": applicationSentDate,
        "Country_Code": countryCode,
        "City": city,
        "Applicant Name": applicantName,
        "Employment Status": employmentStatus,
        "AgreementSentDate": agreementSentDate,
        "Email": email,
        "DocReceivedDate": docReceivedDate,
        "Application Received": applicationReceived,
        "Applicant_ID": applicantId,
        "DocReviewStatus": docReviewStatus!.toJson(),
        "ReferenceRequestReceivedDate": referenceRequestReceivedDate,
        "Questionnaires Received Count": questionnairesReceivedCount,
        "Vehicle": vehicle,
        "Dial_Code": dialCode,
        "Rating": rating,
        "RatingReview": ratingReview,
        "Prop_ID": propId,
        "ApplicationReceivedDate": applicationReceivedDate,
        "CreatedOn": CreatedOn,
        "UpdatedOn": UpdatedOn,
        "ischeck": ischeck,
        "isexpand": isexpand,
        'leadReference': leadReference,
      };
}
