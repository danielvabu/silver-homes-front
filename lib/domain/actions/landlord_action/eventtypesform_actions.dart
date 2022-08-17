import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateEventTypesForm implements Action {
  final int index;

  UpdateEventTypesForm(this.index);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesFormState(selectView: index);
  }
}

class UpdateEventTypesFormAddress implements Action {
  final String title;

  UpdateEventTypesFormAddress(this.title);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesFormState(eventtypes_address: title);
  }
}

class UpdateEventTypesFormisValueUpdate implements Action {
  final bool isValueUpdate;

  UpdateEventTypesFormisValueUpdate(this.isValueUpdate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesFormState(isValueUpdate: isValueUpdate);
  }
}
