import 'package:silverhome/tablayer/tablePOJO.dart';

class PropertyData {
  String? buildingName;
  String? otherPropertyType;
  SystemEnumDetails? propertyType;
  String? propertyAddress;
  bool? isActive;
  MediaInfo? propertyImage;
  String? ID;
  String? postalCode;
  String? countryCode;
  int? size;
  String? otherPartialFurniture;
  String? dateAvailable;
  String? maxOccupancy;
  bool? isAgreedTandC;
  SystemEnumDetails? minLeaseDuration;
  String? city;
  String? rentAmount;
  SystemEnumDetails? leaseType;
  int? minLeaseNumber;
  String? parkingStalls;
  SystemEnumDetails? furnishing;
  String? propertyName;
  String? country;
  int? bedrooms;
  String? suiteUnit;
  SystemEnumDetails? rentPaymentFrequency;
  SystemEnumDetails? storageAvailable;
  String? province;
  SystemEnumDetails? rentalSpace;
  String? propertyDescription;
  int? bathrooms;
  int? PropDrafting;
  bool? Vacancy;
  bool? IsPublished;
  String? createdOn;
  String? updatedOn;

  String? Media_ID;

  //List<PropertyImageMediaInfo>? PropertyImageMediaInfolist;

  String? ApplicantID;
  String? TenantName;

  PropertyData({
    this.buildingName,
    this.otherPropertyType,
    this.propertyType,
    this.propertyAddress,
    this.isActive,
    this.propertyImage,
    this.ID,
    this.postalCode,
    this.countryCode,
    this.size,
    this.otherPartialFurniture,
    this.dateAvailable,
    this.maxOccupancy,
    this.isAgreedTandC,
    this.minLeaseDuration,
    this.city,
    this.rentAmount,
    this.leaseType,
    this.minLeaseNumber,
    this.parkingStalls,
    this.furnishing,
    this.propertyName,
    this.country,
    this.bedrooms,
    this.suiteUnit,
    this.rentPaymentFrequency,
    this.storageAvailable,
    this.province,
    this.rentalSpace,
    this.propertyDescription,
    this.bathrooms,
    this.PropDrafting,
    this.Vacancy,
    this.IsPublished,
    this.createdOn,
    this.updatedOn,
    this.Media_ID,
    //this.PropertyImageMediaInfolist,
    this.ApplicantID,
    this.TenantName,
  });

  factory PropertyData.fromJson(Map<String, dynamic> json) => PropertyData(
        buildingName: json["Building_Name"],
        otherPropertyType: json["Other_Property_Type"],
        propertyType: SystemEnumDetails.fromJson(json["Property_Type"]),
        propertyAddress: json["Property_Address"],
        isActive: json["IsActive"],
        propertyImage: json["Property_Image"] != null
            ? MediaInfo.fromJson(json["Property_Image"])
            : null,
        ID: json["ID"],
        postalCode: json["Postal_Code"],
        countryCode: json["Country_Code"],
        size: json["Size"],
        otherPartialFurniture: json["Other_Partial_Furniture"],
        dateAvailable: json["Date_Available"],
        maxOccupancy: json["Max_Occupancy"],
        isAgreedTandC: json["IsAgreed_TandC"],
        minLeaseDuration:
            SystemEnumDetails.fromJson(json["Min_Lease_Duration"]),
        city: json["City"],
        rentAmount: json["Rent_Amount"],
        leaseType: SystemEnumDetails.fromJson(json["Lease_Type"]),
        minLeaseNumber: json["Min_Lease_Number"],
        parkingStalls: json["Parking_Stalls"],
        furnishing: SystemEnumDetails.fromJson(json["Furnishing"]),
        propertyName: json["PropertyName"],
        country: json["Country"],
        bedrooms: json["Bedrooms"],
        suiteUnit: json["Suite_Unit"],
        rentPaymentFrequency:
            SystemEnumDetails.fromJson(json["Rent_Payment_Frequency"]),
        storageAvailable: SystemEnumDetails.fromJson(json["StorageAvailable"]),
        province: json["Province"],
        rentalSpace: SystemEnumDetails.fromJson(json["Rental_Space"]),
        propertyDescription: json["Property_Description"],
        bathrooms: json["Bathrooms"],
        PropDrafting: json["PropDrafting"],
        Vacancy: json["Vacancy"],
        IsPublished: json["IsPublished"],
        createdOn: json["CreatedOn"],
        updatedOn: json["UpdatedOn"],
        Media_ID: json["Media_ID"],
        /* PropertyImageMediaInfolist: List<PropertyImageMediaInfo>.from(
            json["PropertyImageMediaInfolist"]
                .map((x) => PropertyImageMediaInfo.fromJson(x))),*/
        ApplicantID: json["ApplicantID"],
        TenantName: json["TenantName"],
      );

  Map<String, dynamic> toJson() => {
        "Building_Name": buildingName,
        "Other_Property_Type": otherPropertyType,
        "Property_Type": propertyType!.toJson(),
        "Property_Address": propertyAddress,
        "IsActive": isActive,
        "Property_Image": propertyImage!.toJson(),
        "ID": ID,
        "Postal_Code": postalCode,
        "Country_Code": countryCode,
        "Size": size,
        "Other_Partial_Furniture": otherPartialFurniture,
        "Date_Available": dateAvailable,
        "Max_Occupancy": maxOccupancy,
        "IsAgreed_TandC": isAgreedTandC,
        "Min_Lease_Duration": minLeaseDuration!.toJson(),
        "City": city,
        "Rent_Amount": rentAmount,
        "Lease_Type": leaseType!.toJson(),
        "Min_Lease_Number": minLeaseNumber,
        "Parking_Stalls": parkingStalls,
        "Furnishing": furnishing!.toJson(),
        "PropertyName": propertyName,
        "Country": country,
        "Bedrooms": bedrooms,
        "Suite_Unit": suiteUnit,
        "Rent_Payment_Frequency": rentPaymentFrequency!.toJson(),
        "StorageAvailable": storageAvailable!.toJson(),
        "Province": province,
        "Rental_Space": rentalSpace!.toJson(),
        "Property_Description": propertyDescription,
        "Bathrooms": bathrooms,
        "PropDrafting": PropDrafting,
        "Vacancy": Vacancy,
        "IsPublished": IsPublished,
        "CreatedOn": createdOn,
        "UpdatedOn": updatedOn,
        "Media_ID": Media_ID,
        // "PropertyImageMediaInfolist": PropertyImageMediaInfolist,
        "ApplicantID": ApplicantID,
        "TenantName": TenantName,
      };
}
