import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/notificationdata.dart';

part 'notification_state.freezed.dart';

@freezed
abstract class NotificationState with _$NotificationState {
  factory NotificationState({
    required List<NotificationData> notificationlist,
    required int PageNo,
    required bool IsLoadmore,
  }) = _NotificationState;

  factory NotificationState.initial() => NotificationState(
        notificationlist: List.empty(),
        PageNo: 1,
        IsLoadmore: false,
      );
}
