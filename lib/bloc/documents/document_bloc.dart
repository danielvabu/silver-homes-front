import 'package:rxdart/rxdart.dart';
import 'package:silverhome/domain/entities/propertylist.dart';
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
  PropertyDataList? currentFilterSelected;
  DocumentModel? currentDocument;

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
  final _documentFilterList = BehaviorSubject<List<PropertyDataList>>();
  Stream<List<PropertyDataList>> get getDocumentFilterListTransformer =>
      _documentFilterList.stream;
  Function(List<PropertyDataList>) get changeDocumentFilterList =>
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
  List<String> breadcrumbsList = [];

  List<DocumentModel> documentPropertyList = [];
  List<DocumentModel> documentTenatsList = [];
  List<DocumentModel> documentOnwersList = [];
  List<DocumentModel> documentVendorsList = [];
  List<DocumentModel> documentOthersList = [];

  List<DocumentModel> documentTrashList = [];
  List<PropertyDataList> filterList = [];

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
