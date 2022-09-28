class RequestRenameDocument {
  String? name;
  String? documentUUID;

  RequestRenameDocument({this.name, this.documentUUID});

  RequestRenameDocument.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    documentUUID = json['document_uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['document_uuid'] = this.documentUUID;
    return data;
  }
}
