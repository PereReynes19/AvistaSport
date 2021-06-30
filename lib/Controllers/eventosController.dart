import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/pages/eventos_page.dart';
import 'package:flutter_app/Preferences/user_preferences.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/pages/partidos_page.dart';
import 'package:flutter_app/pages/pestanya_page.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_app/pages/marcadores_page.dart';

class CustomEventosLV extends State<Eventos> {
  final prefs = new PreferenciasUsuario();
  List eventos;
  String ids;
  bool todosPartidos = true;
  static const logo = const Color.fromRGBO(255, 96, 78, 1);

  CustomEventosLV({this.eventos});

  void handleClick(String value) async {
    ids = widget.id;
    //métode per realitzar unes de les opcions dels 3 puntets de l'appbar
    switch (value) {
      case 'Cerrar Sesion': //tanca sessió i te redirigeix a la pantalla de login
        prefs.deletePrefs();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
        break;
      case 'Partidos Anteriores': //et reseteja els marcadors i ho envia per GET al controlador
        todosPartidos = false;
        List p = await downloadJSON(prefs.getGroupId, ids, todosPartidos);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Pestanya(
                      eventos: p,
                    )));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (eventos.isNotEmpty && eventos != null) {
      String deportes = '${eventos[0]}';
      var deportesSplit = deportes.split(",");
      var deport = deportesSplit[1].split(":");
      print(deport[1]);

      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(deport[1].toString().toUpperCase(),
              style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Partidos Anteriores', 'Cerrar Sesion'}
                    .map((String choice) {
                  var popupMenuItem = PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );

                  return popupMenuItem;
                }).toList();
              },
            ),
            PopupMenuItem(
                child: Divider(
              thickness: 2.0,
              color: Colors.black,
            ))
          ],
          backgroundColor: logo,
        ),
        body: WillPopScope(
          onWillPop: () => exit(0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: eventos.length,
            itemBuilder: (context, int currentIndex) {
              return createViewItem(eventos[currentIndex], context);
            },
          ),
        ),
      );
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Partidos()));
    }
  }

  Widget createViewItem(events, BuildContext context) {
    String local = "${events['Local']}";
    var localSplit;

    if (local.contains("20/21")) {
      localSplit = local.split("20/21");
      localSplit = localSplit[1];
    } else {
      localSplit = local;
    }

    return SizedBox(
      child: Container(
        color: Colors.white24,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: GestureDetector(
                  child: Card(
                    elevation: 6.0,
                    margin: EdgeInsets.all(10.0),
                    shadowColor: Colors.grey,
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0, left: 15.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: RichText(
                              maxLines: 1,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: deleteSport(localSplit +
                                          ' -  ${events['Visitante']} ')),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, left: 15.0, right: 15.0, bottom: 15.0),
                          child: Table(
                            children: [
                              TableRow(children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        color: Colors.black,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Fecha: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(text: '${events['Fecha']}'),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        color: Colors.black,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Resultado: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                            text: '${events['Resultado']} '),
                                      ],
                                    ),
                                  ),
                                )
                              ])
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    //una vegada pitges sobre una Card et redirigeix a la vista Marcadors
                    print('${events['Id']}');
                    if (events['Id'] != "-1") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Marcadores(
                                  local: deleteSport(localSplit),
                                  visitante: '${events['Visitante']} ',
                                  id: '${events['Id']}',
                                  fecha: '${events['Fecha']}')));
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  String deleteSport(deporte) {
    //mètode per separar l'esport del texte que noltros volem p.e: Futbol Infantil 2ª Regional
    if (deporte.contains("Voleibol")) {
      return deporte.replaceAll("Voleibol", "");
    }
    if (deporte.contains("Futbol")) {
      return deporte.replaceAll("Futbol", "");
    }
    if (deporte.contains("Basquet")) {
      return deporte.replaceAll("Basquet", "");
    }
    return deporte;
  }

  Future<List<dynamic>> downloadJSON(groupId, eventoId, todosPartidos) async {
    try {
      String jsonEndpoint;
      if (todosPartidos) {
        jsonEndpoint = "http://172.20.101.245/test/partidos.php?id=" +
            groupId +
            "&partido=true";
      } else {
        jsonEndpoint = "http://172.20.101.245/test/partidos.php?id=" +
            groupId +
            "&partido=false";
      }
      //et descarrega la llista completa dels events futurs disponibles
      final resp = await http.get(jsonEndpoint);
      Map<String, dynamic> eventos = json.decode(resp.body);

      if (eventos['result'] == '200' || eventos['result'] == '499') {
        List<dynamic> datosEventos = json.decode(eventos['data'][0]);
        return datosEventos;
      } else {
        return [];
      }
    } catch (e) {}
  }
}
