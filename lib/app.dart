import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/themes.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'common/sharedpref.dart';

class SilverApp extends StatefulWidget {
  @override
  _SilverAppState createState() => _SilverAppState();
}

class _SilverAppState extends State<SilverApp> {
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized()
        .addPostFrameCallback((timeStamp) async {
      await Prefs.init();
    });
  }

  //flutter run -d chrome --web-port=8181 --no-sound-null-safety

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: GlobleString.App_Name,
      debugShowCheckedModeBanner: false,
      theme: defaultTheme,
      supportedLocales: [Locale('en')],
      localizationsDelegates: [CountryLocalizations.delegate],
      initialRoute: RouteNames.splashScreen,
      routes: RouteNames.routes,
      onGenerateRoute: RouteNames.generateRoute,
    );
  }
}
