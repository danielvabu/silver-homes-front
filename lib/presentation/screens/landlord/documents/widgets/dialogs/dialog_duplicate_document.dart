import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silverhome/bloc/bloc.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/document_list_screen_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/document_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/repository/document_reposirtory.dart';

class AlertDialogDuplicateDocument extends StatefulWidget {
  final String title;
  final String positiveText;
  final String negativeText;
  final Function negativeButton;
  final String documentFatherUUID;
  final String documentUUID;

  AlertDialogDuplicateDocument({
    required String title,
    required String positiveText,
    required String negativeText,
    required Function negativeButton,
    required String documentFatherUUID,
    required String documentUUID,
  })  : title = title,
        positiveText = positiveText,
        negativeText = negativeText,
        negativeButton = negativeButton,
        documentFatherUUID = documentFatherUUID,
        documentUUID = documentUUID;

  @override
  _AlertDialogDuplicateDocumentState createState() =>
      _AlertDialogDuplicateDocumentState();
}

class _AlertDialogDuplicateDocumentState
    extends State<AlertDialogDuplicateDocument> {
  final _nameFolderController = new TextEditingController();
  DocumentsService documentsService = new DocumentsService();

  _duplicateDocument(Bloc bloc) async {
    bool? isDuplicatedDocument = await documentsService.duplicateDocument(
        context, widget.documentUUID, widget.documentFatherUUID);
    print("isDuplicatedDocument $isDuplicatedDocument");
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
                minWidth: 500, maxWidth: 500, minHeight: 150, maxHeight: 150),
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
                          _duplicateDocument(bloc);
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
