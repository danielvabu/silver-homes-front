import 'package:silverhome/tablayer/tablePOJO.dart';

class LeadTenantData {
  LeadTenantData({
    this.mobileNumber,
    this.personId,
    this.propertyName,
    this.landlordName,
    this.id,
    this.ownerId,
    this.countryCode,
    this.applicantName,
    this.email,
    this.applicantId,
    this.dialCode,
    this.rating,
    this.ratingReview,
    this.Prop_ID,
    this.applicationStatus,
  });

  String? mobileNumber;
  int? personId;
  String? propertyName;
  String? landlordName;
  int? id;
  int? ownerId;
  String? countryCode;
  String? applicantName;
  String? email;
  int? applicantId;
  String? dialCode;
  double? rating;
  String? ratingReview;
  String? Prop_ID;
  SystemEnumDetails? applicationStatus;

  factory LeadTenantData.fromJson(Map<String, dynamic> json) => LeadTenantData(
        mobileNumber: json["MobileNumber"] != null ? json["MobileNumber"] : "",
        personId: json["PersonID"] != null ? json["PersonID"] : 0,
        propertyName:
            json["Property Name"] != null ? json["Property Name"] : "",
        landlordName:
            json["Landlord Name"] != null ? json["Landlord Name"] : "",
        id: json["ID"] != null ? json["ID"] : 0,
        ownerId: json["Owner_ID"] != null ? json["Owner_ID"] : 0,
        countryCode: json["Country_Code"] != null ? json["Country_Code"] : "",
        applicantName:
            json["Applicant Name"] != null ? json["Applicant Name"] : "",
        email: json["Email"] != null ? json["Email"] : "",
        applicantId: json["Applicant_ID"] != null ? json["Applicant_ID"] : 0,
        dialCode: json["Dial_Code"] != null ? json["Dial_Code"] : "",
        rating: json["Rating"] != null ? json["Rating"] : 0,
        ratingReview: json["RatingReview"] != null ? json["RatingReview"] : "",
        Prop_ID: json["Prop_ID"] != null ? json["Prop_ID"] : "",
        applicationStatus: json["ApplicationStatus"] != null
            ? SystemEnumDetails.fromJson(json["ApplicationStatus"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "MobileNumber": mobileNumber,
        "PersonID": personId,
        "Property Name": propertyName,
        "Landlord Name": landlordName,
        "ID": id,
        "Owner_ID": ownerId,
        "Country_Code": countryCode,
        "Applicant Name": applicantName,
        "Email": email,
        "Applicant_ID": applicantId,
        "Dial_Code": dialCode,
        "Rating": rating,
        "RatingReview": ratingReview,
        "Prop_ID": Prop_ID,
        "ApplicationStatus": applicationStatus!.toJson(),
      };
}
