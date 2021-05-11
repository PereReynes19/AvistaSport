import 'package:flutter/material.dart';

import 'package:flutter_app/Controllers/marcadoresController.dart';

class Marcadores extends StatefulWidget {
  final String local;
  final String visitante;
  final String id;

  Marcadores({Key key, this.local, this.visitante, this.id}) : super(key: key);
  @override
  MarcadoresController createState() => MarcadoresController();
}
