import 'package:flutter_app/pages/partidos_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  var context;
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

  Partidos partidos = new Partidos();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  deletePrefs() async {
    this._prefs = await SharedPreferences.getInstance();
    await _prefs.remove('token_app');
    await _prefs.remove('groupId');
  }

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET
  get getToken {
    return _prefs.getString('token_app') ?? '';
  }

  set setToken(String value) {
    _prefs.setString('token_app', value);
  }

  get getUserId {
    return _prefs.getString('id') ?? '';
  }

  set setUserId(String value) {
    _prefs.setString('id', value);
  }

  get getGroupId {
    return _prefs.getString('id') ?? '';
  }

  set setGroupId(String value) {
    _prefs.setString('id', value);
  }
}
