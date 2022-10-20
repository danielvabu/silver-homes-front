import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:silverhome/bloc/bloc.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/domain/entities/propertylist.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/breadcumb_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/document_list_screen_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/document_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/filter_document_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/repository/document_reposirtory.dart';
import 'package:silverhome/presentation/screens/landlord/documents/widgets/border_bread.dart';
import 'package:silverhome/presentation/screens/landlord/documents/widgets/bread_new.dart';
import 'package:silverhome/presentation/screens/landlord/documents/widgets/dialogs/dialog_create_document.dart';
import 'package:silverhome/presentation/screens/landlord/documents/widgets/dialogs/dialog_move_document.dart';
import 'package:silverhome/presentation/screens/landlord/documents/widgets/table/table_document.dart';
import 'package:silverhome/tablayer/api_manager_admin.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';
import 'dart:html' as html;

class FileDocuments extends StatefulWidget {
  const FileDocuments({Key? key}) : super(key: key);

  @override
  State<FileDocuments> createState() => _FileDocumentsState();
}

late OverlayEntry loader;
DocumentsService _documentsService = new DocumentsService();
TextEditingController _searchController = new TextEditingController();
Timer? _debounce;

_sendFileToApi(BuildContext context, Bloc bloc) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowedExtensions: ['jpg', 'png', 'pdf', "doc", "jpeg"],
    type: FileType.custom,
  );

  if (result != null) {
    PlatformFile file = result.files.first as PlatformFile;

    Helper.Log("file size", file.size.toString());

    if ((file.size / 1024) < 0) {
      ToastUtils.showCustomToast(
          context, GlobleString.TVD_Document_Image_Size_0_error, false);
    } else if ((file.size / 1024) > 10240) {
      ToastUtils.showCustomToast(
          context, GlobleString.TVD_Document_Image_Size_error, false);
    } else if ((file.name.split('.').last).contains("jpg") ||
        (file.name.split('.').last).contains("JPG") ||
        (file.name.split('.').last).contains("png") ||
        (file.name.split('.').last).contains("PNG") ||
        (file.name.split('.').last).contains("pdf") ||
        (file.name.split('.').last).contains("PDF") ||
        (file.name.split('.').last).contains("jpeg") ||
        (file.name.split('.').last).contains("JPEG") ||
        (file.name.split('.').last).contains("doc") ||
        (file.name.split('.').last).contains("DOC")) {
      loader = Helper.overlayLoader(context);
      Overlay.of(context)!.insert(loader);
      DocumentModel? documentModel = await _documentsService.uploadDocument(
          context,
          file.bytes!,
          file.name.split('.').last,
          bloc.documentBloc.currentDocumentTab.toUpperCase(),
          bloc.documentBloc.currentFilterSelected == null
              ? ""
              : bloc.documentBloc.currentFilterSelected!.id ?? "",
          bloc.documentBloc.currentFatherFolderUUID ?? "",
          file.name.split('.').first);
      /* if (documentModel != null) { */
      DocumentsListScreenModel? temporalDocumentList =
          await _documentsService.getDocumentListByUUID(
              context,
              bloc.documentBloc.currentFatherFolderUUID!,
              bloc.documentBloc.currentDocumentTab.toUpperCase());
      bloc.documentBloc
          .changeDocumentFileList(temporalDocumentList!.folderContent!);
      bloc.documentBloc
          .changeDocumentBreadcumList(temporalDocumentList.breadcumbs!);
      bloc.documentBloc.currentFatherFolderUUID =
          temporalDocumentList.documentFatherUUID;
      loader.remove();
      /*   } */
    }
  }
}

_createFolder(BuildContext context, String folderFatherUUID) async {
  await showDialog(
    context: context,
    barrierColor: Colors.black45,
    useSafeArea: true,
    barrierDismissible: false,
    builder: (BuildContext context1) {
      return AlertDialogCreateDocument(
        title: GlobleString.Document_create,
        negativeText: GlobleString.Mant_DL_Cancel,
        positiveText: GlobleString.Button_OK,
        negativeButton: () {
          Navigator.pop(context);
        },
        documentFatherUUID: folderFatherUUID,
      );
    },
  );
}

