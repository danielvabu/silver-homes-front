import 'package:silverhome/tablayer/tablePOJO.dart';

class TenancyEmploymentInformation {
  String? id;
  String? occupation;
  String? organization;
  String? lenthofemp;
  bool? IsCurrentOccupation;
  SystemEnumDetails? anualIncome;
  bool? error_occupation = false;
  bool? error_organization = false;
  bool? error_lenthofemp = false;
  bool? error_anualIncome = false;

  TenancyEmploymentInformation({
    this.id,
    this.occupation,
    this.organization,
    this.lenthofemp,
    this.IsCurrentOccupation,
    this.anualIncome,
    this.error_occupation,
    this.error_organization,
    this.error_lenthofemp,
    this.error_anualIncome,
  });

  TenancyEmploymentInformation.clone(TenancyEmploymentInformation source)
      : this.id = source.id,
        this.occupation = source.occupation,
        this.organization = source.organization,
        this.lenthofemp = source.lenthofemp,
        this.IsCurrentOccupation = source.IsCurrentOccupation,
        this.anualIncome = source.anualIncome,
        this.error_occupation = source.error_occupation,
        this.error_organization = source.error_organization,
        this.error_lenthofemp = source.error_lenthofemp,
        this.error_anualIncome = source.error_anualIncome;

  factory TenancyEmploymentInformation.fromJson(Map<String, dynamic> json) =>
      TenancyEmploymentInformation(
        id: json["id"],
        occupation: json["occupation"],
        organization: json["organization"],
        lenthofemp: json["lenthofemp"],
        IsCurrentOccupation: json["IsCurrentOccupation"],
        anualIncome: json["anualIncome"],
        error_occupation: json["error_occupation"],
        error_organization: json["error_organization"],
        error_lenthofemp: json["error_lenthofemp"],
        error_anualIncome: json["error_anualIncome"],
      );

  Map toJson() => {
        "id": id,
        "occupation": occupation,
        "organization": organization,
        "lenthofemp": lenthofemp,
        "IsCurrentOccupation": IsCurrentOccupation,
        "anualIncome": anualIncome,
        "error_occupation": error_occupation,
        "error_organization": error_organization,
        "error_lenthofemp": error_lenthofemp,
        "error_anualIncome": error_anualIncome,
      };
}
