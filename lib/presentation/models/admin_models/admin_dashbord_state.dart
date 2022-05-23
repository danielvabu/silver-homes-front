import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/admin_class/db_tenant_owner_data.dart';

part 'admin_dashbord_state.freezed.dart';

@freezed
abstract class AdminDashbordState with _$AdminDashbordState {
  const factory AdminDashbordState({
    required int totalProperty_cout,
    required int totalTenant_cout,
    required int totalProperty_owner_cout,
    required int totallease_signed_count,
    required List<DbTenantOwnerData> newJoineeOwnerList,
    required List<DbTenantOwnerData> todayTenantInviteList,
  }) = _AdminDashbordState;

  factory AdminDashbordState.initial() => AdminDashbordState(
        totalProperty_cout: 0,
        totalTenant_cout: 0,
        totalProperty_owner_cout: 0,
        totallease_signed_count: 0,
        newJoineeOwnerList: List.empty(),
        todayTenantInviteList: List.empty(),
      );
}
