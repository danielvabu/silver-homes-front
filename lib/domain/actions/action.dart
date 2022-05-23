import 'package:silverhome/presentation/models/app_state.dart';

abstract class Action {
  AppState updateState(AppState appState);
}
