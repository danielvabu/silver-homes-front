import 'package:silverhome/domain/entities/lead_reference.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class TenancyApplicationDocments {
  String? name;
  int? application_id;
  bool? required;
  int? ownerId;
  TenancyApplicationDocments({
    this.name,
    this.application_id,
    this.required,
    this.ownerId,
  });

  factory TenancyApplicationDocments.fromJson(Map<String, dynamic> json) =>
      TenancyApplicationDocments(
        name: json["name"],
        application_id: json["application_id"],
        required: json["required"],
        ownerId: json["Owner_ID"],
      );

  Map toJson() => {
        "name": name,
        "application_id": application_id,
        "required": required,
        "ownerId": ownerId,
      };
}
