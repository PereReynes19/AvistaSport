import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/Preferences/user_preferences.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/pages/partidos_page.dart';

class CustomEventosLV extends StatelessWidget {
  static final String routeName = 'logged';
  final List eventos;
  static const logo = const Color.fromRGBO(0, 168, 45, 1);

  CustomEventosLV({this.eventos});

  @override
  Widget build(BuildContext context) {
    String deportes = '${eventos[0]}';
    var deportesSplit = deportes.split(",");
    var deport = deportesSplit[0].split(" ");
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
    return Container(
      color: Colors.white24,
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Card(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                //side: BorderSide(color: Colors.black87, width: 1),
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: EdgeInsets.all(10.0),
              semanticContainer: false,
              shadowColor: Colors.grey,
              color: Color.fromRGBO(203, 233, 155, 1),
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
                              text: 'Local: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: '${events['Local']}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, left: 15.0, right: 15.0),
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
                                  TextSpan(text: '${events['Resultat']} '),
                                ],
                              ),
                            ),
                          )
                        ])
                      ],
                    ),
                  ),

                  /*Table(
                    children: [
                      TableRow(children: [
                        ListTile(
                            title: Text('Visitante: ${events['Visitante']}')),
                        ListTile(
                            title: Text(
                          'Resultat: ${events['Resultat']}',
                          style: TextStyle(fontSize: 17.0),
                          textAlign: TextAlign.right,
                        )),
                      ])
                    ],
                  ),*/
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
