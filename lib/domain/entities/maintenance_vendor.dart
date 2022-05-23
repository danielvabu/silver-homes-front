import 'package:silverhome/domain/entities/citydata.dart';
import 'package:silverhome/domain/entities/countrydata.dart';
import 'package:silverhome/domain/entities/statedata.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class MaintenanceVendor {
  MaintenanceVendor({
    this.ID,
    this.Instruction,
    this.province,
    this.companyName,
    this.rating,
    this.address,
    this.vid,
    this.suite,
    this.country,
    this.city,
    this.category,
    this.PersonID,
    this.email,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.showInstruction,
  });

  String? ID;
  String? Instruction;
  StateData? province;
  String? companyName;
  double? rating;
  String? address;
  int? vid;
  String? suite;
  CityData? city;
  CountryData? country;
  SystemEnumDetails? category;
  String? PersonID;
  String? email;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  bool? showInstruction;

  factory MaintenanceVendor.fromJson(Map<String, dynamic> json) =>
      MaintenanceVendor(
        ID: json["ID"],
        Instruction: json["Instruction"],
        province: StateData.fromJson(json["Province"]),
        companyName: json["CompanyName"],
        rating: json["Rating"],
        address: json["Address"],
        vid: json["VID"],
        suite: json["Suite"],
        city: CityData.fromJson(json["City"]),
        country: CountryData.fromJson(json["Country"]),
        category: SystemEnumDetails.fromJson(json["Category"]),
        PersonID: json["PersonID"],
        email: json["Email"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        mobileNumber: json["MobileNumber"],
        showInstruction:
            json["showInstruction"] != null ? json["showInstruction"] : false,
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "Instruction": Instruction,
        "Province": province!.toJson(),
        "CompanyName": companyName,
        "Rating": rating,
        "Address": address,
        "VID": vid,
        "Suite": suite,
        "City": city!.toJson(),
        "Country": country!.toJson(),
        "Category": category!.toJson(),
        "PersonID": PersonID,
        "Email": email,
        "FirstName": firstName,
        "LastName": lastName,
        "MobileNumber": mobileNumber,
        "showInstruction": showInstruction,
      };
}
