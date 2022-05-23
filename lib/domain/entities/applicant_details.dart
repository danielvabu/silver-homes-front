import 'package:silverhome/tablayer/tablePOJO.dart';

class ApplicantDetails {
  ApplicantDetails({
    this.yourStory,
    this.intendedTenancyStartDate,
    this.note,
    this.intendedPeriod,
    this.intendedLenth,
    this.id,
    this.intendedPeriodNo,
    this.isSmoking,
    this.isPet,
    this.numberOfChildren,
    this.isVehicle,
    this.rating,
    this.numberOfOccupant,
    this.smokingDesc,
    this.personId,
  });

  String? yourStory;
  String? intendedTenancyStartDate;
  String? note;
  SystemEnumDetails? intendedPeriod;
  SystemEnumDetails? intendedLenth;
  String? id;
  String? intendedPeriodNo;
  bool? isSmoking;
  bool? isPet;
  String? numberOfChildren;
  bool? isVehicle;
  double? rating;
  String? numberOfOccupant;
  String? smokingDesc;
  ApplicantPersonId? personId;

  factory ApplicantDetails.fromJson(Map<String, dynamic> json) =>
      ApplicantDetails(
        yourStory: json["YourStory"],
        intendedTenancyStartDate: json["IntendedTenancyStartDate"],
        note: json["Note"],
        intendedPeriod: SystemEnumDetails.fromJson(json["IntendedPeriod"]),
        intendedLenth: SystemEnumDetails.fromJson(json["IntendedLenth"]),
        id: json["ID"],
        intendedPeriodNo: json["IntendedPeriodNo"],
        isSmoking: json["IsSmoking"],
        isPet: json["IsPet"],
        numberOfChildren: json["NumberOfChildren"],
        isVehicle: json["IsVehicle"],
        rating: json["Rating"],
        numberOfOccupant: json["NumberOfOccupant"],
        smokingDesc: json["SmokingDesc"],
        personId: ApplicantPersonId.fromJson(json["Person_ID"]),
      );

  Map<String, dynamic> toJson() => {
        "YourStory": yourStory,
        "IntendedTenancyStartDate": intendedTenancyStartDate,
        "Note": note,
        "IntendedPeriod": intendedPeriod!.toJson(),
        "IntendedLenth": intendedLenth!.toJson(),
        "ID": id,
        "IntendedPeriodNo": intendedPeriodNo,
        "IsSmoking": isSmoking,
        "IsPet": isPet,
        "NumberOfChildren": numberOfChildren,
        "IsVehicle": isVehicle,
        "Rating": rating,
        "NumberOfOccupant": numberOfOccupant,
        "SmokingDesc": smokingDesc,
        "Person_ID": personId!.toJson(),
      };
}

class ApplicantPersonId {
  ApplicantPersonId(
      {this.countryCode,
      this.email,
      this.firstName,
      this.mobileNumber,
      this.id,
      this.dialCode,
      this.lastName,
      this.DOB});

  String? countryCode;
  String? country;
  String? email;
  String? firstName;
  String? mobileNumber;
  String? id;
  String? dialCode;
  String? lastName;
  String? DOB;

  factory ApplicantPersonId.fromJson(Map<String, dynamic> json) =>
      ApplicantPersonId(
        countryCode: json["Country_Code"],
        email: json["Email"],
        firstName: json["FirstName"],
        mobileNumber: json["MobileNumber"],
        id: json["ID"],
        dialCode: json["Dial_Code"],
        lastName: json["LastName"],
        DOB: json["DOB"],
      );

  Map<String, dynamic> toJson() => {
        "Country_Code": countryCode,
        "Email": email,
        "FirstName": firstName,
        "MobileNumber": mobileNumber,
        "ID": id,
        "Dial_Code": dialCode,
        "LastName": lastName,
        "DOB": DOB,
      };
}
