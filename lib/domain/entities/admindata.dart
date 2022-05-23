class AdminData {
  String? id;
  String? name;
  String? email;
  String? phoneno;
  String? ofproperty;
  bool? activeInactive;

  AdminData({
    this.id,
    this.name,
    this.email,
    this.phoneno,
    this.ofproperty,
    this.activeInactive,
  });

  factory AdminData.fromJson(Map<String, dynamic> json) => AdminData(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phoneno: json["phoneno"],
        ofproperty: json["ofproperty"],
        activeInactive: json["activeInactive"],
      );

  Map toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phoneno": phoneno,
        "ofproperty": ofproperty,
        "activeInactive": activeInactive,
      };
}
