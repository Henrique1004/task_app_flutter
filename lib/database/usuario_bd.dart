import 'package:flutter/material.dart';
import 'package:task_app_flutter/entities/usuario.dart';

class UsuarioBD extends ChangeNotifier{

  static List<Usuario> usuarios = [];

  void adUsuario(Usuario usuario) {
    usuarios.add(usuario);
    notifyListeners();
  }

  Usuario? getUsuario(String email, String senha) {
    for (var usuario in usuarios) {
      if (usuario.email == email && usuario.senha == senha) {
        return usuario;
      }
    }
    return null;
  }
  
}
