import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/Preferences/user_preferences.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/pages/partidos_page.dart';

import 'package:flutter_app/pages/marcadores_page.dart';

class CustomEventosLV extends StatelessWidget {
  static final String routeName = 'logged';
  final List eventos;
  static const logo = const Color.fromRGBO(0, 168, 45, 1);

  CustomEventosLV({this.eventos});

  @override
  Widget build(BuildContext context) {
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
          FlatButton(
            textColor: Colors.white,
            onPressed: () async {
              PreferenciasUsuario pref = new PreferenciasUsuario();
              await pref.deletePrefs();

              if (pref.getToken == '') {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              } else {
                print("error");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Partidos()));
              }
            },
            child: Icon(
              Icons.logout,
              size: 30,
            ),
          ),
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
  }

  Widget createViewItem(events, BuildContext context) {
    String local = "${events['Local']}";
    var localSplit = local.split("20/21");

    return Container(
      color: Colors.white24,
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11.0),
                  ),
                  margin: EdgeInsets.all(10.0),
                  semanticContainer: false,
                  shadowColor: Colors.grey,
                  color: Color.fromRGBO(205, 205, 205, 1),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 15.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 17.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Local:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: deleteSport(localSplit[1])),
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
                                        text: 'Visitante: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(text: '${events['Visitante']} '),
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
                                      TextSpan(text: '${events['Resultado']} '),
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
                  print('${events['Id']} ');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Marcadores(
                              local: deleteSport(localSplit[1]),
                              visitante: '${events['Visitante']} ',
                              id: '${events['Id']}')));
                }),
          )
        ],
      ),
    );
  }

  String deleteSport(deporte) {
    if (deporte.contains("Voleibol")) {
      return deporte.replaceAll("Voleibol", "");
    }
    if (deporte.contains("Futbol")) {
      return deporte.replaceAll("Futbol", "");
    }
    if (deporte.contains("Basquet")) {
      return deporte.replaceAll("Basquet", "");
    }
    return "";
  }
}
