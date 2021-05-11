import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Preferences/user_preferences.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_app/pages/marcadores_page.dart';
import 'package:flutter_app/Controllers/text_Editing_Controller.dart';
import 'package:flutter_app/pages/eventos_page.dart';

class MarcadoresController extends State<Marcadores> {
  TextoController cargarLista;
  final prefs = new PreferenciasUsuario();

  final resLocal = TextEditingController();
  final resVisitante = TextEditingController();
  String resultadoLocal, resultadoRival, ids;
  List events;

  updateResult() async {
    resultadoLocal = resLocal.text.toString();
    resultadoRival = resVisitante.text.toString();
    ids = widget.id;
    //events = (await cargarLista.downloadJSON());
    //print(events);
    final url =
        "http://172.20.101.245/test/resultado.php?resLocal=$resultadoLocal&resVisitante=$resultadoRival&id=$ids";
    final resp = await http.get(url);
    print(resp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MARCADORES",
          style: TextStyle(
              fontFamily: 'Arial', fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                columnWidths: {
                  0: FractionColumnWidth(0.4),
                  1: FractionColumnWidth(0.6),
                },
                children: [
                  TableRow(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 60.0),
                      child: Text(
                        "LOCAL",
                        style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 20,
                            letterSpacing: 1.3,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0, top: 42.0),
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: widget.local,
                            labelStyle: TextStyle(
                                color: Colors.grey[600], fontSize: 16)),
                      ),
                    ),
                  ]),
                  TableRow(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 70.0),
                      child: Text(
                        "VISITANTE",
                        style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 20,
                            letterSpacing: 1.3,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0, top: 50.0),
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black, width: 10.0)),
                            labelText: widget.visitante,
                            labelStyle: TextStyle(
                                color: Colors.grey[600], fontSize: 16)),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 90.0),
              child: Text(
                "RESULTADO",
                style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 25,
                    letterSpacing: 2.4,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Table(
              children: [
                TableRow(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, top: 42.0, right: 10),
                    child: TextField(
                      controller: resLocal,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 20.0)),
                        labelText: 'Local',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 1.0, top: 20.0, right: 10),
                        child: Icon(
                          Icons.minimize,
                          size: 60,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, top: 42.0),
                    child: TextField(
                      controller: resVisitante,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 10.0)),
                        labelText: 'Visitante',
                      ),
                    ),
                  ),
                ])
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 180.0, right: 20),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: () async {
                      updateResult();
                      //Navigator.pop(context);
                      List p = await downloadJSON(prefs.getGroupId);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CustomEventosLV(eventos: p)));
                    },
                    child: Icon(Icons.send),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<List<dynamic>> downloadJSON(groupId) async {
    final jsonEndpoint =
        "http://172.20.101.245/test/partidos.php?id=" + groupId;

    final resp = await http.get(jsonEndpoint);
    Map<String, dynamic> eventos = json.decode(resp.body);

    if (eventos['result'] == '200') {
      List<dynamic> datosEventos = json.decode(eventos['data'][0]);
      return datosEventos;
    } else {
      return [];
    }
    //List<Map<String, dynamic>> eventos = new List<Map<String, dynamic>>.from(json.decode(resp.body));
  }
}
