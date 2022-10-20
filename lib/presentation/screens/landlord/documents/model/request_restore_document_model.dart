class RequestRestoreDocument {
  String? documentUUID;
  String? documentFatherUUID;

  RequestRestoreDocument({this.documentUUID, this.documentFatherUUID});

  RequestRestoreDocument.fromJson(Map<String, dynamic> json) {
    documentUUID = json['document_uuid'];
    documentUUID = json['document_father_uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['document_uuid'] = this.documentUUID;
    data['document_father_uuid'] = this.documentFatherUUID;
    return data;
  }
}
