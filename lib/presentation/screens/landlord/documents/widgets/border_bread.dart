import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:provider/provider.dart';
import 'package:silverhome/bloc/bloc.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/breadcumb_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/document_list_screen_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/repository/document_reposirtory.dart';

class BreadCumb extends StatefulWidget {
  BreadcumbModel bread;
  BreadCumb({Key? key, required this.bread}) : super(key: key);

  @override
  State<BreadCumb> createState() => _BreadCumbState();
}

DocumentsService _documentsService = new DocumentsService();

initData(String fatherUUID, Bloc bloc, BuildContext context,
    [String type = ""]) async {
  await bloc.propertyBloc
      .getPropertyFilterList("", 1, "PropertyName", 1, 0, context);
  await _getDocumentsFileList(
      bloc,
      context,
      fatherUUID,
      type == "" ? "property" : type,
      "",
      bloc.documentBloc.currentFilterSelected != null
          ? (bloc.documentBloc.currentFilterSelected!.id ?? "")
          : "");
}

_getDocumentsFileList(Bloc bloc, BuildContext context, String fatherUUID,
    String type, String search, String filter) async {
  print(filter);
  bloc.documentBloc.changeDocumentFileList([]);
  bloc.documentBloc.changeDocumentBreadcumList([]);
  DocumentsListScreenModel? temporalDocumentList =
      await _documentsService.getDocumentListByUUID(
          context, fatherUUID, type != "" ? type : "property", search, filter);
  bloc.documentBloc
      .changeDocumentFileList(temporalDocumentList!.folderContent!);
  bloc.documentBloc
      .changeDocumentBreadcumList(temporalDocumentList.breadcumbs!);
  bloc.documentBloc.currentFatherFolderUUID =
      temporalDocumentList.documentFatherUUID;
}

class _BreadCumbState extends State<BreadCumb> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<Bloc>(context);
    return InkWell(
        onTap: () {
          initData(widget.bread.breadcumbUUID!, bloc, context,
              bloc.documentBloc.currentDocumentTab);
        },
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: ClipPath(
                clipper: ArrowClipper(20, 50, Edge.RIGHT),
                child: Container(
                  height: 70,
                  width: 190,
                  padding: EdgeInsets.only(right: 10),
                  color: myColor.drawselectcolor,
                  child: Center(
                      child: Text(
                    "${widget.bread.name}",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  )),
                ))));
  }
}
