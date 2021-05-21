import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Constructors/Eventos.dart';
import 'package:flutter_app/Preferences/user_preferences.dart';
import 'package:flutter_app/pages/login_page.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_app/pages/marcadores_page.dart';
import 'package:flutter_app/Controllers/text_Editing_Controller.dart';
import 'package:flutter_app/pages/eventos_page.dart';

class MarcadoresController extends State<Marcadores> {
  TextoController cargarLista;
  final prefs = new PreferenciasUsuario();

  static const logo = const Color.fromRGBO(0, 168, 45, 1);

  final resLocal = TextEditingController();
  final resVisitante = TextEditingController();
  final equipoLocal = TextEditingController();
  final equipoVisitante = TextEditingController();
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

  void handleClick(String value) async {
    switch (value) {
      case 'Cerrar Sesion':
        prefs.deletePrefs();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
        break;
      case 'Reset Marcadores':
        String resultadoCompleto = "";
        final url =
            "http://192.168.10.147/test/camaras.php?resultado=$resultadoCompleto&id=$ids";
        final resp = await http.get(url);
        List p = await downloadJSON(prefs.getGroupId, ids, true);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CustomEventosLV(eventos: p)));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: logo,
        title: Text(
          "MARCADORES",
          style: TextStyle(
              fontFamily: 'Arial', fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Cerrar Sesion', 'Reset Marcadores'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(columnWidths: {
                0: FractionColumnWidth(0.4),
                1: FractionColumnWidth(0.6),
              }, children: [
                TableRow(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                    child: Text(
                      "LOCAL:",
                      style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 20,
                          letterSpacing: 1.3,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, top: 22.0),
                    child: Text(widget.local,
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 17)),
                  ),
                ]),
              ]),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
              child: Table(
                children: [
                  TableRow(children: <Widget>[
                    TextField(
                      controller: equipoLocal,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 2.5,
                          fontWeight: FontWeight.bold),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^[a-zA-Z]{1,3}$')),
                      ],
                      decoration: InputDecoration(
                          labelStyle:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    ),
                  ]),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
              child: Table(columnWidths: {
                0: FractionColumnWidth(0.4),
                1: FractionColumnWidth(0.6),
              }, children: [
                TableRow(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                    child: Text(
                      "VISITANTE:",
                      style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 20,
                          letterSpacing: 1.3,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, top: 22.0),
                    child: Text(widget.visitante,
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 17)),
                  ),
                ]),
              ]),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
              child: Table(
                children: [
                  TableRow(children: <Widget>[
                    TextField(
                      controller: equipoVisitante,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 2.5,
                          fontWeight: FontWeight.bold),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^[a-zA-Z]{1,3}$')),
                      ],
                      decoration: InputDecoration(
                          labelStyle:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    ),
                  ]),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 75.0),
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
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    backgroundColor: logo,
                    onPressed: () async {
                      String resultadoCompleto = equipoLocal.text +
                          " " +
                          resLocal.text +
                          " - " +
                          resVisitante.text +
                          " " +
                          equipoVisitante.text;
                      updateResult();
                      updateCams(resultadoCompleto, ids);
                      List p = await downloadJSON(prefs.getGroupId, ids, true);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CustomEventosLV(eventos: p)));
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<List<dynamic>> downloadJSON(groupId, eventoId, bool ask) async {
    if (ask) {
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
    }
  }

  updateCams(String resultado, eventoId) async {
    print(resultado);
    print(eventoId);
    final url =
        "http://192.168.10.147/test/camaras.php?resultado=$resultado&id=$ids";
    final resp = await http.get(url);
  }
}
