import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/pages/partidos_page.dart';

class TextoController extends State<Login> {
  static const logo = const Color.fromRGBO(0, 168, 45, 1);

  String errormsg;
  bool error, showprogress;
  String username, password;

  final _userController = TextEditingController();
  final _pwdController = TextEditingController(); //Crear el controlador

  startLogin() async {
    String apiurl = "http://192.168.1.63/test/controller.php"; //api url

    print('Usuaario: $username');

    var response = await http.post(Uri.parse(apiurl), body: {
      'username': username, //get the username text
      'password': password //get password text
    });

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      if (jsondata["error"]) {
        setState(() {
          print('error');
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = jsondata["message"];
        });
      } else {
        if (jsondata["success"]) {
          setState(() {
            print('succes');
            Navigator.push(context, MaterialPageRoute(builder: (context) => Partidos()));
            error = false;
            showprogress = false;
          });
          //save the data returned from server
          //and navigate to home page
          String uid = jsondata["uid"];
          String fullname = jsondata["fullname"];
          String address = jsondata["address"];
          print(fullname);
          //user shared preference to save data
        } else {
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = "Something went wrong.";
        }
      }
    } else {
      setState(() {
        showprogress = false; //don't show progress indicator
        error = true;
        errormsg = "Error during connecting to server.";
      });
    }
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _pwdController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: logo,
      //color set to transperent or set your own color
    ));
    return Scaffold (
      appBar: AppBar (
        title: Text('LOGIN', style: TextStyle(fontFamily: 'Arial', fontSize: 20, fontWeight: FontWeight.bold),),
        backgroundColor: logo,
      ),
      body: SingleChildScrollView (
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center (
                child: GestureDetector (
                  onTap: _launchURL,
                  child: Image.network('https://www.ibred.es/avista/wp-content/uploads/2019/07/ibred-logo-cmyk-2019.png', height: 100, width: 300, ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only( top: 15.0),
              child: Center (
                child: Text('AVISTA SPORTS', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Luminari', fontSize: 30, fontWeight: FontWeight.bold),),
              ),
            ),
            Container(
              //show error message here
              margin: EdgeInsets.only(top:30),
              padding: EdgeInsets.all(10),
              //child:error? errmsg(errormsg):Container(),
              //if error == true then show error message
              //else set empty container as child
            ),
            Padding(
              padding: const EdgeInsets.only(left:15.0,right: 15.0,top:45,bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _userController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Usuario',
                    hintText: 'Usuario'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:15.0,right: 15.0,top:25,bottom: 0),
              child: TextField(
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
              padding: const EdgeInsets.only(left:35.0,right: 35.0,top:55,bottom: 0),
              child: ElevatedButton(
                onPressed: () => {
                startLogin()
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(logo),
                ),
                child: Text('INICIA SESION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget errmsg(String text){
    //error message widget.
    return Container(
      padding: EdgeInsets.all(15.00),
      margin: EdgeInsets.only(bottom: 10.00),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.red,
          border: Border.all(color:Colors.red[300], width:2)
      ),
      child: Row(children: <Widget>[
        Container(
          margin: EdgeInsets.only(right:6.00),
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
}