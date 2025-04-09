import 'package:flutter/material.dart';
import 'package:task_app_flutter/entities/atividade.dart';
import 'package:task_app_flutter/entities/todo_list.dart';
import 'package:task_app_flutter/entities/usuario.dart';

class ListasBD extends ChangeNotifier {
  
  static List<TodoList> listas = [];

  void adTodoList(TodoList todoList) {
    listas.add(todoList);
    notifyListeners();
  }

  void deleteTodoList(TodoList todoList) {
    listas.remove(todoList);
    notifyListeners();
  }

  void toggleConcluido(TodoList lista, Atividade atividade) {
    atividade.concluida = !atividade.concluida;
    notifyListeners();
  }

  void setConcluida(TodoList lista, bool concluida) {
    lista.setConcluida(concluida);
    notifyListeners();
  }

  void removerAtividade(TodoList lista, Atividade atividade) {
    lista.listaAtividades.remove(atividade);
    notifyListeners();
  }

  TodoList getLista(int index) => listas[index];

  List<TodoList> getListasDoUsuario(Usuario usuario) {
    return listas.where((l) => l.criador.email == usuario.email).toList();
  }

  List<TodoList> getListasPendentesDoUsuario(Usuario usuario) {
    return listas
        .where((l) => !l.concluida && l.criador.email == usuario.email)
        .toList();
  }

}
