import 'package:flutter/material.dart';
import 'package:silverhome/app.dart';
import 'package:silverhome/bloc/bloc.dart';
import 'package:silverhome/store/store.dart';
import 'package:provider/provider.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  initServiceLocator();
  //window.document.onContextMenu.listen((evt) => evt.preventDefault());
  runApp(Provider<Bloc>(create: (context) => Bloc(), dispose: (context, bloc) => bloc.dispose(), child: SilverApp()));
}
// flutter build web --no-sound-null-safety
