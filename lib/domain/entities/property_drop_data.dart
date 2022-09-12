import 'package:silverhome/tablayer/tablePOJO.dart';

class PropertyDropData {
  PropertyDropData({
    this.id,
    this.propertyName,
    this.adress,
  });

  String? id;
  String? propertyName;
  String? adress;

  factory PropertyDropData.fromJson(Map<String, dynamic> json) =>
      PropertyDropData(
        id: json["ID"],
        propertyName: json["PropertyName"],
        adress: json["adress"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "PropertyName": propertyName,
        "adress": adress,
      };
}
