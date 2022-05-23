import 'package:silverhome/tablayer/tablePOJO.dart';

class OwnerData {
  String? id;
  String? CompanyName;
  String? HomePageLink;
  String? CustomerFeatureListingURL;
  MediaInfo? Company_logo;

  OwnerData({
    this.id,
    this.CompanyName,
    this.HomePageLink,
    this.CustomerFeatureListingURL,
    this.Company_logo,
  });

  factory OwnerData.fromJson(Map<String, dynamic> json) => OwnerData(
        id: json["id"],
        CompanyName: json["CompanyName"],
        HomePageLink: json["HomePageLink"],
        CustomerFeatureListingURL: json["CustomerFeatureListingURL"],
        Company_logo: MediaInfo.fromJson(json["Company_logo"]),
      );

  Map toJson() => {
        "id": id,
        "CompanyName": CompanyName,
        "HomePageLink": HomePageLink,
        "CustomerFeatureListingURL": CustomerFeatureListingURL,
        "Company_logo": Company_logo!.toJson(),
      };
}
