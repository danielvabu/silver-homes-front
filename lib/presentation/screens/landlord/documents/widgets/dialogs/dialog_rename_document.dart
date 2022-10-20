import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silverhome/bloc/bloc.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/document_list_screen_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/document_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/repository/document_reposirtory.dart';

class AlertDialogRenameDocument extends StatefulWidget {
  final String title;
  final String positiveText;
  final String negativeText;
  final Function negativeButton;
  final String documentUUID;
  final String documentFatherUUID;

  AlertDialogRenameDocument({
    required String title,
    required String positiveText,
    required String negativeText,
    required Function negativeButton,
    required String documentUUID,
    required String documentFatherUUID,
  })  : title = title,
        positiveText = positiveText,
        negativeText = negativeText,
        negativeButton = negativeButton,
        documentUUID = documentUUID,
        documentFatherUUID = documentFatherUUID;

  @override
  _AlertDialogRenameDocumentState createState() =>
      _AlertDialogRenameDocumentState();
}

class _AlertDialogRenameDocumentState extends State<AlertDialogRenameDocument> {
  final _nameFolderController = new TextEditingController();
  DocumentsService documentsService = new DocumentsService();
  late OverlayEntry loader;
  _renameDocument(Bloc bloc) async {
    bool? isRenamedDocument = await documentsService.renameDocument(
        context,
        widget.documentUUID,
        _nameFolderController.text,
        widget.documentFatherUUID);
    if (isRenamedDocument ?? false) {
      loader = Helper.overlayLoader(context);
      Overlay.of(context)!.insert(loader);
      DocumentsListScreenModel? temporalDocumentList =
          await documentsService.getDocumentListByUUID(
              context,
              widget.documentFatherUUID,
              bloc.documentBloc.currentDocumentTab.toUpperCase());
      loader.remove();
      bloc.documentBloc
          .changeDocumentFileList(temporalDocumentList!.folderContent!);
      bloc.documentBloc
          .changeDocumentBreadcumList(temporalDocumentList.breadcumbs!);
      bloc.documentBloc.currentFatherFolderUUID =
          temporalDocumentList.documentFatherUUID;
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<Bloc>(context);
    return Align(
      alignment: Alignment(0, 0),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: 500, maxWidth: 500, minHeight: 250, maxHeight: 350),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.white),
              padding:
                  EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: MyStyles.SemiBold(20, myColor.text_color),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextField(
                    controller: _nameFolderController,
                    autofocus: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      focusColor: Colors.transparent,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: myColor.blue, width: 2.0),
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black12, width: 1.0)),
                      fillColor: myColor.white,
                      hintText: GlobleString.Document_rename,
                      hintStyle: MyStyles.Regular(16, myColor.Circle_main),
                      labelStyle: MyStyles.Regular(16, myColor.Circle_main),
                    ),
                    onSubmitted: (value) {
                      _renameDocument(bloc);
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          widget.negativeButton();
                        },
                        child: Container(
                          height: 35,
                          width: 90,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: myColor.white,
                            border: Border.all(
                                color: myColor.Circle_main, width: 1),
                          ),
                          child: Text(
                            widget.negativeText,
                            style: MyStyles.Medium(14, myColor.Circle_main),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          _renameDocument(bloc);
                        },
                        child: Container(
                          height: 35,
                          width: 90,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: myColor.Circle_main,
                            border: Border.all(
                                color: myColor.Circle_main, width: 1),
                          ),
                          child: Text(
                            widget.positiveText,
                            style: MyStyles.Medium(14, myColor.white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
