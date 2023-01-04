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
import 'package:silverhome/presentation/models/teamMembers/teamMembersRoleModel.dart';
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

class TeamMemberService {
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

  Future<List<TeamMembersModel>?> getTeamMembersFilter(BuildContext context, String type) async {
    try {
      var response = await _client?.get(Uri.parse(Weburl.Teams_members_Api + "/" + type), headers: getHeadersJson());
      if (response!.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          if (jsonDecode(response.body)['Result'] != null) {
            return jsonDecode(response.body)['Result'].map<TeamMembersModel>((data) => TeamMembersModel.fromJson(data)).toList();
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

  Future<List<TeamMembersModel>?> getTeamMembers(BuildContext context, String type) async {
    try {
      var response = await _client?.get(Uri.parse(Weburl.Teams_members_Api + "/" + type), headers: getHeadersJson());
      if (response!.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          if (jsonDecode(response.body)['Result'] != null) {
            return jsonDecode(response.body)['Result'].map<TeamMembersModel>((data) => TeamMembersModel.fromJson(data)).toList();
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
}
