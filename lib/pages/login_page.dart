import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_app/pages/partidos_page.dart';

class Login extends StatelessWidget {
  @override
  static const logo = const Color.fromRGBO(0, 168, 45, 1);

  Widget build(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.only(left:15.0,right: 15.0,top:45,bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Usuario',
                    hintText: 'Usuario'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:15.0,right: 15.0,top:25,bottom: 0),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contraseña',
                    hintText: 'Contraseña'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:35.0,right: 35.0,top:55,bottom: 0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push( context, MaterialPageRoute(builder: (context) => Partidos()));},
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

  _launchURL() async {
    const url = 'https://www.ibred.es/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
