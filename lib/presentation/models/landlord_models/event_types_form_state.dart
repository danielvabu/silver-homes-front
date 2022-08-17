import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_types_form_state.freezed.dart';

@freezed
abstract class EventTypesFormState with _$EventTypesFormState {
  const factory EventTypesFormState({
    required String eventtypes_address,
    required int selectView,
    required bool isValueUpdate,
  }) = _EventTypesFormState;

  factory EventTypesFormState.initial() => EventTypesFormState(
        eventtypes_address: "",
        selectView: 1,
        isValueUpdate: false,
      );
}
