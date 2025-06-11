import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_app_flutter/entities/usuario.dart';

class ListasBD extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> listas = [];

  Future<void> adTodoList(Map<String, dynamic> novaLista) async {
    final doc = await _firestore.collection('task_lists').add(novaLista);
    novaLista['id'] = doc.id;
    listas.add(novaLista);
    notifyListeners();
  }

  Future<void> deleteTodoList(Map<String, dynamic> lista) async {
    await _firestore.collection('task_lists').doc(lista['id']).delete();
    listas.removeWhere((l) => l['id'] == lista['id']);
    notifyListeners();
  }

  Future<void> toggleConcluido(Map<String, dynamic> lista, Map<String, dynamic> atividade) async {
    final atividades = List<Map<String, dynamic>>.from(lista['lista_atividades']);
    final index = atividades.indexWhere((a) => a['nome'] == atividade['nome']);

    if (index != -1) {
      atividades[index]['concluida'] = !(atividades[index]['concluida'] ?? false);
      lista['lista_atividades'] = atividades;

      await _firestore.collection('task_lists').doc(lista['id']).update({
        'lista_atividades': atividades,
      });

      int listaIndex = listas.indexWhere((l) => l['id'] == lista['id']);
      if (listaIndex != -1) {
        listas[listaIndex] = lista;
      }

      notifyListeners();
    }
  }

  Future<void> setConcluida(Map<String, dynamic> lista, bool concluida) async {
    await _firestore.collection('task_lists').doc(lista['id']).update({
      'concluida': concluida,
    });

    int index = listas.indexWhere((l) => l['id'] == lista['id']);
    if (index != -1) {
      listas[index]['concluida'] = concluida;
    }

    notifyListeners();
  }

  Future<void> removerAtividade(Map<String, dynamic> lista, Map<String, dynamic> atividade) async {
    final atividades = List<Map<String, dynamic>>.from(lista['lista_atividades']);
    atividades.removeWhere((a) => a['nome'] == atividade['nome']);
    lista['lista_atividades'] = atividades;

    await _firestore.collection('task_lists').doc(lista['id']).update({
      'lista_atividades': atividades,
    });

    int index = listas.indexWhere((l) => l['id'] == lista['id']);
    if (index != -1) {
      listas[index] = lista;
    }

    notifyListeners();
  }

  List<Map<String, dynamic>> getListasDoUsuario(String uid) {
    return listas.where((l) => l['criador_uid'] == uid).toList();
  }

  List<Map<String, dynamic>> getListasPendentesDoUsuario(UsuarioDTO usuario) {
    return listas
        .where((l) => !(l['concluida'] ?? false) && l['criador_uid'] == usuario.uid)
        .toList();
  }

  List<Map<String, dynamic>> getListasConcluidasDoUsuario(String usuarioId) {
    return listas
        .where((l) => l['concluida'] == true && l['criador_uid'] == usuarioId)
        .toList();
  }

  Future<void> carregarListas(UsuarioDTO usuario) async {
    final query = await _firestore
        .collection('task_lists')
        .where('criador_uid', isEqualTo: usuario.uid)
        .get();

    listas = query.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();

    notifyListeners();
  }
}
