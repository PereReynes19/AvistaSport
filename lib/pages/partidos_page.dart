import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Partidos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'PARTIDOS',
          style: TextStyle(
              fontFamily: 'Arial', fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: WillPopScope(
        onWillPop: () => _salirApp(),
        child: Container(),
      ),
    );
  }
}

_salirApp() {
  exit(0);
}
