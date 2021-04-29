import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_app/Preferences/user_preferences.dart';
import 'package:flutter_app/pages/login_page.dart';

class Partidos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'PARTIDOS',
          style: TextStyle(
              fontFamily: 'Arial', fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              PreferenciasUsuario pref = new PreferenciasUsuario();
              pref.deletePrefs();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
            child: Icon(
              Icons.logout,
              size: 30,
            ),
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: WillPopScope(
        onWillPop: () => exit(0),
        child: Container(),
      ),
    );
  }
}
