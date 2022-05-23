import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/tenancy_employment_information.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'tf_employment_state.freezed.dart';

@freezed
abstract class TFEmploymentState with _$TFEmploymentState {
  const factory TFEmploymentState({
    required String othersourceincome,
    required String linkedprofile,
    required List<TenancyEmploymentInformation> listoccupation,
    SystemEnumDetails? empstatus,
    required List<SystemEnumDetails> empstatuslist,
    SystemEnumDetails? anualincomestatus,
    required List<SystemEnumDetails> anualincomelist,

//Final Value
    required String FNLothersourceincome,
    required String FNLlinkedprofile,
    required List<TenancyEmploymentInformation> FNLlistoccupation,
    SystemEnumDetails? FNLempstatus,
    required List<SystemEnumDetails> FNLempstatuslist,
    SystemEnumDetails? FNLanualincomestatus,
    required List<SystemEnumDetails> FNLanualincomelist,
    required bool isUpdate,
    required String EmploymentID,

    /*Error falg*/
    required bool error_linkedprofile,
    required bool error_empstatus,
    required bool error_anualincomestatus,
  }) = _TFEmploymentState;

  factory TFEmploymentState.initial() => TFEmploymentState(
        othersourceincome: "",
        linkedprofile: "",
        listoccupation: List.empty(),
        empstatus: null,
        empstatuslist: List.empty(),
        anualincomestatus: null,
        anualincomelist: List.empty(),
        FNLothersourceincome: "",
        FNLlinkedprofile: "",
        FNLlistoccupation: List.empty(),
        FNLempstatus: null,
        FNLempstatuslist: List.empty(),
        FNLanualincomestatus: null,
        FNLanualincomelist: List.empty(),
        isUpdate: false,
        EmploymentID: "",
        error_linkedprofile: false,
        error_empstatus: false,
        error_anualincomestatus: false,
      );
}
