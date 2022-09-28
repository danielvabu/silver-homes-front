import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silverhome/bloc/bloc.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/document_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/widgets/table/header_table_document.dart';
import 'package:silverhome/presentation/screens/landlord/documents/widgets/table/item_table_document.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

class TableDocument extends StatefulWidget {
  TableDocument({Key? key}) : super(key: key);

  @override
  State<TableDocument> createState() => _TableDocumentState();
}

class _TableDocumentState extends State<TableDocument> {
  double sswidth = 0, ssheight = 0;
  int limitPage = 20, numberPage = 1;

  @override
  Widget build(BuildContext context) {
    ssheight = MediaQuery.of(context).size.height - 70;
    sswidth = MediaQuery.of(context).size.width - 230;
    final bloc = Provider.of<Bloc>(context);
    return _tableview(bloc);
  }

  Widget _tableview(Bloc bloc) {
    List<DocumentModel> temp = [];
    return Container(
      width: sswidth,
      margin: EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3))),
      child: Column(
        children: [
          DocumentTableHeader(
            onPressedSortName: () async {},
            onPressedSortType: () async {},
            onPressedSortDateCreated: () async {},
            onPressedSortCreatedBy: () async {},
            onPressedSortRestricEditing: () async {},
          ),
          StreamBuilder(
            stream: bloc.documentBloc.getDocumentFileListTransformer,
            initialData: temp,
            builder:
                (BuildContext context, AsyncSnapshot snapshotDocumentList) {
              if (snapshotDocumentList.hasData) {
                return tableItem(
                    snapshotDocumentList.data as List<DocumentModel>, bloc);
              } else {
                return Center(
                  child: Text(GlobleString.Message_No_File_upload),
                );
              }
            },
          ),

          /*    if (documentList.length > 0) tablefooter(documentList) */
        ],
      ),
    );
  }

  Widget tableItem(List<DocumentModel> documentList, Bloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder(
          stream: bloc.documentBloc.getDocumentLoadingTransformer,
          initialData: false,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              return Expanded(
                child: Container(
                  width: sswidth,
                  height: ssheight - 310,
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text(
                    "Please wait.....",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: MyStyles.Medium(18, myColor.Circle_main),
                  ),
                ),
              );
            } else {
              if (documentList != null && documentList.length > 0) {
                return Expanded(
                  child: DocumentItem(
                    documentListData: documentList,
                    onPressDocumentName: (DocumentModel documentModel) {},
                    onPressDocumentType: (DocumentModel documentModel) {},
                    onPresseDateCreated: (DocumentModel documentModel) {},
                    onPresseCreatedBy: (DocumentModel documentModel) {},
                    onPresseEditing: (DocumentModel documentModel) {},
                  ),
                );
              } else {
                return Expanded(
                  child: Container(
                    width: sswidth,
                    height: ssheight - 310,
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Text(
                      GlobleString.Message_No_File_upload,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: MyStyles.Medium(18, myColor.tabel_msg),
                    ),
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }
}
