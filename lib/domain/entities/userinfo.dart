class UserInfo {
  UserInfo({
    this.roles,
    this.id,
    this.userId,
    this.userName,
    this.personId,
  });

  String? roles;
  int? id;
  String? userId;
  String? userName;
  int? personId;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        roles: json["Roles"] != null ? json["Roles"] : "",
        id: json["Roles"] != null ? json["ID"] : 0,
        userId: json["Roles"] != null ? json["UserID"] : "",
        userName: json["Roles"] != null ? json["UserName"] : "",
        personId: json["Roles"] != null ? json["PersonID"] : 0,
      );

  Map<String, dynamic> toJson() => {
        "Roles": roles,
        "ID": id,
        "UserID": userId,
        "UserName": userName,
        "PersonID": personId,
      };
}
