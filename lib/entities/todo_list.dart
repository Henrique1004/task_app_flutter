import 'package:task_app_flutter/entities/atividade.dart';
import 'package:task_app_flutter/entities/usuario.dart';

class TodoList {

  List<Atividade> listaAtividades;
  String nome;
  Usuario criador;
  bool concluida;

  TodoList(this.listaAtividades, this.nome, this.criador, [this.concluida = false]);

  void deletaAtividade(Atividade atividadeDelete) {
    listaAtividades.remove(atividadeDelete);
  }

  bool isConcluida() {
    return concluida;
  }

  void setConcluida(bool concluida) {
    this.concluida = concluida;
  }

}
