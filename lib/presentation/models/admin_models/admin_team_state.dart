import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/landlorddata.dart';

part 'admin_team_state.freezed.dart';

@freezed
abstract class AdminTeamState with _$AdminTeamState {
  const factory AdminTeamState({
    required bool isIDSort,
    required int IDSortAcsDes,
    required bool isNameSort,
    required int NameSortAcsDes,
    required bool isEmailSort,
    required int EmailSortAcsDes,
    required bool isPhoneSort,
    required int PhoneSortAcsDes,
    required bool isActiveSort,
    required int ActiveSortAcsDes,
    required String AdminTeamSearchText,
    required List<LandLordData> teamdatalist,
    required bool isloding,
    required int pageNo,
    required int totalpage,
    required int totalRecord,
  }) = _AdminTeamState;

  factory AdminTeamState.initial() => AdminTeamState(
        isIDSort: false,
        IDSortAcsDes: 1,
        isNameSort: false,
        NameSortAcsDes: 0,
        isEmailSort: false,
        EmailSortAcsDes: 0,
        isPhoneSort: false,
        PhoneSortAcsDes: 0,
        isActiveSort: false,
        ActiveSortAcsDes: 0,
        AdminTeamSearchText: "",
        teamdatalist: List.empty(),
        isloding: false,
        pageNo: 1,
        totalpage: 0,
        totalRecord: 0,
      );
}
