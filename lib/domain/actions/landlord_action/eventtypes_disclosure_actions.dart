import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateAgreeTCPP implements Action {
  final bool agreeTCPP;

  UpdateAgreeTCPP(this.agreeTCPP);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(agree_TCPP: agreeTCPP);
  }
}
