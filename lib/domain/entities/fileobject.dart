import 'dart:typed_data';

import 'package:silverhome/tablayer/tablePOJO.dart';

class FileObject {
  Uint8List? appImage;
  String? filename;
  bool? islocal;
  MediaInfo? mediaId;
  int? id;

  FileObject({
    this.appImage,
    this.filename,
    this.islocal,
    this.mediaId,
    this.id,
  });

  factory FileObject.fromJson(Map<String, dynamic> json) => FileObject(
        appImage: json["appImage"] != null ? json["appImage"] : null,
        filename: json["filename"] != null ? json["filename"] : "",
        islocal: json["islocal"] != null ? json["islocal"] : false,
        mediaId: json["Media_ID"] != null
            ? MediaInfo.fromJson(json["Media_ID"])
            : null,
        id: json["ID"] != null ? json["ID"] : 0,
      );

  Map toJson() => {
        "appImage": appImage,
        "filename": filename,
        "islocal": islocal,
        "Media_ID": mediaId!.toJson(),
        "ID": id,
      };
}
