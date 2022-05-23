import 'package:silverhome/tablayer/tablePOJO.dart';

class LandlordProfile {
  LandlordProfile({
    this.id,
    this.companyname,
    this.homepagelink,
    this.CustomerFeatureListingURL,
    this.PersonID,
    this.firstname,
    this.lastname,
    this.email,
    this.phonenumber,
    this.countrycode,
    this.dialcode,
    this.companylogo,
  });

  String? id;
  String? companyname;
  String? homepagelink;
  String? CustomerFeatureListingURL;
  String? PersonID;
  String? firstname;
  String? lastname;
  String? email;
  String? phonenumber;
  String? countrycode;
  String? dialcode;
  MediaInfo? companylogo;
}
