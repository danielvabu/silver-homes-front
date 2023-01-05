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
import 'package:silverhome/presentation/models/teamMembers/teamMemberUserList.dart';
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
  TeamMemberService() {
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

  Future<TeamMemberUserListModel?> getTeamMembers(BuildContext context, String id, String search) async {
    Map data = {"created_by": id, "first_name": search};
    //encode Map to JSON
    var body = json.encode(data);
    //try {
    var response = await _client?.post(Uri.parse("https://qjif09kr99.execute-api.us-east-1.amazonaws.com/dev/team/fetch-team-members"),
        headers: getHeadersJson(), body: body);

    print("prueba1005: " + response!.body.toString());
    if (response!.statusCode == 200) {
      if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
        TeamMemberUserListModel data = teamMemberUserListModelFromJson(response.body);

        return data;
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
    // } catch (e) {
    // print("prueba1006: " + e.toString());
    // ToastUtils.showCustomToast(context, GlobleString.Error_server, false);
    // }
  }

  Future activeAndInactiveMembers(BuildContext context, String id, bool active) async {
    Map data = {"id": id, "is_enabled": active};
    //encode Map to JSON
    var body = json.encode(data);
    //try {
    var response = await _client?.post(Uri.parse("https://qjif09kr99.execute-api.us-east-1.amazonaws.com/dev/team/set-team-member-status"),
        headers: getHeadersJson(), body: body);

    print("prueba1010: " + response!.body.toString());
    if (response!.statusCode == 200) {
      if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
        // TeamMemberUserListModel data = teamMemberUserListModelFromJson(response.body);

        // return data;
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
  }
}
