class FilterDocumentModel {
  String? filterUUID;
  String? name;

  FilterDocumentModel({this.filterUUID, this.name});

  FilterDocumentModel.fromJson(Map<String, dynamic> json) {
    filterUUID = json['filter_uuid'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filter_uuid'] = this.filterUUID;
    data['name'] = this.name;
    return data;
  }
}
