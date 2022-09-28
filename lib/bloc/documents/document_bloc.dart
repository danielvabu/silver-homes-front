import 'package:rxdart/rxdart.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/breadcumb_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/document_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/filter_document_model.dart';

import 'package:silverhome/validators/validators.dart';

class DocumentBloc with Validators {
  DocumentBloc();
  String submenuItemSelected = "";
  String currentDocumentTab = "Property";
  DocumentModel? currentDocumentMenuSelected;
  String? currentFatherFolderUUID;
  FilterDocumentModel? currentFilterSelected;

  ///DocumentBloc
  ///MenuDrawer
  final _documentMenuDrawer = BehaviorSubject<bool>();
  Stream<bool> get getDocumentMenuTransformer => _documentMenuDrawer.stream;
  Function(bool) get changeDocumentMenuDrawer => _documentMenuDrawer.sink.add;
  documentMenuValue() {
    return _documentMenuDrawer.value;
  }

  ///SubMenuDrawer
  final _documentSubMenuDrawer = BehaviorSubject<int>();
  Stream<int> get getDocumentSubMenuTransformer =>
      _documentSubMenuDrawer.stream;
  Function(int) get changeDocumentSubMenuDrawer =>
      _documentSubMenuDrawer.sink.add;
  documentSubMenuValue() {
    return _documentSubMenuDrawer.value;
  }

  ///loading Documents
  final _documentLoading = BehaviorSubject<bool>();
  Stream<bool> get getDocumentLoadingTransformer => _documentLoading.stream;
  Function(bool) get changeDocumentLoading => _documentLoading.sink.add;
  openDocumentLoadingValue() {
    return _documentLoading.value;
  }

  ///Trash Documents
  final _documentTrash = BehaviorSubject<bool>();
  Stream<bool> get getDocumentTrashTransformer => _documentTrash.stream;
  Function(bool) get changeDocumentTrash => _documentTrash.sink.add;
  openDocumentTrashValue() {
    return _documentTrash.value;
  }

  ///Others Documents
  final _documentOthers = BehaviorSubject<bool>();
  Stream<bool> get getDocumentOthersTransformer => _documentOthers.stream;
  Function(bool) get changeDocumentOthers => _documentOthers.sink.add;
  openDocumentOthersValue() {
    return _documentOthers.value;
  }

  ///File Tab Documents
  final _documentFileTab = BehaviorSubject<int>();
  Stream<int> get getDocumentFileTabTransformer => _documentFileTab.stream;
  Function(int) get changeDocumentFileTab => _documentFileTab.sink.add;
  openDocumentFileTabValue() {
    return _documentFileTab.value;
  }

  ///List Documents
  final _documentFileList = BehaviorSubject<List<DocumentModel>>();
  Stream<List<DocumentModel>> get getDocumentFileListTransformer =>
      _documentFileList.stream;
  Function(List<DocumentModel>) get changeDocumentFileList =>
      _documentFileList.sink.add;
  openDocumentFileListValue() {
    return _documentFileList.value;
  }

  ///List BreadCumbs
  final _documentBreadcumbsList = BehaviorSubject<List<BreadcumbModel>>();
  Stream<List<BreadcumbModel>> get getDocumentBreadcumListTransformer =>
      _documentBreadcumbsList.stream;
  Function(List<BreadcumbModel>) get changeDocumentBreadcumList =>
      _documentBreadcumbsList.sink.add;
  openDocumentBreadcumListValue() {
    return _documentBreadcumbsList.value;
  }

  ///List Filters
  final _documentFilterList = BehaviorSubject<List<FilterDocumentModel>>();
  Stream<List<FilterDocumentModel>> get getDocumentFilterListTransformer =>
      _documentFilterList.stream;
  Function(List<FilterDocumentModel>) get changeDocumentFilterList =>
      _documentFilterList.sink.add;
  openDocumentFilterListValue() {
    return _documentFilterList.value;
  }

  ///Show Move Documents Component
  final _documentShowMove = BehaviorSubject<bool>();
  Stream<bool> get getDocumentShowMoveTransformer => _documentShowMove.stream;
  Function(bool) get changeDocumentShowMove => _documentShowMove.sink.add;
  openDocumentShowMoveValue() {
    return _documentShowMove.value;
  }

//Temporal Data
  List<String> breadcrumbsList = [
    "ABC WINDOW CLEANING INC.",
    "ABC WINDOW CLEANING INC 1.",
    "ABC WINDOW CLEANING INC. 2"
  ];

