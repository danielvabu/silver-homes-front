class RequestCreateFolder {
  String? name;
  String? fatherUUID;

  RequestCreateFolder({this.name, this.fatherUUID});

  RequestCreateFolder.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    fatherUUID = json['father_uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['father_uuid'] = this.fatherUUID;
    return data;
  }
}
