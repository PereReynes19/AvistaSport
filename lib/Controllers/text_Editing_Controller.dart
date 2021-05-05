import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/Preferences/user_preferences.dart';
import 'package:flutter_app/pages/eventos_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

import 'package:flutter_app/pages/login_page.dart';

class TextoController extends State<Login> {
  static const logo = const Color.fromRGBO(0, 168, 45, 1);

  String errormsg;
  bool error, isLogged;
  String username, password, tokenApp, userId, groupId;

  final _userController = TextEditingController();
  final _pwdController = TextEditingController(); //Crear el controlador

  startLogin() async {
    final responseBody = {
      'nombre': _userController.text, //get the username text
      'pass': _pwdController.text //get password text
    };
    //var apiurl = "http://192.168.1.49/test/controller.php"; //api url
    var apiurl = 'http://192.168.10.199/test/controller.php'; //api url

    final response = await http.post(apiurl, body: jsonEncode(responseBody));
    final PreferenciasUsuario prefs = new PreferenciasUsuario();

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      if (jsondata["error"]) {
        setState(() {
          print('error');
          error = true;
          errormsg = jsondata["message"];
        });
      } else {
        tokenApp = jsondata["token_app"];
        userId = jsondata["userId"];
        groupId = jsondata["groupId"];

        prefs.setToken = tokenApp;
        prefs.setGroupId = groupId;
        //shared preference to save data

        List events = (await downloadJSON());
        tokenApp = jsondata["token_app"];

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CustomEventosLV(eventos: events)));
        error = false;

        //save the data returned from server
        //and navigate to home page
      }
    } else {
      setState(() {
        error = true;
        errormsg = "Error during connecting to server.";
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _userController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    username = "";
    password = "";
    errormsg = "";
    error = false;
    isLogged = false;

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LOGIN',
          style: TextStyle(
              fontFamily: 'Arial', fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: logo,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: GestureDetector(
                  onTap: _launchURL,
                  child: Image.network(
                    'https://www.ibred.es/avista/wp-content/uploads/2019/07/ibred-logo-cmyk-2019.png',
                    height: 100,
                    width: 300,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Center(
                child: Text(
                  'AVISTA SPORTS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Luminari',
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              //show error message here
              margin: EdgeInsets.only(top: 30),
              padding: EdgeInsets.all(10),
              child: error ? errmsg(errormsg) : Container(),
              //if error == true then show error message
              //else set empty container as child
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 45, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: _userController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Usuario',
                    hintText: 'Usuario'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 25, bottom: 0),
              child: TextFormField(
                controller: _pwdController,
                obscureText: true,
                autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña',
                  hintText: 'Contraseña',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 35.0, right: 35.0, top: 55, bottom: 0),
              child: ElevatedButton(
                onPressed: () => startLogin(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(logo),
                ),
                child: Text(
                  'INICIA SESION',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget errmsg(String text) {
    //error message widget.
    return Container(
      padding:
          const EdgeInsets.only(left: 15.0, right: 15.0, top: 7, bottom: 7),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red,
          border: Border.all(color: Colors.red[300], width: 2)),
      child: Row(children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 8.00),
          child: Icon(Icons.info, color: Colors.white),
        ), // icon for error message
        Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),
        //show error message text
      ]),
    );
  }

  _launchURL() async {
    const url = 'https://www.ibred.es/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<List<dynamic>> downloadJSON() async {
    final PreferenciasUsuario prefs = new PreferenciasUsuario();
    groupId = prefs.getGroupId;
    print(groupId);
    final jsonEndpoint = "http://192.168.10.199/test/partidos.php?id=$groupId";

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
