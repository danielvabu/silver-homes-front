import 'package:freezed_annotation/freezed_annotation.dart';

part 'landlordapplication_state.freezed.dart';

@freezed
abstract class LandLordApplicationState with _$LandLordApplicationState {
  const factory LandLordApplicationState({
    required int selecttab,
    required int leads_cout,
    required int applications_count,
    required int varfy_documents_count,
    required int references_check_count,
    required int leases_count,
    required int active_tenants_count,
  }) = _LandLordApplicationState;

  factory LandLordApplicationState.initial() => LandLordApplicationState(
        selecttab: 1,
        leads_cout: 0,
        applications_count: 0,
        varfy_documents_count: 0,
        references_check_count: 0,
        leases_count: 0,
        active_tenants_count: 0,
      );
}
