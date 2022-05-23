import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/tenancy_additional_info.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'tf_additonal_info_state.freezed.dart';

@freezed
abstract class TFAdditionalInfoState with _$TFAdditionalInfoState {
  const factory TFAdditionalInfoState({
    required List<Pets> petslist,
    required bool isPets,
    required List<Vehical> vehicallist,
    required bool isVehical,
    required bool isSmoking,
    required String Comment,
    DateTime? tenancystartdate,
    SystemEnumDetails? lenthoftenancy,
    required List<SystemEnumDetails> lenthoftenancylist,
    required List<SystemEnumDetails> Periodlist,
    SystemEnumDetails? PeriodValue,
    required String lenthoftenancynumber,

//final value
    required List<Pets> FNLpetslist,
    required bool FNLisPets,
    required List<Vehical> FNLvehicallist,
    required bool FNLisVehical,
    required bool FNLisSmoking,
    required String FNLComment,
    DateTime? FNLtenancystartdate,
    SystemEnumDetails? FNLlenthoftenancy,
    required List<SystemEnumDetails> FNLlenthoftenancylist,
    required List<SystemEnumDetails> FNLPeriodlist,
    SystemEnumDetails? FNLPeriodValue,
    required String FNLlenthoftenancynumber,
    required bool isUpdate,

    /*Error falg*/
    required bool error_tenancystartdate,
    required bool error_lenthoftenancynumber,
    required bool error_PeriodValue,
  }) = _TFAdditionalInfoState;

  factory TFAdditionalInfoState.initial() => TFAdditionalInfoState(
        petslist: List.empty(),
        isPets: false,
        vehicallist: List.empty(),
        isVehical: false,
        isSmoking: false,
        Comment: "",
        tenancystartdate: null,
        lenthoftenancy: null,
        lenthoftenancylist: List.empty(),
        Periodlist: List.empty(),
        PeriodValue: null,
        lenthoftenancynumber: "",
        FNLpetslist: List.empty(),
        FNLisPets: false,
        FNLvehicallist: List.empty(),
        FNLisVehical: false,
        FNLisSmoking: false,
        FNLComment: "",
        FNLtenancystartdate: null,
        FNLlenthoftenancy: null,
        FNLlenthoftenancylist: List.empty(),
        FNLPeriodlist: List.empty(),
        FNLPeriodValue: null,
        FNLlenthoftenancynumber: "",
        isUpdate: false,
        error_tenancystartdate: false,
        error_lenthoftenancynumber: false,
        error_PeriodValue: false,
      );
}
