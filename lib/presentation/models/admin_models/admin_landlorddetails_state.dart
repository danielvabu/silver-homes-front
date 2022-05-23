import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_landlorddetails_state.freezed.dart';

@freezed
abstract class AdminLandlordDetailsState with _$AdminLandlordDetailsState {
  const factory AdminLandlordDetailsState({
    required int selecttab,
  }) = _AdminLandlordDetailsState;

  factory AdminLandlordDetailsState.initial() => AdminLandlordDetailsState(
        selecttab: 1,
      );
}