_moveDocument(Bloc bloc, BuildContext context) async {
  await showDialog(
    context: context,
    barrierColor: Colors.black45,
    useSafeArea: true,
    barrierDismissible: false,
    builder: (BuildContext context1) {
      return AlertDialogMoveDocument(
        title: GlobleString.Document_move,
        negativeText: GlobleString.Mant_DL_Cancel,
        positiveText: GlobleString.Button_OK,
        negativeButton: () {
          Navigator.pop(context1);
        },
        documentFatherUUID:
            bloc.documentBloc.currentDocumentMenuSelected!.folderFatherUUID!,
        documentUUID:
            bloc.documentBloc.currentDocumentMenuSelected!.documentUUID!,
        documentNewFatherUUID: bloc.documentBloc.currentFatherFolderUUID!,
      );
    },
  );
}

_onSearchChanged(String searchValue, Bloc bloc, BuildContext context) async {
  await _getDocumentsFileList(
      bloc,
      context,
      bloc.documentBloc.currentDocumentTab.toUpperCase(),
      searchValue,
      bloc.documentBloc.currentFilterSelected == null
          ? ""
          : bloc.documentBloc.currentFilterSelected!.id ?? "");
/*   _searchController.clear(); */
}

Widget _breadcrumbs(Bloc bloc) {
  return StreamBuilder(
    stream: bloc.documentBloc.getDocumentBreadcumListTransformer,
    builder: (BuildContext context, AsyncSnapshot snapshotBreadcumList) {
      if (snapshotBreadcumList.hasData) {
        List<BreadcumbModel> tempBreadList =
            snapshotBreadcumList.data as List<BreadcumbModel>;
        return Container(
          height: tempBreadList.isNotEmpty ? 35 : 0,
          margin: EdgeInsets.fromLTRB(5, 12, 5, 6),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tempBreadList.length,
            itemBuilder: (BuildContext context, int index) {
              return BreadCumb(bread: tempBreadList[index]);
            },
          ),
        );
      } else {
        return SizedBox();
      }
    },
  );
}

Widget _getTableDocuments() {
  return TableDocument();
}

_changeDocumentList(int value, Bloc bloc, BuildContext context) async {
  bloc.documentBloc.changeDocumentFileTab(value);
  if (value != 4) {
    bloc.documentBloc.changeDocumentOthers(false);
  }
  switch (value) {
    case 0:
      bloc.documentBloc.currentDocumentTab = GlobleString.Tab_Document_property;
      _searchController.clear();
      initData(bloc, context, bloc.documentBloc.currentDocumentTab);
      bloc.documentBloc.changeDocumentOthers(false);
      break;
    case 1:
      bloc.documentBloc.currentDocumentTab = GlobleString.Tab_Document_tenants;
      _searchController.clear();
      initData(bloc, context, bloc.documentBloc.currentDocumentTab);
      bloc.documentBloc.changeDocumentOthers(false);
      break;
    case 2:
      bloc.documentBloc.currentDocumentTab = GlobleString.Tab_Document_onwers;
      _searchController.clear();
      initData(bloc, context, bloc.documentBloc.currentDocumentTab);
      bloc.documentBloc.changeDocumentOthers(false);
      break;
    case 3:
      bloc.documentBloc.currentDocumentTab = GlobleString.Tab_Document_vendors;
      _searchController.clear();
      initData(bloc, context, bloc.documentBloc.currentDocumentTab);
      bloc.documentBloc.changeDocumentOthers(false);
      break;
    case 4:
      bloc.documentBloc.currentDocumentTab = GlobleString.Tab_Document_other;
      _searchController.clear();
      initData(bloc, context, bloc.documentBloc.currentDocumentTab);
      bloc.documentBloc.changeDocumentOthers(true);

      break;
    case 5:
      bloc.documentBloc.currentDocumentTab = GlobleString.Tab_Document_trash;
      _searchController.clear();
      initData(bloc, context, bloc.documentBloc.currentDocumentTab);
      bloc.documentBloc.changeDocumentOthers(false);

      break;
    default:
      bloc.documentBloc.changeDocumentFileList([]);
  }
}

_getDocumentsFileList(Bloc bloc, BuildContext context, String type,
    String search, String filter) async {
  print(filter);
  bloc.documentBloc.changeDocumentFileList([]);
  bloc.documentBloc.changeDocumentBreadcumList([]);
  DocumentsListScreenModel? temporalDocumentList =
      await _documentsService.getDocumentListByUUID(
          context, "", type != "" ? type : "property", search, filter);
  bloc.documentBloc
      .changeDocumentFileList(temporalDocumentList!.folderContent!);
  bloc.documentBloc
      .changeDocumentBreadcumList(temporalDocumentList.breadcumbs!);
  bloc.documentBloc.currentFatherFolderUUID =
      temporalDocumentList.documentFatherUUID;
}

