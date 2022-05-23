import 'package:flutter/material.dart';
import 'package:silverhome/app.dart';
import 'package:silverhome/store/store.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  initServiceLocator();
  //window.document.onContextMenu.listen((evt) => evt.preventDefault());
  runApp(SilverApp());
}
// flutter build web --no-sound-null-safety