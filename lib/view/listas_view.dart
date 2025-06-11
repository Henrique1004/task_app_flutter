import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app_flutter/database/listas_bd.dart';
import 'package:task_app_flutter/entities/usuario.dart';

class TodoListsView extends StatefulWidget {
  final UsuarioDTO usuario;

  const TodoListsView({super.key, required this.usuario});

  @override
  State<TodoListsView> createState() => _TodoListsViewState();
}

class _TodoListsViewState extends State<TodoListsView> {
  final TextEditingController _searchController = TextEditingController();
  OrdenarPor _ordenarPor = OrdenarPor.nomeAsc;
  List<Map<String, dynamic>> _listasFiltradas = [];

  @override
  void initState() {
    super.initState();
    final listasBD = Provider.of<ListasBD>(context, listen: false);
    listasBD.carregarListas(widget.usuario).then((_) {
      _filtrarListas();
    });
    _searchController.addListener(_filtrarListas);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _filtrarListas();
  }

  void _filtrarListas() {
    final listasBD = Provider.of<ListasBD>(context, listen: false);
    final todasListas = listasBD.getListasPendentesDoUsuario(widget.usuario);

    String textoBusca = _searchController.text.toLowerCase();

    var filtradas = todasListas.where((lista) {
      final nome = (lista['nome'] ?? '').toString().toLowerCase();
      return nome.contains(textoBusca);
    }).toList();

    // Ordenação apenas por nome
    filtradas.sort((a, b) {
      switch (_ordenarPor) {
        case OrdenarPor.nomeAsc:
          return (a['nome'] ?? '').compareTo(b['nome'] ?? '');
        case OrdenarPor.nomeDesc:
          return (b['nome'] ?? '').compareTo(a['nome'] ?? '');
      }
    });

    setState(() {
      _listasFiltradas = filtradas;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final listasBD = Provider.of<ListasBD>(context);

    if (_searchController.text.isEmpty && _listasFiltradas.isEmpty) {
      _filtrarListas();
    }

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
                arguments: widget.usuario,
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
                arguments: widget.usuario,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () async {
              await logout();
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
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Pesquisar listas',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<OrdenarPor>(
                  value: _ordenarPor,
                  onChanged: (OrdenarPor? novo) {
                    if (novo != null) {
                      setState(() {
                        _ordenarPor = novo;
                      });
                      _filtrarListas();
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: OrdenarPor.nomeAsc,
                      child: Text('Nome ↑'),
                    ),
                    DropdownMenuItem(
                      value: OrdenarPor.nomeDesc,
                      child: Text('Nome ↓'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _listasFiltradas.isEmpty
                  ? const Center(child: Text('Nenhuma lista pendente.'))
                  : ListView.builder(
                      itemCount: _listasFiltradas.length,
                      itemBuilder: (context, index) {
                        final lista = _listasFiltradas[index];
                        return Card(
                          child: ListTile(
                            title: Text(lista['nome'] ?? 'Sem nome'),
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
                                  value: lista['concluida'] ?? false,
                                  onChanged: (value) async {
                                    if (value != null) {
                                      await listasBD.setConcluida(lista, value);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            value
                                                ? 'Lista "${lista['nome']}" marcada como concluída!'
                                                : 'Lista "${lista['nome']}" desmarcada!',
                                          ),
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
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            'adicionaLista',
            arguments: widget.usuario,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

enum OrdenarPor {
  nomeAsc,
  nomeDesc
}
