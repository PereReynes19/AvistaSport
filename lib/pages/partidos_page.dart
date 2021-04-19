import 'package:flutter/material.dart';

class Partidos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar (
        title: Text('PARTIDDOS', style: TextStyle(fontFamily: 'Arial', fontSize: 20, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blue,
      ),
    );
  }
}