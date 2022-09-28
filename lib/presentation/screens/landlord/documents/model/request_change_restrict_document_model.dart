class RequestChangeRestrictDocument {
  String? documentUUID;
  bool? isRestricted;

  RequestChangeRestrictDocument({this.documentUUID, this.isRestricted});

  RequestChangeRestrictDocument.fromJson(Map<String, dynamic> json) {
    documentUUID = json['document_uuid'];
    isRestricted = json['is_restricted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['document_uuid'] = this.documentUUID;
    data['is_restricted'] = this.isRestricted;
    return data;
  }
}
