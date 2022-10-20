class RequestCreateFolder {
  String? name;
  String? fatherUUID;
  String? ownerUUID;
  String? propertyUUID;
  String? type;

  RequestCreateFolder(
      {this.name,
      this.fatherUUID,
      this.ownerUUID,
      this.propertyUUID,
      this.type});

  RequestCreateFolder.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    fatherUUID = json['father_uuid'];
    ownerUUID = json['owner_id'];
    propertyUUID = json['property_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['father_uuid'] = this.fatherUUID;
    data['owner_id'] = this.ownerUUID;
    data['property_id'] = this.propertyUUID;
    data['type'] = this.type;
    return data;
  }
}
