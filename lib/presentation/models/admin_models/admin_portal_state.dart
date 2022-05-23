import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/common/globlestring.dart';

part 'admin_portal_state.freezed.dart';

@freezed
abstract class AdminPortalState with _$AdminPortalState {
  factory AdminPortalState({
    bool? isLoading,
    int? index,
    int? subindex,
    required String title,
    required bool isMenuDialogshow,
  }) = _AdminPortalState;

  factory AdminPortalState.initial() => AdminPortalState(
        isLoading: false,
        index: 0,
        subindex: 0,
        title: GlobleString.NAV_Overview,
        isMenuDialogshow: false,
      );
}
