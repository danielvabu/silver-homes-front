import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:silverhome/bloc/bloc.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/entities/propertylist.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/document_list_screen_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/document_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/repository/document_reposirtory.dart';
import 'package:silverhome/presentation/screens/landlord/documents/widgets/dialogs/dialog_delete_document.dart';
import 'package:silverhome/presentation/screens/landlord/documents/widgets/dialogs/dialog_duplicate_document.dart';
import 'package:silverhome/presentation/screens/landlord/documents/widgets/dialogs/dialog_rename_document.dart';
import 'package:silverhome/presentation/screens/landlord/documents/widgets/dialogs/dialog_restore_document.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';
import 'dart:js' as js;

typedef VoidCallDocumentName = void Function(DocumentModel documentModel);
typedef VoidCallDocumentType = void Function(DocumentModel documentModel);
typedef VoidCallDateCreated = void Function(DocumentModel documentModel);
typedef VoidCallCreatedBy = void Function(DocumentModel documentModel);

/* typedef VoidCallActive = void Function(DocumentModel documentModel, int pos);
typedef VoidCallInActive = void Function(DocumentModel documentModel, int pos);
typedef VoidCallIsPublish = void Function(
    DocumentModel documentModel, int pos, bool flag); */

class DocumentItem extends StatefulWidget {
  final VoidCallDocumentName _callbackDocumentName;
  final VoidCallDocumentType _callbackDocumentType;
  final VoidCallDateCreated _callbackDateCreated;
  final VoidCallCreatedBy _callbackCreatedBy;
  final VoidCallCreatedBy _callbackRestrictEditing;
  List<DocumentModel> documentList;

  DocumentItem({
    required List<DocumentModel> documentListData,
    required VoidCallDocumentName onPressDocumentName,
    required VoidCallDocumentType onPressDocumentType,
    required VoidCallDateCreated onPresseDateCreated,
    required VoidCallCreatedBy onPresseCreatedBy,
    required VoidCallCreatedBy onPresseEditing,
  })  : documentList = documentListData,
        _callbackDocumentName = onPressDocumentName,
        _callbackDocumentType = onPressDocumentType,
        _callbackDateCreated = onPresseDateCreated,
        _callbackCreatedBy = onPresseCreatedBy,
        _callbackRestrictEditing = onPresseEditing;

  @override
  _DocumentItemState createState() => _DocumentItemState();
}

class _DocumentItemState extends State<DocumentItem> {
  late OverlayEntry loader;
  double height = 0, width = 0;
  DocumentsService _documentsService = new DocumentsService();
  final _store = getIt<AppStore>();

  @override
  void initState() {
    super.initState();
  }

