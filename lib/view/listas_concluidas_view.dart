import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app_flutter/database/listas_bd.dart';
import 'package:task_app_flutter/entities/usuario.dart';

class ListasConcluidasView extends StatelessWidget {
  final UsuarioDTO usuario;

  const ListasConcluidasView({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listas Concluídas'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ListasBD>(
          builder: (context, listasBD, child) {
            final listasConcluidas = listasBD.getListasConcluidasDoUsuario(usuario.uid);

            if (listasConcluidas.isEmpty) {
              return const Center(
                child: Text('Nenhuma lista concluída ainda.'),
              );
            }

            return ListView.builder(
              itemCount: listasConcluidas.length,
              itemBuilder: (context, index) {
                final lista = listasConcluidas[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(
                      lista['nome'] ?? 'Sem nome',
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.restore),
                          tooltip: 'Restaurar lista',
                          onPressed: () {
                            listasBD.setConcluida(lista, false);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            listasBD.deleteTodoList(lista);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
