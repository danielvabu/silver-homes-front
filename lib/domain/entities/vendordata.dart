import 'package:silverhome/domain/entities/citydata.dart';
import 'package:silverhome/domain/entities/statedata.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

import 'countrydata.dart';

class VendorData {
  VendorData({
    this.province,
    this.country,
    this.companyName,
    this.rating,
    this.address,
    this.id,
    this.suite,
    this.city,
    this.category,
    this.PersonID,
    this.email,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.PostalCode,
    this.Dial_Code,
    this.Country_Code,
    this.Note,
    this.showInstruction,
  });

  StateData? province;
  CountryData? country;
  String? companyName;
  double? rating;
  String? address;
  int? id;
  String? suite;
  CityData? city;
  SystemEnumDetails? category;
  int? PersonID;
  String? email;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? PostalCode;
  String? Dial_Code;
  String? Country_Code;
  String? Note;
  bool? showInstruction;

  factory VendorData.fromJson(Map<String, dynamic> json) => VendorData(
        country: CountryData.fromJson(json["Country"]),
        province: StateData.fromJson(json["Province"]),
        companyName: json["CompanyName"],
        rating: json["Rating"],
        address: json["Address"],
        id: json["ID"],
        suite: json["Suite"],
        city: CityData.fromJson(json["City"]),
        category: SystemEnumDetails.fromJson(json["Category"]),
        PersonID: json["PersonID"],
        email: json["Email"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        mobileNumber: json["MobileNumber"],
        PostalCode: json["PostalCode"],
        Dial_Code: json["Dial_Code"],
        Country_Code: json["Country_Code"],
        Note: json["Note"],
        showInstruction:
            json["showInstruction"] != null ? json["showInstruction"] : false,
      );

  Map<String, dynamic> toJson() => {
        "Country": country!.toJson(),
        "Province": province!.toJson(),
        "CompanyName": companyName,
        "Rating": rating,
        "Address": address,
        "ID": id,
        "Suite": suite,
        "City": city,
        "Category": category!.toJson(),
        "PersonID": PersonID,
        "Email": email,
        "FirstName": firstName,
        "LastName": lastName,
        "MobileNumber": mobileNumber,
        "PostalCode": PostalCode,
        "Dial_Code": Dial_Code,
        "Country_Code": Country_Code,
        "Note": Note,
        "showInstruction": showInstruction,
      };
}
