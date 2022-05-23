import 'package:flutter/widgets.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';

// ConnectState is an embeddable widget allowing easy access to specific parts
// of the global state from anywhere within the widget tree.
class ConnectState<T> extends StatelessWidget {
  final T Function(AppState state) map;
  final bool Function(T prev, T next) where;
  final Widget Function(T? state) builder;

  final _store = getIt<AppStore>();

  ConnectState({
    Key? key,
    required this.map,
    required this.where,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: _store.state$
          .map(map)
          .distinct((T prev, T next) => !where(prev, next)),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        }

        return builder(snapshot.data);
      },
    );
  }
}
