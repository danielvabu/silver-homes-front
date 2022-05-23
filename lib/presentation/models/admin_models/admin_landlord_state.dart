import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/landlorddata.dart';

part 'admin_landlord_state.freezed.dart';

@freezed
abstract class AdminLandlordState with _$AdminLandlordState {
  const factory AdminLandlordState({
    required bool isIDSort,
    required int IDSortAcsDes,
    required bool isNameSort,
    required int NameSortAcsDes,
    required bool isEmailSort,
    required int EmailSortAcsDes,
    required bool isPhoneSort,
    required int PhoneSortAcsDes,
    required bool isPropertySort,
    required int PropertySortAcsDes,
    required bool isActiveSort,
    required int ActiveSortAcsDes,
    required String LandlordSearchText,
    required List<LandLordData> landlorddatalist,
    required bool isloding,
    required int pageNo,
    required int totalpage,
    required int totalRecord,
  }) = _AdminLandlordState;

  factory AdminLandlordState.initial() => AdminLandlordState(
        isIDSort: false,
        IDSortAcsDes: 1,
        isNameSort: false,
        NameSortAcsDes: 0,
        isEmailSort: false,
        EmailSortAcsDes: 0,
        isPhoneSort: false,
        PhoneSortAcsDes: 0,
        isPropertySort: false,
        PropertySortAcsDes: 0,
        isActiveSort: false,
        ActiveSortAcsDes: 0,
        LandlordSearchText: "",
        landlorddatalist: List.empty(),
        isloding: false,
        pageNo: 1,
        totalpage: 0,
        totalRecord: 0,
      );
}
