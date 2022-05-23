import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_setting_state.freezed.dart';

@freezed
abstract class AdminSettingState with _$AdminSettingState {
  factory AdminSettingState({
    int? ID,
    bool? isloading,
    bool? isMaintenance,
    required String title,
    required String instruction,
  }) = _AdminSettingState;

  factory AdminSettingState.initial() => AdminSettingState(
        ID: 0,
        isloading: true,
        isMaintenance: false,
        title: "",
        instruction: "",
      );
}
