import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/notificationdata.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateNotificationisIsLoadmore implements Action {
  final bool IsLoadmore;

  UpdateNotificationisIsLoadmore(this.IsLoadmore);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.notificationState(IsLoadmore: IsLoadmore);
  }
}

class UpdateNotificationList implements Action {
  final List<NotificationData> notificationlist;

  UpdateNotificationList(this.notificationlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .notificationState(notificationlist: notificationlist);
  }
}

class UpdateNotificationPageNo implements Action {
  final int PageNo;

  UpdateNotificationPageNo(this.PageNo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.notificationState(PageNo: PageNo);
  }
}
