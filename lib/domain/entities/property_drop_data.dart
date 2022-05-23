import 'package:silverhome/tablayer/tablePOJO.dart';

class PropertyDropData {
  PropertyDropData({
    this.id,
    this.propertyName,
  });

  String? id;
  String? propertyName;

  factory PropertyDropData.fromJson(Map<String, dynamic> json) =>
      PropertyDropData(
        id: json["ID"],
        propertyName: json["PropertyName"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "PropertyName": propertyName,
      };
}
