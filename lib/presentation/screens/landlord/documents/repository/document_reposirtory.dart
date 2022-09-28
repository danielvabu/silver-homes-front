import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:silverhome/bloc/bloc.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/document_list_screen_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/document_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/filter_document_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/request_change_restrict_document_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/request_create_folder_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/request_delete_document_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/request_duplicate_document_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/request_move_document_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/request_rename_document_model.dart';
import 'package:silverhome/presentation/screens/landlord/documents/model/request_restore_document_model.dart';
import 'package:silverhome/tablayer/httpclient.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:http_parser/src/media_type.dart';

class DocumentsService {
  http.Client? _client;
  DocumentsService() {
    _client = http.Client();
  }

  Map<String, String> getHeadersJson() {
    Prefs.init();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
    };
  }

  Map<String, String> getHeadersMultipart() {
    Prefs.init();
    return {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
    };
  }

/*  static var Create_Folder_Api = base_url + "documents/create/folder"; */
  Future<bool?> createFolder(
      BuildContext context, String folderName, String fatherUUID) async {
    try {
      final bloc = Provider.of<Bloc>(context);
      var response = await _client?.post(Uri.parse(Weburl.Create_Document_Api),
          headers: getHeadersJson(),
          body: RequestCreateFolder(fatherUUID: fatherUUID, name: folderName));

      if (response!.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          DocumentsListScreenModel? temporalDocumentList =
              await getDocumentListByUUID(context, fatherUUID,
                  bloc.documentBloc.currentDocumentTab.toLowerCase());
          bloc.documentBloc
              .changeDocumentFileList(temporalDocumentList!.folderContent!);
          bloc.documentBloc
              .changeDocumentBreadcumList(temporalDocumentList.breadcumbs!);
          bloc.documentBloc.currentFatherFolderUUID =
              temporalDocumentList.documentFatherUUID;
          return true;
        } else {
          ToastUtils.showCustomToast(context, GlobleString.Error, false);
          return false;
        }
      } else if (response.statusCode == 401) {
        ToastUtils.showCustomToast(context, GlobleString.Error_401, false);
        return false;
      } else {
        ToastUtils.showCustomToast(context, GlobleString.Error, false);
        return false;
      }
    } catch (e) {
      print(e);
      ToastUtils.showCustomToast(context, GlobleString.Error_server, false);
      return false;
    } finally {
      //CallBackQuesy(false, GlobleString.Error_server);
    }
  }

  /*   static var Restore_File_Api = base_url + "documents/restore"; */
  Future<bool?> restoreDocument(BuildContext context, String documentUUID,
      String documentFatherUUID) async {
    final bloc = Provider.of<Bloc>(context);
    try {
      var response = await _client?.post(Uri.parse(Weburl.Restore_Document_Api),
          headers: getHeadersJson(),
          body: RequestDuplicateDocument(
              documentUUID: documentUUID,
              documentFatherUUID: documentFatherUUID));

      if (response!.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          DocumentsListScreenModel? temporalDocumentList =
              await getDocumentListByUUID(context, documentFatherUUID,
                  bloc.documentBloc.currentDocumentTab.toLowerCase());
          bloc.documentBloc
              .changeDocumentFileList(temporalDocumentList!.folderContent!);
          bloc.documentBloc
              .changeDocumentBreadcumList(temporalDocumentList.breadcumbs!);
          bloc.documentBloc.currentFatherFolderUUID =
              temporalDocumentList.documentFatherUUID;
          return true;
        } else {
          ToastUtils.showCustomToast(context, GlobleString.Error, false);
          return false;
        }
      } else if (response.statusCode == 401) {
        ToastUtils.showCustomToast(context, GlobleString.Error_401, false);
        return false;
      } else {
        ToastUtils.showCustomToast(context, GlobleString.Error, false);
        return false;
      }
    } catch (e) {
      print(e);
      ToastUtils.showCustomToast(context, GlobleString.Error_server, false);
      return false;
    } finally {}
  }

  /* static var Rename_Api = base_url + "documents/remane"; */
  Future<bool?> renameDocument(BuildContext context, String documentUUID,
      String documentName, String documentFatherUUID) async {
    try {
      final bloc = Provider.of<Bloc>(context);
      var response = await _client?.post(Uri.parse(Weburl.Rename_Document_Api),
          headers: getHeadersJson(),
          body: RequestRenameDocument(
              documentUUID: documentUUID, name: documentName));

      if (response!.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          DocumentsListScreenModel? temporalDocumentList =
              await getDocumentListByUUID(context, documentFatherUUID,
                  bloc.documentBloc.currentDocumentTab.toLowerCase());
          bloc.documentBloc
              .changeDocumentFileList(temporalDocumentList!.folderContent!);
          bloc.documentBloc
              .changeDocumentBreadcumList(temporalDocumentList.breadcumbs!);
          bloc.documentBloc.currentFatherFolderUUID =
              temporalDocumentList.documentFatherUUID;
          return true;
        } else {
          ToastUtils.showCustomToast(context, GlobleString.Error, false);
          return false;
        }
      } else if (response.statusCode == 401) {
        ToastUtils.showCustomToast(context, GlobleString.Error_401, false);
        return false;
      } else {
        ToastUtils.showCustomToast(context, GlobleString.Error, false);
        return false;
      }
    } catch (e) {
      print(e);
      ToastUtils.showCustomToast(context, GlobleString.Error_server, false);
      return false;
    } finally {}
  }

  /*   static var Duplicate_File_Api = base_url + "documents/duplicate"; */
  Future<bool?> duplicateDocument(BuildContext context, String documentUUID,
      String documentFatherUUID) async {
    final bloc = Provider.of<Bloc>(context);
    try {
      var response = await _client?.post(
          Uri.parse(Weburl.Duplicate_Document_Api),
          headers: getHeadersJson(),
          body: RequestDuplicateDocument(
              documentUUID: documentUUID,
              documentFatherUUID: documentFatherUUID));

      if (response!.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          DocumentsListScreenModel? temporalDocumentList =
              await getDocumentListByUUID(context, documentFatherUUID,
                  bloc.documentBloc.currentDocumentTab.toLowerCase());
          bloc.documentBloc
              .changeDocumentFileList(temporalDocumentList!.folderContent!);
          bloc.documentBloc
              .changeDocumentBreadcumList(temporalDocumentList.breadcumbs!);
          bloc.documentBloc.currentFatherFolderUUID =
              temporalDocumentList.documentFatherUUID;
          return true;
        } else {
          ToastUtils.showCustomToast(context, GlobleString.Error, false);
          return false;
        }
      } else if (response.statusCode == 401) {
        ToastUtils.showCustomToast(context, GlobleString.Error_401, false);
        return false;
      } else {
        ToastUtils.showCustomToast(context, GlobleString.Error, false);
        return false;
      }
    } catch (e) {
      print(e);
      ToastUtils.showCustomToast(context, GlobleString.Error_server, false);
      return false;
    } finally {}
  }

  /*   static var Delete_Document_Api = base_url + "documents/delete"; */
  Future<bool?> deleteDocument(BuildContext context, String documentUUID,
      String documentFatherUUID) async {
    try {
      final bloc = Provider.of<Bloc>(context);
      var response =
          await _client?.delete(Uri.parse(Weburl.Delete_Document_Api),
              headers: getHeadersJson(),
              body: RequestDeleteDocument(
                documentUUID: documentUUID,
              ));

      if (response!.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          DocumentsListScreenModel? temporalDocumentList =
              await getDocumentListByUUID(context, documentFatherUUID,
                  bloc.documentBloc.currentDocumentTab.toLowerCase());

          bloc.documentBloc
              .changeDocumentFileList(temporalDocumentList!.folderContent!);
          bloc.documentBloc
              .changeDocumentBreadcumList(temporalDocumentList.breadcumbs!);
          bloc.documentBloc.currentFatherFolderUUID =
              temporalDocumentList.documentFatherUUID;
          return true;
        } else {
          ToastUtils.showCustomToast(context, GlobleString.Error, false);
          return false;
        }
      } else if (response.statusCode == 401) {
        ToastUtils.showCustomToast(context, GlobleString.Error_401, false);
        return false;
      } else {
        ToastUtils.showCustomToast(context, GlobleString.Error, false);
        return false;
      }
    } catch (e) {
      print(e);
      ToastUtils.showCustomToast(context, GlobleString.Error_server, false);
      return false;
    } finally {}
  }

  /*   static var Move_To_Folder_Api = base_url + "documents/move";*/
  Future<bool?> moveDocument(BuildContext context, String documentUUID,
      String fatherUUID, String newFatherUUID) async {
    final bloc = Provider.of<Bloc>(context);
    try {
      var response = await _client?.post(Uri.parse(Weburl.Move_Document_Api),
          headers: getHeadersJson(),
          body: RequestMoveDocument(
            documentUUID: documentUUID,
            fatherUUID: fatherUUID,
            newFatherUUID: newFatherUUID,
          ));

      if (response!.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          DocumentsListScreenModel? temporalDocumentList =
              await getDocumentListByUUID(context, newFatherUUID,
                  bloc.documentBloc.currentDocumentTab.toLowerCase());
          bloc.documentBloc
              .changeDocumentFileList(temporalDocumentList!.folderContent!);
          bloc.documentBloc
              .changeDocumentBreadcumList(temporalDocumentList.breadcumbs!);
          bloc.documentBloc.currentFatherFolderUUID =
              temporalDocumentList.documentFatherUUID;
          return true;
        } else {
          ToastUtils.showCustomToast(context, GlobleString.Error, false);
          return false;
        }
      } else if (response.statusCode == 401) {
        ToastUtils.showCustomToast(context, GlobleString.Error_401, false);
        return false;
      } else {
        ToastUtils.showCustomToast(context, GlobleString.Error, false);
        return false;
      }
    } catch (e) {
      print(e);
      ToastUtils.showCustomToast(context, GlobleString.Error_server, false);
      return false;
    } finally {}
  }

  /*  static var Upload_File_Api = base_url + "documents/upload"; */

  Future<DocumentModel?> uploadDocument(
      BuildContext context, Uint8List data, String extension) async {
    try {
      List<int> _selectedFile = data;
      final bloc = Provider.of<Bloc>(context);
      String filepath = '${DateTime.now().millisecondsSinceEpoch}.$extension';

      var multipartRequest = new http.MultipartRequest(
          "POST", Uri.parse(Weburl.Upload_Document_Api));

      multipartRequest.headers.addAll(getHeadersMultipart());

      multipartRequest.files.add(await http.MultipartFile.fromBytes(
          'file', _selectedFile,
          contentType: new MediaType('application', extension),
          filename: filepath));

      await multipartRequest.send().then((result) {
        //print('admin');
        if (result.statusCode == 200) {
          http.Response.fromStream(result).then((response) async {
            if (response.statusCode == 200) {
              if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
                DocumentsListScreenModel? temporalDocumentList =
                    await getDocumentListByUUID(
                        context,
                        bloc.documentBloc.currentFatherFolderUUID!,
                        bloc.documentBloc.currentDocumentTab.toLowerCase());
                bloc.documentBloc.changeDocumentFileList(
                    temporalDocumentList!.folderContent!);
                bloc.documentBloc.changeDocumentBreadcumList(
                    temporalDocumentList.breadcumbs!);
                bloc.documentBloc.currentFatherFolderUUID =
                    temporalDocumentList.documentFatherUUID;
                var data = jsonDecode(response.body);

                if (data != null && data['Result'] is Map<String, dynamic>) {
                  return DocumentModel.fromJson(data['Result']);
                } else {
                  ToastUtils.showCustomToast(
                      context, GlobleString.Error, false);
                  return null;
                }
              } else {
                ToastUtils.showCustomToast(context, GlobleString.Error, false);
                return null;
              }
            } else if (response.statusCode == 401) {
              ToastUtils.showCustomToast(
                  context, GlobleString.Error_401, false);
              return null;
            } else {
              ToastUtils.showCustomToast(context, GlobleString.Error, false);
              return null;
            }
          });
        } else if (result.statusCode == 401) {
          ToastUtils.showCustomToast(context, GlobleString.Error_401, false);
          return null;
        } else {
          ToastUtils.showCustomToast(context, GlobleString.Error, false);
          return null;
        }
      });
    } catch (e) {
      print(e);
      ToastUtils.showCustomToast(context, GlobleString.Error_server, false);
    } finally {
      //CallBackQuesy(false, GlobleString.Error_server);
    }
  }

  /*  static var Get_Filters_Api = base_url + "documents/filters"; */

  Future<List<FilterDocumentModel>?> getDocumentsFilter(
      BuildContext context, String type) async {
    try {
      var response = await _client?.get(
          Uri.parse(Weburl.Get_Document_Filters_Api + "/" + type),
          headers: getHeadersJson());
      if (response!.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          if (jsonDecode(response.body)['Result'] != null) {
            return jsonDecode(response.body)['Result']
                .map<FilterDocumentModel>(
                    (data) => FilterDocumentModel.fromJson(data))
                .toList();
          } else {
            ToastUtils.showCustomToast(context, GlobleString.Error, false);
            return null;
          }
        } else {
          ToastUtils.showCustomToast(context, GlobleString.Error, false);
          return null;
        }
      } else if (response.statusCode == 401) {
        ToastUtils.showCustomToast(context, GlobleString.Error_401, false);
        return null;
      } else {
        ToastUtils.showCustomToast(context, GlobleString.Error, false);
        return null;
      }
    } catch (e) {
      print(e);
      ToastUtils.showCustomToast(context, GlobleString.Error_server, false);
    }
  }

