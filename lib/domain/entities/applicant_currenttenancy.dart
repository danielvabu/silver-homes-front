// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

class ApplicatCurrentTenancy {
  ApplicatCurrentTenancy({
    this.address,
    this.suite,
    this.startDate,
    this.endDate,
    this.city,
    this.postalCode,
    this.province,
    this.currentLandLordIscheckedAsReference,
    this.id,
    this.CurrentLandLord_ID,
    this.CurrentLandLord_FirstName,
    this.CurrentLandLord_LastName,
    this.CurrentLandLord_Email,
    this.CurrentLandLord_MobileNumber,
    this.CurrentLandLord_Country_Code,
    this.CurrentLandLord_Dial_Code,
  });

  String? address;
  String? suite;
  String? startDate;
  String? endDate;
  String? city;
  String? postalCode;
  String? province;
  bool? currentLandLordIscheckedAsReference;
  String? id;
  String? CurrentLandLord_ID;
  String? CurrentLandLord_FirstName;
  String? CurrentLandLord_LastName;
  String? CurrentLandLord_Email;
  String? CurrentLandLord_MobileNumber;
  String? CurrentLandLord_Country_Code;
  String? CurrentLandLord_Dial_Code;

  factory ApplicatCurrentTenancy.fromJson(Map<String, dynamic> json) =>
      ApplicatCurrentTenancy(
        address: json["Address"],
        suite: json["Suite"],
        startDate: json["Start_Date"],
        endDate: json["End_Date"],
        city: json["City"],
        postalCode: json["PostalCode"],
        province: json["Province"],
        currentLandLordIscheckedAsReference:
            json["CurrentLandLordIschecked_As_Reference"],
        id: json["ID"],
        CurrentLandLord_ID: json["CurrentLandLord_ID"],
        CurrentLandLord_FirstName: json["CurrentLandLord_FirstName"],
        CurrentLandLord_LastName: json["CurrentLandLord_LastName"],
        CurrentLandLord_Email: json["CurrentLandLord_Email"],
        CurrentLandLord_MobileNumber: json["CurrentLandLord_MobileNumber"],
        CurrentLandLord_Country_Code: json["CurrentLandLord_Country_Code"],
        CurrentLandLord_Dial_Code: json["CurrentLandLord_Dial_Code"],
      );

  Map<String, dynamic> toJson() => {
        "Address": address,
        "Suite": suite,
        "Start_Date": startDate,
        "End_Date": endDate,
        "City": city,
        "PostalCode": postalCode,
        "Province": province,
        "CurrentLandLordIschecked_As_Reference":
            currentLandLordIscheckedAsReference,
        "ID": id,
        "CurrentLandLord_ID": CurrentLandLord_ID,
        "CurrentLandLord_FirstName": CurrentLandLord_FirstName,
        "CurrentLandLord_LastName": CurrentLandLord_LastName,
        "CurrentLandLord_Email": CurrentLandLord_Email,
        "CurrentLandLord_MobileNumber": CurrentLandLord_MobileNumber,
        "CurrentLandLord_Country_Code": CurrentLandLord_Country_Code,
        "CurrentLandLord_Dial_Code": CurrentLandLord_Dial_Code,
      };
}
