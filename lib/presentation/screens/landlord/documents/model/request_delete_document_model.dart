class RequestDeleteDocument {
  String? documentUUID;

  RequestDeleteDocument({this.documentUUID});

  RequestDeleteDocument.fromJson(Map<String, dynamic> json) {
    documentUUID = json['document_uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['document_uuid'] = this.documentUUID;
    return data;
  }
}