/*   static var Get_List_Documents = base_url + "documents/list"; */
  Future<DocumentsListScreenModel?> getDocumentListByUUID(
      BuildContext context, String folderUUID, String type,
      [String? search, String? filter]) async {
    try {
      var urlParams = Weburl.Get_Documents_List;
      urlParams = (search == "" || search == null)
          ? urlParams
          : urlParams + "search=$search";
      urlParams =
          (type == "" || type == null) ? urlParams : urlParams + "type=$type";

      var response =
          await _client?.get(Uri.parse(urlParams), headers: getHeadersJson());
      if (response!.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          return DocumentsListScreenModel.fromJson(
              jsonDecode(response.body)['Result']);
        } else {
          ToastUtils.showCustomToast(context, GlobleString.Error, false);
          return null;
        }
      } else if (response.statusCode == 401) {
        ToastUtils.showCustomToast(context, GlobleString.Error_401, false);
        return null;
      } else {
        ToastUtils.showCustomToast(context, GlobleString.Error, false);
        return null;
      }
    } catch (e) {
      print(e);
      ToastUtils.showCustomToast(context, GlobleString.Error_server, false);
    }
  }

  /*   static var Change_Restric_Api = base_url + "documents/restric";*/
  Future<bool?> changeRestrictEditing(BuildContext context, String documentUUID,
      bool newValue, String fatherUUID) async {
    final bloc = Provider.of<Bloc>(context);
    try {
      var response = await _client?.post(
          Uri.parse(Weburl.Change_Restrict_Editing),
          headers: getHeadersJson(),
          body: RequestChangeRestrictDocument(
              documentUUID: documentUUID, isRestricted: newValue));

      if (response!.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          DocumentsListScreenModel? temporalDocumentList =
              await getDocumentListByUUID(
                  context,
                  bloc.documentBloc.currentFatherFolderUUID!,
                  bloc.documentBloc.currentDocumentTab.toLowerCase());
          bloc.documentBloc
              .changeDocumentFileList(temporalDocumentList!.folderContent!);
          bloc.documentBloc.currentFatherFolderUUID =
              temporalDocumentList.documentFatherUUID;
          return true;
        } else {
          ToastUtils.showCustomToast(context, GlobleString.Error, false);
          return false;
        }
      } else if (response.statusCode == 401) {
        ToastUtils.showCustomToast(context, GlobleString.Error_401, false);
        return false;
      } else {
        ToastUtils.showCustomToast(context, GlobleString.Error, false);
        return false;
      }
    } catch (e) {
      print(e);
      ToastUtils.showCustomToast(context, GlobleString.Error_server, false);
      return false;
    } finally {}
  }
}
