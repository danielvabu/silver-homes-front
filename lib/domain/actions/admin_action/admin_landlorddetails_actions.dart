import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateLandlordDetailsTab implements Action {
  final int index;

  UpdateLandlordDetailsTab(this.index);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordDetailsState(selecttab: index);
  }
}
