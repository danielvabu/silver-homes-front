import 'dart:html';

class DocumentModel {
  String? documentName;
  String? documentType;
  String? documentDateCreated;
  String? documentCreatedBy;
  bool? isFile;
  bool? isDelete;
  bool? isRestricted;
  String? url;
  String? documentUUID;
  String? folderFatherUUID;
  DocumentModel({
    required this.documentName,
    required this.documentType,
    required this.documentDateCreated,
    required this.documentCreatedBy,
    required this.isFile,
    required this.isDelete,
    required this.isRestricted,
    required this.url,
    required this.documentUUID,
    required this.folderFatherUUID,
  });

  DocumentModel.fromJson(Map<String, dynamic> json) {
    documentName = json['document_name'] ?? "";
    documentType = json['document_type'] ?? "";
    documentDateCreated = json['document_date_created'] ?? "";
    documentCreatedBy = json['document_created_by'] ?? "";
    isFile = json['is_file'] != null
        ? (json['is_file'] is bool? ? json['is_file'] : false)
        : false;
    isDelete = json['is_delete'] != null
        ? (json['is_delete'] is bool? ? json['is_delete'] : false)
        : false;
    isRestricted = json['is_restricted'] != null
        ? (json['is_restricted'] is bool? ? json['is_restricted'] : false)
        : false;
    url = json['url'] ?? "";
    documentUUID = json['document_uuid'] ?? "";
    folderFatherUUID = json['folder_father_uuid'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['document_name'] = this.documentName;
    data['document_type'] = this.documentType;
    data['document_date_created'] = this.documentDateCreated;
    data['document_created_by'] = this.documentCreatedBy;
    data['is_file'] = this.isFile;
    data['is_delete'] = this.isDelete;
    data['is_restricted'] = this.isRestricted;
    data['url'] = this.url;
    data['document_uuid'] = this.documentUUID;
    data['folder_father_uuid'] = this.folderFatherUUID;
    return data;
  }
}
