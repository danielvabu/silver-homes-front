import 'package:get_it/get_it.dart';
import 'package:silverhome/common/global_timer.dart';
import 'package:silverhome/common/navigation_notifier.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/store/app_store.dart';

GetIt getIt = GetIt.instance;
NavigationNotifier navigationNotifier = NavigationNotifier();
void initServiceLocator() async {
  getIt.registerSingleton<AppStore>(AppStore(AppState.initial()));
  getIt.registerSingleton<GlobalTimer>(GlobalTimer());
}
