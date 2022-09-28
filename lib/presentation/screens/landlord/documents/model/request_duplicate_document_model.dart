class RequestDuplicateDocument {
  String? documentFatherUUID;
  String? documentUUID;

  RequestDuplicateDocument({this.documentFatherUUID, this.documentUUID});

  RequestDuplicateDocument.fromJson(Map<String, dynamic> json) {
    documentFatherUUID = json['document_father_uuid'];
    documentUUID = json['document_uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['document_father_uuid'] = this.documentFatherUUID;
    data['document_uuid'] = this.documentUUID;
    return data;
  }
}
