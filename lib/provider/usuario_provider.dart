import 'package:flutter/material.dart';
import 'package:healthroom_app/model/usuario.dart';
import 'package:provider/provider.dart';

class UsuarioProvider extends ChangeNotifier {
  late Usuario _usuario;

  Usuario get usuario => _usuario;

  void setUsuario(Usuario usuario, String uid) {
    _usuario = usuario;
    usuario.uid = uid;
    // TODO: Ver erro que está estourando aqui
    notifyListeners();
  }

  static Usuario getProvider(context) {
    return Provider.of<UsuarioProvider>(context).usuario;
  }
}
