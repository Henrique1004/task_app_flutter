import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app_flutter/database/listas_bd.dart';
import 'package:task_app_flutter/entities/usuario.dart';

class AdListaView extends StatefulWidget {
  final UsuarioDTO usuario;

  const AdListaView({super.key, required this.usuario});

  @override
  _AdListaViewState createState() => _AdListaViewState();
}

class _AdListaViewState extends State<AdListaView> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _atividadeController = TextEditingController();

  List<Map<String, dynamic>> _atividades = [];

  void _adicionarAtividade() {
    if (_atividadeController.text.isNotEmpty) {
      setState(() {
        _atividades.add({
          'nome': _atividadeController.text,
          'concluida': false,
        });
        _atividadeController.clear();
      });
    }
  }

  Future<void> _salvarLista(BuildContext context) async {
    if (_nomeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insira um nome para a lista!')),
      );
      return;
    }
    if (_atividades.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insira pelo menos uma atividade!')),
      );
      return;
    }

    final novaListaData = {
      'nome': _nomeController.text,
      'criador_uid': widget.usuario.uid,
      'concluida': false,
      'lista_atividades': _atividades,
    };


    try {
      await Provider.of<ListasBD>(context, listen: false)
          .adTodoList(novaListaData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lista "${_nomeController.text}" salva!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar lista: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nova Lista")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: "Nome da Lista",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _atividadeController,
                    decoration: const InputDecoration(
                      labelText: "Nova Atividade",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _adicionarAtividade,
                  child: const Text("Adicionar"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _atividades.length,
                itemBuilder: (context, index) {
                  final atividade = _atividades[index];
                  return ListTile(
                    title: Text(atividade['nome']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _atividades.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Consumer<ListasBD>(
              builder: (context, listasBD, child) {
                return ElevatedButton(
                  onPressed: () => _salvarLista(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Salvar Lista"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