  _changeRestrictEditing(DocumentModel model, bool currentValue) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);
    bool? isRestrictedChange = await _documentsService.changeRestrictEditing(
        context, model.documentUUID!, currentValue, model.folderFatherUUID!);
    if (isRestrictedChange!) {
      model.isRestricted = currentValue;
      setState(() {});
    }
    loader.remove();
  }

  _openDocument(
    DocumentModel model,
  ) {
    js.context.callMethod('open', [model.url]);
  }

  _restoreDocument(
    DocumentModel model,
  ) async {
    await showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialogRestoreDocument(
          title: GlobleString.Document_restore,
          negativeText: GlobleString.Mant_DL_Cancel,
          positiveText: GlobleString.Button_OK,
          negativeButton: () {
            Navigator.pop(context);
          },
          documentFatherUUID: model.folderFatherUUID!,
          documentUUID: model.documentUUID!,
        );
      },
    );
  }

  _renameDocument(DocumentModel model, BuildContext context) async {
    await showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialogRenameDocument(
          title: GlobleString.Document_rename,
          negativeText: GlobleString.Mant_DL_Cancel,
          positiveText: GlobleString.Button_OK,
          negativeButton: () {
            Navigator.pop(context);
          },
          documentFatherUUID: model.folderFatherUUID!,
          documentUUID: model.documentUUID!,
        );
      },
    );
  }

  _moveDocument(DocumentModel model, Bloc bloc) {
    bloc.documentBloc.changeDocumentShowMove(true);
  }

  _downloadDocument(
    DocumentModel model,
  ) async {
    html.AnchorElement anchorElement = new html.AnchorElement(href: model.url);
    anchorElement.download = model.url;
    anchorElement.target = "blank";
    anchorElement.click();
  }

  _duplicateDocument(
    DocumentModel model,
  ) async {
    await showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialogDuplicateDocument(
          title: GlobleString.Document_duplicate,
          negativeText: GlobleString.Mant_DL_Cancel,
          positiveText: GlobleString.Button_OK,
          negativeButton: () {
            Navigator.pop(context);
          },
          documentFatherUUID: model.folderFatherUUID!,
          documentUUID: model.documentUUID!,
        );
      },
    );
  }

  _deleteDocument(
    DocumentModel model,
  ) async {
    await showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialogDeleteDocument(
          title: GlobleString.Document_delete,
          negativeText: GlobleString.Mant_DL_Cancel,
          positiveText: GlobleString.Button_OK,
          negativeButton: () {
            Navigator.pop(context);
          },
          documentFatherUUID: model.folderFatherUUID!,
          documentUUID: model.documentUUID!,
        );
      },
    );
  }

  _switchItemDocumentAction(DocumentModel model, value, Bloc bloc) {
    switch (value) {
      case 0:
        _openDocument(model);
        break;
      case 1:
        _restoreDocument(model);
        break;
      case 2:
        _renameDocument(model, context);
        break;
      case 3:
        _moveDocument(model, bloc);
        break;
      case 4:
        _downloadDocument(model);
        break;
      case 5:
        _duplicateDocument(model);
        break;
      case 6:
        _deleteDocument(model);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 230;
    final bloc = Provider.of<Bloc>(context);
    return Container(
      width: width,
      height: height - 220,
      child: ListviewBuid(widget.documentList, bloc),
    );
  }

  Widget ListviewBuid(List<DocumentModel> listdata, Bloc bloc) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: myColor.TA_table_header,
        thickness: 0,
        height: 0,
      ),
      scrollDirection: Axis.vertical,
      key: UniqueKey(),
      itemCount: listdata.length,
      itemBuilder: (BuildContext ctxt, int Index) {
        return Container(
          decoration: BoxDecoration(
            color: /* Index % 2 == 0 ? myColor.TA_dark : */ myColor.TA_light,
            border: Border.all(
              color: myColor.gray,
              width: 0.1,
            ),
          ),
          height: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: _tableData(listdata[Index], bloc),
          ),
        );
      },
    );
  }

  List<Widget> _tableData(DocumentModel documentModel, Bloc bloc) {
    var result = <Widget>[];
    result.add(_datavalueDocumentName(documentModel, bloc));
    result.add(_datavalueDocumentType(documentModel));
    result.add(_datavalueDateCreated(documentModel));
    result.add(_datavalueCreatedBy(documentModel));
    result.add(_datavalueRestrictEditing(documentModel));
    result.add(_actionPopup(documentModel, bloc));

    return result;
  }

  Widget _datavalueDocumentName(DocumentModel model, Bloc bloc) {
    return InkWell(
      onTap: () async {
        bloc.documentBloc.currentDocument = model;
        if (model.isFile!) {
          _downloadDocument(model);
        } else {
          bloc.documentBloc.changeDocumentFileList([]);
          bloc.documentBloc.changeDocumentBreadcumList([]);
          DocumentsListScreenModel? temporalDocumentList =
              await _documentsService.getDocumentListByUUID(
                  context,
                  model.documentUUID == null ? "" : model.documentUUID!,
                  bloc.documentBloc.currentDocumentTab.toUpperCase());
          bloc.documentBloc
              .changeDocumentFileList(temporalDocumentList!.folderContent!);
          bloc.documentBloc
              .changeDocumentBreadcumList(temporalDocumentList.breadcumbs!);
          bloc.documentBloc.currentFatherFolderUUID =
              temporalDocumentList.documentFatherUUID;
        }
      },
      child: Container(
        height: 40,
        width: width / 6,
        margin: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Tooltip(
            message: model.documentName!,
            child: Row(
              children: [
                Icon(model.isFile! ? FontAwesomeIcons.filePdf : Icons.folder,
                    color: model.isFile! ? null : myColor.black, size: 14),
                SizedBox(
                  width: 5,
                ),
                Text(
                  model.documentName!,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: MyStyles.Medium(12, myColor.blue),
                ),
              ],
            )),
      ),
    );
  }

  Widget _datavalueDocumentType(DocumentModel model) {
    return Container(
      height: 40,
      width: width / 6,
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.documentType!,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueDateCreated(DocumentModel model) {
    return Container(
      height: 40,
      width: width / 6,
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.documentDateCreated!,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueCreatedBy(DocumentModel model) {
    return Container(
      height: 40,
      width: width / 7,
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.documentCreatedBy!,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueRestrictEditing(DocumentModel model) {
    return Container(
      height: 40,
      width: width / 8,
      margin: EdgeInsets.only(right: 40),
      alignment: Alignment.centerLeft,
      child: FlutterSwitch(
        width: 55.0,
        activeIcon: Icon(FontAwesomeIcons.unlock, color: myColor.propertyOn),
        inactiveIcon: Icon(FontAwesomeIcons.lock, color: myColor.gray),
        height: 25.0,
        valueFontSize: 10.0,
        toggleSize: 20.0,
        value: model.isRestricted!,
        borderRadius: 30.0,
        padding: 2.0,
        activeColor: myColor.propertyOn,
        activeText: "",
        activeTextColor: myColor.white,
        inactiveColor: myColor.gray,
        inactiveText: "",
        inactiveTextColor: myColor.white,
        showOnOff: true,
        onToggle: (val) {
          _changeRestrictEditing(model, val);
        },
      ),
    );
  }

  Widget _actionPopup(DocumentModel model, Bloc bloc) {
    return StreamBuilder(
      stream: bloc.documentBloc.getDocumentShowMoveTransformer,
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot snapshotShowMove) {
        return Expanded(
          flex: 1,
          child: model.isRestricted! ||
                  (snapshotShowMove.hasData && snapshotShowMove.data)
              ? SizedBox()
              : Container(
                  height: 28,
                  margin: EdgeInsets.only(left: 5, right: 5),
                  alignment: Alignment.centerRight,
                  child: StreamBuilder(
                    stream: bloc.documentBloc.getDocumentTrashTransformer,
                    initialData: false,
                    builder: (BuildContext context,
                        AsyncSnapshot snapshotTrashDocument) {
                      return PopupMenuButton(
                        shape: Border.all(color: myColor.black),
                        position: PopupMenuPosition.under,
                        onSelected: (value) {
                          bloc.documentBloc.currentDocumentMenuSelected = model;
                          _switchItemDocumentAction(model, value, bloc);
                        },
                        child: Container(
                          height: 40,
                          width: 20,
                          margin: EdgeInsets.only(right: 5),
                          child: Icon(Icons.more_vert),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 0,
                            child: Text(
                              GlobleString.Pop_Menu_documents_table_view,
                              style: MyStyles.Medium(14, myColor.text_color),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          if (snapshotTrashDocument.hasData &&
                              snapshotTrashDocument.data) ...[
                            PopupMenuItem(
                              value: 1,
                              child: Text(
                                GlobleString.Pop_Menu_documents_table_restore,
                                style: MyStyles.Medium(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                          if ((snapshotTrashDocument.hasData &&
                                  snapshotTrashDocument.data == false) ||
                              !snapshotTrashDocument.hasData) ...[
                            PopupMenuItem(
                              value: 2,
                              child: Text(
                                GlobleString.Pop_Menu_documents_table_rename,
                                style: MyStyles.Medium(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            )
                          ],
                          if (!model.isDelete!) ...[
                            PopupMenuItem(
                              value: 3,
                              child: Text(
                                GlobleString.Pop_Menu_documents_table_move,
                                style: MyStyles.Medium(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                          if (model.isFile!)
                            PopupMenuItem(
                              value: 4,
                              child: Text(
                                GlobleString.Pop_Menu_documents_table_download,
                                style: MyStyles.Medium(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          if ((snapshotTrashDocument.hasData &&
                                  snapshotTrashDocument.data == false) ||
                              !snapshotTrashDocument.hasData) ...[
                            PopupMenuItem(
                              value: 5,
                              child: Text(
                                GlobleString.Pop_Menu_documents_table_duplicate,
                                style: MyStyles.Medium(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                          PopupMenuItem(
                            value: 6,
                            child: Text(
                              GlobleString.Pop_Menu_documents_table_delete,
                              style: MyStyles.Medium(14, myColor.text_color),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}
