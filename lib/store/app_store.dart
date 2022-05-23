import 'package:rxdart/rxdart.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/presentation/models/app_state.dart';

import '../domain/actions/actions.dart';

class AppStore {
  final BehaviorSubject<AppState> _stateSubject;

  AppStore(AppState initialState)
      : _stateSubject = BehaviorSubject.seeded(initialState);

  AppState? get state {
    return _stateSubject.value;
  }

  Stream<AppState> get state$ {
    return _stateSubject;
  }

  void dispatch(Action action) {
    //Helper.Log("Action", "${action.runtimeType}");
    _stateSubject.add(action.updateState(_stateSubject.value!));
  }
}
