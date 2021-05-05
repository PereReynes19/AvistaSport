import 'package:flutter/material.dart';
import 'package:flutter_app/Controllers/text_Editing_Controller.dart';
import 'package:flutter_app/pages/eventos_page.dart';

import 'package:flutter_app/pages/login_page.dart';

import 'Preferences/user_preferences.dart';

String initialRoute = '';
List eventos;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new PreferenciasUsuario();
  final lista = new TextoController();

  await prefs.initPrefs();

  eventos = await lista.downloadJSON();

  if (prefs.getToken == '') {
    initialRoute = Login.routeName;
  } else {
    initialRoute = CustomEventosLV.routeName;
  }
  runApp(MyApp());
}

@override
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        Login.routeName: (BuildContext context) => Login(),
        CustomEventosLV.routeName: (BuildContext context) =>
            CustomEventosLV(eventos: eventos)
      },
    );
  }
}