  List<DocumentModel> documentPropertyList = [
    DocumentModel(
        documentUUID: "1231-erqd-54da-45541-asdad",
        documentCreatedBy: "Mauricio M.",
        documentDateCreated: "12/12/1994",
        documentName: "Folder 1 Property",
        documentType: "Folder",
        isFile: false,
        isDelete: false,
        isRestricted: false,
        url:
            "https://cdn.website-editor.net/50c6037605bc4d1e9286f706427108e6/files/uploaded/Schultz_Teorias%2520de%2520la%2520Personalidad.pdf",
        folderFatherUUID: "0998-erqd-54da-45541-asdad"),
    DocumentModel(
      documentUUID: "2231-erqd-54da-45541-asdad",
      documentCreatedBy: "Jorge S.",
      documentDateCreated: "07/08/1994",
      documentName: "File 1 Property",
      documentType: "PDF",
      isFile: true,
      isDelete: false,
      isRestricted: false,
      url:
          "https://cdn.website-editor.net/50c6037605bc4d1e9286f706427108e6/files/uploaded/Schultz_Teorias%2520de%2520la%2520Personalidad.pdf",
      folderFatherUUID: "1998-erqd-54da-45541-asdad",
    ),
    DocumentModel(
      documentUUID: "3231-erqd-54da-45541-asdad",
      documentCreatedBy: "Andres M.",
      documentDateCreated: "06/01/1994",
      documentName: "File 2 Property",
      documentType: "PDF",
      isFile: true,
      isDelete: false,
      isRestricted: false,
      url:
          "https://cdn.website-editor.net/50c6037605bc4d1e9286f706427108e6/files/uploaded/Schultz_Teorias%2520de%2520la%2520Personalidad.pdf",
      folderFatherUUID: "2998-erqd-54da-45541-asdad",
    ),
  ];
  List<DocumentModel> documentTenatsList = [
    DocumentModel(
      documentUUID: "4231-erqd-54da-45541-asdad",
      documentCreatedBy: "Marcelo H.",
      documentDateCreated: "12/05/1994",
      documentName: "Folder 1 Tenats",
      documentType: "Folder",
      isFile: false,
      isDelete: false,
      isRestricted: false,
      url:
          "https://cdn.website-editor.net/50c6037605bc4d1e9286f706427108e6/files/uploaded/Schultz_Teorias%2520de%2520la%2520Personalidad.pdf",
      folderFatherUUID: "3998-erqd-54da-45541-asdad",
    ),
    DocumentModel(
      documentUUID: "5231-erqd-54da-45541-asdad",
      documentCreatedBy: "Jose M.",
      documentDateCreated: "06/01/1994",
      documentName: "File 2 Tenats",
      documentType: "PDF",
      isFile: true,
      isDelete: false,
      isRestricted: false,
      url:
          "https://cdn.website-editor.net/50c6037605bc4d1e9286f706427108e6/files/uploaded/Schultz_Teorias%2520de%2520la%2520Personalidad.pdf",
      folderFatherUUID: "4998-erqd-54da-45541-asdad",
    ),
  ];
  List<DocumentModel> documentOnwersList = [
    DocumentModel(
      documentUUID: "6231-erqd-54da-45541-asdad",
      documentCreatedBy: "Jorge S.",
      documentDateCreated: "12/11/1994",
      documentName: "File 1 Onwer",
      documentType: "PDF",
      isFile: true,
      isDelete: false,
      isRestricted: false,
      url:
          "https://cdn.website-editor.net/50c6037605bc4d1e9286f706427108e6/files/uploaded/Schultz_Teorias%2520de%2520la%2520Personalidad.pdf",
      folderFatherUUID: "5998-erqd-54da-45541-asdad",
    ),
    DocumentModel(
      documentUUID: "7231-erqd-54da-45541-asdad",
      documentCreatedBy: "Andres M.",
      documentDateCreated: "09/12/1994",
      documentName: "File 2 Onwer",
      documentType: "PDF",
      isFile: true,
      isDelete: false,
      isRestricted: false,
      url:
          "https://cdn.website-editor.net/50c6037605bc4d1e9286f706427108e6/files/uploaded/Schultz_Teorias%2520de%2520la%2520Personalidad.pdf",
      folderFatherUUID: "5998-erqd-54da-45541-asdad",
    ),
  ];
  List<DocumentModel> documentVendorsList = [
    DocumentModel(
      documentUUID: "8231-erqd-54da-45541-asdad",
      documentCreatedBy: "Martin M.",
      documentDateCreated: "11/12/2020",
      documentName: "Folder 1 Vendor",
      documentType: "Folder",
      isFile: false,
      isDelete: false,
      isRestricted: false,
      url:
          "https://cdn.website-editor.net/50c6037605bc4d1e9286f706427108e6/files/uploaded/Schultz_Teorias%2520de%2520la%2520Personalidad.pdf",
      folderFatherUUID: "6998-erqd-54da-45541-asdad",
    ),
    DocumentModel(
      documentUUID: "9231-erqd-54da-45541-asdad",
      documentCreatedBy: "Willy D.",
      documentDateCreated: "07/08/1994",
      documentName: "File 1 Vendor",
      documentType: "PDF",
      isFile: true,
      isDelete: false,
      isRestricted: false,
      url:
          "https://cdn.website-editor.net/50c6037605bc4d1e9286f706427108e6/files/uploaded/Schultz_Teorias%2520de%2520la%2520Personalidad.pdf",
      folderFatherUUID: "7998-erqd-54da-45541-asdad",
    ),
    DocumentModel(
      documentUUID: "1031-erqd-54da-45541-asdad",
      documentCreatedBy: "Cristian p.",
      documentDateCreated: "06/01/1994",
      documentName: "File 2 Vendor",
      documentType: "PDF",
      isFile: true,
      isDelete: false,
      isRestricted: false,
      url:
          "https://cdn.website-editor.net/50c6037605bc4d1e9286f706427108e6/files/uploaded/Schultz_Teorias%2520de%2520la%2520Personalidad.pdf",
      folderFatherUUID: "8998-erqd-54da-45541-asdad",
    ),
  ];
  List<DocumentModel> documentOthersList = [
    DocumentModel(
      documentUUID: "1131-erqd-54da-45541-asdad",
      documentCreatedBy: "Pedro M.",
      documentDateCreated: "12/12/1994",
      documentName: "Folder 1 Others",
      documentType: "Folder",
      isFile: false,
      isDelete: false,
      isRestricted: false,
      url:
          "https://cdn.website-editor.net/50c6037605bc4d1e9286f706427108e6/files/uploaded/Schultz_Teorias%2520de%2520la%2520Personalidad.pdf",
      folderFatherUUID: "9998-erqd-54da-45541-asdad",
    ),
    DocumentModel(
      documentUUID: "1331-erqd-54da-45541-asdad",
      documentCreatedBy: "Juan T.",
      documentDateCreated: "07/08/1994",
      documentName: "File 1 Others",
      documentType: "PDF",
      isFile: true,
      isDelete: false,
      isRestricted: false,
      url:
          "https://cdn.website-editor.net/50c6037605bc4d1e9286f706427108e6/files/uploaded/Schultz_Teorias%2520de%2520la%2520Personalidad.pdf",
      folderFatherUUID: "1098-erqd-54da-45541-asdad",
    ),
    DocumentModel(
      documentUUID: "1431-erqd-54da-45541-asdad",
      documentCreatedBy: "Wilman C.",
      documentDateCreated: "06/01/1994",
      documentName: "File 2 Others",
      documentType: "PDF",
      isFile: true,
      isDelete: false,
      isRestricted: false,
      url:
          "https://cdn.website-editor.net/50c6037605bc4d1e9286f706427108e6/files/uploaded/Schultz_Teorias%2520de%2520la%2520Personalidad.pdf",
      folderFatherUUID: "1198-erqd-54da-45541-asdad",
    ),
  ];

