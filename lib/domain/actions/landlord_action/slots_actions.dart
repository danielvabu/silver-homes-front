import 'package:silverhome/domain/entities/event_typesdata.dart';
import 'package:silverhome/domain/entities/slots.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/domain/actions/action.dart';

class UpdateSlots implements Action {
  final List<Slots> eventType;

  UpdateSlots(this.eventType);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.slotsListState(eventtypeslist: eventType);
  }
}
