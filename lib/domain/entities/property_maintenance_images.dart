import 'package:silverhome/tablayer/tablePOJO.dart';

class PropertyMaintenanceImages {
  PropertyMaintenanceImages({
    this.mediaId,
    this.id,
  });

  MediaInfo? mediaId;
  int? id;

  factory PropertyMaintenanceImages.fromJson(Map<String, dynamic> json) =>
      PropertyMaintenanceImages(
        mediaId: json["Media_ID"] != null
            ? MediaInfo.fromJson(json["Media_ID"])
            : null,
        id: json["ID"] != null ? json["ID"] : 0,
      );

  Map<String, dynamic> toJson() => {
        "Media_ID": mediaId!.toJson(),
        "ID": id,
      };
}
