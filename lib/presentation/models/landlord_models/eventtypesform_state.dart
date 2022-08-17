import 'package:freezed_annotation/freezed_annotation.dart';

part 'eventtypesform_state.freezed.dart';

@freezed
abstract class EventtypesFormState with _$EventtypesFormState {
  const factory EventtypesFormState({
    required String property_address,
    required int selectView,
    required bool isValueUpdate,
  }) = _EventtypesFormState;

  factory EventtypesFormState.initial() => EventtypesFormState(
        property_address: "",
        selectView: 1,
        isValueUpdate: false,
      );
}
