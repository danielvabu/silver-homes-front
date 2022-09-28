import 'package:silverhome/presentation/screens/landlord/documents/model/breadcumb_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/document_model.dart';

class DocumentsListScreenModel {
  List<DocumentModel>? folderContent;
  List<BreadcumbModel>? breadcumbs;
  String? documentFatherUUID;

  DocumentsListScreenModel(
      {this.folderContent, this.breadcumbs, this.documentFatherUUID});

  DocumentsListScreenModel.fromJson(Map<String, dynamic> json) {
    if (json['folder_content'] != null) {
      folderContent = <DocumentModel>[];
      json['folder_content'].forEach((v) {
        folderContent!.add(new DocumentModel.fromJson(v));
      });
    }
    if (json['breadcumbs'] != null) {
      breadcumbs = <BreadcumbModel>[];
      json['breadcumbs'].forEach((v) {
        breadcumbs!.add(new BreadcumbModel.fromJson(v));
      });
    }
    documentFatherUUID = json['document_father_uuid'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.folderContent != null) {
      data['folder_content'] =
          this.folderContent!.map((v) => v.toJson()).toList();
    }
    if (this.breadcumbs != null) {
      data['breadcumbs'] = this.breadcumbs!.map((v) => v.toJson()).toList();
    }
    data['document_father_uuid'] = documentFatherUUID;
    return data;
  }
}
