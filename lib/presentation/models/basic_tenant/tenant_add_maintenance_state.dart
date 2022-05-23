import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/fileobject.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'tenant_add_maintenance_state.freezed.dart';

@freezed
abstract class TenantAddMaintenanceState with _$TenantAddMaintenanceState {
  factory TenantAddMaintenanceState({
    required String mid,
    required int Type_User,
    required bool IsLock,
    SystemEnumDetails? selectStatus,
    required List<SystemEnumDetails> MaintenanceCategorylist,
    SystemEnumDetails? selectCategory,
    required String requestName,
    required int priority,
    required String description,
    required List<FileObject> fileobjectlist,
  }) = _TenantAddMaintenanceState;

  factory TenantAddMaintenanceState.initial() => TenantAddMaintenanceState(
        mid: "",
        Type_User: 0,
        IsLock: false,
        selectStatus: null,
        MaintenanceCategorylist: List.empty(),
        selectCategory: null,
        requestName: "",
        priority: 0,
        description: "",
        fileobjectlist: List.empty(),
      );
}
