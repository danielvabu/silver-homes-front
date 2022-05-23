import 'package:freezed_annotation/freezed_annotation.dart';

part 'propertyform_state.freezed.dart';

@freezed
abstract class PropertyFormState with _$PropertyFormState {
  const factory PropertyFormState({
    required String property_address,
    required int selectView,
    required bool isValueUpdate,
  }) = _PropertyFormState;

  factory PropertyFormState.initial() => PropertyFormState(
        property_address: "",
        selectView: 1,
        isValueUpdate: false,
      );
}
