import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app_flutter/entities/todo_list.dart';
import 'package:task_app_flutter/database/listas_bd.dart';

class DetalheListaView extends StatelessWidget {
  
  final TodoList lista;

  const DetalheListaView({super.key, required this.lista});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lista.nome)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Atividades",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<ListasBD>(
                builder: (context, listasBD, child) {
                  final atividades = lista.listaAtividades;

                  return ListView.builder(
                    itemCount: atividades.length,
                    itemBuilder: (context, index) {
                      final atividade = atividades[index];

                      return Card(
                        child: ListTile(
                          title: Text(
                            atividade.nome,
                            style: TextStyle(
                              decoration: atividade.concluida
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          leading: Checkbox(
                            value: atividade.concluida,
                            onChanged: (value) {
                              listasBD.toggleConcluido(lista, atividade);
                            },
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              listasBD.removerAtividade(lista, atividade);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
