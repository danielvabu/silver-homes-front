import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/leadtenantdata.dart';

part 'admin_landlord_leads_state.freezed.dart';

@freezed
abstract class AdminLandlordLeadsState with _$AdminLandlordLeadsState {
  const factory AdminLandlordLeadsState({
    required bool isLeadIDSort,
    required int LeadIDSortAcsDes,
    required bool isLeadApplicantSort,
    required int LeadApplicantSortAcsDes,
    required bool isLeadEmailSort,
    required int LeadEmailSortAcsDes,
    required bool isLeadPhoneNoSort,
    required int LeadPhoneNoSortAcsDes,
    required bool isLeadRatingSort,
    required int LeadRatingSortAcsDes,
    required bool isLeadStatusSort,
    required int LeadStatusSortAcsDes,
    required bool isLeadLLnameSort,
    required int LeadLLnameSortAcsDes,
    required bool isLeadPropertyNameSort,
    required int LeadPropertyNameSortAcsDes,
    required String leadstenantSearchText,
    required List<LeadTenantData> leadstenantDatalist,
    required bool isloding,
    required int pageNo,
    required int totalpage,
    required int totalRecord,
  }) = _AdminLandlordLeadsState;

  factory AdminLandlordLeadsState.initial() => AdminLandlordLeadsState(
        isLeadIDSort: false,
        LeadIDSortAcsDes: 1,
        isLeadApplicantSort: false,
        LeadApplicantSortAcsDes: 1,
        isLeadEmailSort: false,
        LeadEmailSortAcsDes: 1,
        isLeadPhoneNoSort: false,
        LeadPhoneNoSortAcsDes: 1,
        isLeadRatingSort: false,
        LeadRatingSortAcsDes: 1,
        isLeadStatusSort: false,
        LeadStatusSortAcsDes: 1,
        isLeadLLnameSort: false,
        LeadLLnameSortAcsDes: 1,
        isLeadPropertyNameSort: false,
        LeadPropertyNameSortAcsDes: 1,
        leadstenantSearchText: "",
        leadstenantDatalist: List.empty(),
        isloding: false,
        pageNo: 1,
        totalpage: 0,
        totalRecord: 0,
      );
}
