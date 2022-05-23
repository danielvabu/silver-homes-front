import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/lead_reference.dart';

part 'reference_check_dialog_state.freezed.dart';

@freezed
abstract class ReferenceCheckDialogState with _$ReferenceCheckDialogState {
  const factory ReferenceCheckDialogState({
    required List<LeadReference> leadReferencelist,
    required bool isAllCheck,
  }) = _ReferenceCheckDialogState;

  factory ReferenceCheckDialogState.initial() => ReferenceCheckDialogState(
        leadReferencelist: List.empty(),
        isAllCheck: false,
      );
}
