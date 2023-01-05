// To parse this JSON data, do
//
//     final teamMemberUserListModel = teamMemberUserListModelFromJson(jsonString);

import 'dart:convert';

TeamMemberUserListModel teamMemberUserListModelFromJson(String str) => TeamMemberUserListModel.fromJson(json.decode(str));

String teamMemberUserListModelToJson(TeamMemberUserListModel data) => json.encode(data.toJson());

class TeamMemberUserListModel {
  TeamMemberUserListModel({
    this.statusCode,
    this.recordAffectted,
    this.totalRecords,
    this.totalExecutionTime,
    this.log,
    this.errors,
    this.data,
  });

  String? statusCode;
  int? recordAffectted;
  int? totalRecords;
  int? totalExecutionTime;
  List<dynamic>? log;
  List<dynamic>? errors;
  List<DatumTeamUser>? data;

  factory TeamMemberUserListModel.fromJson(Map<String, dynamic> json) => TeamMemberUserListModel(
        statusCode: json["StatusCode"],
        recordAffectted: json["RecordAffectted"],
        totalRecords: json["TotalRecords"],
        totalExecutionTime: json["TotalExecutionTime"],
        log: List<dynamic>.from(json["Log"].map((x) => x)),
        errors: List<dynamic>.from(json["Errors"].map((x) => x)),
        data: List<DatumTeamUser>.from(json["data"].map((x) => DatumTeamUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "StatusCode": statusCode,
        "RecordAffectted": recordAffectted,
        "TotalRecords": totalRecords,
        "TotalExecutionTime": totalExecutionTime,
        "Log": List<dynamic>.from(log!.map((x) => x)),
        "Errors": List<dynamic>.from(errors!.map((x) => x)),
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DatumTeamUser {
  DatumTeamUser({
    this.id,
    this.createdBy,
    this.userId,
    this.loginUserId,
    this.personId,
    this.firstName,
    this.lastName,
    this.email,
    this.roleName,
    this.roleId,
    this.activatedAt,
    this.lastLoggedIn,
    this.isEnabled,
  });

  int? id;
  int? createdBy;
  int? userId;
  String? loginUserId;
  int? personId;
  String? firstName;
  String? lastName;
  String? email;
  String? roleName;
  int? roleId;
  dynamic? activatedAt;
  dynamic? lastLoggedIn;
  bool? isEnabled;

  factory DatumTeamUser.fromJson(Map<String, dynamic> json) => DatumTeamUser(
        id: json["id"],
        createdBy: json["created_by"],
        userId: json["user_id"],
        loginUserId: json["login_user_id"],
        personId: json["person_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        roleName: json["role_name"],
        roleId: json["role_id"],
        activatedAt: json["activated_at"],
        lastLoggedIn: json["last_logged_in"],
        isEnabled: json["is_enabled"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_by": createdBy,
        "user_id": userId,
        "login_user_id": loginUserId,
        "person_id": personId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "role_name": roleName,
        "role_id": roleId,
        "activated_at": activatedAt,
        "last_logged_in": lastLoggedIn,
        "is_enabled": isEnabled,
      };
}
