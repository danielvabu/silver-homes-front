import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/propertydata.dart';

part 'editlead_state.freezed.dart';

@freezed
abstract class EditLeadState with _$EditLeadState {
  const factory EditLeadState({
    required List<PropertyData> propertylist,
    PropertyData? propertyValue,
    String? applicationid,
    String? applicantid,
    String? PersionId,
    String? firstname,
    String? lastname,
    String? phoneNumber,
    String? Email,
    String? Lead_occupant,
    String? Lead_children,
    String? PrivateNotes,
    String? CountryCode,
    String? CountrydialCode,
  }) = _EditLeadState;

  factory EditLeadState.initial() => EditLeadState(
        propertylist: List.empty(),
        propertyValue: null,
        applicationid: "",
        applicantid: "",
        PersionId: "",
        firstname: "",
        lastname: "",
        phoneNumber: "",
        Email: "",
        Lead_occupant: "",
        Lead_children: "",
        PrivateNotes: "",
        CountryCode: "CA",
        CountrydialCode: "+1",
      );
}
