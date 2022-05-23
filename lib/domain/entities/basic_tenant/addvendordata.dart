import 'package:silverhome/domain/entities/vendordata.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

import '../vendordata.dart';

class AddVendorData {
  String? id;
  String? Instruction;
  List<VendorData>? filtervendordatalist = [];
  VendorData? selectvendor;
  SystemEnumDetails? selectfilterCategory;

  AddVendorData({
    this.id,
    this.Instruction,
    this.filtervendordatalist,
    this.selectvendor,
    this.selectfilterCategory,
  });

  factory AddVendorData.fromJson(Map<String, dynamic> json) => AddVendorData(
        id: json["id"] != null ? json["id"] : 0,
        Instruction: json["Instruction"] != null ? json["Instruction"] : false,
        selectvendor: VendorData.fromJson(json["selectvendor"]),
        selectfilterCategory:
            SystemEnumDetails.fromJson(json["selectfilterCategorylist"]),
        filtervendordatalist: List<VendorData>.from(
            json["filtervendordatalist"].map((x) => VendorData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Instruction": Instruction,
        "selectvendor": selectvendor,
        "selectfilterCategory": selectfilterCategory,
        'filtervendordatalist': filtervendordatalist,
      };
}
