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
import 'package:silverhome/common/prefsname.dart';

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
  Future<bool?> createFolder(BuildContext context, String folderName,
      String fatherUUID, String currenTab,
      [String propertyUUID = ""]) async {
    try {
      /*     */
      var response = await _client?.post(
          Uri.parse(
              /* Weburl.Create_Document_Api */ "https://api.ren-hogar.com/documentsnewfolder"),
          headers: getHeadersJson(),
          body: jsonEncode(RequestCreateFolder(
                  fatherUUID: fatherUUID,
                  name: folderName,
                  ownerUUID: Prefs.getString(PrefsName.OwnerID),
                  propertyUUID: propertyUUID,
                  type: currenTab.toUpperCase())
              .toJson()));

      if (response!.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
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
    try {
      var response = await _client?.post(
          Uri.parse(
              "https://api.ren-hogar.com/documentsrestore" /* Weburl.Restore_Document_Api */),
          headers: getHeadersJson(),
          body: jsonEncode(RequestRestoreDocument(
                  documentUUID: documentUUID,
                  documentFatherUUID: documentFatherUUID)
              .toJson()));

      if (response!.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
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
      var response = await _client?.post(
          Uri.parse(
              /* Weburl.Rename_Document_Api */ "https://api.ren-hogar.com/documentsrename"),
          headers: getHeadersJson(),
          body: jsonEncode(RequestRenameDocument(
                  documentUUID: documentUUID, name: documentName)
              .toJson()));

      if (response!.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
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
    try {
      var response = await _client?.post(
          Uri.parse(
              /* Weburl.Duplicate_Document_Api */ "https://www.ren-hogar.com/documentsduplicate/"),
          headers: getHeadersJson(),
          body: jsonEncode(RequestDuplicateDocument(
                  documentUUID: documentUUID,
                  documentFatherUUID: documentFatherUUID)
              .toJson()));

      if (response!.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
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
      var response = await _client?.post(
          Uri.parse(
              /* Weburl.Delete_Document_Api */ "https://api.ren-hogar.com/documentsdelete"),
          headers: getHeadersJson(),
          body: jsonEncode(RequestDeleteDocument(
            documentUUID: documentUUID,
          ).toJson()));

      if (response!.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
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
    try {
      var response = await _client?.post(
          Uri.parse(
              /* Weburl.Move_Document_Api */ "https://api.ren-hogar.com/documentsmove"),
          headers: getHeadersJson(),
          body: jsonEncode(RequestMoveDocument(
            documentUUID: documentUUID,
            fatherUUID: fatherUUID,
            newFatherUUID: newFatherUUID,
          ).toJson()));

      if (response!.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
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
      BuildContext context,
      Uint8List data,
      String extension,
      String type,
      String propertyId,
      String fatherId,
      String name) async {
    try {
      List<int> _selectedFile = data;

      String filepath = '$name.$extension';

      var multipartRequest = new http.MultipartRequest(
          "POST",
          Uri.parse(
              /* Weburl.Upload_Document_Api */ "https://www.ren-hogar.com/documentupload/"));

      multipartRequest.headers.addAll(getHeadersMultipart());
      multipartRequest.fields["property_id"] = propertyId;
      multipartRequest.fields["father_id"] = fatherId;
      multipartRequest.fields["type"] = type;
      multipartRequest.fields["owner_id"] = Prefs.getString(PrefsName.OwnerID);
      multipartRequest.fields["name"] = name;
      multipartRequest.files.add(await http.MultipartFile.fromBytes(
          'file', _selectedFile,
          contentType: new MediaType('application', extension),
          filename: filepath));

      await multipartRequest.send().then((result) {
        //print('admin');
        if (result.statusCode == 200) {
          print(result);
          http.Response.fromStream(result).then((response) async {
            if (response.statusCode == 200) {
              print(jsonDecode(response.body));
              print("result");
              if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
                var data = jsonDecode(response.body);

                if (data != null && data['Result'] != null) {
                  return DocumentModel.fromJson(data['Result'][0]);
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
      [String search = "", String? filter = ""]) async {
    try {
      /*    var urlParams = Weburl.Get_Documents_List;=
      urlParams = (search == "" || search == null)
          ? urlParams
          : urlParams + "search=$search";
      urlParams =
          (type == "" || type == null) ? urlParams : urlParams + "type=$type";
 */
      var response = await _client?.post(
          Uri.parse("https://api.ren-hogar.com/documentslist"),
          headers: getHeadersJson(),
          body: jsonEncode({
            "type": type.toUpperCase(),
            "owner_id": Prefs.getString(PrefsName.OwnerID),
            "search": search,
            "property_id": filter,
            "father_id": folderUUID
          }));
      if (response!.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          return DocumentsListScreenModel.fromJson(jsonDecode(response.body));
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
    try {
      var response = await _client?.post(
          Uri.parse(
              /*Weburl.Change_Restrict_Editing */ "https://api.ren-hogar.com/documentsrestrict"),
          headers: getHeadersJson(),
          body: jsonEncode(RequestChangeRestrictDocument(
                  documentUUID: documentUUID, isRestricted: newValue)
              .toJson()));

      if (response!.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
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
