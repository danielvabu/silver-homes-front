import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdatePropertyForm implements Action {
  final int index;

  UpdatePropertyForm(this.index);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyFormState(selectView: index);
  }
}

class UpdatePropertyFormAddress implements Action {
  final String title;

  UpdatePropertyFormAddress(this.title);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyFormState(property_address: title);
  }
}

class UpdatePropertyFormisValueUpdate implements Action {
  final bool isValueUpdate;

  UpdatePropertyFormisValueUpdate(this.isValueUpdate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyFormState(isValueUpdate: isValueUpdate);
  }
}
