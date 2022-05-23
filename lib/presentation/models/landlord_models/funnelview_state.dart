import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';

part 'funnelview_state.freezed.dart';

@freezed
class FunnelViewState with _$FunnelViewState {
  const factory FunnelViewState({
    int? lead_count,
    int? applicant_count,
    int? documentvarify_count,
    int? referencecheck_count,
    int? leasesent_count,
    int? activetenent_count,
    required List<TenancyApplication> alllistdata,
    required List<TenancyApplication> leadlist,
    required List<TenancyApplication> applicantlist,
    required List<TenancyApplication> documentvarifylist,
    required List<TenancyApplication> referencechecklist,
    required List<TenancyApplication> leasesentlist,
    required List<TenancyApplication> activetenantlist,
  }) = _FunnelViewState;

  factory FunnelViewState.initial() => FunnelViewState(
        lead_count: 0,
        applicant_count: 0,
        documentvarify_count: 0,
        referencecheck_count: 0,
        leasesent_count: 0,
        activetenent_count: 0,
        alllistdata: List.empty(),
        leadlist: List.empty(),
        applicantlist: List.empty(),
        documentvarifylist: List.empty(),
        referencechecklist: List.empty(),
        leasesentlist: List.empty(),
        activetenantlist: List.empty(),
      );
}
