import 'package:flutter/material.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/pages/partidos_page.dart';

import 'Preferences/user_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

@override
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();

    prefs.initPrefs();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: prefs.getToken == '' ? Login() : Partidos(),
    );
  }
}
