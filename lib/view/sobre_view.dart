import 'package:flutter/material.dart';

class SobreView extends StatelessWidget {
  
  const SobreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sobre o Aplicativo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Objetivo do Aplicativo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Este aplicativo foi desenvolvido para facilitar o gerenciamento de tarefas, '
              'permitindo aos usuários criarem listas e acompanharem suas atividades.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Desenvolvedor:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Henrique Clemencio de Oliveira', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
