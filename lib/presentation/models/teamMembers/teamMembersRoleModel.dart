// To parse this JSON data, do
//
//     final teamMembersModel = teamMembersModelFromJson(jsonString);

import 'dart:convert';

TeamMembersModel teamMembersModelFromJson(var str) => TeamMembersModel.fromJson(str);

String teamMembersModelToJson(TeamMembersModel data) => json.encode(data.toJson());

class TeamMembersModel {
  TeamMembersModel({
    this.teamMembers,
  });

  List<TeamMember>? teamMembers;

  factory TeamMembersModel.fromJson(Map<String, dynamic> json) => TeamMembersModel(
        teamMembers: List<TeamMember>.from(json["team_members"].map((x) => TeamMember.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "team_members": List<dynamic>.from(teamMembers!.map((x) => x.toJson())),
      };
}

class TeamMember {
  TeamMember({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.role,
    this.activatedAt,
    this.lastLoggedIn,
    this.isEnabled,
  });

  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? role;
  String? activatedAt;
  String? lastLoggedIn;
  bool? isEnabled;

  factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        role: json["role"],
        activatedAt: json["activated_at"],
        lastLoggedIn: json["last_logged_in"],
        isEnabled: json["is_enabled"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "role": role,
        "activated_at": activatedAt,
        "last_logged_in": lastLoggedIn,
        "is_enabled": isEnabled,
      };
}
