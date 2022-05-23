import 'package:flutter/material.dart';
import 'package:silverhome/store/service_locator.dart';

import 'global_timer.dart';

mixin BasicPage<Page extends BasePage> on BaseState<Page> {
  var timer = getIt<GlobalTimer>();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (hover) => timer.checkAndUpdateTimer(context),
      child: rootWidget(context),
    );
  }

  Widget rootWidget(BuildContext context);
}

abstract class BasePage extends StatefulWidget {
  BasePage({Key? key}) : super(key: key);
}

abstract class BaseState<Page extends BasePage> extends State<Page> {}
