import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/newlead.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateNewLeadProperty implements Action {
  final PropertyData? property;

  UpdateNewLeadProperty(this.property);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.newLeadState(propertyValue: property);
  }
}

class UpdateNewLeadPropertyList implements Action {
  final List<PropertyData> propertylist;

  UpdateNewLeadPropertyList(this.propertylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.newLeadState(propertylist: propertylist);
  }
}

class UpdateNewLeadNewLeadList implements Action {
  final List<NewLead> newleadlist;

  UpdateNewLeadNewLeadList(this.newleadlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.newLeadState(newleadlist: newleadlist);
  }
}

class UpdateNewLeadisreferesh implements Action {
  final String isreferesh;

  UpdateNewLeadisreferesh(this.isreferesh);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.newLeadState(isreferesh: isreferesh);
  }
}
