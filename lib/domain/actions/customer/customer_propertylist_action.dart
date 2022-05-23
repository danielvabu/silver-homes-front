import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateCustomer_propertylist implements Action {
  final List<PropertyData> propertylist;

  UpdateCustomer_propertylist(this.propertylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertylistState(propertylist: propertylist);
  }
}
