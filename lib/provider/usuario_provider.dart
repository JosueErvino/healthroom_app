import 'package:flutter/material.dart';
import 'package:healthroom_app/model/usuario.dart';

class UsuarioProvider with ChangeNotifier {
  late Usuario usuario;

  void setUsuario(Usuario value, String uid) {
    usuario = value;
    usuario.uid = uid;
  }
}