  List<DocumentModel> documentTrashList = [
    DocumentModel(
      documentUUID: "1531-erqd-54da-45541-asdad",
      documentCreatedBy: "Jony S.",
      documentDateCreated: "12/11/1994",
      documentName: "File 1 Trash",
      documentType: "PDF",
      isFile: true,
      isDelete: true,
      isRestricted: false,
      url:
          "https://cdn.website-editor.net/50c6037605bc4d1e9286f706427108e6/files/uploaded/Schultz_Teorias%2520de%2520la%2520Personalidad.pdf",
      folderFatherUUID: "1298-erqd-54da-45541-asdad",
    ),
    DocumentModel(
      documentUUID: "1631-erqd-54da-45541-asdad",
      documentCreatedBy: "Gonzalo P.",
      documentDateCreated: "09/12/1994",
      documentName: "File 2 Trash",
      documentType: "PDF",
      isFile: true,
      isDelete: true,
      isRestricted: false,
      url:
          "https://cdn.website-editor.net/50c6037605bc4d1e9286f706427108e6/files/uploaded/Schultz_Teorias%2520de%2520la%2520Personalidad.pdf",
      folderFatherUUID: "1398-erqd-54da-45541-asdad",
    ),
  ];
  List<String> temporalList = ['Brentwood - Unit 100', 'Brentwood - Unit 200'];

  dispose() {
    _documentMenuDrawer.close();
    _documentSubMenuDrawer.close();
    _documentLoading.close();
    _documentOthers.close();
    _documentTrash.close();
    _documentFileTab.close();
    _documentFileList.close();
  }
}
