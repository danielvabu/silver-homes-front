import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/tenancy_additionaloccupants.dart';

part 'tf_additonal_occupant_state.freezed.dart';

@freezed
abstract class TFAdditionalOccupantState with _$TFAdditionalOccupantState {
  const factory TFAdditionalOccupantState({
    required List<TenancyAdditionalOccupant> occupantlist,
    required List<TenancyAdditionalOccupant> liveserveroccupantlist,
    required bool notapplicable,

    //final value
    required List<TenancyAdditionalOccupant> FNLoccupantlist,
    required List<TenancyAdditionalOccupant> FNLliveserveroccupantlist,
    required bool FNLnotapplicable,
    required bool isUpdate,
  }) = _TFAdditionalOccupantState;

  factory TFAdditionalOccupantState.initial() => TFAdditionalOccupantState(
        occupantlist: List.empty(),
        liveserveroccupantlist: List.empty(),
        notapplicable: false,
        FNLoccupantlist: List.empty(),
        FNLliveserveroccupantlist: List.empty(),
        FNLnotapplicable: false,
        isUpdate: false,
      );
}
