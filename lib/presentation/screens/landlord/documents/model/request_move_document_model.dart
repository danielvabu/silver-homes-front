class RequestMoveDocument {
  String? fatherUUID;
  String? documentUUID;
  String? newFatherUUID;

  RequestMoveDocument({this.fatherUUID, this.documentUUID, this.newFatherUUID});

  RequestMoveDocument.fromJson(Map<String, dynamic> json) {
    fatherUUID = json['father_uuid'];
    documentUUID = json['document_uuid'];
    newFatherUUID = json['new_father_uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['father_uuid'] = this.fatherUUID;
    data['document_uuid'] = this.documentUUID;
    data['new_father_uuid'] = this.newFatherUUID;
    return data;
  }
}
