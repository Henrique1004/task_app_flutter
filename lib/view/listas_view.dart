import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app_flutter/database/listas_bd.dart';
import 'package:task_app_flutter/entities/usuario.dart';

class TodoListsView extends StatelessWidget {
  final Usuario usuario;

  const TodoListsView({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Listas de Tarefas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Estatísticas',
            onPressed: () {
              Navigator.pushNamed(
                context,
                'estatisticas',
                arguments: usuario,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Listas Concluídas',
            onPressed: () {
              Navigator.pushNamed(
                context,
                'listasConcluidas',
                arguments: usuario,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                'login',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ListasBD>(
          builder: (context, listasBD, child) {
            final listas = listasBD.getListasPendentesDoUsuario(usuario);

            if (listas.isEmpty) {
              return const Center(
                child: Text('Nenhuma lista pendente.'),
              );
            }

            return ListView.builder(
              itemCount: listas.length,
              itemBuilder: (context, index) {
                final lista = listas[index];
                return Card(
                  child: ListTile(
                    title: Text(lista.nome),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        'verLista',
                        arguments: lista,
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            listasBD.deleteTodoList(lista);
                          },
                        ),
                        Checkbox(
                          value: lista.concluida,
                          onChanged: (value) {
                            if (value != null && value) {
                              listasBD.setConcluida(lista, value);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Lista "${lista.nome}" marcada como concluída!'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            'adicionaLista',
            arguments: usuario,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
