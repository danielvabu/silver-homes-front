import 'package:silverhome/tablayer/tablePOJO.dart';

class ApplicationDetails {
  ApplicationDetails({
    this.applicationSentDate,
    this.agreementSentDate,
    this.isAuthorized,
    this.disclaimer,
    this.applicationStatus,
    this.docReviewStatus,
    this.docRequestSentDate,
    this.applicationReceivedDate,
    this.isAgreedTerms,
    this.leaseStatus,
    this.agreementReceivedDate,
    this.id,
    this.group1,
    this.docReceivedDate,
    this.IsNotApplicableAddOccupant,
  });

  String? applicationSentDate;
  String? agreementSentDate;
  bool? isAuthorized;
  bool? disclaimer;
  SystemEnumDetails? applicationStatus;
  SystemEnumDetails? docReviewStatus;
  String? docRequestSentDate;
  String? applicationReceivedDate;
  bool? isAgreedTerms;
  SystemEnumDetails? leaseStatus;
  String? agreementReceivedDate;
  String? id;
  String? group1;
  String? docReceivedDate;
  bool? IsNotApplicableAddOccupant;

  factory ApplicationDetails.fromJson(Map<String, dynamic> json) =>
      ApplicationDetails(
        applicationSentDate: json["ApplicationSentDate"],
        agreementSentDate: json["AgreementSentDate"],
        isAuthorized: json["IsAuthorized"],
        disclaimer: json["disclaimer"],
        applicationStatus:
            SystemEnumDetails.fromJson(json["ApplicationStatus"]),
        docReviewStatus: SystemEnumDetails.fromJson(json["DocReviewStatus"]),
        docRequestSentDate: json["DocRequestSentDate"],
        applicationReceivedDate: json["ApplicationReceivedDate"],
        isAgreedTerms: json["IsAgreedTerms"],
        leaseStatus: SystemEnumDetails.fromJson(json["LeaseStatus"]),
        agreementReceivedDate: json["AgreementReceivedDate"],
        id: json["ID"],
        group1: json["group1"],
        docReceivedDate: json["DocReceivedDate"],
        IsNotApplicableAddOccupant: json["IsNotApplicableAddOccupant"],
      );

  Map<String, dynamic> toJson() => {
        "ApplicationSentDate": applicationSentDate,
        "AgreementSentDate": agreementSentDate,
        "IsAuthorized": isAuthorized,
        "disclaimer": disclaimer,
        "ApplicationStatus": applicationStatus!.toJson(),
        "DocReviewStatus": docReviewStatus!.toJson(),
        "DocRequestSentDate": docRequestSentDate,
        "ApplicationReceivedDate": applicationReceivedDate,
        "IsAgreedTerms": isAgreedTerms,
        "LeaseStatus": leaseStatus!.toJson(),
        "AgreementReceivedDate": agreementReceivedDate,
        "ID": id,
        "group1": group1,
        "DocReceivedDate": docReceivedDate,
        "IsNotApplicableAddOccupant": IsNotApplicableAddOccupant,
      };
}
