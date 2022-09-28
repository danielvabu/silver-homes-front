class BreadcumbModel {
  String? breadcumbUUID;
  String? name;

  BreadcumbModel({this.breadcumbUUID, this.name});

  BreadcumbModel.fromJson(Map<String, dynamic> json) {
    breadcumbUUID = json['breadcumb_uuid'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['breadcumb_uuid'] = this.breadcumbUUID;
    data['name'] = this.name;
    return data;
  }
}