initData(Bloc bloc, BuildContext context, [String type = ""]) async {
  await bloc.propertyBloc
      .getPropertyFilterList("", 1, "PropertyName", 1, 0, context);
  await _getDocumentsFileList(
      bloc,
      context,
      type == "" ? "property" : type,
      "",
      bloc.documentBloc.currentFilterSelected != null
          ? (bloc.documentBloc.currentFilterSelected!.id ?? "")
          : "");
}

class _FileDocumentsState extends State<FileDocuments> {
  double height = 0, width = 0, ancho = 0;
  bool isFirstCharge = true;
  Widget _searchRow(
      double width, double height, Bloc bloc, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: myColor.TA_Border,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      width: width * .20,
                      child: TextFormField(
                        controller: _searchController,
                        onChanged: (value) {},
                        onFieldSubmitted: (value) {
                          _onSearchChanged(value, bloc, context);
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: MyStyles.Medium(14, myColor.hintcolor),
                          contentPadding: const EdgeInsets.all(10),
                          isDense: true,
                          hintText: GlobleString.CALENDAR_Search,
                        ),
                        style: MyStyles.Medium(14, myColor.text_color),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 6, right: 4),
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                )),
            StreamBuilder(
                stream: bloc.documentBloc.getDocumentTrashTransformer,
                initialData: false,
                builder:
                    (BuildContext context, AsyncSnapshot snapshotTrashButton) {
                  if (!snapshotTrashButton.hasData ||
                      !snapshotTrashButton.data) {
                    return PopupMenuButton(
                      constraints: BoxConstraints(
                        maxWidth: width * .107,
                        maxHeight: height * .25,
                      ),
                      shape: Border.all(color: myColor.black),
                      onSelected: (value) async {
                        switch (value) {
                          case 0:
                            _sendFileToApi(context, bloc);
                            break;
                          case 1:
                            _createFolder(
                                context,
                                bloc.documentBloc.currentFatherFolderUUID ??
                                    "");
                            break;
                          default:
                        }
                      },
                      position: PopupMenuPosition.under,
                      child: Container(
                        height: 32,
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                          border: Border.all(color: myColor.black),
                          color: myColor.Circle_main,
                        ),
                        child: Row(
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.add_circle,
                                color: myColor.white,
                                size: 20,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              GlobleString.Button_Document_new,
                              style: MyStyles.Regular(14, myColor.white),
                            ),
                            /* ;
                          } else {
                            return SizedBox();
                          } 
                        }),*/
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: myColor.white,
                                size: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 0,
                          child: Text(
                            GlobleString.Option_Upload_file,
                            style: MyStyles.Medium(14, myColor.text_color),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        PopupMenuItem(
                          value: 1,
                          child: Text(
                            GlobleString.Option_Create_file,
                            style: MyStyles.Medium(14, myColor.text_color),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                })
          ],
        ),
        Row(
          children: [
            StreamBuilder(
                stream: bloc.propertyBloc.getpropertyTransformer,
                builder: (BuildContext context,
                    AsyncSnapshot snapshotDocumentFilterList) {
                  if (snapshotDocumentFilterList.hasData) {
                    List<PropertyDataList> temporalListP =
                        snapshotDocumentFilterList.data;

                    return Container(
                      width: width * .30,
                      height: 32,
                      child: DropdownSearch<PropertyDataList>(
                        mode: Mode.MENU,
                        key: UniqueKey(),
                        errorcolor: myColor.errorcolor,
                        /*  clearButton: Icon(Icons.close, size: 4, color: Colors.black), */
                        clearButtonBuilder: (context) {
                          return InkWell(
                            onTap: () async {
                              bloc.documentBloc.currentFilterSelected = null;
                              setState(() {});
                              await _getDocumentsFileList(
                                  bloc,
                                  context,
                                  bloc.documentBloc.currentDocumentTab
                                      .toUpperCase(),
                                  "",
                                  "");
                            },
                            child: Icon(Icons.close,
                                size: 12, color: Colors.black),
                          );
                        },
                        showClearButton: true,
                        focuscolor: myColor.blue,
                        focusWidth: 2,
                        popupBackgroundColor: myColor.white,
                        items: temporalListP,
                        itemAsString: (PropertyDataList? p) =>
                            p != null ? p.propertyName! : "",
                        defultHeight: temporalListP.length * 35 > 250
                            ? 250
                            : temporalListP.length * 35,
                        textstyle: MyStyles.Medium(14, myColor.text_color),
                        hint:
                            "All ${bloc.documentBloc.currentDocumentTab.toUpperCase()}",
                        selectedItem: bloc.documentBloc.currentFilterSelected,
                        onChanged: (value) async {
                          bloc.documentBloc.currentFilterSelected = value;
                          await _getDocumentsFileList(
                              bloc,
                              context,
                              bloc.documentBloc.currentDocumentTab
                                  .toUpperCase(),
                              "",
                              bloc.documentBloc.currentFilterSelected!.id!);
                        },
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
            StreamBuilder(
              stream: bloc.documentBloc.getDocumentShowMoveTransformer,
              initialData: false,
              builder: (BuildContext context,
                  AsyncSnapshot snapshotDocumentShowMove) {
                if (snapshotDocumentShowMove.hasData &&
                    snapshotDocumentShowMove.data) {
                  return Row(
                    children: [
                      InkWell(
                          onTap: () {
                            _moveDocument(bloc, context);
                          },
                          child: Container(
                            height: 32,
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                              border: Border.all(color: myColor.gray),
                              color: myColor.Circle_main,
                            ),
                            child: Text(
                              GlobleString.Document_Button_move,
                              style: MyStyles.Regular(14, myColor.white),
                            ),
                          )),
                      InkWell(
                          onTap: () {
                            bloc.documentBloc.changeDocumentShowMove(false);
                          },
                          child: Container(
                            height: 32,
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                              border: Border.all(color: myColor.black),
                              color: myColor.white,
                            ),
                            child: Text(
                              GlobleString.Document_Button_cancel,
                              style: MyStyles.Regular(14, myColor.Circle_main),
                            ),
                          ))
                    ],
                  );
                } else {
                  return StreamBuilder(
                    stream: bloc.documentBloc.getDocumentTrashTransformer,
                    initialData: false,
                    builder: (BuildContext context,
                        AsyncSnapshot snapshotTrashButton) {
                      return InkWell(
                          onTap: () {
                            bloc.documentBloc
                                .changeDocumentTrash(!snapshotTrashButton.data);
                            _changeDocumentList(
                                snapshotTrashButton.data ? 0 : 5,
                                bloc,
                                context);
                          },
                          child: Container(
                            height: 32,
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                              border: Border.all(
                                  color: snapshotTrashButton.hasData &&
                                          snapshotTrashButton.data
                                      ? myColor.gray
                                      : myColor.black),
                              color: snapshotTrashButton.hasData &&
                                      snapshotTrashButton.data
                                  ? myColor.gray
                                  : myColor.white,
                            ),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Icon(
                                    FontAwesomeIcons.trashAlt,
                                    color: snapshotTrashButton.hasData &&
                                            snapshotTrashButton.data
                                        ? myColor.white
                                        : myColor.Circle_main,
                                    size: 15,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  GlobleString.Button_Document_view_trash,
                                  style: MyStyles.Regular(
                                      14,
                                      snapshotTrashButton.hasData &&
                                              snapshotTrashButton.data
                                          ? myColor.white
                                          : myColor.Circle_main),
                                ),
                              ],
                            ),
                          ));
                    },
                  );
                }
              },
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 240;
    final bloc = Provider.of<Bloc>(context);
    ancho = (width / 100) - 0.1;

    if (isFirstCharge) {
      isFirstCharge = false;
      initData(bloc, context);
    }
    return Container(
      /*     height: height, */
      width: width,
      color: myColor.bg_color1,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              DefaultTabController(
                  length: 5,
                  child: TabBar(
                    indicatorColor: myColor.email_color,
                    unselectedLabelColor: myColor.gray,
                    onTap: (value) {
                      _changeDocumentList(value, bloc, context);
                    },
                    labelColor: myColor.email_color,
                    tabs: [
                      Tab(
                        text: GlobleString.Tab_Document_property,
                        height: height * .05,
                      ),
                      Tab(
                        text: GlobleString.Tab_Document_tenants,
                        height: height * .05,
                      ),
                      Tab(
                        text: GlobleString.Tab_Document_onwers,
                        height: height * .05,
                      ),
                      Tab(
                        text: GlobleString.Tab_Document_vendors,
                        height: height * .05,
                      ),
                      Tab(
                        text: GlobleString.Tab_Document_other,
                        height: height * .05,
                      ),
                    ],
                  )),
              Container(
                  width: width,
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: myColor.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _searchRow(
                        width,
                        height,
                        bloc,
                        context,
                      ),
                      _breadcrumbs(bloc),
                      _getTableDocuments()
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
